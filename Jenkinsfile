pipeline {

  environment {
    docker_tag = getLatestCommitId()	
    registry = "6785/myweb:${docker_tag}"
	prev_docker_tag = getSecLastCommitIdToDeleteImg()
	prev_registry = "6785/myweb:${prev_docker_tag}"
    registryCredential = "dockerhub"
    dockerImage = ""
  }

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        git 'https://github.com/AjitBhavle/playjenkins.git'
		
		echo "${prev_docker_tag}"
        sh "chmod +x imageTag.sh"
        sh "./imageTag.sh ${docker_tag}"
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
          kubernetesDeploy(configs: "new_myweb.yaml", kubeconfigId: "mykubeconfig")
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
	   script {
	   
			if(prev_docker_tag == null)
				echo "No Prev_tag available to delete"
			else
				sh "docker rmi -f $prev_registry"
			}
		}
	}
    
  }

}

def getLatestCommitId(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
def getSecLastCommitIdToDeleteImg(){
    def previous_tag  = sh script: 'git rev-parse @~', returnStdout: true
    return previous_tag
}