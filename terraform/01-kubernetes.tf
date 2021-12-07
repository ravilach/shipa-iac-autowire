#Wire Kubernetes Resources
#https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
#https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/guides/getting-started

provider "kubernetes" {
  config_path = "~/.kube/config"
}


# Shipa Needed Token and Binding
# Cluster Service Account 
resource "kubernetes_service_account" "shipa-admin" {
  metadata {
    name = "shipa-admin"
    namespace = "kube-system"
  }
}

#Shipa Cluster Role Binding
resource "kubernetes_cluster_role_binding" "shipa-admin" {
  metadata {
    name = "shipa-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "shipa-admin"
    namespace = "kube-system"
  }
}

##Ideas
/*
#Represent Kubernetes Cluster as object
data "kubernetes" "current_cluster" {
  name= "current_cluster"
}

#EKS Wiring
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}
*/
