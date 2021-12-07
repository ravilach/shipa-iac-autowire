terraform {

  required_providers {

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }

    shipa = {
      version = ">= 0.0.6"
      source  = "shipa-corp/shipa"
    }
  }

}
