# Laravel 5 Alpine

Simple Alpine image with php7 to wrap your Laravel 5 applications

## Configuration

Create a `docker-compose.yml` file at the root directory of your Laravel application and put the following content:

```yaml
version: '3.1'

services:
    app:
        tty: true
        image: pochwar/laravel5-alpine:latest
        depends_on:
          - mariadb
        ports:
            - 8000:8000
        volumes:
            - .:/app

    mariadb:
        image: mariadb:10.2.7
        restart: always
        environment:
            - MYSQL_USER=root
            - MYSQL_ROOT_PASSWORD=0000
            - MYSQL_DATABASE=database
        ports:
            - 33066:3306
        volumes:
            - mariadb:/var/lib/mysql/

volumes:
    mariadb:
```

### Notes
- Exposition of the "mariadb" service to the local port `33066` is optional and just for accessing db from your local machine

## Usage
Run `docker-compose up` the first time to create and start the container.
Next times, just run `docker-compose start` to start the container.

### Install back dependencies
Run `docker-compose exec app composer install`

### Install front dependencies
Run `docker-compose exec app npm i`

### Run migrations
Run `docker-compose exec app php artisan migrate`

### Launch server
Run `docker-compose exec app php artisan serve --host=0.0.0.0 --port=8000`

## Development
As docker is used to wrap the application, it means that you can install packages inside the container and you don't have to install/use Composer and NPM on your machine (but you can!)

Access container shell with this command: `docker-compose exec app /bin/sh` 

Then run any command you wish: `composer require rap2hpoutre/laravel-log-viewer` for instance!

## Troubleshooting
You may have some right access issues due to files generated in the container.

This can be solved by running `chown 1000:1000 path/to/file/or/folder` into the container.
Docker will automatically bind '1000:1000' to your machine 'user:group'