# Laravel 5 Alpine

Simple Alpine image with php7 to handle Laravel 5

## Configuration

Create a `docker-compose.yml` file at the root directory of your Laravel application and put the following content:

```yaml
version: '3.1'

services:
    app:
        tty: true
        image: pochwar/laravel5-alpine:latest
        environment:
            - DB_HOST=mariadb
            - DB_USERNAME=root
            - DB_PASSWORD=0000
            - DB_DATABASE=database
            - DB_PORT=3306
        depends_on:
          - mariadb
        ports:
            - 2440:2440
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
- Declaration of DB environment variables in the "app" service is because they are used by `startup.sh` script. There is no need to set them in the `.env` file.

- The "app" service port is set to `2440` and binded to `2440` too to prevent potentials conflicts with other applications that could run on usual ports. It's recommended to keep `2440` for the local port because this value is used in the creation of the `.env` file for the `APP_URL` value in the `startup.sh` script.<br>If you must or want to change this value, be sur to change the `APP_URL` value ine the `.env` consequently.

- Exposition of the "mariadb" service to the local port `33066` is optional.

- Access container shell with this command: `docker-compose exec app /bin/sh` 

## Usage
Run `docker-compose up` the first time to create and start the container.

The next times, just run `docker-compose start` to start the container.

If it's a fresh Laravel application, the script `startup.sh` will install dependencies, create `.env` file and setup the database.

Else, it will update the dependencies if needed.

The the application will be available at `http://localhost:2440`