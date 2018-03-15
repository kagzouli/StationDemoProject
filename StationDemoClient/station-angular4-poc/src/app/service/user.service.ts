import { Injectable } from '@angular/core';

import { HttpClient , HttpHeaders , HttpParams} from '@angular/common/http';

import { AuthenticateResponse } from '../bean/authenticateresponse';
import { Observable } from 'rxjs/Observable';

import { ErrorObservable } from 'rxjs/observable/ErrorObservable';
import { catchError } from 'rxjs/operators/catchError';


@Injectable()
export class UserService {

  // URL 
  contextUserUrl = 'http://54.38.186.137:9080/StationDemoWeb/user'
       

  constructor(private http: HttpClient) { }

  authenticateUser(login: string, password: string) : Observable<AuthenticateResponse>{
    
     let body = new HttpParams()
     .set('login', login)
     .set('password', password);
  
     const headers = new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded');
     return this.http.post(this.contextUserUrl + '/authenticate', body.toString(), {headers: headers, withCredentials: false })
     .pipe(catchError(this.formatErrors));
   }

   private formatErrors(error: any) {
    return new ErrorObservable(error.error);
  }
 

}
