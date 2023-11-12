#!/bin/bash

##################################STAGE 1: [Init]######################
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
echo  -e "\n${LGREEN} ######################Inicio de Automatizacion#########################${NC}"
echo  -e "\n${LGREEN} ########################################################################${NC}"

#Usuario Root solamente
if [ "${USERID}" -ne 0 ]; then
       echo -e "\n${LGREEN} El usuario debe ser Root ${NC}"
       exit
fi

echo -e "\n${LGREEN} Actualizando servidor ${NC}"
apt-get update
echo -e "\n${LGREEN} El Servidor se encuentra Actualizado ...${NC}"


# Instalando paquetes
# curl
if ! dpkg -s curl > /dev/null 2>&1; then
    apt install curl -y 2>&1
fi

# Git
if dpkg -s git > /dev/null 2>&1; then
    echo "  *** Git installed ***"
else
    echo "installing Git..."
    apt install git -y > /dev/null 2>&1
    echo "  *** successful Installation ***"
fi


#Mariadb
if dpkg -s mariadb-server > /dev/null 2>&1; then
    echo -e "\n${LBLUE}Mariadb se encuentra Actualizado ...${NC}"
else
    echo -e "\n${LYELLOW}instalando MARIA DB ...${NC}"
    apt install -y mariadb-server
    ###Iniciando la base de datos
    systemctl start mariadb
    systemctl enable mariadb
    echo "  *** successful Installation ***"
 # Configuración de la base de datos
    echo "  === Configurating Database ==="
    mysql -e "CREATE DATABASE devopstravel;
    CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
    GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
    FLUSH PRIVILEGES;"
fi    

#Apache

if dpkg -s apache2 > /dev/null 2>&1; then
      echo -e "\n${LGREEN} El Apache2 se encuentra ya instalado ...${NC}"
else
      echo -e "\n${LYELLOW} Instalando apache2 ...${NC}"
      apt install -y apache2
      #php
      apt install -y php libapache2-mod-php php-mysql
      systemctl start apache2
      systemctl enable apache2
      mv /var/www/html/index.html /var/www/html/index.html.bkp
      # Ajustar la configuración de PHP para admitir archivos dinámicos
      sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf
      echo -e "\n${LGREEN} Apache2 instalado ...${NC}"}
 fi

echo -e "\n${LGREEN} Version php:${NC}"
php -version | head -n 1



##################################STAGE 2: [Build]######################

#MAIN="/root/BootCamp-DevOps-roxsross"
REPO="bootcamp-devops-2023"
BRANCH="clase2-linux-bash"
APP="app-295devops-travel"


# Test de Repo
if test -d "$PWD/$REPO"; then
    cd $PWD/$REPO
    git pull
else
    sleep 1
    git clone -b $BRANCH https://github.com/roxsross/$REPO.git
    # Injección de primeros datos
    mysql <  $PWD/$REPO/$APP/database/devopstravel.sql
fi



# Copiando archivos
cd $REPO
cp -r $APP/* /var/www/html
sed -i 's/""/"codepass"/g' /var/www/html/config.php
# Test de codigo
if test -f "/var/www/html/index.php"; then 
    echo "  "
    echo "  === The code was copied ==="

fi

##################################STAGE 3: [Deploy]######################

curl localhost


#echo -e "\n${LBLUE}Configurando base de datos ...${NC}"
echo -e "\n${LBLUE} Volcando parte de la base de datos ...${NC}"
mysql -e "
use devopstravel;
select * from booking;"
#Revisar la ingesta de datos en la base de datos


echo -e "\n${LBLUE} Reload Web ...${NC}"
sleep 1
systemctl reload apache2
echo -e "\n${LBLUE} Sitio desplegado ...${NC}"


##################################STAGE 4: [Notify]######################

# Configura el token de acceso de tu bot de Discord
##DISCORD="https://discord.com/api/webhooks/1169002249939329156/7MOorDwzym-yBUs3gp0k5q7HyA42M5eYjfjpZgEwmAx1vVVcLgnlSh4TmtqZqCtbupov"


# Obtiene el nombre del repositorio
##REPO_NAME=$(basename $(git rev-parse --show-toplevel))
# Obtiene la URL remota del repositorio
##REPO_URL=$(git remote get-url origin)
##WEB_URL="localhost"
# Realiza una solicitud HTTP GET a la URL
##HTTP_STATUS=$(curl -Is "$WEB_URL" | head -n 1)

# Verifica si la respuesta es 200 OK 

##if [[ "$HTTP_STATUS" == *"200 OK"* ]]; then
  # Obtén información del repositorio
##    DEPLOYMENT_INFO2="Despliegue del repositorio $REPO_NAME: "
##    DEPLOYMENT_INFO="La página web $WEB_URL está en línea."
##    COMMIT="Commit: $(git rev-parse --short HEAD)"
##    AUTHOR="Autor: $(git log -1 --pretty=format:'%an')"
##    DESCRIPTION="Descripción: $(git log -1 --pretty=format:'%s')"
##else
##  DEPLOYMENT_INFO="La página web $WEB_URL no está en línea."
##fi

# Envía el mensaje a Discord utilizando la API de Discord
# Construye el mensaje
##MESSAGE="$DEPLOYMENT_INFO2\n$DEPLOYMENT_INFO\n$COMMIT\n$AUTHOR\n$REPO_URL\n$DESCRIPTION"
##curl -X POST -H "Content-Type: application/json" \
##     -d '{
##       "content": "'"${MESSAGE}"'"
##     }' "$DISCORD"