import { Injectable } from '@angular/core';

import { HttpClient , HttpHeaders , HttpParams} from '@angular/common/http';

import { AuthenticateResponse } from '../bean/authenticateresponse';

@Injectable()
export class UserService {

  // URL 
  contextUserUrl = 'https://http://54.38.186.137:9080/StationDemoWeb/user'
       

  constructor(private http: HttpClient) { }

  authenticateUser(login: string, password: string , callback: (jsonResult: AuthenticateResponse) => void){
    
     let body = new HttpParams()
     .set('login', login)
     .set('password', password);
  
     const headers = new HttpHeaders().set('Content-Type', 'application/x-www-form-urlencoded');
     this.http.post<AuthenticateResponse>(this.contextUserUrl + '/authenticate', body.toString(), {headers: headers, withCredentials: true })
     .subscribe(
      res => {
         console.log("Info token : " + res.user  + "/ success : " + res.success);  
         localStorage.setItem('currentUser' , JSON.stringify(res.user));    
         callback(res);
        
      },
      err => {
        console.log('Error occured --> ' + err);
      }
    );
 
   }
 

}
