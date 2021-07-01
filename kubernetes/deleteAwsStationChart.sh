sudo kubectl delete -f efsstorage/efs-csidriver.yaml
sudo kubectl delete -f efsstorage/efs-storageclass.yaml
sudo helm delete stationdev -n stationdev
