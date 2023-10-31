ARGO_NAMESPACE="argocd"

kubectl config set-context --current --namespace=argocd

# Delete applications 
helm delete applications

kubectl delete -f ingress/vault-ing.yaml
kubectl delete -f ingress/falco-ing.yaml
kubectl delete -f ingress/prometheus-ing.yaml

# Delete shared
helm delete shared

# Delete service monitor
kubectl delete -f cadvisor_sm.yaml


helm delete argocd  -n ${ARGO_NAMESPACE}