#!/bin/bash
echo "Iniciando"

#Variables
#repo="app-295devops-travel"
repo="295devops-groupo4"
USERID=$(id -u)
#colores
LRED='\033[1;31m'
LGREEN='\033[1;32m'
NC='\033[0m'
LBLUE='\033[0;34m'
LYELLOW='\033[1;33m'



echo  -e "\n${LGREEN} ########################################################################${NC}"
echo -e "\n${LGREEN} ######################Inicio de Automatizacion#########################${NC}"
echo -e "\n${LGREEN} ########################################################################${NC}"



#Usuario Root solamente
if [ "${USERID}" -ne 0 ]; then
       echo -e "\n${LGREEN} El usuario debe ser Root ${NC}"
       exit
fi



echo -e "\n${LGREEN} Actualizando servidor ${NC}"
apt-get update
echo -e "\n${LGREEN} El Servidor se encuentra Actualizado ...${NC}"







##################################STAGE 1: [Build]######################
#Instalacion de paquetes en el sistema operativo ubuntu: [apache, php, mariadb, git, curl, etc]
#apache
	#Importante se debe Configurar apache para que soporte extensión php, en el repositorio estan los pasos.


  if dpkg -s apache2 > /dev/null 2>&1; then
      echo -e "\n${LGREEN} El Apache2 se encuentra ya instalado ...${NC}"
else
      echo -e "\n${LYELLOW} Instalanco Apache2 ...${NC}"
      apt install -y apache2
      #php
      apt install -y php libapache2-mod-php php-mysql
      systemctl start apache2
      systemctl enable apache2
      mv /var/www/html/index.html /var/www/html/index.html.bkp
      echo -e "\n${LGREEN} Apache2 instalado ...${NC}"}
 fi

echo -e "\n${LGREEN} Version php:${NC}"
php -version


#git
if dpkg -s git > /dev/null 2>&1; then
  echo -e "\n${LGREEN} El git se encuentra ya instalado ...${NC}"
else
  apt install -y git
  echo -e "\n${LYELLOW}instalando GIT ...${NC}"
fi


##################################STAGE 2: [Build]######################
#Voy a verificar primeramente si existe el repositorio porque desde allí sacae la base de destinations
#Luego instala Mariadb
#el script debe permitir evaluar la existencia del proyecto, si existe un git pull y si no existe un git clone
#Mover al directorio donde se guardar los archivos de configuración de apache /var/www/html/
#Testear existencia del codigo de la aplicación
#Se recomienda renombrar en index.html default de apache para que no pise con el index.php

if [ -d "$repo" ]; then
    echo "La carpeta $repo existe"
    git pull
