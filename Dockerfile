FROM alpine:3.9

# Install php and extensions
RUN apk update && apk upgrade
RUN apk add curl php7 php7-json php7-phar php7-mbstring php7-openssl php7-zip php7-pdo php7-bcmath php7-dom php7-xml php7-xmlwriter php7-tokenizer php7-pdo_mysql php7-fileinfo php7-session

# Install composer
RUN curl -s https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Install Node and NPM
RUN apk add nodejs npm

WORKDIR /app
VOLUME /app
COPY startup.sh /startup.sh

ENTRYPOINT [ "/startup.sh" ]
