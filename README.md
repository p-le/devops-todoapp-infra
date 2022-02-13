# Requirements

1. Install `tfenv` then install latest Terraform version: https://github.com/tfutils/tfenv
2. Prepare GCP Service Account Key
- Create a service account with enough IAM Role Permission in target GCP Project
- Generate JSON Service Account Key
- Download, rename to `service_account.json` and place JSON Service Account Key in root folder of this project
- Update `GOOGLE_PROJECT` in `terraform.sh`
3. Generate `.env` file, update `GOOGLE_PROJECT`, and `GOOGLE_APPLICATION_CREDENTIALS` values
*Note: Do not push GCP Service Account Key into GitHub Respository*


# Execute Terraform Plan
Using `terraform.sh` script to execute terraform commands
```
./terraform.sh init
./terraform.sh plan
./terraform.sh apply
```

