// Jenkinsfile declarativo (Tema 6, clase 8). Define el pipeline como código y se versiona con el proyecto.
// Fases: Clonar, Tests, Build imagen, Seguridad y Publicar. En .github/workflows/ci.yml está el mismo
// flujo para GitHub Actions.
pipeline {
  // Dónde se ejecuta: cualquier agente disponible (aquí, el propio Jenkins).
  agent any

  // Herramientas que Jenkins pone en el PATH. 'node24' es el nombre de la instalación de NodeJS
  // definida en Manage Jenkins > Tools (necesita el plugin NodeJS).
  tools {
    nodejs 'node24'
  }

  // Formulario de "Build with Parameters": permite lanzar el pipeline sin publicar la imagen.
  parameters {
    booleanParam(name: 'PUBLICAR',
      defaultValue: true,
      description: 'Subir la imagen a DockerHub')
  } 
 
  // Variables disponibles en todas las etapas.
  // IMAGEN: nombre en Docker Hub (usuario en minúsculas). VERSION: etiqueta única por build.
  environment {
    IMAGEN  = 'juankaruva/calculadora'
    VERSION = "1.0.${env.BUILD_NUMBER}"
  }
  
  // skipDefaultCheckout: el clonado lo hace la etapa Clonar (checkout scm) y no se repite solo.
  // timeout: aborta el build si pasa de 15 minutos, para no dejar un pipeline colgado.
  options {
    skipDefaultCheckout()
    timeout(time: 15, unit: 'MINUTES')
  }

  stages {
    // Clonar: trae del repositorio la rama y el commit que ha lanzado el pipeline.
    stage('Clonar') {
      steps {
        checkout scm
      }
    }

    // Tests: instala dependencias (npm ci) y ejecuta Jest. npm test falla si algún test falla o si la
    // cobertura no llega al umbral del package.json; entonces el pipeline se detiene aquí.
    stage('Tests') {
      steps {
        sh 'npm ci'
        sh 'npm test'
      }
      post {
        always {
          // Informe JUnit: pestaña de resultados de tests en cada build.
          // allowEmptyResults: si npm ci falla y no hay XML, no añade otro error.
          junit allowEmptyResults: true, testResults: 'reports/junit.xml'
          // Artefactos: el build conserva el informe HTML de cobertura (coverage/lcov-report/index.html)
          archiveArtifacts artifacts: 'coverage/lcov-report/**', allowEmptyArchive: true
        }
      }
    }

    // Calidad (Tema 9): análisis estático con SonarQube; lee sonar-project.properties y la cobertura de Jest.
    // withSonarQubeEnv pasa la URL y el token del servidor 'sonarqube' (Manage Jenkins > System > SonarQube
    // servers: URL http://sonarqube:9000 y la credencial sonar-token). tool 'sonar-scanner' devuelve dónde está
    // instalado el escáner (Manage Jenkins > Tools > SonarQube Scanner installations, nombre sonar-scanner).
    stage('Calidad') {
      steps {
        withSonarQubeEnv('sonarqube') {
          sh "${tool 'sonar-scanner'}/bin/sonar-scanner"
        }
      }
    }

    // Quality Gate: espera el veredicto de SonarQube (la nota del código nuevo) y detiene el pipeline si no pasa,
    // antes de construir la imagen. SonarQube avisa por un webhook (Administration > Configuration > Webhooks,
    // URL http://jenkins:8080/sonarqube-webhook/: con el nombre del contenedor, no localhost). El timeout evita
    // esperar para siempre si el webhook falla.
    stage('Quality Gate') {
      steps {
        timeout(time: 5, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }
      }
    }

    // Build imagen: construye la imagen con el Dockerfile y le pone dos etiquetas: la versión del build
    // (1.0.<n>) y latest. Necesita el socket de Docker montado en el contenedor de Jenkins.
    stage('Build imagen') {
      steps {
        sh "docker build -t ${IMAGEN}:${VERSION} ."
        sh "docker tag ${IMAGEN}:${VERSION} ${IMAGEN}:latest"
      }
    }

    // Seguridad: Trivy analiza la imagen ya construida y ANTES de publicar. Se ejecuta como contenedor
    // efímero (--rm): el socket de Docker le deja ver la imagen local y el volumen trivy-cache conserva
    // la base de vulnerabilidades entre ejecuciones. Versión fija por la seguridad de la cadena de suministro.
    // --severity CRITICAL: solo paran las críticas; --exit-code 1 hace fallar la etapa si las hay;
    // --ignore-unfixed ignora las que aún no tienen versión corregida.
    stage('Seguridad') {
      steps {
        sh """
          docker run --rm \\
            -v /var/run/docker.sock:/var/run/docker.sock \\
            -v trivy-cache:/root/.cache/ \\
            aquasec/trivy:0.76.2 image \\
            --severity CRITICAL \\
            --exit-code 1 \\
            --ignore-unfixed \\
            ${IMAGEN}:${VERSION}
        """
      }
    }

    // Publicar: login en Docker Hub y push de las dos etiquetas.
    // when: solo se ejecuta si el parámetro PUBLICAR está activado.
    // withCredentials: inyecta la credencial 'dockerhub-cred' (usuario y token) solo dentro del bloque,
    // sin escribirla en el código; Jenkins la enmascara en los logs. El token entra por stdin.
    stage('Publicar') {
      when {
        expression { params.PUBLICAR }
      }
      steps {
        withCredentials([usernamePassword(
            credentialsId: 'dockerhub-cred',
            usernameVariable: 'USUARIO',
            passwordVariable: 'TOKEN')]) {
          sh 'echo "$TOKEN" | docker login -u "$USUARIO" --password-stdin'
          sh "docker push ${IMAGEN}:${VERSION}"
          sh "docker push ${IMAGEN}:latest"
        }
      }
    }
  }

  // Acciones al terminar el pipeline.
  post {
    // always: se ejecuta pase lo que pase; cierra la sesión de Docker Hub.
    always {
      sh 'docker logout'
    }
    success {
      echo "Correcto: ${IMAGEN}:${VERSION}"
    }
    failure {
      echo 'Revisar la etapa en rojo'
    }
  }
}
