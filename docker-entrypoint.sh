#!/bin/bash

# 必要なディレクトリの作成
mkdir -p /var/www/laravel_app/storage /var/www/laravel_app/bootstrap/cache

# 権限の設定
chown -R www-data:www-data /var/www/laravel_app/storage /var/www/laravel_app/bootstrap/cache
chmod -R 775 /var/www/laravel_app/storage /var/www/laravel_app/bootstrap/cache

# アプリケーションキーの生成（初回のみ必要な場合はコメントアウト可）
# php artisan key:generate

# データベースのマイグレーション（必要に応じてコメントアウト可）
# php artisan migrate --force

# PHP-FPMの起動
php-fpm -F 