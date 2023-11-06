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




if dpkg -s git > /dev/null 2>&1; then
      echo -e "\n${LBLUE} xxxEl Apache2 se encuentra ya instalado ...${NC}"
else    
      echo -e "\n${LBLUE} xxxxInstalanco Apache2 ...${NC}"
     # apt instll -y apache2
      #apt install -y php libapache2-mod-php php-mysql
      #systemctl start apache2
      #systemctl enable apache2
 fi

if dpkg -l git >/dev/null; then echo yes;fi
