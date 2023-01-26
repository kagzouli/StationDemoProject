kubectl create namespace transverse --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /var/lib/mysql 
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install metrics-server metrics-server/metrics-server --version 3.8.2 --set  args[0]="--kubelet-insecure-tls=true" -n transverse
helm upgrade --install argo-rollout argo/argo-rollouts --version 2.21.3 --set installCRDs=true -n transverse
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx    --version 4.4.2 -n transverse --create-namespace

# Check that Argo Rollout are is Running or failed state 
NOTPENDING_ARGO_ROLLOUT=$( kubectl get pods -n transverse -o json  | jq -r '.items[] |  select( (.metadata.name |  contains("argo-rollout")) and (.status.phase=="Running" or .status.phase=="Failed"))' | jq -jr '.metadata | .name, ", " ')
while [[ -z "${NOTPENDING_ARGO_ROLLOUT}" ]]
do
  echo "Les pods ${NOTPENDING_ARGO_ROLLOUT} de ArgoRollout sont encore en cours"
  sleep 5s
  NOTPENDING_ARGO_ROLLOUT=$( kubectl get pods -n transverse -o json  | jq -r '.items[] |  select( (.metadata.name |  contains("argo-rollout")) and (.status.phase=="Running" or .status.phase=="Failed"))' | jq -jr '.metadata | .name, ", " ')
done

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

helm upgrade --install stationdev ./station -n stationdev --create-namespace

kubectl apply -f ipaddress_pools.yaml
