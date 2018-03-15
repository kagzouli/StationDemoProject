import { Injectable } from '@angular/core';

import { HttpClient , HttpHeaders , HttpParams} from '@angular/common/http';

import { CriteriaSearchStation } from '../bean/criteriasearchstation';
import { TrafficStationBean } from '../bean/trafficstationbean';

import { CreateStationResponse } from '../bean/createstationresponse';
import { UpdateStationResponse } from '../bean/updatestationresponse';
import { DeleteStationResponse } from '../bean/deletestationresponse';
import { Observable } from 'rxjs/Observable';
import { ErrorObservable } from 'rxjs/observable/ErrorObservable';
import { catchError } from 'rxjs/operators/catchError';



@Injectable()
export class TrafficstationService {

    // URL 
    contextTrafficServiceUrl = 'http://54.38.186.137:9080/StationDemoWeb/station'
    

  constructor(private http: HttpClient , private httpNew:HttpClient) { }

   /**
   * Method to find all traffic stations by criteria.<br/>
   * 
   */  
  findTrafficStations(criteriaSearchStation : CriteriaSearchStation) :  Observable<TrafficStationBean[]> {
    const headers = new HttpHeaders().set('Content-Type', 'application/json');
    return this.http.post(this.contextTrafficServiceUrl + '/findStationsByCrit', criteriaSearchStation, {headers: headers})
    .pipe(catchError(this.formatErrors));
 }

 private formatErrors(error: any) {
  return new ErrorObservable(error.error);
}

/**
   * Method to count all traffic stations by criteria.<br/>
   * 
   */  
  countStations(criteriaSearchStation : CriteriaSearchStation) :  Observable<number> {
    const headers = new HttpHeaders().set('Content-Type', 'application/json');
    return this.http.post(this.contextTrafficServiceUrl + '/countStationsByCrit', criteriaSearchStation, {headers: headers})
    .pipe(catchError(this.formatErrors));
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

    let params = new HttpParams()
    .append('newTraffic', traffic.toString())
    .append('newCorr', correspondance);
    

    this.http.patch<CreateStationResponse>(this.contextTrafficServiceUrl + '/updateStation/' + stationId + "?"+ params.toString() , {headers: headers})
     .subscribe(
      res => {
       callback(res);
      },
      err => {
       console.log('Error occured --> ' + err);
      }
    );
  }

  deleteStation(stationId : number, callback: (updateStationResponse: DeleteStationResponse) => void){
      const headers = new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded');
    
        let params = new HttpParams();
        
    
        this.http.delete<DeleteStationResponse>(this.contextTrafficServiceUrl + '/deleteStation/' + stationId  , {headers: headers})
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
