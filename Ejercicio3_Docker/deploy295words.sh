#!/bin/bash

#Autor: Juan M Parra D.

#Variable
REPO="bootcamp-devops-2023"
BRANCH="ejercicio2-dockeriza"
FOLDER="295words-docker"
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



### Crear Dockerfile en Frontend 
echo -e "\n${LGREEN}Creando Dockerfile ${NC}"
echo "FROM golang:alpine AS builder" >> web/Dockerfile
echo "RUN mkdir /app" >> web/Dockerfile
echo "COPY . /app" >> web/Dockerfile
echo "WORKDIR /app" >> web/Dockerfile
echo "RUN go mod init WebApp" >> web/Dockerfile
echo "RUN go build -o dispatcher ." >> web/Dockerfile
echo 'CMD ["/app/dispatcher"]' >> web/Dockerfile

### Crear Dockerfile en Backend 
echo "FROM amazoncorretto:18 AS builder" > api/Dockerfile
echo "RUN yum install -y curl tar gzip" >> api/Dockerfile
echo "RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz -o /tmp/apache-maven-3.2.5-bin.tar.gz \\" >> api/Dockerfile
echo "    && tar xf /tmp/apache-maven-3.2.5-bin.tar.gz -C /opt \\" >> api/Dockerfile
echo "    && ln -s /opt/apache-maven-3.2.5 /opt/maven \\" >> api/Dockerfile
echo "    && ln -s /opt/maven/bin/mvn /usr/bin/mvn" >> api/Dockerfile
echo "ENV M2_HOME /opt/maven" >> api/Dockerfile
echo "ENV MAVEN_HOME /opt/maven" >> api/Dockerfile
echo "ENV PATH=\${M2_HOME}/bin:\${PATH}" >> api/Dockerfile
echo "WORKDIR /app" >> api/Dockerfile
echo "COPY pom.xml ." >> api/Dockerfile
echo "COPY src ./src" >> api/Dockerfile
echo "RUN mvn clean package" >> api/Dockerfile
echo "CMD [\"java\", \"-jar\", \"target/words.jar\"]" >> api/Dockerfile


#creando Docker-Compose file
echo -e "\n${LGREEN}Creando DockerCompose File ${NC}"
cat <<EOF > docker-compose.yml
version: "3"

services:
  web:
    container_name: web
    build:
      context: ./web
      args:
        - --no-cache
      dockerfile: Dockerfile
    ports:
      - "80:80"
    networks:
      - app-network

  api:
    container_name: api
    build:
      context: ./api
      args:
        - --no-cache
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    depends_on:
      - db
    networks:
      - app-network

  db:
    image: postgres:15-alpine
    restart: always
    environment:
      POSTGRES_DB: postgres
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - ./db:/docker-entrypoint-initdb.d
      - ./db/db-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"   
    networks:
      - app-network

  pgadmin:
    image: dpage/pgadmin4:4.18
    restart: always
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@example.com
      PGADMIN_DEFAULT_PASSWORD: secret123
      PGADMIN_DEFAULT_PORT: 80
    ports:
      - "5050:80"
    volumes:
      - ./pgadmin-data:/var/lib/pgadmin

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
#notify "/root/295devops-groupo4/Ejercicio3_Docker/$REPO"
fi

