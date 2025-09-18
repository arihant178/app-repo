pipeline {
  agent any
  environment {
    DOCKER_IMAGE = "dockeruserari/ci-cd-demo"
  }
  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/YOUR-USER/app-repo.git'
      }
    }
    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${DOCKER_IMAGE}:${env.BUILD_NUMBER} ."
      }
    }
    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh """
            echo $PASS | docker login -u $USER --password-stdin
            docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
          """
        }
      }
    }
    stage('Update GitOps Repo') {
      steps {
        withCredentials([string(credentialsId: 'git-token', variable: 'GIT_TOKEN')]) {
          sh '''
            git clone https://$GIT_TOKEN@github.com/YOUR-USER/gitops-repo.git
            cd gitops-repo
            sed -i "s|image:.*|image: dockeruserari/ci-cd-demo:${BUILD_NUMBER}|" base/deployment.yaml
            git config user.email "jenkins@example.com"
            git config user.name "jenkins"
            git commit -am "Update image to ${BUILD_NUMBER}"
            git push https://$GIT_TOKEN@github.com/YOUR-USER/gitops-repo.git HEAD:main
          '''
        }
      }
    }
  }
}
