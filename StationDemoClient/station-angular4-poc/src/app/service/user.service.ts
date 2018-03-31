import { Injectable } from '@angular/core';

import { HttpClient , HttpHeaders , HttpParams} from '@angular/common/http';

import { AuthenticateResponse } from '../bean/authenticateresponse';
import { Observable } from 'rxjs/Observable';

import { ErrorObservable } from 'rxjs/observable/ErrorObservable';
import { catchError } from 'rxjs/operators/catchError';

import { OAuthService } from 'angular-oauth2-oidc';
import { UserBean } from '../bean/user';
import { TranslateService } from '@ngx-translate/core';


@Injectable()
export class UserService {

  // URL 
  contextUserUrl = 'http://54.38.186.137:9080/StationDemoSecureWeb/user'

// contextUserUrl = 'http://localhost:8080/StationDemoSecureWeb/user'
  
       

  constructor(private http: HttpClient , private oauthService : OAuthService, private translateService : TranslateService) { }

  retrieveRole(login: string) : Observable<UserBean>{
    
     const headers = this.createHttpHeader('application/x-www-form-urlencoded');
     return this.http.get(this.contextUserUrl + '/retrieveRole?login='+ login,  {headers: headers })
     .pipe(
       catchError(this.formatErrors)
      );
   }

   private formatErrors(error: any) {
    return new ErrorObservable(error.error);
  }

  createHttpHeader(contentType: string):  HttpHeaders{
    let headers : HttpHeaders = new HttpHeaders().set('Content-Type', contentType).set('Authorization','Bearer ' + this.oauthService.getAccessToken());
   
     if (this.translateService.currentLang != null){
       headers = headers.set('Content-Language', this.translateService.currentLang);
       headers = headers.set('Accept-Language', this.translateService.currentLang);
     }


     return headers;

}

 

}
