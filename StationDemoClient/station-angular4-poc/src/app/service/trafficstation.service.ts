import { Injectable } from '@angular/core';

import { HttpClient , HttpHeaders , HttpParams} from '@angular/common/http';

import { CriteriaSearchStation } from '../bean/criteriasearchstation';
import { TrafficStationBean } from '../bean/trafficstationbean';

import { CreateStationResponse } from '../bean/createstationresponse';
import { UpdateStationResponse } from '../bean/updatestationresponse';


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


  // Method to select the station by id.
  selectStationById(id: number , callback: (createStationResponse: TrafficStationBean) => void){
      const relativeUrl = '/findStationById/' + id;

      const headers = new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded')
      this.http.get<TrafficStationBean>(this.contextTrafficServiceUrl + relativeUrl, {headers: headers})
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
  * Update station 

  */
  updateStation(traffic : number, correspondance: string ,stationId: number, callback: (updateStationResponse: UpdateStationResponse) => void){
    const headers = new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded');

    let body = new HttpParams()
    .set('newTraffic', traffic.toString())
    .set('newCorr', correspondance);

    this.http.patch<CreateStationResponse>(this.contextTrafficServiceUrl + '/updateStation/' + stationId, body.toString(), {headers: headers})
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
