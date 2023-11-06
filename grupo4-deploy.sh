#!/bin/bash

echo "Inicio de Aotomatización"

#Usuario Root solamente
#Permiso de ejecución





##################################STAGE 1: [Build]######################
#Instalacion de paquetes en el sistema operativo ubuntu: [apache, php, mariadb, git, curl, etc]


#git

#php

#apache
	#Importante se debe Configurar apache para que soporte extensión php, en el repositorio estan los pasos.


#Mariadb

#Base de datos (Se debe automatizar que se pueda agregar el pass de la base de datos al momento de ejecutar el script asi evitamos que datos sensibles queden en el repositorio)









##################################STAGE 2: [Build]######################

#el script debe permitir evaluar la existencia del proyecto, si existe un git pull y si no existe un git clone

#Mover al directorio donde se guardar los archivos de configuración de apache /var/www/html/
#Testear existencia del codigo de la aplicación

#Ajustar el config de php para que soporte los archivos dinamicos de php agregando index.php


#Testear la compatibilidad -> ejemplo http://localhost/info.php
#Si te muestra resultado de una pantalla informativa php , estariamos funcional para la siguiente etapa.












#Se recomienda renombrar en index.html default de apache para que no pise con el index.php


#Revisar la ingesta de datos en la base de datos