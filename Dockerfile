# Use an official PHP image with Apache
FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpq-dev \
    libicu-dev \
    libxml2-dev \
    libgd-dev \
    libonig-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libc-client-dev \
    libkrb5-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) \
    zip \
    pdo \
    pdo_pgsql \
    bcmath \
    imap \
    sockets \
    gd \
    intl \
    xml \
    mbstring

# Install Node.js 18.x
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy Mautic files
COPY . /var/www/html

# Set permissions for npm (avoid running as root)
RUN chown -R www-data:www-data /var/www/html

# Switch to a non-root user
USER www-data

# Install Mautic dependencies
WORKDIR /var/www/html
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Expose port 80
EXPOSE 80
