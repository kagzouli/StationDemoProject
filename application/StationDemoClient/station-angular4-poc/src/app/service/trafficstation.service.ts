import { Injectable } from '@angular/core';

import { HttpClient , HttpHeaders , HttpParams,HttpErrorResponse} from '@angular/common/http';

import { CriteriaSearchStation } from '../bean/criteriasearchstation';
import { TrafficStationBean } from '../bean/trafficstationbean';

import { Observable, throwError } from 'rxjs';
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
   if (params && params.trim() !== '') {
      params = '?' + params;
   }

   return this.http
    .get<TrafficStationBean[]>(`${this.configurationLoaderService.getURLTrafficService()}/stations${params}`, { headers })
    .pipe(
      catchError(err => this.handleError(err))  // handleError returns Observable<never>
    ); }


/**
   * Method to count all traffic stations by criteria.<br/>
   * 
   */  
countStations(criteriaSearchStation: CriteriaSearchStation): Observable<number> {
   const headers = this.createHttpHeader('application/json');

   let params = this.convertStationCriteria(criteriaSearchStation);
   if (params && params.trim() !== '') {
      params = '?' + params;
   }

   return this.http
      .get<number>(`${this.configurationLoaderService.getURLTrafficService()}/stations/count${params}`, { headers })
      .pipe(
      catchError(err => this.handleError(err))  // handleError returns Observable<never>
      );
}



 /**
  * Create station 

  */
createStation(trafficStationBean: TrafficStationBean): Observable<number> {
   const headers = this.createHttpHeader('application/json');

   return this.http
      .put<number>(
      `${this.configurationLoaderService.getURLTrafficService()}/stations`,
      trafficStationBean,
      { headers }
   )
   .pipe(
      catchError(err => this.handleError(err))  // handleError returns Observable<never>
   );
}


selectStationById(id: number): Observable<TrafficStationBean> {
   const headers = this.createHttpHeader('application/x-www-form-urlencoded');

   return this.http
      .get<TrafficStationBean>(
      `${this.configurationLoaderService.getURLTrafficService()}/stations/${id}`,
      { headers }
   )
   .pipe(
      catchError(err => this.handleError(err))  // handleError returns Observable<never>
   );
}


  /**
  * Update station 

  */
updateStation(traffic: number, correspondance: string, stationId: number): Observable<any> {
   const headers = this.createHttpHeader('application/x-www-form-urlencoded');

   const params = new HttpParams()
   .set('newTraffic', traffic.toString())
   .set('newCorr', correspondance);

   const url = `${this.configurationLoaderService.getURLTrafficService()}/stations/${stationId}?${params.toString()}`;

   return this.http
   .patch<any>(url, {}, { headers })
   .pipe(
      catchError(err => this.handleError(err))  // handleError returns Observable<never>
   );
}


deleteStation(stationId: number): Observable<any> {
   const headers = this.createHttpHeader('application/x-www-form-urlencoded');

   const url = `${this.configurationLoaderService.getURLTrafficService()}/stations/${stationId}`;

   return this.http
      .delete<any>(url, { headers })
      .pipe(
   catchError(err => this.handleError(err))  // handleError returns Observable<never>
   );
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

  /** Error handler for Angular 9 */
   private handleError(error: HttpErrorResponse): Observable<never> {
      if ([400, 401, 403, 404, 500].includes(error.status)) {
         this.router.navigate(['/error/' + error.status]);
      } else {
         console.error('HTTP Error:', error);
      }
      return throwError(() => error);
   }



}
