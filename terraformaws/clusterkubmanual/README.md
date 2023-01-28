<br>Etape 1 :</b> Générer le réseaux dans terraformaws/networks (generateNetworks.sh)<br/><br/>
<br>Etape 2 :</b> Générer le master du cluster kubernetes.<br/>
    2.1 Aller sur terraformaws/clusterkubmanual/master<br/>
    2.2 Lancer generatemaster.sh<br/>
    2.3 Se connecter à la machine et faire un sudo su -<br/>
    2.4 Attendre que la machine s'initialise bien (On peut utiliser journalctl -u cloud-final)<br/>
    2.5 Lancer la commande : "kubeadm token create --print-join-command". Cette commande permettra au worker de se connecter au master.<br/><br/>
<br>Etape 3 :</b> Générer les workers du cluster kubernetes.<br/>
    3.1 Aller sur terraformaws/clusterkubmanual/worker<br/>
    2.2 Lancer generateworker.sh<br/>
    3.3 Se connecter à la machine et faire un sudo su -<br/>
    3.4 Copier le résultat de la commande en 2.5 et l'éxecuter sur l'ensemble des workers.<br/><br/>
<br>Etape 4 :</b> Initialiser l'application station dans le cluster : <br/>
    Aller sur kubernetes/helm et lancer plusieurs fois launchStationChart.sh afin que le cluster s'initialise.<br/><br/>
