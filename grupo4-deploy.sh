#!/bin/bash

##################################STAGE 1: [Init]######################
#variables
REPO="bootcamp-devops-2023"
BRANCH="clase2-linux-bash"
APP="app-295devops-travel"
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

init(){
  echo -e "\n${LGREEN}Actualizando servidor ${NC}"
  apt-get update
  echo -e "\n${LGREEN}El Servidor se encuentra Actualizado ...${NC}"

  # Instalando paquetes
  PKG=(
      apache2
      git
      curl
      mariadb-server
      php
      libapache2-mod-php
      php-mysql
  )

  for i in "${PKG[@]}"
  do
      dpkg -s $i &> /dev/null
      if [ $? -eq 0 ]; then
          sleep 1
          echo -e "\n${LGREEN}$i is already installed...${NC}"
      else
          echo -e "\n${LGREEN}$i instalando $i ${NC}"
          apt install $i -y
          if [ $? -ne 0 ]; then
              echo -e "\n${LRED} Error installing $i ${NC}"
              exit 1
          else
            echo -e "\n${LGREEN}$i Installed $i ${NC}"
          fi

      fi
  done
  echo -e "\n${LGREEN} *** successful Installation *** ${NC}"
  #Mariadb  
  systemctl start mariadb
  systemctl enable mariadb
  #Apache
  systemctl start apache2
  systemctl enable apache2
  
  mv /var/www/html/index.html /var/www/html/index.html.bkp
  # Ajustar la configuración de PHP para admitir archivos dinámicos
  sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf
  echo -e "\n${LGREEN} Apache2 configurado ...${NC}"


  echo -e "\n${LGREEN}Version php:${NC}"
  php -version | head -n 1
}

##################################STAGE 2: [Build]######################
build(){
  # Test de Repo
  if test -d "$PWD/$REPO"; then
      cd $REPO
      git pull
  else
      sleep 1
      #git clone -b $BRANCH https://github.com/roxsross/$REPO.git
      # Clonar el repositorio desde GitHub
      git clone https://github.com/roxsross/bootcamp-devops-2023.git

      # 2. Desplazarse al repositorio y cambiar a la rama 'clase2-linux-bash'
     cd $REPO
  fi

  git checkout clase2-linux-bash

  # Copiando archivos
  cp -r app-295devops-travel/* /var/www/html 
  sleep 5
  sed -i 's/""/"codepass"/g' /var/www/html/config.php

  # Test de codigo
  if test -f "/var/www/html/index.php"; then
      echo "  "
      echo -e "\n${LBLUE} Fuentes copiadas ...${NC}"
  fi

  # Configuración de la base de datos
  database_check=$(mysql -e "SHOW DATABASES LIKE 'devopstravel'")
  if [ -z "$database_check" ]; then
      echo -e "\n${LBLUE} Volcando y verificacion de la base de datos ...${NC}"      
      mysql -e "CREATE DATABASE devopstravel;
      CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
      GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
      FLUSH PRIVILEGES;"
      mysql <  $PWD/$APP/database/devopstravel.sql
  else
      echo -e "\n${LGREEN}$i La base de datos 'devopstravel' ya existe ${NC}"
  fi
  #Verificaci�n de los datos
  mysql -e  "
  use devopstravel;
  select * from booking; "

}


##################################STAGE 3: [Deploy]######################
deploy(){

  
  echo -e "\n${LBLUE} Sitio desplegado ...${NC}"
  #Reload to get changes
  sudo systemctl reload apache2 >/dev/null 2>&1

  #Verificar la aplicacion
  curl localhost
}

##################################STAGE 4: [Notify]######################
notify() {
    echo -e "\n${LGREEN}STAGE 4ii: [NOTIFY]${NC}"
    # Configura el token de acceso de tu bot de Discord
    DISCORD="https://discord.com/api/webhooks/1154865920741752872/au1jkQ7v9LgQJ131qFnFqP-WWehD40poZJXRGEYUDErXHLQJ_BBszUFtVj8g3pu9bm7h"
    # Verifica si se proporcionó el argumento del directorio del repositorio
    if [ $# -ne 1 ]; then
        echo "Uso: $0 <ruta_al_repositorio>"
        exit 1
    fi

    # Cambia al directorio del repositorio
    cd "$1"

    # Obtiene el nombre del repositorio
    REPO_NAME=$(basename $(git rev-parse --show-toplevel))
    # Obtiene la URL remota del repositorio
    REPO_URL=$(git remote get-url origin)
    WEB_URL="http://localhost/index.php"    
    # Realiza una solicitud HTTP GET a la URL
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$WEB_URL")


    if [ "$HTTP_STATUS" -eq 200 ]; then
        # Obtén información del repositorio
        DEPLOYMENT_INFO2="Despliegue del repositorio $REPO_NAME: "
        DEPLOYMENT_INFO="La página web $WEB_URL está en línea."
        GRUPO="Equipo 4"        
        COMMIT="Commit: $(git rev-parse --short HEAD)"
        AUTHOR="Autor: $(git log -1 --pretty=format:'%an')"
        DESCRIPTION="Descripción: $(git log -1 --pretty=format:'%s')"
        echo -e "\n${LGREEN}$i La aplicacion esta funcional ${NC}"
    else
        DEPLOYMENT_INFO="La página web $WEB_URL no está en línea."
        GRUPO="Equipo 4"
        COMMIT="Commit: $(git rev-parse --short HEAD)"
        AUTHOR="Autor: $(git log -1 --pretty=format:'%an')"
        DESCRIPTION="Descripción: $(git log -1 --pretty=format:'%s')"
        echo -e "\n${LRED}$i La aplicacion no esta lista ${NC}"
    fi

    MESSAGE="$DEPLOYMENT_INFO2\n$DEPLOYMENT_INFO\n$COMMIT\n$AUTHOR\n$GRUPO\n$REPO_URL\n$DESCRIPTION"

    # Envía el mensaje a Discord utilizando la API de Discord
    curl -X POST -H "Content-Type: application/json" \
         -d '{
           "content": "'"${MESSAGE}"'"
         }' "$DISCORD"
}

#Usuario Root solamente
if [ $EUID != 0 ]; then
    echo -e "\n${LRED}You need to have root privileges to run this script.${NC}"
    exit 1
else
  init
  build
  deploy
  notify "/root/295devops-groupo4/bootcamp-devops-2023"
fi

