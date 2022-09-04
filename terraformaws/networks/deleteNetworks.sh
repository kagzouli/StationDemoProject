CPT_NAME="dev"
rm -rf .terraform
terraform init --backend-config="backends/${CPT_NAME}_backend.tfvars"
terraform destroy -auto-approve  --var-file=../vars/dev.tvars
