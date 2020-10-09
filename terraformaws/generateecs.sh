terraform apply -auto-approve --lock=false --var-file=vars/dev.tvars  -state=ecs/output/terraform.tfstate ecs
