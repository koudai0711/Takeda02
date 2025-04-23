FROM php:8.2.15-fpm

# システムの依存関係をインストール
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libpq-dev \
    nodejs \
    npm \
    nginx \
    postgresql-client \
    libzip-dev

# PHP拡張機能をインストール
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd pdo_pgsql zip

# Composerをインストール
COPY --from=composer:2.6.6 /usr/bin/composer /usr/bin/composer

# Nginxの設定をコピー
COPY ./docker/nginx/conf.d /etc/nginx/conf.d/

# 作業ディレクトリを設定
WORKDIR /var/www/laravel_app


# アプリ本体をコピー
COPY laravel_app /var/www/laravel_app

# 依存インストール
RUN npm install
RUN composer install
# 必要なディレクトリの作成
RUN mkdir -p /var/www/laravel_app/storage /var/www/laravel_app/bootstrap/cache

# 権限の設定
RUN chown -R www-data:www-data /var/www/laravel_app \
    && chmod -R 755 /var/www/laravel_app/storage \
    && chmod -R 755 /var/www/laravel_app/bootstrap/cache

# 環境変数の設定
ENV DB_DATABASE=laravel
ENV DB_USERNAME=postgres
ENV DB_PASSWORD=secret

# ポートの公開
EXPOSE 8000
EXPOSE 5432

# 起動スクリプトの作成
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Node.js, npm, composer, PHP拡張は既にインストール済み
# package.json, package-lock.json, vite.config.js, tailwind.config.js, postcss.config.js などがあればCOPYする
# COPY package.json /var/www/laravel_app/package.json
# package-lock.jsonがあればコピー（なければスキップ）
# COPY package-lock.json /var/www/laravel_app/package-lock.json

# Vite, Tailwind, Inertia, Vue, Axios, PostCSS, laravel-vite-plugin等のnpm依存はdocker-entrypoint.shでnpm installする前提

# コンテナ起動時のコマンド
CMD ["docker-entrypoint.sh"] 