import { Injectable } from '@angular/core';

import { HttpClient , HttpHeaders , HttpParams,HttpErrorResponse} from '@angular/common/http';

import { CriteriaSearchStation } from '../bean/criteriasearchstation';
import { TrafficStationBean } from '../bean/trafficstationbean';

import { Observable } from 'rxjs/Observable';
import { ErrorObservable } from 'rxjs/observable/ErrorObservable';
import { catchError } from 'rxjs/operators/catchError';
import { Router } from '@angular/router';

import { OAuthService } from 'angular-oauth2-oidc';
import { TranslateService } from '@ngx-translate/core';

import { OrderBean } from '../bean/orderbean';
import { ConfigurationLoaderService } from './configuration-loader.service';
import { Configuration } from '../bean/configuration';


@Injectable()
export class TrafficstationService {
  

  constructor(private readonly http: HttpClient, private readonly oauthService : OAuthService, 
    private readonly translateService : TranslateService,
    private readonly router: Router,
    private readonly configurationLoaderService : ConfigurationLoaderService) {
    }

  

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

    return this.http.get(`${this.configurationLoaderService.getURLTrafficService()}/stations` + params, {headers: headers})
    .pipe(catchError(err =>  this.formatErrors(err)));
 }

 private formatErrors(error: any) {


  if (error instanceof HttpErrorResponse){
     const status = error.status;
     if (status === 400 || status === 401 || status === 403 || status === 404 || status === 500){
        this.router.navigate(['/error/' + status]);
     }else{
      return new ErrorObservable(error);
     }
  }else{
    return new ErrorObservable(error);
  }


  
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


    return this.http.get(`${this.configurationLoaderService.getURLTrafficService()}/stations/count` + params, {headers: headers})
    .pipe(catchError(err =>  this.formatErrors(err)));
 }



 /**
  * Create station 

  */
  createStation(trafficStationBean : TrafficStationBean)  : Observable<number>{
    const headers = this.createHttpHeader('application/json');   
    return this.http.put(`${this.configurationLoaderService.getURLTrafficService()}/stations`, trafficStationBean, {headers: headers})
    .pipe(catchError(err =>  this.formatErrors(err)));
  }


  // Method to select the station by id.
  selectStationById(id: number) : Observable<TrafficStationBean>{
      const headers = this.createHttpHeader('application/x-www-form-urlencoded');     
      return this.http.get<TrafficStationBean>(`${this.configurationLoaderService.getURLTrafficService()}/stations/${id}`, {headers: headers})
      .pipe(catchError(err =>  this.formatErrors(err)));
  }

  /**
  * Update station 

  */
  updateStation(traffic : number, correspondance: string ,stationId: number) : Observable<any>{
    const headers = this.createHttpHeader('application/x-www-form-urlencoded');  
   
    let params = new HttpParams()
    .append('newTraffic', traffic.toString())
    .append('newCorr', correspondance);
    

    return this.http.patch(`${this.configurationLoaderService.getURLTrafficService()}/stations/${stationId}` + "?"+ params.toString() ,{}, {headers: headers})
      .pipe(catchError(err =>  this.formatErrors(err)));
  }

  deleteStation(stationId : number) : Observable<any>{
      const headers = this.createHttpHeader('application/x-www-form-urlencoded');  
          
      return this.http.delete(`${this.configurationLoaderService.getURLTrafficService()}/stations/${stationId}`  , {headers: headers})
       .pipe(catchError(err =>  this.formatErrors(err)));
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
