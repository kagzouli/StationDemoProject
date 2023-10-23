ARGO_NAMESPACE="argocd"

helm delete shared

helm delete argocd  -n ${ARGO_NAMESPACE}