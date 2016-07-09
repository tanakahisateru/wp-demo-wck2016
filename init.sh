#!/usr/bin/env bash

# CREATE USER wordpress@localhost IDENTIFIED BY 'wordpresspass';

# CREATE DATABASE wpdemo;
# CREATE DATABASE `wpdemo-tests`;
# GRANT ALL ON wpdemo.* TO wordpress@localhost;
# GRANT ALL ON `wpdemo-tests`.* TO wordpress@localhost;

wp core download --path=docroot --locale=ja --version=4.5.3

composer install

rm docroot/wp-config.php
wp core config --path=docroot --locale=ja \
    --dbname=wpdemo --dbuser=wordpress --dbpass=wordpresspass --dbhost=localhost \
    --skip-check --skip-salts --extra-php < salts.txt

if ! $(wp core is-installed --path=docroot); then
    wp core install --path=docroot \
        --url=http://localhost:8000/ --title=demo \
        --admin_user=root --admin_password=rootpass --admin_email=root@example.com
fi

# php -S 0.0.0.0:8000 -t docroot
