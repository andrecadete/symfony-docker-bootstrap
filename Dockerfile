FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

ARG LANG=en_US.UTF-8
ARG PHP_VERSION=7.1
ARG TIMEZONE=UTC
ARG USER_ID=501

# Configure locale and timezone and install base packages
RUN locale-gen $LANG && \
    echo $TIMEZONE > /etc/timezone && \
    ln -fs /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    apt-get update && \
    apt-get -yq install --no-install-recommends \
        ca-certificates bzip2 git curl zip unzip acl && \
    # Install php and base packages
    echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E5267A6C && \
    apt-get update && \
    apt-get -yq upgrade && \
    apt-get -yq install --no-install-recommends \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysql
         \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-json \
        php${PHP_VERSION}-sqlite \
        php${PHP_VERSION}-xdebug \
        php${PHP_VERSION}-xml \
        bzip2 git curl zip unzip acl && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Configure www-data user
    usermod -d /var/www -s /bin/bash -u ${USER_ID} www-data && \
    # Configure FPM
    sed -i 's@^variables_order .*@variables_order = "EGPCS"@' /etc/php/${PHP_VERSION}/fpm/php.ini && \
    sed -i 's@^error_log .*@error_log = /proc/self/fd/2@' /etc/php/${PHP_VERSION}/fpm/php-fpm.conf && \
    sed -i 's@^listen .*@listen = 0.0.0.0:9000@; s@^access.log .*@access.log = /proc/self/fd/2@' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf && \
    ln -sf /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm && \
    mkdir -p /run/php && \
    chown www-data. /run/php

COPY . /var/www
WORKDIR /var/www
USER www-data
EXPOSE 9000

ENV SYMFONY_ENV=dev
ENV SYMFONY_DEBUG=1

CMD ["/usr/sbin/php-fpm", "-F"]