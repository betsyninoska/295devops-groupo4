#!/bin/bash
#Programa para mostrar menu de opciones
#Autor: Juan M Parra D.

#Variable
REPO="bootcamp-devops-2023"
BRANCH="ejercicio2-dockeriza"
FOLDER="295topics-fullstack"
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
#creando variables de entornos



#creando variables de entornos backend
echo "API_URI=http://backend:5000/api/topics" >> .env
echo "DATABASE_URL=mongodb://mongodb:27017" >> .env
echo "DATABASE_NAME=TopicstoreDb" >> .env
echo "HOST=0.0.0.0" >> .env
echo "PORT=5000" >> .env

echo "API_URI=http://jotamario:5000/api/topics" >> frontend/.env
echo "DATABASE_URL=mongodb://mongodb:27017" >> backend/.env
echo "DATABASE_NAME=TopicstoreDb" >> backend/.env
echo "HOST=0.0.0.0" >> backend/.env
echo "PORT=5000" >> backend/.env



### Crear Dockerfile en Frontend 
echo -e "\n${LGREEN}Creando Dockerfile ${NC}"
echo "FROM node:16-alpine AS builder" >> frontend/Dockerfile
echo "WORKDIR /usr/src/app" >> frontend/Dockerfile
echo "COPY package*.json ./" >> frontend/Dockerfile
echo "RUN npm install" >> frontend/Dockerfile
echo "COPY . ." >> frontend/Dockerfile
echo "EXPOSE 3000" >> frontend/Dockerfile
echo 'CMD ["node", "server.js"]' >> frontend/Dockerfile

### Crear Dockerfile en Backend 
echo "FROM node:16-alpine AS builder" >> backend/Dockerfile
echo "WORKDIR /usr/src/app" >> backend/Dockerfile
echo "RUN npm install -g ts-node" >> backend/Dockerfile
echo "COPY package*.json ./" >> backend/Dockerfile
echo "RUN npm install" >> backend/Dockerfile
echo "COPY . ." >> backend/Dockerfile
echo "RUN npm run prebuild" >> backend/Dockerfile
echo "RUN npm run build" >> backend/Dockerfile
echo "EXPOSE 5000" >> backend/Dockerfile
echo 'CMD ["npm", "start"]' >> backend/Dockerfile


#creando Docker-Compose file
echo -e "\n${LGREEN}Creando DockerCompose File ${NC}"
cat <<EOF > docker-compose.yml
version: "3"

services:
  frontend:
    container_name: frontend
    env_file:
      - .env
    build:
      context: ./frontend
      args:
        - --no-cache
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      API_URI: '\${API_URI}'
    networks:
      - app-network

  backend:
    container_name: backend
    env_file:
      - .env
    build:
      context: ./backend
      args:
        - --no-cache
      dockerfile: Dockerfile
    ports:
      - "5000:5000"
    environment:
      DATABASE_URL: '\${DATABASE_URL}'
      DATABASE_NAME: '\${DATABASE_NAME}'
      HOST: '\${HOST}'
      PORT: '\${PORT}'
    depends_on:
      - mongodb
    networks:
      - app-network

  mongodb:
    image: mongo
    container_name: mongodb
    ports:
      - "27017:27017"
    volumes:
      - ./db/db-data:/data/db
      - ./db:/docker-entrypoint-initdb.d
    networks:
      - app-network

  mongo_ui:
    image: mongo-express
    container_name: mongo_ui
    ports:
      - "8081:8081"
    environment:
      ME_CONFIG_MONGODB_SERVER: mongodb
      ME_CONFIG_MONGODB_PORT: 27017
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 172.25.0.0/16 

EOF

echo -e "\n${LGREEN}STAGE 2: Build Finalizado ${NC}"
sleep 3
}

deploy(){
# Ejecutar Docker Compose
docker-compose up -d --build
sleep 5
docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq)
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
        DESCRIPTION="DescripciÃ³n: $(git log -1 --pretty=format:'%s')"
        echo -e "\n${LGREEN}$i La aplicacion esta funcional ${NC}"
    else
        DEPLOYMENT_INFO="La pÃ¡gina web $WEB_URL no estÃ¡ en lÃ­nea."
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
