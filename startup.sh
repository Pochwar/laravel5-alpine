#!/bin/sh

#########################################################
#                                                       #
# This script is highly inspired by the one             #
# of the bitnami-docker-laravel image                   #
#                                                       #
# https://github.com/bitnami/bitnami-docker-laravel     #
#                                                       #
#########################################################

INIT_SEM=/tmp/initialized.sem

fresh_container() {
  [[ ! -f ${INIT_SEM} ]]
}

app_present() {
  [[ -f /app/config/database.php ]]
}

wait_for_db() {
  local db_host="${DB_HOST:-mariadb}"
  local db_port="${DB_PORT:-3306}"
  local db_address=$(getent hosts "$db_host" | awk '{ print $1 }')
  counter=0
  echo "Connecting to mariadb at $db_address"
  while ! curl --silent "$db_address:$db_port" >/dev/null; do
    counter=$((counter+1))
    if [[ $counter == 30 ]]; then
      echo "Error: Couldn't connect to mariadb."
      exit 1
    fi
    echo "Trying to connect to mariadb at $db_address. Attempt $counter."
    sleep 5
  done
}

create_env_file() {
  echo "Create .env file"
  cp .env.example .env
  chmod 777 .env
  sed -i 's/\(APP_URL=\).*/\1http:\/\/localhost:'${APP_PORT}'/' .env
  sed -i 's/\(DB_HOST=\).*/\1'${DB_HOST}'/' .env
  sed -i 's/\(DB_USERNAME=\).*/\1'${DB_USERNAME}'/' .env
  sed -i 's/\(DB_PASSWORD=\).*/\1'${DB_PASSWORD}'/' .env
  sed -i 's/\(DB_DATABASE=\).*/\1'${DB_DATABASE}'/' .env
  sed -i 's/\(DB_PORT=\).*/\1'${DB_PORT}'/' .env
  php artisan key:generate
}

setup_db() {
  echo "Configuring the database"
  sed -i "s/utf8mb4/utf8/g" /app/config/database.php
  php artisan migrate --force
}

echo "Installing/Updating Laravel dependencies (composer)"
composer install
echo "Laravel dependencies installed/updated"

if [[ -f ".env" ]];then
  echo ".env file already exists"
else
  create_env_file
fi

wait_for_db

if ! fresh_container; then
  echo "#########################################################################"
  echo "                                                                         "
  echo " App initialization skipped:                                             "
  echo " Delete the file $INIT_SEM and restart the container to reinitialize     "
  echo " You can alternatively run specific commands using docker-compose exec   "
  echo " e.g docker-compose exec myapp php artisan make:console FooCommand       "
  echo "                                                                         "
  echo "#########################################################################"
else
  setup_db
  echo "Initialization finished"
  touch ${INIT_SEM}
fi

echo "Installing/Updating Front dependencies (npm)"
npm i
echo "Front dependencies installed/updated"

echo "Build front"
npm run dev
echo "Front build"

php artisan serve --host=0.0.0.0 --port=2440
