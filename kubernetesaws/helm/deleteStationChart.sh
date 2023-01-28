SHARED_NAMESPACE="transverse"

helm delete stationdev -n stationdev

helm delete argo-rollout  -n ${SHARED_NAMESPACE}

helm delete metrics-server  -n ${SHARED_NAMESPACE}

helm delete ingress-nginx -n ${SHARED_NAMESPACE}

helm delete external-secrets -n ${SHARED_NAMESPACE}


kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/aws/deploy.yaml



