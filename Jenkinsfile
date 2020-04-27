pipeline {

  environment {
    docker_tag = getDockerTag()
    registry = "6785/myweb:${docker_tag}"
    registryCredential = "dockerhub"
    dockerImage = ""
  }

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        git 'https://github.com/AjitBhavle/playjenkins.git'
      }
    }

    stage('Build image') {
      steps{
            sh "docker build . -t ${registry}"
        }
    }

    stage('Push Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
           sh "docker push ${registry}"
          }
        }
      }
    }

    stage('Deploy App') {
      steps {
        script {
          sh "chmod +X imageTag.sh"
          sh "./imageTag.sh ${docker_tag}"
          kubernetesDeploy(configs: "new_myweb.yaml", kubeconfigId: "mykubeconfig")
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry"
      }
    }
    
  }

}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
