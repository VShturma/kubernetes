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
	file(credentialsId: 'kubernetes-haproxy-cfg', variable: 'kubernetes_haproxy_cfg'),
	file(credentialsId: 'kubernetes-containerd-config', variable: 'kubernetes_containerd_config'),
	file(credentialsId: 'kubernetes-containerd-service', variable: 'kubernetes_containerd_service'),
	file(credentialsId: 'kubernetes-worker1-crt', variable: 'kubernetes_worker1_crt'),
	file(credentialsId: 'kubernetes-worker2-crt', variable: 'kubernetes_worker2_crt'),
	file(credentialsId: 'kubernetes-worker1-key', variable: 'kubernetes_worker1_key'),
	file(credentialsId: 'kubernetes-worker2-key', variable: 'kubernetes_worker2_key'),
	file(credentialsId: 'kubernetes-worker1-kubeconfig', variable: 'kubernetes_worker1_kubeconfig'),
	file(credentialsId: 'kubernetes-worker2-kubeconfig', variable: 'kubernetes_worker2_kubeconfig'),
	file(credentialsId: 'kubernetes-kubelet-config', variable: 'kubernetes_kubelet_config'),
	file(credentialsId: 'kubernetes-kubelet-service', variable: 'kubernetes_kubelet_service'),
	file(credentialsId: 'kubernetes-kube-proxy-kubeconfig', variable: 'kubernetes_kube_proxy_kubeconfig'),
	file(credentialsId: 'kubernetes-kube-proxy-config-yaml', variable: 'kubernetes_kube_proxy_config_yaml'),
	file(credentialsId: 'kubernetes-kube-proxy-service', variable: 'kubernetes_kube_proxy_service')
      ]) {
        sh 'mkdir -p keys/etcd/; cp $kubernetes_ca_crt $kubernetes_etcd_crt $kubernetes_etcd_key $kubernetes_etcd_service keys/etcd/'
        
	sh '''mkdir -p keys/kubernetes/; cp $kubernetes_ca_crt $kubernetes_ca_key $kubernetes_etcd_key  $kubernetes_etcd_crt \\
        $kubernetes_api_crt $kubernetes_api_key $kubernetes_serviceacc_crt $kubernetes_serviceacc_key \\
        $kubernetes_encr_config_yaml $kubernetes_apiserver_service $kubernetes_controller_manager_kubeconfig \\
        $kubernetes_controller_manager_service $kubernetes_scheduler_kubeconfig $kubernetes_scheduler_service \\
        $kubernetes_admin_kubeconfig $kubernetes_haproxy_cfg keys/kubernetes/'''
	
	sh '''mkdir -p worker/kubelet; cp $kubernetes_containerd_config $kubernetes_containerd_service \\
	$kubernetes_worker1_kubeconfig $kubernetes_worker2_kubeconfig \\
	$kubernetes_kubelet_config $kubernetes_kubelet_service $kubernetes_kube_proxy_kubeconfig \\
	$kubernetes_kube_proxy_config_yaml $kubernetes_kube_proxy_service worker/'''
        
	sh ''' cp $kubernetes_worker1_crt $kubernetes_worker1_key $kubernetes_worker2_crt $kubernetes_worker2_key worker/kubelet/'''
      }
      ansiblePlaybook credentialsId: 'ssh-jenkins-agent', disableHostKeyChecking: true, inventory: 'inventory', playbook: 'site.yml'
    }
  }
}
