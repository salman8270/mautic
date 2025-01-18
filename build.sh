#!/bin/bash

# Install PHP and required extensions
apt-get update && apt-get install -y \
    php \
    php-cli \
    php-zip \
    php-pgsql \
    php-xml

# Install Composer
EXPECTED_CHECKSUM="$(curl -s https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
    >&2 echo 'ERROR: Invalid Composer installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
rm composer-setup.php

# Install Mautic dependencies
php composer.phar install --no-dev --optimize-autoloader
