kubectl create namespace transverse --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /var/lib/mysql 
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install metrics-server metrics-server/metrics-server --version 3.8.2 --set  args[0]="--kubelet-insecure-tls=true" -n transverse
helm upgrade --install argo-rollout argo/argo-rollouts --version 2.21.3 --set installCRDs=true -n transverse
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx    --version 4.4.2 -n transverse --create-namespace

helm install stationdev ./station -n stationdev --create-namespace
