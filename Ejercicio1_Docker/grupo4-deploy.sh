#!/bin/bash
#Programa para mostrar menu de opciones
#Autor: Juan M Parra D.

#Variable
REPO="bootcamp-devops-2023"
BRANCH="ejercicio2-dockeriza"
FOLDER="295devops-travel-lamp"
#Colores
LRED='\033[1;31m'
LGREEN='\033[1;32m'
NC='\033[0m'
LBLUE='\033[0;34m'
LYELLOW='\033[1;33m'

init(){
    echo -e "\n${LGREEN}STAGE 1: [INIT]${NC}"

#UPDATE
apt-get update
echo -e "\n${LGREEN}El Servidor se encuentra Actualizado...${NC}"

#Instalación de Git
apt install -y git 
echo -e "\n${LYELLOW} instalando GIT... ${NC}"

echo -e "\n${LGREEN}STAGE 1: Init Finalizado ${NC}"
sleep 1
}

build(){
    echo -e "\n${LGREEN}STAGE 2: [Build]${NC}"

if [ -d "${REPO}" ]; then
    echo -e "\n${LBLUE}repositorio ya existe...${NC}"
    rm -rf ${REPO}          
fi
echo -e "\n${LYELLOW}Instalando WEB...${NC}"
sleep 1
git clone https://github.com/roxsross/$REPO
sleep 1
cd $REPO
git checkout $BRANCH
sleep 1

cd $FOLDER

sleep 1

#creando variables de entornos desde el script
echo "MYSQL_PASSWORD=codepass" >> .env
echo "MYSQL_ROOT_PASSWORD=Strongpassword@123" >> .env
echo "DB_HOST=dbphp" >> .env
echo "DB_PORT=3306" >> .env
echo "MYSQL_DATABASE=devopstravel" >> .env
echo "DB_USER=codeuser" >> .env

sed -i 's/"localhost"/getenv('\''DB_HOST'\'')/g' config.php
sed -i 's/"codeuser"/getenv('\''DB_USER'\'')/g' config.php
sed -i 's/""/getenv('\''MYSQL_PASSWORD'\'')/g' config.php
sed -i 's/"devopstravel"/getenv('\''MYSQL_DATABASE'\'')/g' config.php

### Crear Dockerfile en . 
echo -e "\n${LGREEN}Creando Dockerfile ${NC}"
../../create_dockerfile.sh
#creando Docker-Compose file
echo -e "\n${LGREEN}Creando DockerCompose File ${NC}"
../../create_docker_compose.sh

echo -e "\n${LGREEN}STAGE 2: Build Finalizado ${NC}"
sleep 3
}

deploy(){
# Ejecutar Docker Compose
docker-compose up -d

    sleep 1
opts=("dbphp" "php" "phpmyadmin")

# Iterate through each container in the array
for container in "${opts[@]}"; do
    status=$(docker inspect --format='{{json .State.Health.Status}}' "$container")
    echo "Container: $container - Health Status: $status"
done
}


notify() {
    echo -e "\n${LGREEN}STAGE 4ii: [NOTIFY]${NC}"
    # Configura el token de acceso de tu bot de Discord
    DISCORD="https://discord.com/api/webhooks/1154865920741752872/au1jkQ7v9LgQJ131qFnFqP-WWehD40poZJXRGEYUDErXHLQJ_BBszUFtVj8g3pu9bm7h"
    # Verifica si se proporcionÃ³ el argumento del directorio del repositorio
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
        # ObtÃ©n informaciÃ³n del repositorio
        DEPLOYMENT_INFO2="Despliegue del repositorio $REPO_NAME: "
        DEPLOYMENT_INFO="La pÃ¡gina web $WEB_URL estÃ¡ en lÃ­nea."
        GRUPO="Equipo 4"        
        COMMIT="Commit: $(git rev-parse --short HEAD)"
        AUTHOR="Autor: $(git log -1 --pretty=format:'%an')"
        DESCRIPTION="Descripcion: $(git log -1 --pretty=format:'%s')"
        echo -e "\n${LGREEN}$i La aplicacion esta funcional ${NC}"
    else
        DEPLOYMENT_INFO="La pa�gina web $WEB_URL no estÃ¡ en lÃ­nea."
        GRUPO="Equipo 4"
        COMMIT="Commit: $(git rev-parse --short HEAD)"
        AUTHOR="Autor: $(git log -1 --pretty=format:'%an')"
        DESCRIPTION="DescripciÃ³n: $(git log -1 --pretty=format:'%s')"
        echo -e "\n${LRED}$i La aplicacion no esta lista ${NC}"
    fi

    MESSAGE="$DEPLOYMENT_INFO2\n$DEPLOYMENT_INFO\n$COMMIT\n$AUTHOR\n$GRUPO\n$REPO_URL\n$DESCRIPTION"

    # EnvÃ­a el mensaje a Discord utilizando la API de Discord
    curl -X POST -H "Content-Type: application/json" \
         -d '{
           "content": "'"${MESSAGE}"'"
         }' "$DISCORD"
}







if [ $EUID != 0 ]; then
    echo -e "\n${LRED}You need to have root privileges to run this script.${NC}"
    exit 1
else 
    init
    build
    deploy
    notify "/root/295devops-groupo4/Ejercicio1_Docker/$REPO"
fi
