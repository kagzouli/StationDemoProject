PROJECT_VERSION=1.0.1
/usr/local/maven/apache-maven-3.3.9/bin/mvn clean install
echo "Build maven install successful"
docker build -t kagzouli/station-db StationDemoDb
docker tag kagzouli/station-db:latest kagzouli/station-db:$PROJECT_VERSION
echo "Lancement image stationdb"
cp StationDemoWeb/target/StationDemoSecureWeb.war StationDemoWeb/docker/StationDemoSecureWeb.war
docker build -t kagzouli/station-back StationDemoWeb/docker
docker tag kagzouli/station-back:latest kagzouli/station-back:$PROJECT_VERSION
echo "Lancement image stationback"
cp -rf StationDemoClient/station-angular4-poc/dist StationDemoClient/station-angular4-poc/dockerwithnginx/
docker build -t kagzouli/station-front-nginx StationDemoClient/station-angular4-poc/dockerwithnginx
docker tag kagzouli/station-front-nginx:latest kagzouli/station-front-nginx:$PROJECT_VERSION
echo "Lancement image nginxstationfront"
cp  StationDemoClient/station-angular4-poc/target/station-angular4-poc.war StationDemoClient/station-angular4-poc/dockerwithtomcat/station-angular4-poc.war
docker build -t kagzouli/station-front-tomcat StationDemoClient/station-angular4-poc/dockerwithtomcat
docker tag kagzouli/station-front-tomcat:latest kagzouli/station-front-tomcat:$PROJECT_VERSION
echo "Lancement image tomcatstationfront"



