SHARED_NAMESPACE="transverse"

helm delete stationdev -n stationdev
kubectl delete secret vault-secret -n stationdev


helm delete prom-adapter -n ${SHARED_NAMESPACE}

helm delete prometheus   -n ${SHARED_NAMESPACE}

helm delete keda -n ${SHARED_NAMESPACE}

helm delete argo-rollout  -n ${SHARED_NAMESPACE}

helm delete metrics-server  -n ${SHARED_NAMESPACE}

helm delete ingress-nginx -n ${SHARED_NAMESPACE}

helm delete external-secrets -n ${SHARED_NAMESPACE}


kubectl delete secret vault-secret -n stationdev


kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/aws/deploy.yaml



