# Host for CRC openshift : https://host.docker.internal:6443
docker run -d -p 4516:4516 \
-v C:/Temp/XebiaLabs/xl-deploy-docker/conf:/opt/xebialabs/xl-deploy-server/conf:rw \
-v C:/Temp/XebiaLabs/xl-deploy-docker/repository:/opt/xebialabs/xl-deploy-server/repository:rw \
-v C:/Temp/XebiaLabs/xl-deploy-docker/archive:/opt/xebialabs/xl-deploy-server/archive:rw \
-e ACCEPT_EULA=Y \
-e "ADMIN_PASSWORD=admin" \
--name xld xebialabsearlyaccess/xl-deploy:25.3.0