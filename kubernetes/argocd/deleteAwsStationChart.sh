aws eks --region "eu-west-3" update-kubeconfig --name station-eks-cluster

echo "Suppression du chart applications"
helm delete applications

echo "Delete transverse namespace and chart helm"
helm delete shared



