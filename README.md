
## Prepare plan to create k8s cluster

```terraform plan -out gke-cicd-cluster```

## Create k8s cluster using  Terraform 

```terraform apply gke-cicd-cluster -var-file=_private_vars.tfvars```