# Shipa IaC Autowire
An example of different IaC Providers e.g Terraform, Crossplane, etc.In these examples the IaC will
either spin up a Kubernetes cluster or ingest a kubeconfig depending on maturity. 

## Example Docs
Can check out the [Shipa Documentation](https://learn.shipa.io/docs) to take a look at the different
IaC providers. 

* Terraform https://learn.shipa.io/docs/terraform
* Crossplane https://learn.shipa.io/docs/crossplane
* Pulumi https://learn.shipa.io/docs/pulumi

## Shipa Cloud or On-Prem Wiring
Will need to grab your target and API key. 
* Target -> target.shipa.cloud. Head to Settings (click on user icon top right), then General. 
* API Key -> Leverage the Shipa CLI to create one and assign a role. [API Key Creation Doc](https://learn.shipa.io/docs/tokens) or show the default token.

## Run the Terraform Example
Clone or Fork the Project and CD into the Terraform Folder
```
#Use default token for quick example.
shipa show token
#TF steps. Can wire the .tfvars in the project. 
terraform init
terraform plan  -var-file="env/autowire.tfvars"
terraform apply -var-file="env/autowire.tfvars"
```

### More Info on Terraform
This demo was given by Shipa at HashiTalks days. 
* https://www.youtube.com/watch?v=pznJCVJ5NB8

### More Info on Crossplane
This demo was given by Shipa on a Shipa Webinar.
* https://www.youtube.com/watch?v=ap1hjGg81XU

## Improvements / To-Do's
Each project in the README can specify specific improvements. PRs are always welcome. 

Globally:
Creating a Shipa RBAC role specifically for this. WIP.
Will connect to default "shipa-team".
```
#https://learn.shipa.io/docs/tokens
shipa token create --team shipa-team --id tfprovidertoken
shipa role permission add tfsys cluster framework node app
shipa role assign tfsys tfprovidertoken 
```
