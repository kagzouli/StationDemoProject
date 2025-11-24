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
        
        /** Connect function called by the table to retrieve one stream containing the data to render. */
        connect(collectionViewer: CollectionViewer): Observable<TrafficStationBean[]> {
            return this.stationTrafficBehavior.asObservable();
        }
      
        disconnect(collectionViewer: CollectionViewer) : void {
            this.stationTrafficBehavior.complete();
            this.loadStationsBehavior.complete();
        }

        async findStations(criteriaSearchStation : CriteriaSearchStation){

            this.loadStationsBehavior.next(true);

            try {
                const stations = await this.trafficStationService.findTrafficStations(criteriaSearchStation);
                this.stationTrafficBehavior.next(stations);
            } catch (error) {
                console.error('Error loading stations:', error);
                this.stationTrafficBehavior.next([]); // fallback to empty array
            } finally {
                this.loadStationsBehavior.next(false); // stop loading
            }         
        }
    }
      