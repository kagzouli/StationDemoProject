docker run -d -p 4516:4516 \
-v C:/Karim/XebiaLabs/xl-deploy-docker/conf:/opt/xebialabs/xl-deploy-server/conf:rw \
-v C:/Karim/XebiaLabs/xl-deploy-docker/repository:/opt/xebialabs/xl-deploy-server/repository:rw \
-v C:/Karim/XebiaLabs/xl-deploy-docker/archive:/opt/xebialabs/xl-deploy-server/archive:rw \
-e ACCEPT_EULA=Y \
--name xld xebialabsearlyaccess/xl-deploy:25.3.0