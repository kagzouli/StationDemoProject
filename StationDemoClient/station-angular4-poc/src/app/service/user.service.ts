import { Injectable } from '@angular/core';

import { HttpClient , HttpHeaders , HttpParams} from '@angular/common/http';

import { AuthenticateResponse } from '../bean/authenticateresponse';
import { Observable } from 'rxjs/Observable';

import { ErrorObservable } from 'rxjs/observable/ErrorObservable';
import { catchError } from 'rxjs/operators/catchError';

import { OAuthService } from 'angular-oauth2-oidc';
import { UserBean } from '../bean/user';


@Injectable()
export class UserService {

  // URL 
  contextUserUrl = 'http://54.38.186.137:9080/StationDemoSecureWeb/user'

 // contextUserUrl = 'http://localhost:8080/StationDemoSecureWeb/user'
  
       

  constructor(private http: HttpClient , private oauthService : OAuthService) { }

  retrieveRole(login: string) : Observable<UserBean>{
    
     const headers = new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded').set('Authorization','Bearer ' + this.oauthService.getAccessToken());
     return this.http.get(this.contextUserUrl + '/retrieveRole?login='+ login,  {headers: headers })
     .pipe(
       catchError(this.formatErrors)
      );
   }

   private formatErrors(error: any) {
    return new ErrorObservable(error.error);
  }
 

}
