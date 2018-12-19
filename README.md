
## Create service account in GCP for Terraform, download it in JSON format and place under `gke/terraform-sa.json`

## Prepare plan to create k8s cluster

```terraform plan -var-file=_private_vars.tfvars```

## Create k8s cluster using  Terraform 

```terraform apply```

## After k8s cluster created there should be  a namespace created as well along with Service Account `jenkins`. then we need to grant current GCP user with enough permissions to grant additional permissions to `jenkins`.

```kubectl create clusterrolebinding $CURRENT_SERVICE_ACCOUNT-user-cluster-admin-binding --clusterrole=cluster-admin --user=$CURRENT_SERVICE_ACCOUNT```

## Create dedicated role for `jenkins`
```kubectl -n ci-cd  apply -f jenkins/role.yml```

## Obtain `jenkins` service account token for authentication from Jenkins master
```kubectl -n ci-cd get secrets $(kc -n ci-cd get serviceaccount jenkins  -o json | jq -Mr '.secrets[].name') -o json | jq -Mr '.data.token' | base64 -D```
