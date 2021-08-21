echo "Fixe les variables"
SHARED_NAMESPACE="transverse"

sudo kubectl delete -f efsstorage/efs-storageclass.yaml

echo "Suppression du chart station"
helm delete stationdev -n stationdev

echo "Delete transverse namespace and chart helm"
helm delete transverse  -n ${SHARED_NAMESPACE}


echo "Delete aws load balancer controller"
helm delete station-aws-load-balancer-controller -n ${SHARED_NAMESPACE}

echo "Delete efs csi driver controller"
helm delete station-aws-efs-csi-driver -n ${SHARED_NAMESPACE}

echo "Delete external secret"
helm delete station-external-secrets -n ${SHARED_NAMESPACE}


