echo "Fixe les variables"
SHARED_NAMESPACE="transverse"
AWS_REGION="eu-west-3"  


aws eks --region ${AWS_REGION} update-kubeconfig --name station-eks-cluster

echo "Suppression du chart applications"
helm delete applications

echo "Delete transverse namespace and chart helm"
helm delete shared



