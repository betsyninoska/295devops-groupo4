#!/bin/bash

##################################STAGE 1: [Init]######################
echo "Iniciando"

#Variables
#MAIN="/root/BootCamp-DevOps-roxsross"
REPO="bootcamp-devops-2023"
REPOGRUPO4="295devops-groupo4"
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
  echo -e "\n${LGREEN} Actualizando servidor ${NC}"
  apt-get update
  echo -e "\n${LGREEN} El Servidor se encuentra Actualizado ...${NC}"

  # Instalando paquetes

  # variables
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


  #Configuraciones

  #Base de datos
  systemctl start mariadb
  systemctl enable mariadb
  echo "  *** successful Installation ***"
  # Configuración de la base de datos
  echo "  === Configurating Database ==="
      mysql -e "CREATE DATABASE devopstravel;
      CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
      GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
      FLUSH PRIVILEGES;"
  # Injección de primeros datos
  mysql <  $PWD/$APP/database/devopstravel.sql

  #Apache
  systemctl start apache2
  systemctl enable apache2
  mv /var/www/html/index.html /var/www/html/index.html.bkp
  # Ajustar la configuración de PHP para admitir archivos dinámicos
  sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf
  echo -e "\n${LGREEN} Apache2 configurado ...${NC}"


  echo -e "\n${LGREEN} Version php:${NC}"
  php -version | head -n 1

}

##################################STAGE 2: [Build]######################
build(){
  # Test de Repo
  if test -d "$PWD/$REPO"; then
      cd $PWD/$REPO
      git pull
  else
      sleep 1
      git clone -b $BRANCH https://github.com/roxsross/$REPO.git
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

  #echo -e "\n${LBLUE}Configurando base de datos ...${NC}"
  echo -e "\n${LBLUE} Volcando parte de la base de datos ...${NC}"
  mysql -e "
  use devopstravel;
  select * from booking;"
  #Revisar la ingesta de datos en la base de datos
  curl localhost

}


##################################STAGE 3: [Deploy]######################
deploy(){

  echo -e "\n${LBLUE} Reload Web ...${NC}"
  sleep 1
  systemctl reload apache2
  #echo -e "\n${LBLUE} Sitio desplegado ...${NC}"

  app_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/index.php)

  if [ $app_status -eq 200 ]; then
    echo "La aplicacion esta funcional"
  else
    echo "La aplicacion no esta lista"
    exit 1
  fi


}

##################################STAGE 4: [Notify]######################
notify() {
    echo -e "\n${LGREEN}STAGE 4: [NOTIFY]${NC}"
    # Configura el token de acceso de tu bot de Discord
    DISCORD="https://discord.com/api/webhooks/1169002249939329156/7MOorDwzym-yBUs3gp0k5q7HyA42M5eYjfjpZgEwmAx1vVVcLgnlSh4TmtqZqCtbupov"

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
    WEB_URL="localhost"
    # Realiza una solicitud HTTP GET a la URL
    HTTP_STATUS=$(curl -Is "$WEB_URL" | head -n 1)

    # Verifica si la respuesta es 200 OK (puedes ajustar esto según tus necesidades)
    if [[ "$HTTP_STATUS" == "200 OK" ]]; then
        # Obtén información del repositorio
        DEPLOYMENT_INFO2="Despliegue del repositorio $REPO_NAME: "
        DEPLOYMENT_INFO="La página web $WEB_URL está en línea."
        COMMIT="Commit: $(git rev-parse --short HEAD)"
        AUTHOR="Autor: $(git log -1 --pretty=format:'%an')"
        DESCRIPTION="Descripción: $(git log -1 --pretty=format:'%s')"
    else
        DEPLOYMENT_INFO="La página web $WEB_URL no está en línea."
    fi

    # Construye el mensaje
    MESSAGE="$DEPLOYMENT_INFO2\n$DEPLOYMENT_INFO\n$COMMIT\n$AUTHOR\n$REPO_URL\n$DESCRIPTION"

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
  notify "https://github.com/betsyninoska/$REPOGRUPO4"
fi

