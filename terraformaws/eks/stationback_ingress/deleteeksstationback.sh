kubectl delete -f external-dns.yaml

kubectl delete -f ingress.yaml

terraform destroy -auto-approve --lock=false --var-file=../../vars/dev.tvars 
