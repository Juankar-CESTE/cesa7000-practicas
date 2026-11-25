pipeline {
  agent any

  tools {
    nodejs 'node24'
  }

  parameters {
    booleanParam(name: 'PUBLICAR',
      defaultValue: true,
      description: 'Subir la imagen a DockerHub')
  } 
 
  environment {
    IMAGEN  = 'juankaruva/calculadora'
    VERSION = "1.0.${env.BUILD_NUMBER}"
  }
  
  options {
    skipDefaultCheckout()
    timeout(time: 15, unit: 'MINUTES')
  }

  stages {
    stage('Clonar') {
      steps {
        checkout scm
      }
    }

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
          // Artefactos: el build conserva el informe y la cobertura (coverage/index.html)
          archiveArtifacts artifacts: 'reports/**, coverage/**', allowEmptyArchive: true
        }
      }
    }

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

  post {
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
