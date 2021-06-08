node('docker-onapp-agent') {
  stage('Checkout repo') {
    checkout scm
  }
  
  stage('terraform-kubernetes') {
    dir('terraform') {
      withCredentials([file(credentialsId: 'kube-tfvars', variable: 'kube_tfvars'), file(credentialsId: 'backend.config', variable: 'kube_backend')]) {
        sh '''terraform init -backend-config=$kube_backend
        terraform apply -var-file=$kube_tfvars -auto-approve
        terraform output -json > terraform_outputs.json'''
      }
    }
  }

}
