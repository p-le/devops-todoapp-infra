# Requirements

1. Install `tfenv` then install latest Terraform version: https://github.com/tfutils/tfenv

1. Prepare GCP Service Account Key
- Create a service account with enough IAM Role Permission in target GCP Project
- Generate JSON Service Account Key
- Download, rename to `service_account.json` and place JSON Service Account Key in root folder of this project
- Update `GOOGLE_PROJECT` in `terraform.sh`

Note: Do not push GCP Service Account Key into GitHub Respository

# Execute Terraform Plan
```
./terraform.sh init
./terraform.sh plan
./terraform.sh apply
```

