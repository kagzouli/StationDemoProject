CPT_NAME="dev"
rm -rf .terraform
terraform init --backend-config="backends/${CPT_NAME}_backend.tfvars"
echo "Apply terraform change"
terraform apply -auto-approve --lock=false --var-file=../vars/${CPT_NAME}.tvars 
