import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';
import {shareReplay} from 'rxjs/operators';
import { Configuration } from '../bean/configuration';

@Injectable()
export class ConfigurationLoaderService {

 
  private readonly CONFIG_URL = 'assets/config/configuration.json';
  private configuration$: Observable<Configuration>;

  constructor(private http: HttpClient) {
     this.loadConfigurations();
  }

  public loadConfigurations():  Observable<Configuration>{
    if (!this.configuration$) {
      this.configuration$ = this.http.get<Configuration>(this.CONFIG_URL).pipe(
        shareReplay(1)
      );
    }
    return this.configuration$;
  }


}
