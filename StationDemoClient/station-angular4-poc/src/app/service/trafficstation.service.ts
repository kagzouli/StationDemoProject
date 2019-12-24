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
import { TranslateService } from '@ngx-translate/core';

import { environment } from '../../environments/environment';
import { OrderBean } from '../bean/orderbean';


@Injectable()
export class TrafficstationService {

  // Contexte  
  contextTrafficServiceUrl = environment.contextPathTrafStation + '/station';
   

  constructor(private http: HttpClient, private oauthService : OAuthService, private translateService : TranslateService) { }

   /**
   * Method to find all traffic stations by criteria.<br/>
   * 
   */  
  findTrafficStations(criteriaSearchStation : CriteriaSearchStation) :  Observable<TrafficStationBean[]> {
    const headers = this.createHttpHeader('application/json');

    let params = this.convertStationCriteria(criteriaSearchStation);
    if (params != null && params.trim() !== ''){
       params = '?' + params;
    }

    return this.http.get(`${this.contextTrafficServiceUrl}/stations` + params, {headers: headers})
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
    const headers = this.createHttpHeader('application/json');   

    let params = this.convertStationCriteria(criteriaSearchStation);
    if (params != null && params.trim() !== ''){
       params = '?' + params;
    }


    return this.http.get(`${this.contextTrafficServiceUrl }/stations/count` + params, {headers: headers})
    .pipe(catchError(this.formatErrors));
 }



 /**
  * Create station 

  */
  createStation(trafficStationBean : TrafficStationBean)  : Observable<CreateStationResponse>{
    const headers = this.createHttpHeader('application/json');   
    return this.http.put(`${this.contextTrafficServiceUrl}/stations`, trafficStationBean, {headers: headers})
    .pipe(catchError(this.formatErrors));
  }


  // Method to select the station by id.
  selectStationById(id: number) : Observable<TrafficStationBean>{
      const headers = this.createHttpHeader('application/x-www-form-urlencoded');     
      return this.http.get<TrafficStationBean>(`${this.contextTrafficServiceUrl}/stations`, {headers: headers})
      .pipe(catchError(this.formatErrors));
  }

  /**
  * Update station 

  */
  updateStation(traffic : number, correspondance: string ,stationId: number) : Observable<CreateStationResponse>{
    const headers = this.createHttpHeader('application/x-www-form-urlencoded');  
   
    let params = new HttpParams()
    .append('newTraffic', traffic.toString())
    .append('newCorr', correspondance);
    

    return this.http.patch(`${this.contextTrafficServiceUrl}/stations/${stationId}` + "?"+ params.toString() ,{}, {headers: headers})
      .pipe(catchError(this.formatErrors));
  }

  deleteStation(stationId : number) : Observable<DeleteStationResponse>{
      const headers = this.createHttpHeader('application/x-www-form-urlencoded');  
      
      let params = new HttpParams();
    
      return this.http.delete(`${this.contextTrafficServiceUrl}/stations/${stationId}`  , {headers: headers})
       .pipe(catchError(this.formatErrors));
  }

  createHttpHeader(contentType: string):  HttpHeaders{
      let headers : HttpHeaders = new HttpHeaders().set('Content-Type', contentType).set('Authorization','Bearer ' + this.oauthService.getAccessToken());
     
       if (this.translateService.currentLang != null){
         headers = headers.set('Content-Language', this.translateService.currentLang);
         headers = headers.set('Accept-Language', this.translateService.currentLang);
       }       
  
       return headers;

  }

  translateMessage(key : string, params : any): string{
    let value = "";
    this.translateService.get(key, params).subscribe((res: string) => {
       value = res;
    });
    return value;  
  }

   /**
   * Convert criteria oeuvre to string.<br/>
   *
   * @param criteria
   *
   */
  private convertStationCriteria(criteria : CriteriaSearchStation) : string{
    const paramsArray : Array<string> = [];

    if (criteria.reseau != null && criteria.reseau.trim() !== ''){
       paramsArray.push('reseau=' + encodeURIComponent(criteria.reseau.trim()));
    }

    if (criteria.station != null && criteria.station.trim() !== ''){
       paramsArray.push('station='+ encodeURIComponent(criteria.station.trim()));
    }

    if (criteria.trafficMin != null){
       paramsArray.push('trafficMin='+ encodeURIComponent(criteria.trafficMin.toString()));
    }

    if (criteria.trafficMax != null){
       paramsArray.push('trafficMax='+ encodeURIComponent(criteria.trafficMax.toString()));
    }

    if (criteria.ville != null && criteria.ville.trim() !== ''){
       paramsArray.push('ville='+ encodeURIComponent(criteria.ville.trim()));
    }

    if (criteria.page != null){
        paramsArray.push('page='+ criteria.page);
    }

    if (criteria.perPage != null){
       paramsArray.push('per_page='+ criteria.perPage);
    }

    const orders : OrderBean[] = criteria.orders;
    const paramsOrders : Array<string> = [];
    if (orders != null){
        for (const order of orders){
             paramsOrders.push(`${order.column}:${order.direction}`)
        }
    }
    paramsArray.push('sort='+ paramsOrders.join(","));
    

    return paramsArray.join('&');

 }



}
