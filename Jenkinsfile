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

  stage('generate inventory') {
    sh 'python3 inventory_creator.py'
  }

  stage('ansible-kubernetes') {
    sh 'sleep 10'
    dir('ansible') {
      withCredentials([
        file(credentialsId: 'kubernetes-ca-crt', variable: 'kubernetes_ca_crt'),
        file(credentialsId: 'kubernetes-etcd-crt', variable: 'kubernetes_etcd_crt'),
        file(credentialsId: 'kubernetes-etcd-key', variable: 'kubernetes_etcd_key')
      ]) {
        sh 'mkdir -p keys/etcd/; cp {$kubernetes_ca_crt,$kubernetes_etcd_crt,$kubernetes_etcd_key} keys/etcd/'
      }
      ansiblePlaybook credentialsId: 'ssh-jenkins-agent', disableHostKeyChecking: true, inventory: 'inventory', playbook: 'site.yml'
    }
  }
}
