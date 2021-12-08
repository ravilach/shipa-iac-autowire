
#Null Resource Wiring
#Gist: https://gist.github.com/brunoa19/25505efd56d46472b092adaf83fe56dd
#Terminal Cleanup: https://unix.stackexchange.com/questions/14684/removing-control-chars-including-console-codes-colours-from-script-output
#Garbage Chars: https://stackoverflow.com/questions/41699927/remove-junk-characters-from-a-utf-8-file-in-unix

resource "null_resource" "k8s_auto_wiring" {
  depends_on = [kubernetes_service_account.shipa-admin]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT

#API Address - Prone to UNIX and Color Characters in stdout. Might have to adjust based on your Linux Distro.
kubectl cluster-info | grep 'Kubernetes' | awk '/http/ {print $NF}' | sed 's/[^[:alpha:];\ -@]//g' > ${path.module}/api-address-temp.txt

#Token
kubectl --namespace kube-system get secret $(kubectl --namespace kube-system get secret | grep shipa-admin | awk '{print $1}') --output jsonpath="{.data.token}" | base64 --decode  > ${path.module}/token.txt

#CA 
kubectl get secret $(kubectl get secret | grep default-token | awk '{print $1}') -o jsonpath='{.data.ca\.crt}' | base64 --decode > ${path.module}/cert.txt

#Format API Endpoint taking off HTTPS and coloring from MacBook [14 characters off front and 2 characters terminal color line end] 
#Kubectl Console to api-address-temp produces on a MacBook "0;33mhttps://D69478E7F0A93850FC2A83594B8E0D70.gr7.ap-southeast-1.eks.amazonaws.com0m\n"
cat ${path.module}/api-address-temp.txt | cut -c 14- | sed 's/..$//' > api-address-formatted.txt

EOT
  }
}

data "local_file" "api_address" {
    filename = "${path.module}/api-address-formatted.txt"
  depends_on = [null_resource.k8s_auto_wiring]
}

data "local_file" "token" {
    filename = "${path.module}/token.txt"
  depends_on = [null_resource.k8s_auto_wiring]
}

data "local_file" "cert" {
    filename = "${path.module}/cert.txt"
  depends_on = [null_resource.k8s_auto_wiring]
}


/*
#External Provider Route e.g get a JSON object back.

data "external" "kubernetes_endpoint" {
  program = ["bash", "kubectl cluster-info | grep 'Kubernetes' | awk '/http/ {print $NF}' "]
}

data "external" "role_token" {
  program = ["bash", "kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep shipa-admin | awk '{print $1}') "]
}

data "external" "token_ca_cert" {
  program = ["bash", "kubectl get secret $(kubectl get secret | grep default-token | awk '{print $1}') -o jsonpath='{.data.ca\\.crt}' | base64 --decode "]
}

#Outputs for Debug
output "Kubernetes_Endpoint" {
  value = data.external.kubernetes_endpoint
}

output "Role_Token" {
  value = data.external.role_token
}

output "CA_Cert" {
  value = data.external.token_ca_cert
}
*/
