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

import { OAuthService } from 'angular-oauth2-oidc';


@Injectable()
export class TrafficstationService {

    // URL 
    contextTrafficServiceUrl = 'http://54.38.186.137:9080/StationDemoWeb/station'
    

  constructor(private http: HttpClient, private oauthService : OAuthService) { }

   /**
   * Method to find all traffic stations by criteria.<br/>
   * 
   */  
  findTrafficStations(criteriaSearchStation : CriteriaSearchStation) :  Observable<TrafficStationBean[]> {
   // const headers = new Headers({ Authorization: 'Bearer ' + oktaAuth.getAccessToken().accessToken });
    const headers = new HttpHeaders().set('Content-Type', 'application/json').set('Authorization','Bearer ' + this.oauthService.getAccessToken());
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
    const headers = new HttpHeaders().set('Content-Type', 'application/json').set('Authorization','Bearer ' + this.oauthService.getAccessToken());
    return this.http.post(this.contextTrafficServiceUrl + '/countStationsByCrit', criteriaSearchStation, {headers: headers})
    .pipe(catchError(this.formatErrors));
 }



 /**
  * Create station 

  */
  createStation(trafficStationBean : TrafficStationBean)  : Observable<CreateStationResponse>{
    const headers = new HttpHeaders().set('Content-Type', 'application/json').set('Authorization','Bearer ' + this.oauthService.getAccessToken());
    return this.http.put(this.contextTrafficServiceUrl + '/insertStation', trafficStationBean, {headers: headers})
    .pipe(catchError(this.formatErrors));
  }


  // Method to select the station by id.
  selectStationById(id: number) : Observable<TrafficStationBean>{
      const relativeUrl = '/findStationById/' + id;

      const headers = new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded').set('Authorization','Bearer ' + this.oauthService.getAccessToken())
      return this.http.get<TrafficStationBean>(this.contextTrafficServiceUrl + relativeUrl, {headers: headers})
      .pipe(catchError(this.formatErrors));
  }

  /**
  * Update station 

  */
  updateStation(traffic : number, correspondance: string ,stationId: number) : Observable<CreateStationResponse>{
    const headers = new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded').set('Authorization','Bearer ' + this.oauthService.getAccessToken());

    let params = new HttpParams()
    .append('newTraffic', traffic.toString())
    .append('newCorr', correspondance);
    

    return this.http.patch(this.contextTrafficServiceUrl + '/updateStation/' + stationId + "?"+ params.toString() , {headers: headers})
      .pipe(catchError(this.formatErrors));
  }

  deleteStation(stationId : number) : Observable<DeleteStationResponse>{
      const headers = new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded').set('Authorization','Bearer ' + this.oauthService.getAccessToken());
    
      let params = new HttpParams();
    
      return this.http.delete(this.contextTrafficServiceUrl + '/deleteStation/' + stationId  , {headers: headers})
       .pipe(catchError(this.formatErrors));
  }


}
