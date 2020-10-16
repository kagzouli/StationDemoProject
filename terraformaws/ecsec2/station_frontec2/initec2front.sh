#!/bin/bash
echo ECS_CLUSTER=station-front-ecs-cluster >> /etc/ecs/ecs.config

echo "Debut Affichage ecs.config"
cat /etc/ecs/ecs.config
echo "Fin Affichage ecs.config"

sudo start ecs

echo "Start Karim"
cat /var/log/ecs/ecs-init.log
echo "End Karim"

echo "Debut des logs"
cat /var/log/ecs/*.log
echo "Fin des logs"
