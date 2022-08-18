 #!/bin/bash
nbr=0
while ((nbr!=53))
do
   echo "Test"
   curl http://stationback.exakaconsulting.org:8080/StationDemoSecureWeb/station/stations/1 
   sleep 0.02 
done
