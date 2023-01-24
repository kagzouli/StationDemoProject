kubectl create namespace transverse --dry-run=client -o yaml | kubectl apply -f -
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install metrics-server metrics-server/metrics-server --version 3.8.2 -n transverse
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argo-rollout argo/argo-rollouts --version 2.18.0 --set installCRDs=true -n transverse
helm install stationdev ./station -n stationdev --create-namespace
