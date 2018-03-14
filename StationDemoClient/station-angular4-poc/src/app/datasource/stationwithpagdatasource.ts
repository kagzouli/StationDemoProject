import {DataSource, CollectionViewer} from '@angular/cdk/collections';

import {Observable} from 'rxjs/Observable';
import { BehaviorSubject } from "rxjs/BehaviorSubject";
import { TrafficStationBean } from '../bean/trafficstationbean';
import { TrafficstationService } from '../service/trafficstation.service';
import { CriteriaSearchStation } from '../bean/criteriasearchstation';

import { catchError } from 'rxjs/operators/catchError';
import { finalize } from 'rxjs/operators/finalize';
import { of } from 'rxjs/observable/of';


export class StationWithPagDataSource extends DataSource<TrafficStationBean> {
    
        private stationTrafficBehavior = new BehaviorSubject<TrafficStationBean[]>([]);
        private loadStationsBehavior = new BehaviorSubject<boolean>(false);

        public loading$ = this.loadStationsBehavior.asObservable();
        
         constructor(private trafficStationService: TrafficstationService)  {
          super();
        }
    
        updateValue(value : any){
            this.stationTrafficBehavior.next(value);
        }
        
        
        /** Connect function called by the table to retrieve one stream containing the data to render. */
        connect(collectionViewer: CollectionViewer): Observable<TrafficStationBean[]> {
            return this.stationTrafficBehavior.asObservable();
        }
      
        disconnect(collectionViewer: CollectionViewer) : void {
            this.stationTrafficBehavior.complete();
            this.loadStationsBehavior.complete();
        }

        findStations(criteriaSearchStation : CriteriaSearchStation){

            this.loadStationsBehavior.next(true);

            

            this.trafficStationService.findTrafficStations(criteriaSearchStation).pipe(
                catchError(() => of([])),
                finalize(() => this.loadStationsBehavior.next(false))
            )
            .subscribe(stations => this.stationTrafficBehavior.next(stations));
        }
      }
      