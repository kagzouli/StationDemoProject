CPT_NAME="dev"
terraform init --backend-config="backends/${CPT_NAME}_backend.tfvars"
terraform apply -auto-approve --var-file=../vars/${CPT_NAME}.tvars
