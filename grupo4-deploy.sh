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



echo  -e "\n${LRED} ########################################################################${NC}"
echo -e "\n${LRED} ######################Inicio de Automatizacion#########################${NC}"
echo -e "\n${LRED} ########################################################################${NC}"



#Usuario Root solamente
if [ "${USERID}" -ne 0 ]; then
       echo -e "\n${LRED} El usuario debe ser Root ${NC}"
       exit
fi



echo -e "\n${LBLUE} Actualizando servidor ${NC}"
apt-get update
echo -e "\n${LGREEN} El Servidor se encuentra Actualizado ...${NC}"







##################################STAGE 1: [Build]######################
#Instalacion de paquetes en el sistema operativo ubuntu: [apache, php, mariadb, git, curl, etc]
#apache
	#Importante se debe Configurar apache para que soporte extensión php, en el repositorio estan los pasos.


  if dpkg -s apache2 > /dev/null 2>&1; then
        echo -e "\n${LBLUE} El Apache2 se encuentra ya instalado ...${NC}"
  else
        echo -e "\n${LBLUE} Instalanco Apache2 ...${NC}"
        apt install -y apache2
        apt install -y php libapache2-mod-php php-mysql
        systemctl start apache2
        systemctl enable apache2
        mv /var/www/html/index.html /var/www/html/index.html.bkp
        echo -e "\n${LBLUE} Apache2 instalado ...${NC}"
   fi



#git
apt install -y git
echo -e "\n${LYELLOW}instalando GIT ...${NC}"

#php



#Mariadb

if dpkg -s mariadb-server > /dev/null 2>&1; then
    echo -e "\n${LBLUE}El Servidor se encuentra Actualizado ...${NC}"
else
    echo -e "\n${LYELLOW}instalando MARIA DB ...${NC}"
    apt install -y mariadb-server
    ###Iniciando la base de datos
    systemctl start mariadb
    systemctl enable mariadb

    echo -e "\n${LBLUE}Configurando base de datos ...${NC}"
    #Base de datos (Se debe automatizar que se pueda agregar el pass de la base de datos al momento de ejecutar el script asi evitamos que datos sensibles queden en el repositorio)
fi #cierre condicional



##################################STAGE 2: [Build]######################

#el script debe permitir evaluar la existencia del proyecto, si existe un git pull y si no existe un git clone

#if [ -d "$repo" ]; then
#    echo "La carpeta $repo existe"
#    rm -rf $repo
#fi

#echo -e "\n\e[92mInstalling web ...\033[0m\n"
#sleep 1
#git clone -b app-295devops-travel https://github.com/betsyninoska/$repo.git
#cp -r $repo/* /var/www/html

#Mover al directorio donde se guardar los archivos de configuración de apache /var/www/html/
#Testear existencia del codigo de la aplicación

#Ajustar el config de php para que soporte los archivos dinamicos de php agregando index.php


#Testear la compatibilidad -> ejemplo http://localhost/info.php
#Si te muestra resultado de una pantalla informativa php , estariamos funcional para la siguiente etapa.




#Se recomienda renombrar en index.html default de apache para que no pise con el index.php


#Revisar la ingesta de datos en la base de datos
