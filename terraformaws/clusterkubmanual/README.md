1 - Generate networks
2 - Generate master kubernetes
3 - Se connecter en root sur master (Pour avoir acces à kubectl). 
4 - Recupérer la commande à l'aide de journalctl -u cloud-final (Recupérer join)
5 - Se connecter à un worker 
 et lancer la commande 

kubeadm join 12.0.3.6:6443 --token $TOKEN --discovery-token-ca-cert-hash 
$DISCOVERY_TOKEN_HASH
