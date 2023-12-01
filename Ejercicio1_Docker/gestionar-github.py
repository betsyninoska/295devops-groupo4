import docker
from datetime import datetime

def build_and_push_docker_image(image_name, dockerfile_path, registry_url, tag_prefix='v'):
    client = docker.from_env()

    # Construir la imagen Docker
    print(f"Construyendo la imagen {image_name}...")
    image, build_logs = client.images.build(
        path=dockerfile_path,
        tag=image_name
    )
    for log in build_logs:
        print(log)

    # Generar un timestamp para el tag
    timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
    tagged_image_name = f"{registry_url}/{image_name}:{tag_prefix}{timestamp}"
    print(f"Taggeando la imagen con el timestamp: {tagged_image_name}")
    image.tag(tagged_image_name)

    # Subir la imagen al registry
    print(f"Subiendo la imagen al registry: {tagged_image_name}")
    client.images.push(tagged_image_name)

    print("Proceso completado.")

if __name__ == "__main__":
    image_name = "mi_imagen"
    dockerfile_path = "."  # Ruta donde esta Dockerfile
    registry_url = "userdockerhub"
    tag_prefix = "v" 

    build_and_push_docker_image(image_name, dockerfile_path, registry_url, tag_prefix)