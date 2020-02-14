FROM php:7.2.13-fpm

RUN apt-get update && apt-get install -y \
   autoconf \
   coreutils \
   g++ \
   gcc \
   git \
   libcurl4-openssl-dev \
   libfreetype6-dev \
   libicu-dev \
   libjpeg62-turbo-dev \
   libmcrypt-dev \
   libpng-dev \
   libpq-dev \
   libssl1.0-dev \
   libtool \
   libvpx-dev \
   libxml2-dev \
   libxpm-dev \
   make \
   openntpd \
   tzdata \
   unzip \
   vim \
   wget \
   tzdata

RUN docker-php-ext-configure intl \
    && docker-php-ext-configure opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
    --with-xpm-dir=/usr/include/

RUN docker-php-ext-install -j$(nproc)  \
   bcmath  \
   curl \
   gd  \
   exif \
   iconv  \
   intl  \
   json \
   mbstring \
   opcache  \
   pdo  \
   pdo_pgsql \
   pgsql \
   soap \
   sockets \
   xml  \
   xmlrpc  \
   zip

# Install imagick
RUN apt-get install -y libmagickwand-dev && \
   pecl install imagick \
   && docker-php-ext-enable imagick

# Install xDebug and Redis
RUN docker-php-source extract \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
#    && pecl install xdebug redis \
#    && docker-php-ext-enable xdebug redis \
    && docker-php-source delete

RUN apt-get update && apt-get install -y librabbitmq-dev \
    && pecl install amqp \
    && docker-php-ext-enable amqp

# Add timezone
RUN rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/UTC /etc/localtime && \
    "date"

# Install composer
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer

# Install Symfony
#RUN mkdir -p /usr/local/bin \
#    && curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony \
#    && chmod a+x /usr/local/bin/symfony

# add config files
#ADD conf/php.ini /usr/local/etc/php/php.ini
#ADD conf/conf.d/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
#RUN mkdir -p /var/log/xdebug/ && touch /var/log/xdebug/xdebug.log && chmod 777 /var/log/xdebug/xdebug.log
##

CMD ["php-fpm"]

ENV TZ=Europe/Paris