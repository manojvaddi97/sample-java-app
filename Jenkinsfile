pipeline {
    agent {
        docker {
        image 'manojvaddi497/java-app:docker-maven-image'
        args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // mount Docker socket to access the host's Docker daemon
    }
    }
}

    stages {
        stage('checkout') {
         steps {
            git branch: 'main' , url: 'https://github.com/manojvaddi97/sample-java-app.git'
         }
        }

        stage('Build and Test'){
            steps {
                sh 'cd sample-java-app && mvn clean package'
            }
        }

        stage('Static Code Analysis') {
      environment {
        SONAR_URL = "http://3.96.197.92:9000"
      }
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
          sh 'cd sample-java-app && mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
      }
    }
    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "manojvaddi497/cicd:${BUILD_NUMBER}"
        // DOCKERFILE_LOCATION = "java-maven-sonar-argocd-helm-k8s/spring-boot-app/Dockerfile"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
            sh 'cd sample-java-app && docker build -t ${DOCKER_IMAGE} .'
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
                dockerImage.push()
            }
        }
      }
    }
    stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "sample-java-app"
            GIT_USER_NAME = "manojvaddi97"
        }
        steps {
            withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                sh '''
                    git config user.email "manojvaddi497@gmail.com"
                    git config user.name "Manoj Vaddi"
                    BUILD_NUMBER=${BUILD_NUMBER}
                    sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" sample-java-app/sample-java-app-manifests/deployment.yml
                    git add sample-java-app/sample-java-app-manifests/deployment.yml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                '''
            }
        }
    }
  }