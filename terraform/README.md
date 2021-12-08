# Terraform Shipa Autowire

Will take current kubeconfig and autowire to Shipa. This can plug into your EKS/AKS/GKE Creation process. 

## How to Run

Fire up Terraform and wire in your keys, names, region, etc into an ENV file.

```
terraform init
terraform plan  -var-file="env/autowire.tfvars"
terraform apply -var-file="env/autowire.tfvars"
```

## How to Reset and Debug

When using cloud resources that don't come up, can manually remove items on the TFState file
and destroy.

### Remove Orphan Items
```
terraform destroy -state=terraform.tfstate -refresh=false -var-file="env/autowire.tfvars"
```

### Debug
```
export TF_LOG="DEBUG"
export TF_LOG_PATH="../autowire-terraform.log"
```

## Enhancements

Always room for improvement!

* This version takes in KubeConfig so getting certain cluster wiring information from cloud e.g AWS Terraform Provider. 
* Not using Null Resource to run kubectl commands for token, endpoint, and cert wirings to Shipa. 
* Easy First PR: Move Shipa Target URL from hard wired Cloud URL to Variable for on-prem or custom installs. 
