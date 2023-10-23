ARGO_NAMESPACE="argocd"

# Repo helm chart
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Install argocd - Mot de passe argocd123 (bcrypt hash)
helm upgrade --install argocd argo/argo-cd --set server.ingress.enabled=true \
    --set server.ingress.annotations."kubernetes\.io/ingress\.class"=nginx \
    --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io/force-ssl-redirect"="true" \
    --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io/backend-protocol"="HTTPS" \
    --set configs.secret.argocdServerAdminPassword='$2y$10$8LaHsCQS1hd74MIYj4jinuVni14FBL4PlDJ0SKAg9f/pQvolxVlRS' \
    --set configs.secret.argocdServerAdminPasswordMtime="2023-10-01T10:11:12Z" \
    --set server.ingress.hosts[0]="argocd.exakaconsulting.org" -n ${ARGO_NAMESPACE} --create-namespace

# Install shared
helm upgrade --install shared ./argocd/shared

