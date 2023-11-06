#!/bin/bash
echo "Iniciando"

#Variables
repo="app-295devops-travel"
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
    git clone  https://github.com/betsyninoska/$repo.git
    cp -r $repo/app-295devops-travel /var/www/html
fi

#Ajustar el config de php para que soporte los archivos dinamicos de php agregando index.php
#Testear la compatibilidad -> ejemplo http://localhost/info.php
#Si te muestra resultado de una pantalla informativa php , estariamos funcional para la siguiente etapa.




#Mariadb

if dpkg -s mariadb-server > /dev/null 2>&1; then
    echo -e "\n${LBLUE}Mariadb se encuentra Actualizado ...${NC}"
else
    echo -e "\n${LYELLOW}instalando MARIA DB ...${NC}"
    apt install -y mariadb-server
    ###Iniciando la base de datos
    systemctl start mariadb
    systemctl enable mariadb

fi #cierre condicional

echo -e "\n${LBLUE}Configurando base de datos ...${NC}"
# **PENDIENTE***Base de datos (Se debe automatizar que se pueda agregar el pass de la base de datos al momento de ejecutar el script asi evitamos que datos sensibles queden en el repositorio)

mysql
create database  devopstravel;
exit
mariadb -h localhost  -u root -P 3306  -p devopstravel < 295devops-groupo4/app-295devops-travel/database/devopstravel.sql
mysql
use devopstravel;
select * from booking;

#Revisar la ingesta de datos en la base de datos
