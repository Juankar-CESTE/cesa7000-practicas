Aquí tienes el documento completo con la sección de autor y profesorado adaptada:

***

# CESA7000 — Prácticas de Agile Development & Software DevOps

![Node.js](https://img.shields.io/badge/Node.js-20.x-339933?logo=node.js&logoColor=white)
![Jest](https://img.shields.io/badge/Jest-Testing-C21325?logo=jest&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?logo=github-actions&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker&logoColor=white)
![Jira](https://img.shields.io/badge/Jira-Scrum-0052CC?logo=jira&logoColor=white)

Repositorio central para el desarrollo práctico y coursework individual de la asignatura **Agile Development and Software DevOps** del Máster Universitario en Informática Aplicada / Inteligencia Artificial (**MISIA**), impartido en **CESTE** en colaboración con la **University of Wales**.

---

## 📌 Descripción del Proyecto

El objetivo de este repositorio es construir y validar un ciclo completo de ingeniería de software moderno y desarrollo ágil orientado a DevOps. Partiendo de una aplicación base en **Node.js**, se implementa un pipeline automatizado de **Integración Continua y Despliegue Continuo (CI/CD)** que abarca desde la planificación ágil de requisitos hasta la verificación de calidad, seguridad y contenerización.

### Alcance del proyecto

1. **Planificación Ágil**: Gestión del ciclo de vida del producto mediante **Jira Software Cloud** (Scrum, épicas, historias de usuario con criterios de aceptación e inversión de estimación en puntos Fibonacci, tableros y límites WIP).
2. **Control de Versiones y Flujo Colaborativo**: Adopción de ramas de funcionalidad (*Feature Branching*), commits semánticos (*Conventional Commits*), gestión de incidencias con *GitHub Issues*, revisión mediante *Pull Requests* con cierre automático (`Closes #X`) y protección de la rama `main` mediante *Rulesets*.
3. **Pruebas y Calidad de Código**: Batería de pruebas unitarias automatizadas con **Jest** bajo enfoque TDD (*Test-Driven Development*).
4. **Automatización CI/CD**:
   - **GitHub Actions**: Workflows automatizados de testeo y validación *Fail-Fast* en cada PR y push.
   - **Jenkins**: Orquestación de pipelines declarativos vía `Jenkinsfile`.
5. **Seguridad y Contenerización**:
   - Empaquetado en imágenes **Docker** optimizadas y publicación en **Docker Hub**.
   - Análisis estático de código y deuda técnica con **SonarQube**.
   - Escaneo de vulnerabilidades y dependencias con **Trivy**.

---

## 🛠️ Stack Tecnológico

| Área | Herramientas / Tecnologías |
|---|---|
| **Lenguaje y Entorno** | Node.js (LTS), JavaScript |
| **Testing** | Jest |
| **Control de Versiones** | Git, GitHub |
| **Gestión Ágil** | Jira Software Cloud (Scrum / Team-Managed Project) |
| **CI / CD Pipelines** | GitHub Actions, Jenkins |
| **Contenedores y Registro** | Docker, Docker Hub |
| **Calidad y Seguridad** | SonarQube, Trivy |

---

## 📁 Estructura del Repositorio

```text
cesa7000-practicas/
├── .github/
│   └── workflows/
│       └── test.yml          # Pipeline de CI en GitHub Actions (Node.js + Jest)
├── src/
│   └── index.js              # Lógica funcional de la aplicación
├── tests/
│   └── index.test.js         # Pruebas unitarias con Jest
├── Dockerfile                # Definición del contenedor Docker
├── Jenkinsfile               # Pipeline declarativo para Jenkins
├── package.json              # Dependencias y scripts del proyecto
├── .gitignore                # Reglas de exclusión para Node.js
└── README.md                 # Documentación del proyecto
```

---

## 🚀 Puesta en Marcha en Local

### Requisitos previos
- **Node.js** (v18 o superior)
- **npm** (v9 o superior)
- **Git**

### Instalación y ejecución de tests

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/cesa7000-practicas.git
cd cesa7000-practicas

# 2. Instalar dependencias
npm install

# 3. Ejecutar la suite de pruebas unitarias
npm test
```

---

## 🔐 Credenciales de Docker Hub en Jenkins

El `Jenkinsfile` obtiene las credenciales mediante `withCredentials`; no se guardan en el repositorio. Para habilitar la etapa de publicación:

1. En Jenkins, abre **Manage Jenkins → Credentials** y añade una credencial de tipo **Username with password** en un almacén accesible para el job.
2. Usa el usuario de Docker Hub como **Username** y un *Personal Access Token* de Docker Hub como **Password**. Para publicar imágenes, el token debe tener permiso de escritura.
3. Asigna exactamente el ID `dockerhub-cred`, que es el que referencia el `Jenkinsfile`.
4. Ejecuta el pipeline con `PUBLICAR` activado. Para practicar solo los tests y el build local sin configurar credenciales ni publicar, desactívalo.

Esta configuración es reutilizable en otros ejercicios que corran en la misma instancia de Jenkins. Si el ejercicio usa otra instancia, crea allí una credencial equivalente con el mismo ID; los secretos no se transfieren con el repositorio.

---

## 🔄 Flujo de Trabajo y Buenas Prácticas Git

Para garantizar la trazabilidad académica y profesional del código:

1. **Ramas de funcionalidad**: Nunca se trabaja directamente sobre `main`. Cada tarea o corrección se realiza en una rama dedicada:
   - Funcionalidades: `feature/{id-issue}-{nombre-corto}` (ejemplo: `feature/1-restar`)
   - Correcciones: `fix/{id-issue}-{nombre-corto}`
2. **Conventional Commits**: Los mensajes de commit deben describir la acción en imperativo:
   - `feat: añadir función restar`
   - `test: añadir test unitario para restar`
   - `ci: configurar workflow de GitHub Actions`
   - `fix: corregir aserción en suma`
3. **Pull Requests e Issues**:
   - Cada rama se integra en `main` mediante una Pull Request revisada.
   - La descripción de la PR debe vincular el issue correspondiente para cerrarlo automáticamente al fusionar (`Closes #1` o `Fixes #1`).
4. **Protección de la rama principal (`main`)**:
   - Configurada con reglas de protección (*Rulesets*): prohíbe el push directo y exige Pull Request previa con validación de tests en verde.

---

## 📋 Autor y Evaluación

- **Alumno**: Juankar
- **Asignatura**: Agile Development and Software DevOps (CESA7000)
- **Profesorado**: Carmen Pellicer / Denis Emilio Ramírez / Francisco Romero
- **Institución**: CESTE, Centro Universitario Internacional / University of Wales
- **Fecha de Entrega**: Diciembre 2026
