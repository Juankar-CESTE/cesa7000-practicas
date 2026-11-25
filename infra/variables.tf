# variables.tf: valores que cambian según el entorno o el ordenador. Se leen con var.<nombre>.
# Cada variable tiene tipo y valor por defecto; terraform.tfvars (que no se sube a Git) puede
# darles otro valor sin tocar los .tf.

variable "docker_host" {
  description = "Conexión con Docker"
  type        = string
  # Linux y Mac. En Windows con Docker Desktop: "npipe:////./pipe/dockerDesktopLinuxEngine".
  # Para saber la dirección exacta: docker context inspect --format "{{.Endpoints.docker.Host}}"
  default = "unix:///var/run/docker.sock"
}

variable "imagen" {
  description = "Imagen de la calculadora en DockerHub"
  type        = string
  # Sustituir "usuario" por el de Docker Hub (en minúsculas) en terraform.tfvars.
  default = "usuario/calculadora:latest"
}

variable "puerto" {
  description = "Puerto del ordenador"
  type        = number
  default     = 3000
}
