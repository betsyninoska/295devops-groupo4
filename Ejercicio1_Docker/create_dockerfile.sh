#!/bin/bash

# Contenido del Dockerfile
DOCKERFILE_CONTENT='
FROM php:7.4-apache

WORKDIR /var/www/html

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

EXPOSE 80
'

# Escribir el contenido en el archivo Dockerfile
echo "$DOCKERFILE_CONTENT" > 'Dockerfile'

echo "Archivo Dockerfile creado con el contenido proporcionado."
