import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';
import {shareReplay} from 'rxjs/operators';
import { Configuration } from '../bean/configuration';
import { Subject } from 'rxjs/Subject';

@Injectable()
export class ConfigurationLoaderService {

  private configuration: Configuration;

 
  private readonly CONFIG_URL = 'assets/config/configuration.json'; 

  constructor(private http: HttpClient) {
  }

  public loadConfigurations(){
    let observableConfiguration :Observable<Configuration>;
    return this.http.get<Configuration>(this.CONFIG_URL).toPromise()
      .then(config => {
        this.configuration = config;
        this.setConfiguration(this.configuration);
      });
    }

  public setConfiguration(configuration : Configuration){
      localStorage.setItem("configurationStation" , JSON.stringify(configuration));
  }

  public getConfiguration() : Configuration{
       return JSON.parse(localStorage.getItem("configurationStation"));
  }

  public getURLTrafficService(){
     let urlTrafficStation = null;
     if (this.configuration != null){
        urlTrafficStation = this.configuration.contextPathTrafStation + '/station';
     }
     return urlTrafficStation;
  }

   public get(key: string) :string {
    return this.configuration[key];
  }
}
