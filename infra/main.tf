# main.tf: infraestructura de la calculadora descrita como código (Tema 7, taller 2 de Terraform).
# En vez de ejecutar a mano "docker pull" y "docker run" (imperativo: se dice QUÉ HACER y falla si
# se repite porque el contenedor ya existe), se declara QUÉ TIENE QUE EXISTIR (declarativo).
# Terraform compara con lo que hay y hace solo lo que falta: aplicarlo dos veces da el mismo
# resultado (es idempotente).
#
# Ciclo de trabajo, siempre dentro de esta carpeta:
#   terraform init     descarga el provider (solo la primera vez o al cambiar de provider)
#   terraform plan     muestra qué va a crear, cambiar o borrar, sin tocar nada
#   terraform apply    aplica los cambios (pide escribir "yes")
#   terraform destroy  borra lo que Terraform creó

# Bloque terraform: fija con qué provider y con qué versión se trabaja.
terraform {
  required_providers {
    # El provider es el plugin que habla con una plataforma (aquí Docker; también existen
    # los de AWS, Azure, Google Cloud...). "source" indica de dónde se descarga.
    docker = {
      source = "kreuzwerker/docker"
      # "~> 3.6.2" admite parches (3.6.3, 3.6.4...) pero no 3.7: evita saltos de versión inesperados.
      # La versión exacta descargada queda fijada en .terraform.lock.hcl, que sí se sube a Git.
      version = "~> 3.6.2"
    }
  }
}

# Configuración del provider: cómo conectarse a Docker. host es la misma "puerta" (docker.sock)
# que usa el cliente docker. Su valor viene de una variable porque cambia según el sistema
# operativo (en Windows es una tubería "npipe"; en Linux y Mac, el socket).
provider "docker" {
  host = var.docker_host
}

# Recurso 1: la imagen. Es el equivalente a "docker pull": la descarga de Docker Hub.
resource "docker_image" "calculadora" {
  name = var.imagen
  # keep_locally = true: al hacer "terraform destroy" no borra la imagen del ordenador,
  # solo el contenedor (así no hay que volver a descargarla).
  keep_locally = true
}

# Recurso 2: el contenedor. Es el equivalente a "docker run -d -p 3000:3000 --name calc-tf <imagen>".
resource "docker_container" "calculadora" {
  # Nombre del contenedor en Docker. Si ya hay uno con este nombre creado a mano, Terraform da
  # error ("container name is already in use"): se borra con "docker rm -f calc-tf".
  name = "calc-tf"

  # Se usa image_id (y no el nombre) de la imagen de arriba: así Terraform sabe que primero
  # hay que descargar la imagen y después crear el contenedor, y recrea el contenedor si la
  # imagen cambia.
  image = docker_image.calculadora.image_id

  # Publicación de puertos (equivale a -p externo:interno).
  ports {
    # Puerto en el que escucha el servidor dentro del contenedor (el del Dockerfile).
    internal = 3000
    # Puerto del ordenador. Cambiarlo obliga a recrear el contenedor ("1 to add, 1 to destroy").
    external = var.puerto
  }
}
