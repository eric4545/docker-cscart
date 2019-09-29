FROM php:7.3.10-apache

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
                        wget \
                        unzip \
                        build-essential && \
    apt-get install --no-install-recommends -y \
                        imagemagick \
                        libxml2-dev \
                        libtool \
                        libgcrypt11-dev \
                        zlib1g-dev && \
    wget "https://www.cs-cart.com/index.php?dispatch=pages.get_trial&page_id=297&edition=ultimate" -O cscart.zip && \
    unzip cscart.zip && \
    chmod 644 config.local.php && \
    chmod -R 755 design images var && \
    find design -type f -print0 | xargs -0 chmod 644 && \
    find images -type f -print0 | xargs -0 chmod 644 && \
    find var -type f -print0 | xargs -0 chmod 644 && \
    chown -R www-data:www-data . && \
    docker-php-ext-install pcntl \
                            soap \
                            opcache \
                            zip \
                            pdo \
                            pdo_mysql && \
    # docker-php-ext-enable \
    #                     imagick \
    #                     redis && \
    apt-get remove -y wget \
                    unzip \
                    build-essential  && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm cscart.zip && \
    # Enable mod_rewrite 
    a2enmod rewrite

CMD ["apache2-foreground"]
