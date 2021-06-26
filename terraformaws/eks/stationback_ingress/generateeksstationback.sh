echo "Apply terraform change"
terraform apply -auto-approve --lock=false --var-file=../../vars/dev.tvars 

echo "Apply external-dns.yaml"
kubectl apply -f external-dns.yaml

echo "Apply ingress.yaml"
kubectl apply -f ingress.yaml

