# See https://github.com/docker-library/php/blob/master/7.1/fpm/Dockerfile
FROM php:7.1-fpm-jessie

# Download nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# Install libs
RUN apt update
RUN apt-get update

RUN apt-get install -my wget
RUN apt-get install -my gnupg
RUN apt-get install -my git
RUN apt-get install -my openssl
RUN apt-get install -my unzip
RUN apt-get install -my zip
RUN apt-get install -my build-essential
RUN apt-get install -my zlib1g-dev
RUN apt-get install -my libmagickwand-dev
RUN apt-get install -my libssl-dev
RUN apt-get install -my libreadline-dev
RUN apt-get install -my libgdbm-dev
RUN apt-get install -my libicu-dev
RUN apt-get install -my libcurl3
RUN apt-get install -my nginx
RUN apt-get install -my gettext-base
RUN apt-get install -my xvfb
RUN apt-get install -my nodejs
RUN apt install -my python-pip


# Install yq
RUN pip install yq

# Install jq
# Because jq version will be 1.4 and we want 1.5
# https://stackoverflow.com/questions/36462955/upgrading-jq-to-1-5-on-ubuntu
# In 1.4 .scenario=input throw error and in 1.5 this bug is fixed
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
RUN chmod +x jq-linux64
RUN mv jq-linux64 /usr/bin/jq

# Install libcurl
RUN cp /usr/lib/x86_64-linux-gnu/libcurl.so.3 /usr/lib/
RUN apt-get install libcurl4-openssl-dev -y
RUN env LD_PRELOAD=/usr/lib/libcurl.so.3

# Install pecl extensions
RUN pecl install APCu-5.1.8
RUN pecl install apcu imagick

# Type docker-php-ext-install to see available extensions
RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo pdo_mysql curl json intl gd xml zip bz2 opcache pcntl shmop
RUN docker-php-ext-enable imagick

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Install chrome-headless
RUN echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/chrome.list
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN set -x
RUN apt-get update
RUN apt-get install -my google-chrome-stable
RUN wget -q -O /usr/bin/xvfb-chrome https://bitbucket.org/atlassian/docker-node-chrome-firefox/raw/ff180e2f16ea8639d4ca4a3abb0017ee23c2836c/scripts/xvfb-chrome
RUN ln -sf /usr/bin/xvfb-chrome /usr/bin/google-chrome
RUN chmod 777 /usr/bin/google-chrome

WORKDIR /var/www/html

CMD ["php-fpm"]