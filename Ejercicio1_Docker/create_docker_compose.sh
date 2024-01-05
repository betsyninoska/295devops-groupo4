#!/bin/bash

# Contenido del archivo docker-compose.yml
DOCKER_COMPOSE_CONTENT="version: '3'
services:
  php:
    env_file:
      - .env
    build:
      context: .
      args:
        - --no-cache
      dockerfile: Dockerfile
    ports:
      - '80:80'
    healthcheck:
      test: ['CMD', 'curl', '-f', 'http://localhost/']
      interval: 10s
      timeout: 5s
      retries: 3
    environment:
      MYSQL_ROOT_PASSWORD: '\${MYSQL_ROOT_PASSWORD}'
      MYSQL_DATABASE: '\${MYSQL_DATABASE}'
      MYSQL_USER: '\${DB_USER}'
      DB_HOST: '\${DB_HOST}'
      DB_PORT: '\${DB_PORT}'
      MYSQL_PASSWORD: '\${MYSQL_PASSWORD}'
    container_name: php
    networks:
      - backend

  dbphp:
    env_file:
      - .env
    image: mariadb:latest
    restart: always
    ports:
      - '3306:3306'
    healthcheck:
      test: ['CMD', 'mysqladmin', 'ping', '-h', 'localhost']
      timeout: '5s'
      interval: '10s'
      retries: 5
    environment:
      MYSQL_ROOT_PASSWORD: '\${MYSQL_ROOT_PASSWORD}'
      MYSQL_DATABASE: '\${MYSQL_DATABASE}'
      MYSQL_USER: '\${DB_USER}'
      MYSQL_PASSWORD: '\${MYSQL_PASSWORD}'
    container_name: dbphp
    volumes:
      - ./database/devopstravel.sql:/docker-entrypoint-initdb.d/devopstravel.sql
      - ./database/mysql_data:/var/lib/mysql
    networks:
      - backend

  phpmyadmin:
    image: phpmyadmin:latest
    container_name: phpmyadmin
    ports:
      - 8000:80 # Expose phpMyAdmin on port 8000
    restart: always
    healthcheck:
      test: ['CMD', 'mysqladmin', 'ping', '-h', 'localhost']
      timeout: '5s'
      interval: '10s'
      retries: 5
    environment:
      PMA_ARBITRARY: 1 # Use the value '1' for arbitrary hostname resolution
      PMA_HOST: '\${DB_HOST}' # Use the container name of the mysql service as the host
    depends_on:
      - dbphp
    networks:
      - backend

networks:
  backend:
    driver: bridge
"

# Guardar el contenido en el archivo docker-compose.yml
echo "$DOCKER_COMPOSE_CONTENT" > /root/295devops-groupo4/Ejercicio1_Docker/docker-compose.yml

echo "El archivo docker-compose.yml ha sido creado exitosamente."
