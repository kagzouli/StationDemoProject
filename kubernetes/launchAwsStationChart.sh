kubectl apply -f efsstorage/efs-csidriver.yaml
kubectl apply -f efsstorage/efs-storageclass.yaml
sudo helm install stationdev ./station -n stationdev -f awsvalue.yaml
