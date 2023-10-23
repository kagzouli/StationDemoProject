ARGO_NAMESPACE="argocd"

helm delete argocd  -n ${ARGO_NAMESPACE}