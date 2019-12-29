import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';
import {shareReplay} from 'rxjs/operators';
import { Configuration } from '../bean/configuration';
import { Subject } from 'rxjs/Subject';

@Injectable()
export class ConfigurationLoaderService {

 
  private readonly CONFIG_URL = 'assets/config/configuration.json'; 

  constructor(private http: HttpClient) {
  }

  public loadConfigurations():  Observable<Configuration>{
    let observableConfiguration :Observable<Configuration>;
    return this.http.get<Configuration>(this.CONFIG_URL).pipe(
        shareReplay(1)
      );
    }

  public setConfiguration(configuration : Configuration){
      localStorage.setItem("configurationStation" , JSON.stringify(configuration));
  }

  public getConfiguration() : Configuration{
       return JSON.parse(localStorage.getItem("configurationStation"));
  }

  public getURLTrafficService(){
     let urlTrafficStation = null;
     const configuration = this.getConfiguration();
     if (configuration != null){
        urlTrafficStation = configuration.contextPathTrafStation;
     }
     return urlTrafficStation;
  }
}
