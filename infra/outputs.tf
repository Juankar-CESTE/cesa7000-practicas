# outputs.tf: datos que Terraform muestra al terminar el "apply".
# Aquí, la URL con la que comprobar que la calculadora responde: debe devolver {"resultado":5}.
output "url" {
  description = "URL de prueba de la calculadora"
  value       = "http://localhost:${var.puerto}/sumar?a=2&b=3"
}
