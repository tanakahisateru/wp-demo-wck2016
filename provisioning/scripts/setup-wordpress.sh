#!/usr/bin/env bash

wp core download --path=/var/www/html --locale=ja

if ! [ -f /var/www/html/wp-config.php ]; then
    wp core config --path=/var/www/html --locale=ja \
        --dbname=wpdemo --dbuser=wordpress --dbpass=wordpresspass --dbhost=localhost
fi

#if ! $(wp core is-installed --path=/var/www/html); then
#    wp core install --path=/var/www/html \
#        --url=http://192.168.7.10/ --title=demo \
#        --admin_user=root --admin_password=rootpass --admin_email=root@example.com
#fi
