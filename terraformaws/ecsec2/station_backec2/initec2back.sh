#!/bin/bash
echo ECS_CLUSTER=station-back-ecs-cluster >> /etc/ecs/ecs.config

echo "Debut Affichage ecs.config"
cat /etc/ecs/ecs.config
echo "Fin Affichage ecs.config"

sudo start ecs

echo "Debut des logs"
cat /var/log/ecs/*.log
echo "Fin des logs"
