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
        file(credentialsId: 'kubernetes-ca-key', variable: 'kubernetes_ca_key'),
        file(credentialsId: 'kubernetes-etcd-crt', variable: 'kubernetes_etcd_crt'),
        file(credentialsId: 'kubernetes-etcd-key', variable: 'kubernetes_etcd_key'),
        file(credentialsId: 'kubernetes-etcd-service', variable: 'kubernetes_etcd_service'),
        file(credentialsId: 'kubernetes-api-crt', variable: 'kubernetes_api_crt'),
        file(credentialsId: 'kubernetes-api-key', variable: 'kubernetes_api_key'),
        file(credentialsId: 'kubernetes-serviceacc-crt', variable: 'kubernetes_serviceacc_crt'),
        file(credentialsId: 'kubernetes-serviceacc-key', variable: 'kubernetes_serviceacc_key'),
        file(credentialsId: 'kubernetes-encr-config-yaml', variable: 'kubernetes_encr_config_yaml'),
        file(credentialsId: 'kubernetes-apiserver-service', variable: 'kubernetes_apiserver_service'),
        file(credentialsId: 'kubernetes-controller-manager-kubeconfig', variable: 'kubernetes_controller_manager_kubeconfig'),
        file(credentialsId: 'kubernetes-controller-manager-service', variable: 'kubernetes_controller_manager_service'),
        file(credentialsId: 'kubernetes-scheduler-kubeconfig', variable: 'kubernetes_scheduler_kubeconfig'),
        file(credentialsId: 'kubernetes-scheduler-service', variable: 'kubernetes_scheduler_service'),  
        file(credentialsId: 'kubernetes-admin-kubeconfig', variable: 'kubernetes_admin_kubeconfig'),
	file(credentialsId: 'kubernetes-haproxy-cfg', variable: 'kubernetes_haproxy_cfg')   
      ]) {
        sh 'mkdir -p keys/etcd/; cp $kubernetes_ca_crt $kubernetes_etcd_crt $kubernetes_etcd_key $kubernetes_etcd_service keys/etcd/'
        sh '''mkdir -p keys/kubernetes/; cp $kubernetes_ca_crt $kubernetes_ca_key $kubernetes_etcd_key  $kubernetes_etcd_crt \\
        $kubernetes_api_crt $kubernetes_api_key $kubernetes_serviceacc_crt $kubernetes_serviceacc_key \\
        $kubernetes_encr_config_yaml $kubernetes_apiserver_service $kubernetes_controller_manager_kubeconfig \\
        $kubernetes_controller_manager_service $kubernetes_scheduler_kubeconfig $kubernetes_scheduler_service \\
        $kubernetes_admin_kubeconfig $kubernetes_haproxy_cfg keys/kubernetes/'''
      }
      ansiblePlaybook credentialsId: 'ssh-jenkins-agent', disableHostKeyChecking: true, inventory: 'inventory', playbook: 'site.yml'
    }
  }
}
