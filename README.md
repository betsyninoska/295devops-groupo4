# Ejercicio-1 Linux y Automatización - 
## Un Portal DevOps para Explorar

Con el Equipo 295, la automatización dejará de ser manual, repetitiva y propensa a errores para convertirse en un proceso rápido y seguro.

## Acerca de DevOps Travel

Los usuarios pueden reservar paquetes fácilmente a través de esta plataforma amigable en la ubicación deseada. El front-end del sitio web está desarrollado con HTML, CSS y JavaScript, asegurando flexibilidad y capacidad de respuesta. El back-end, impulsado por una base de datos PHP y MySQL, se ejecuta en un servidor Apache.

## Descripción de la Arquitectura

En el diagrama de arquitectura, los usuarios inician una solicitud HTTP accediendo a la aplicación a través del navegador usando "localhost" o la dirección IP del servidor. El servidor Apache responde entregando el archivo solicitado, solicitando a los usuarios que completen sus detalles, como nombre, correo electrónico y descripción.

Una vez completado el formulario, los usuarios envían los datos al servidor. Apache reenvía estos datos a un script PHP responsable de almacenar la información en la base de datos MySQL. Si los datos se almacenan con éxito, MySQL comunica este logro al script PHP, que responde con un mensaje HTML que se muestra en el navegador del usuario. Si surge algún problema con el almacenamiento de datos, el script PHP devuelve un mensaje de error al navegador del usuario.

Esta sólida arquitectura garantiza un flujo de datos eficiente entre los usuarios, Apache, PHP y MySQL, lo que proporciona una experiencia de usuario fluida y una gestión de datos confiable.

## Diagrama de la Aplicación
Puntos de Acceso Principales:

- Página de Inicio
- Galería
- Paquete
- Reserva

## El Desafío

Crear un script en bash que pueda instalar la web, la base de datos y el servidor Apache en Linux (Ubuntu) para desplegar la aplicación web. Este enfoque sigue la arquitectura LAMP, que representa Linux, Apache, MySQL y PHP, un conjunto de aplicaciones de software de código abierto comúnmente utilizadas para alojar aplicaciones web dinámicas.

### Lo que Representa LAMP

- Linux: El sistema operativo en el que se ejecutarán las aplicaciones web, conocido por su estabilidad y escalabilidad.
- Apache: El servidor web, ampliamente utilizado y altamente configurable.
- MySQL: El sistema de gestión de bases de datos relacionales utilizado para almacenar y administrar los datos de la aplicación web.
- PHP (o a veces Perl o Python): El lenguaje de programación utilizado para desarrollar la lógica de la aplicación web.

### Sistema Operativo: Ubuntu

## Consideraciones Importantes

- El nombre del script puede ser elegido por el equipo, por ejemplo, "deploy.sh" o "grupo1-deploy.sh".
- Asegúrese de conceder permisos de ejecución para ejecutarlo como ./deploy.sh.
- El script debe evaluar si solo el usuario root puede ejecutarlo o verificar los privilegios de superusuario "sudo" antes de la ejecución.
- Compruebe la existencia de paquetes como [git, php, apache, mariadb] para evitar reinstalarlos.
- Automatice la adición de la contraseña de la base de datos al ejecutar el script para evitar que se almacenen datos sensibles en el repositorio.
- Pruebe la funcionalidad de PHP.
- Configure Apache para admitir la extensión PHP (pasos en el repositorio).
- Considere cambiar el nombre del índice predeterminado de Apache de index.html para evitar conflictos con index.php.
- Copie archivos estáticos al directorio de Apache /var/www/html.
- El script debe evaluar la existencia del proyecto, realizar un git pull si existe y un git clone si no existe.
- Asegúrese de la ingestión de datos en la base de datos.

## Resumen

Este es el flujo que debe seguir el script:

### ETAPA 1: [Inicio]

- Instalación de paquetes en el sistema operativo Ubuntu: [apache, php, mariadb, git, curl, etc.].
- Validación de la instalación de paquetes para evitar reinstalaciones.
- Habilitar y probar la instalación de paquetes.

### ETAPA 2: [Construcción]

