<br><b>Etape 1 :</b> Générer le réseaux dans terraformaws/networks (generateNetworks.sh)<br/><br/>
<br><b>Etape 2 :</b> Générer le master du cluster kubernetes.<br/>
    2.1 Aller sur terraformaws/clusterkubmanual/master<br/>
    2.2 Lancer generatemaster.sh<br/>
    2.3 Se connecter à la machine et faire un sudo su -<br/>
    2.4 Attendre que la machine s'initialise bien (On peut utiliser journalctl -u cloud-final)<br/>
    2.5 Lancer la commande : "kubeadm token create --print-join-command". Cette commande permettra au worker de se connecter au master.<br/><br/>
<br><b>Etape 3 :</b> Générer les workers du cluster kubernetes.<br/>
    3.1 Aller sur terraformaws/clusterkubmanual/worker<br/>
    2.2 Lancer generateworker.sh<br/>
    3.3 Se connecter à la machine et faire un sudo su -<br/>
    3.4 Attendre que la machine s'initialise bien (On peut utiliser journalctl -u cloud-final).<br/>
    3.5 Copier le résultat de la commande en 2.5 et l'éxecuter sur l'ensemble des workers.<br/><br/>
<br><b>Etape 4 (Si secretsMode=vault) :</b> Créer la vault.<br/>
    4.1 Aller sur terraformaws/clusterkubmanual/vault<br/>
    4.2 Lancer generatevault.sh<br/>
    4.3 Se connecter à la machine et faire un sudo su -<br/>
    4.4 Attendre que la machine s'initialise bien (On peut utiliser journalctl -u cloud-final).<br/>
    4.5 Se connecter sur http://stationvault.exakaconsulting.org:8200/ui/ et saisir 1 et 1 pour les 2 paramètres.<br/>
    4.6 Penser bien à copier le token root ainsi que la clé pour unsteal vault.<br/>
    4.7 Saisir le token root pour s'authentifier.<br/>
    4.8 Aller sur terraformaws/clusterkubmanual/vault/script et lancer putSecret $rootToken.<br/>
    4.9 Garder bien le token généré qui est celui de l'ulitisateur de la vault.<br/><br/>
<br><b>Etape 5 :</b> Initialiser l'application station dans le cluster : <br/>
    5.1 Si secrets=internal, aller sur kubernetesaws/helm et lancer bash launchStationChart.sh internal afin que le cluster s'initialise avec l'application station et les add-ons necéssaires pour l'application.<br/>
    5.2 Si secrets=vault, aller sur kubernetesaws/helm et lancer bash launchStationChart.sh vault $token (Recupéré en 4.9) afin que le cluster s'initialise avec l'application station et les add-ons necéssaires pour l'application.<br/>
