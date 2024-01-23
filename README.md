# IV Edición Bootcamp DevOps by RoxsRoss
![JavaScript](https://img.shields.io/badge/-JavaScript-F7DF1E?style=for-the-badge&logo=JavaScript&logoColor=black)
![Node.js](https://img.shields.io/badge/-Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![HTML5](https://img.shields.io/badge/-HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-7B42BC?logo=terraform&logoColor=white&style=for-the-badge)
![VSCode](https://img.shields.io/badge/Visual_Studio_Code-0078D4?style=for-the-badge&logo=visual%20studio%20code&logoColor=white)
![kubernetes](https://img.shields.io/badge/kubernetes-326CE5?logo=kubernetes&logoColor=white&style=for-the-badge)
![Azure](https://img.shields.io/badge/azure-0078D4?logo=microsoft-azure&logoColor=white&style=for-the-badge)
![Amazon](https://img.shields.io/badge/Amazon_AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Gcp](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![Docker](https://img.shields.io/badge/docker-2496ED?logo=docker&logoColor=white&style=for-the-badge)
![python](https://img.shields.io/badge/python-3776AB?logo=python&logoColor=white&style=for-the-badge)
![golang](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)
![github Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Gitlab](https://img.shields.io/badge/GitLab-330F63?style=for-the-badge&logo=gitlab&logoColor=white)
![Jenkins](	https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=Jenkins&logoColor=white)
![city](https://img.shields.io/badge/TeamCity-000000?style=for-the-badge&logo=TeamCity&logoColor=white)

---
![](https://github.com/roxsross/roxsross/blob/main/images/roxsross-banner-1.png)

🔥🔥🔥🔥

### by RoxsRoss

---
## Descripción del Desafío

¡Bienvenido al desafío final del bootcamp DevOps! En este desafío, demostrarás tus habilidades integrando un robusto pipeline de CI/CD utilizando Jenkins y desplegando una aplicación completa en un clúster local de Kubernetes (Minikube). 
La aplicación comprende varios componentes esenciales: 
- Una aplicación web front-end en Python, 
- Un backend .NET, 
- Un servidor Redis para votos, 
- Una base de datos PostgreSQL respaldada por un volumen Docker, 
- y Una aplicación web Node.js que muestra los resultados de la votación en tiempo real.

## Objetivo General

Implementar un pipeline de CI/CD que automatice la construcción, las pruebas 
y el despliegue de la aplicación en un entorno local de Kubernetes (Minikube).

## Pasos del Desafío

### 1. Configuración del Repositorio

- Utiliza un sistema de control de versiones (Git) para almacenar el código fuente de la aplicación.
- Estructura el repositorio con las ramas de desarrollo y producción.

### 2. Construcción del Pipeline en Jenkins

- Instala Jenkins en tu entorno local o en una máquina virtual.
- Crea un pipeline en Jenkins que abarque las siguientes etapas:
  - **Construcción del Front-end en Python:**
    - Clona el repositorio.
    - Construye la aplicación web front-end en Python.

  - **Pruebas Unitarias y de Integración:**
    - Ejecuta pruebas unitarias para el front-end.
    - Configura y ejecuta pruebas de integración.

  - **Construcción y Despliegue del Backend .NET:**
    - Construye el backend .NET.
    - Despliega el backend en un entorno de prueba.

  - **Pruebas Automatizadas para el Backend .NET:**
    - Ejecuta pruebas automatizadas para el backend .NET.

  - **Construcción del Backend con Node.js:**
    - Construye la aplicación web Node.js.

  - **Despliegue en Minikube:**
    - Configura y despliega la aplicación en Minikube.
    - Utiliza configuraciones de Kubernetes para manejar Redis y PostgreSQL.

### 3. Creación de Objetos de Kubernetes

- Crea archivos YAML separados para cada objeto de Kubernetes que represente los componentes de la aplicación (Deployment, Service, PersistentVolume, etc.).

### 4. Creación de Imágenes Docker

- Crea Dockerfiles para cada componente de la aplicación.
- Utiliza Jenkins para construir y etiquetar las imágenes Docker.

### 5. Publicación en Docker Hub usando Jenkins

- Configura Jenkins para autenticarse y publicar las imágenes Docker en un repositorio en Docker Hub.

### 6. Notificación y Monitoreo

- Configura notificaciones en el pipeline para informar sobre el éxito o fracaso de cada etapa.
- Implementa monitoreo básico para la aplicación desplegada en Minikube.

### 7. Documentación

- Proporciona documentación detallada sobre cómo ejecutar el pipeline.
- Incluye información sobre la estructura del pipeline, requisitos previos y configuraciones adicionales.

## Consideraciones Adicionales

- Asegúrate de gestionar las credenciales y secretos de manera segura en Jenkins.
- Utiliza scripts y configuraciones versionadas para la construcción y despliegue.
- Realiza una revisión de seguridad del pipeline.

## Importante (Opcionales)

- En caso de no poder usar Minikube, puede usar alternativas como killercoda

## Puntos Extra (Opcionales)

- Implementa rollback automático en caso de fallos en producción.
- Integra pruebas de seguridad en el pipeline.
- Configura Jenkins para integrarse con herramientas de análisis estático de código.

Este desafío abarca aspectos clave de DevOps, desde la construcción y pruebas hasta el despliegue y la monitorización. Asegúrate de comprender cada componente de la aplicación y cómo interactúan entre sí. ¡Buena suerte!


## Solución del desafío
- Clonar el repositorio https://github.com/betsyninoska/295devops-groupo4/
- Las ramas a utilizar son:
  - Desarrollo:ejercicio3-despliega_dev
  - Produccion:ejercicio3-despliega_master
- Los fuentes: bootcamp-devops-2023 rama ejercicio3-despliega
- 

🔥🔥🔥🔥


### ✉️  &nbsp;Contactos 




<samp>
<samp>
  </div>
  


COPY kubectl /bin/kubectl 
