/usr/local/maven/apache-maven-3.3.9/bin/mvn clean install
echo "Build maven install successful"
docker build -t kagzouli/station-db StationDemoDb
echo "Lancement image stationdb"
cp StationDemoWeb/target/StationDemoSecureWeb.war StationDemoWeb/docker/StationDemoSecureWeb.war
docker build -t kagzouli/station-back StationDemoWeb/docker
echo "Lancement image stationback"
cp -rf StationDemoClient/station-angular4-poc/dist StationDemoClient/station-angular4-poc/dockerwithnginx/
docker build -t kagzouli/station-front-nginx StationDemoClient/station-angular4-poc/dockerwithnginx
echo "Lancement image nginxstationfront"
cp  StationDemoClient/station-angular4-poc/target/station-angular4-poc.war StationDemoClient/station-angular4-poc/dockerwithtomcat/station-angular4-poc.war
docker build -t kagzouli/station-front-tomcat StationDemoClient/station-angular4-poc/dockerwithtomcat
echo "Lancement image tomcatstationfront"