else
    echo -e "\n${LYELLOW} Installing web ...${NC}"
    sleep 1
    #git clone -b app-295devops-travel https://github.com/betsyninoska/$repo.git
    git clone https://github.com/betsyninoska/$repo.git
    cp -r $repo/app-295devops-travel/* /var/www/html
fi

#Ajustar el config de php para que soporte los archivos dinamicos de php agregando index.php
#Testear la compatibilidad -> ejemplo http://localhost/info.php
#Si te muestra resultado de una pantalla informativa php , estariamos funcional para la siguiente etapa.


#Mariadb

if dpkg -s mariadb-server > /dev/null 2>&1; then
    echo -e "\n${LBLUE}El Servidor se encuentra Actualizado ...${NC}"
else
    echo -e "\n${LYELLOW}instalando MARIA DB ...${NC}"
    apt install -y mariadb-server
    ###Iniciando la base de datos
    systemctl start mariadb
    systemctl enable mariadb
    
    sleep 1
    echo -e "\n${LYELLOW} Creando database y sumando datos...${NC}"
    mysql -e "
         CREATE DATABASE devopstravel;
         CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
         GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
         FLUSH PRIVILEGES;"
    cat > devopstravel.sql <<-EOF
    USE devopstravel;
    CREATE TABLE booking (booking_id int(11) NOT NULL,user_id int(11) DEFAULT NULL, name varchar(200) DEFAULT NULL,email varchar(100) DEFAULT NULL,phone int(11) DEFAULT NULL,
    address varchar(300) DEFAULT NULL, package_id int(11) DEFAULT NULL, adults int(11) DEFAULT NULL, children int(11) DEFAULT NULL, date date DEFAULT NULL, PRIMARY KEY (booking_id)) AUTO_INCREMENT=1;
    INSERT INTO booking (booking_id, user_id, name, email, phone, address, package_id, adults, children, date) VALUES ("1", "1", "name1", "test1@test.com", "123456789", "home", "3", "2", "1", "2023-09-30"),
    ("2", "2", "name2", "test2@test.com", "123", "home", "3", "5", "2", "2023-10-21"), ("30", "1", "name1", "test1@test.com", "12345", "adsf", "5", "2", "2", "2023-10-22");
    CREATE TABLE package (package_id int(11) NOT NULL, package_name varchar(100) NOT NULL, description text DEFAULT NULL, days int(11) DEFAULT NULL, price decimal(10,2) DEFAULT NULL,
    destinations varchar(200) DEFAULT NULL, PRIMARY KEY (package_id)) AUTO_INCREMENT=1;
    INSERT INTO package (package_id, package_name, description, days, price, destinations) VALUES ("1", "Isla de Margarita Package", "Kochi, Isla de Margarita.", "10", "40000.00", "Isla de Margarita"), ("2", "Isla de Coche Package", "Isla de Coche.", "7", "30000.00", "Isla de coche"),
    ("3", "Calafate Package", "Calafate.", "11", "37000.00", "Calafate"), ("4", "Cataratas Iguazu Package", "Cataratas de Iguazu", "10", "35000.00", "Cataratas"), ("5", "Buenos Aires Package", "Buenos Aires.", "6", "25000.00", "Buenos Aires"),
    ("6", "Buenos Aires at Night Package", "Buenos Aires at Night.", "9", "42000.00", "Buenos Aires");
    CREATE TABLE user ( user_id int(11) NOT NULL, username varchar(255) NOT NULL, email varchar(255) NOT NULL, password varchar(255) NOT NULL, regis_date datetime NOT NULL DEFAULT current_timestamp(), PRIMARY KEY (user_id)) AUTO_INCREMENT=1;
    INSERT INTO user (user_id, username, email, password, regis_date) VALUES ("1", "user1", "test1@test.com", "$2y$10$Snp9TypJqAy8UcTE6Nf1Qu1JPB.eQnXv0xjJ3KkFg4QMyXlAF5TIW", "2023-09-22 16:30:08"),
    ("2", "user2", "test2@test.com", "$2y$10$nfrL4wW1OqwfUTOGQWmBCu1EamV8HxAsSVrLkRy1z6.SFy81kGjp.", "2023-10-05 01:23:37");
EOF
 echo -e "\n\033[33m Info sql generada\033[0m\n"
 mysql < devopstravel.sql
 echo -e "\n\033[33m Info sql ejecutada\033[0m\n"
    
fi #cierre condicional
#Revisar la ingesta de datos en la base de datos


#echo -e "\n${LBLUE}Configurando base de datos ...${NC}"
echo -e "\n${LBLUE} Volcando parte de la base de datos ...${NC}"
# **PENDIENTE***Base de datos (Se debe automatizar que se pueda agregar el pass de la base de datos al momento de ejecutar el script asi evitamos que datos sensibles queden en el repositorio)
#mysql
#create database  devopstravel;
#exit
#mariadb -h localhost  -u root -P 3306  -p devopstravel < 295devops-groupo4/app-295devops-travel/database/devopstravel.sql
mysql -e "
use devopstravel;
select * from booking;"
#Revisar la ingesta de datos en la base de datos