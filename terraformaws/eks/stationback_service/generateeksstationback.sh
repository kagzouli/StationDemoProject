echo "Apply terraform change"
terraform apply -auto-approve --lock=false --var-file=../../vars/dev.tvars 
