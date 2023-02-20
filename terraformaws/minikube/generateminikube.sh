echo "Apply terraform change"
CPT_NAME="dev"
rm -rf .terraform
terraform init --backend-config="backends/${CPT_NAME}_backend.tfvars"
terraform apply -auto-approve --lock=false --var-file=../vars/dev.tvars 
