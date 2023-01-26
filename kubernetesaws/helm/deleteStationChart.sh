helm delete stationdev -n stationdev

helm delete argo-rollout  -n transverse

helm delete metrics-server  -n transverse

helm upgrade --install ingress-nginx -n transverse

kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/aws/deploy.yaml



