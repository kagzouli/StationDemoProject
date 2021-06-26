kubectl delete -f ingress.yaml

terraform destroy -auto-approve --lock=false --var-file=../../vars/dev.tvars 
