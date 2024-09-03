FROM composer:latest

ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]

WORKDIR /var/www/html