#!/bin/bash

cd /var/www/html

sleep 5

if [ ! -f wp-config.php ]; then
    echo "📦​ Downloading Wordpress..."
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    mv wordpress/* ./
    rm -rf wordpress latest.tar.gz

    echo "​💾​ wp-config.php configuration"
    cp wp-config-sample.php wp-config.php

    sed -i "s#database_name_here#${MYSQL_DATABASE}#" wp-config.php
    sed -i "s#username_here#${MYSQL_USER}#" wp-config.php
    sed -i "s#password_here#${MYSQL_PASSWORD}#" wp-config.php
    sed -i "s#localhost#mariadb#" wp-config.php

    echo "🔧 Fixing ownership and permissions..."
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
fi

until mysqladmin ping -h mariadb --silent; do
    echo "​⏳​ Waiting for MariaDB..."
    sleep 1
done

if ! wp core is-installed --allow-root; then
    echo "​​👩🏼‍💻​ Downloading Wordpress..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

    wp core install \
        --url=$DOMAIN_NAME \
        --title="$WP_SITE_TITLE" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root
    
    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
fi

echo "​✅​ Wordpress ready on php-fpm"
mkdir -p /run/php
exec php-fpm7.4 -F