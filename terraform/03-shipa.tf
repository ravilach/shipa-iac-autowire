#https://learn.shipa.io/docs/terraform

# Shipa Provider Wiring
provider "shipa" {
  host  = "https://target.shipa.cloud:8081"
  token = var.shipa_token
}

#Create a basic Shipa Kubernetes Framework
resource "shipa_framework" "tf-framework" {
   depends_on = [kubernetes_service_account.shipa-admin]
  framework {
    name        = var.framework_name
    provisioner = "kubernetes"
    resources {
      general {
        setup {
          public  = false
          default = false
        }
        security {
          disable_scan = true
        }
        router = "traefik"
        app_quota {
          limit = "3"
        }
        access {
          append = ["shipa-team"]
        }
        plan {
          name = "shipa-plan"
        }
        container_policy {
          allowed_hosts = []
        }
      }
    }
  }
}

/*
Wire an existing Kubernetes Cluster to Shipa
Kubectl Console produces "0;33mhttps://D69478E7F0A93850FC2A83594B8E0D70.gr7.ap-southeast-1.eks.amazonaws.com0m\n"
for Kubernetes Endpoint API due to coloring. SED in the Null Resource to remove garabage.Chomp to remove newlines.
*/

resource "shipa_cluster" "tf-cluster" {
  depends_on = [null_resource.k8s_auto_wiring]
  cluster {
    name = var.cluster_name
    endpoint {
      addresses = [chomp(data.local_file.api_address.content)]
      ca_cert   = data.local_file.cert.content
      token     = "${chomp(data.local_file.token.content)}"
    }
    resources {
      frameworks {
        name = [var.framework_name]
      }
    }
  }
}

##Ideas
/*
#CA
#kubectl get secret $(kubectl get secret | grep default-token | awk '{print $1}') -o jsonpath='{.data.ca\.crt}' | base64 --decode
data "kubernetes_secret" "default-token" {
  depends_on = [kubernetes_service_account.shipa-admin]
  metadata {
    name = "default-token"
    namespace = "default"
  }
}

#Token
#kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep shipa-admin | awk '{print $1}')
data "kubernetes_secret" "shipa-admin" {
  depends_on = [kubernetes_service_account.shipa-admin]
  metadata {
    name = "shipa-admin"
    namespace = "kube-system"
  }
}
*/
