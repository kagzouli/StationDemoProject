# Host for CRC openshift : https://host.docker.internal:6443
docker run -d  \
  --name xlr-26.1.0 \
  -p 5516:5516 \
  -e ACCEPT_EULA=Y \
  -e ADMIN_PASSWORD=admin \
  -v C:/Temp/XebiaLabs/xl-release-server/xlr-conf:/opt/xebialabs/xl-release-server/conf \
  -v C:/Temp/XebiaLabs/xl-release-server/xlr-repo:/opt/xebialabs/xl-release-server/repository \
  -v C:/Temp/XebiaLabs/xl-release-server/xlr-node:/opt/xebialabs/xl-release-server/node-conf \
  -e XL_RELEASE_SERVER_URL=http://host.docker.internal:5516/ \
  xebialabsearlyaccess/xl-release:26.1.0
