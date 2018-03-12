import { Injectable } from '@angular/core';

import { HttpClient , HttpHeaders , HttpParams} from '@angular/common/http';

import { CriteriaSearchStation } from '../bean/criteriasearchstation';
import { TrafficStationBean } from '../bean/trafficstationbean';

import { CreateStationResponse } from '../bean/createstationresponse';


@Injectable()
export class TrafficstationService {

    // URL 
    contextTrafficServiceUrl = 'http://54.38.186.137:9080/StationDemoWeb/station'
    

  constructor(private http: HttpClient) { }

   /**
   * Method to find all traffic stations
   * 
   */  
  findTrafficStations(criteriaSearchStation : CriteriaSearchStation, callback: (listTrafficStations: TrafficStationBean[]) => void){
    const headers = new HttpHeaders().set('Content-Type', 'application/json');
    this.http.post<TrafficStationBean[]>(this.contextTrafficServiceUrl + '/findStationsByCrit', criteriaSearchStation, {headers: headers})
   .subscribe(
    res => {
      callback(res);
    },
    err => {
      console.log('Error occured --> ' + err);
    }
  );
 }

 /**
  * Create station 

  */
  createStation(trafficStationBean : TrafficStationBean , callback: (createStationResponse: CreateStationResponse) => void){
  const headers = new HttpHeaders().set('Content-Type', 'application/json');
  this.http.put<CreateStationResponse>(this.contextTrafficServiceUrl + '/insertStation', trafficStationBean, {headers: headers})
 .subscribe(
  res => {
    callback(res);
  },
  err => {
    console.log('Error occured --> ' + err);
  }
);
}

}
