/usr/local/maven/apache-maven-3.3.9/bin/mvn clean install
echo "Build maven install successful"
docker build -t station-db StationDemoDb/ 
echo "Lancement image stationdb"
docker build -t station-back StationDemoWeb/docker 
echo "Lancement image stationback"
docker build -t station-front-nginx StationDemoClient/station-angular4-poc/dockerwithnginx/ 
echo "Lancement image nginxstationfront"
docker build -t station-front-tomcat StationDemoClient/station-angular4-poc/dockerwithtomcat/ 
echo "Lancement image tomcatstationfront"



