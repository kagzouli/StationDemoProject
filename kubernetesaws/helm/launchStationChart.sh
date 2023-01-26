kubectl create namespace transverse --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /var/lib/mysql 
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install metrics-server metrics-server/metrics-server --version 3.8.2 --set  args[0]="--kubelet-insecure-tls=true" -n transverse
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argo-rollout argo/argo-rollouts --version 2.21.3 --set installCRDs=true -n transverse
helm install stationdev ./station -n stationdev --create-namespace
