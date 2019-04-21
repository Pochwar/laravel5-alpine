FROM alpine:latest

# Install PHP7 and extensions
RUN apk update && apk upgrade
RUN apk add php7 php7-bcmath php7-ctype php7-dom php7-fileinfo php7-gd php7-json php7-mbstring php7-openssl php7-pdo php7-pdo_mysql php7-pdo_sqlite php7-pecl-xdebug php7-phar php7-session php7-simplexml php7-tokenizer php7-xml php7-xmlwriter php7-zip


# Enable Xdebug
RUN sed -i "s/;zend_extension=xdebug.so/zend_extension=xdebug.so/g" /etc/php7/conf.d/xdebug.ini

# Install composer
RUN apk add curl
RUN curl -s https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Install Node and NPM
RUN apk add nodejs npm

WORKDIR /app
VOLUME /app

# keep container running
CMD tail -f /dev/null