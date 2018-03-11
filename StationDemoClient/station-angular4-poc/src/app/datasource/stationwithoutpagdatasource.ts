import {DataSource} from '@angular/cdk/collections';

import {Observable} from 'rxjs/Observable';
import { BehaviorSubject } from "rxjs/BehaviorSubject";



/**
 * Data source to provide what data should be rendered in the table. The observable provided
 * in connect should emit exactly the data that should be rendered by the table. If the data is
 * altered, the observable should emit that new set of data on the stream. In our case here,
 * we return a stream that contains only one set of data that doesn't change.
 */
export class StationWithoutPagDataSource extends DataSource<any> {

    dataChange = new BehaviorSubject<any[]>([]);
    
     constructor() {
      super();
    }

    updateValue(value : any){
        this.dataChange.next(value);
    }
    
    
    /** Connect function called by the table to retrieve one stream containing the data to render. */
    connect(): Observable<any[]> {
        return this.dataChange.asObservable();
    }
  
    disconnect() {}
  }
  