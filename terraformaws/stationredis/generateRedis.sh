CPT_NAME="dev"
rm -rf .terraform
terraform init --backend-config="backends/${CPT_NAME}_backend.tfvars"
terraform apply --lock=false -auto-approve --var-file=../vars/${CPT_NAME}.tvars
