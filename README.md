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
        environment:
            - APP_PORT=8000
            - DB_HOST=mariadb
            - DB_USERNAME=root
            - DB_PASSWORD=0000
            - DB_DATABASE=database
            - DB_PORT=3306
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
- Environment variables in the "app" service are used to generate the `.env` file for fresh installations. `APP_PORT` value should be the same as the local port define in "app" service.<br>If you want to change the port on the local machine (ex: `8080`), modify `APP_PORT` value to `8080` (or the the port of `APP_URL` in the `.env` file if you work on an already configured application) and `ports` value to `8080:8000` 

- Exposition of the "mariadb" service to the local port `33066` is optional.

- Access container shell with this command: `docker-compose exec app /bin/sh` 

## Usage
Run `docker-compose up` the first time to create and start the container.

Next times, just run `docker-compose start` to start the container.

If it's a fresh Laravel application, the script `startup.sh` will install dependencies, create `.env` file and setup the database.

Else, it will update the dependencies if needed.

The the application will be available at `http://localhost:8000`