- Clonar el repositorio de la aplicación.
- Comprobar si el repositorio de la aplicación no existe; si es así, realizar un git clone. Si existe, realizar un git pull.
- Mover al directorio donde se almacenan los archivos de configuración de Apache (/var/www/html/).
- Probar la existencia del código de la aplicación.
- Ajustar la configuración de PHP para admitir archivos PHP dinámicos agregando index.php.
- Probar la compatibilidad (por ejemplo, http://localhost/info.php).

### ETAPA 3: [Despliegue]

- Probar la aplicación; recuerde recargar Apache y acceder a la aplicación DevOps Travel.
- La aplicación está disponible para los usuarios finales.

### ETAPA 4: [Notificación]

- Informar sobre el estado de la aplicación, ya sea que esté funcionando correctamente o tenga problemas, a través de un webhook en el canal de Discord #deploy-bootcamp.
- La información a mostrar incluye el Autor del Commit, Commit, Descripción, Grupo y Estado.

## Documentación Adicional
- [Cómo Instalar MariaDB en Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-mariadb-on-ubuntu-20-04)
- [Guía de Referencia de MySQL](https://dev.mysql.com/doc/refman/8.0/en/)
- [Comando `sed` de Linux: Usos y Ejemplos](https://www.hostinger.com/tutoriales/el-comando-sed-de-linux-usos-y-ejemplos)
- [40 Comandos Básicos de Linux que Todo Usuario Debe Saber](https://www.hostinger.com/tutoriales/linux-commands)


# Resolución del reto

# Clonar repo de desafios y ejercicios
- `git clone https://github.com/betsyninoska/295devops-group4.git`

# Reto 1: app-295devops-travel
- `cd 295devops-groupo4`
- `chmod +x grupo4-deploy.sh `
- `./grupo4-deploy.sh`

- Ir a Traffic/Ports -> port 80

![](/img/trafficport.png) 

# Despliegue de las Etapas del Reto - Resolución del ejercicio

ETAPA 1: [Inicio del despliegue...]
- Instalación de paquetes en el sistema operativo Ubuntu: [apache, php, mariadb, git, curl, etc.].
- Validación de la instalación de paquetes para evitar reinstalaciones.
- Habilitar y probar la instalación de paquetes

Los requisitos planteados se resolvieron cómo se muestra en la siguiente imagen:
    [![rt02.jpg](https://i.postimg.cc/kGBLHZtx/rt02.jpg)](https://postimg.cc/y3CfgLjd)

### ETAPA 2: [Construcción - Build - Despliegue]

- Clonar el repositorio de la aplicación.
- Comprobar si el repositorio de la aplicación no existe; si es así, realizar un git clone. Si existe, realizar un git pull.
- Mover al directorio donde se almacenan los archivos de configuración de Apache (/var/www/html/).
- Probar la existencia del código de la aplicación.
- Ajustar la configuración de PHP para admitir archivos PHP dinámicos agregando index.php.
- Probar la compatibilidad (por ejemplo, http://localhost/info.php).

    Se ofrece a continuación una imagen de como se resolvieron los requisitos en esta etapa:
    [![rt03.jpg](https://i.postimg.cc/0j3kb7sq/rt03.jpg)](https://postimg.cc/D4rkNJ0C)
### ETAPA 3: [Despliegue final]

- Probar la aplicación; recuerde recargar Apache y acceder a la aplicación DevOps Travel.
- La aplicación está disponible para los usuarios finales.

A continuación se ofrece la explicación de cómo se ejecutó lo planteado:
[![rt04.jpg](https://i.postimg.cc/pLSMtKHf/rt04.jpg)](https://postimg.cc/21nKQb3y)

### ETAPA 4: [Notificación]

- Informar sobre el estado de la aplicación, ya sea que esté funcionando correctamente o tenga problemas, a través de un webhook en el canal de Discord #deploy-bootcamp.
- La información a mostrar incluye el Autor del Commit, Commit, Descripción, Grupo y Estado.

Esta etapa fue resuelta como se mestra en la imagen:
[![rt05.jpg](https://i.postimg.cc/N0YNrMBy/rt05.jpg)](https://postimg.cc/FYWbMhfm)

    La notificacíon de envío a Discord se muestra a continuación:

[![discordr4.jpg](https://i.postimg.cc/c4Lt6Gps/discordr4.jpg)](https://postimg.cc/7bjZQdPc)

A continuación ofrecemos un vídeo del despliegue para su evaluación:

[![Video](https://img.youtube.com/vi/v0zvGUrv3KY/maxresdefault.jpg)](https://youtu.be/v0zvGUrv3KY)