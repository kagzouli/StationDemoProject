minikube config set cpus 5
minikube config set memory 9216
minikube start --memory 9216 --cpus 5
minikube addons enable ingress
