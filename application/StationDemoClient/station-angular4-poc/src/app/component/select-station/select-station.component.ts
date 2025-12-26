import { Component, OnInit  , signal } from '@angular/core';

import { ActivatedRoute, Router } from "@angular/router";

import { TrafficStationBean } from '../../bean/trafficstationbean';

import { TrafficstationService } from '../../service/trafficstation.service';
import { Params } from '@angular/router';
import { HttpErrorResponse } from '@angular/common/http';

@Component({
  selector: 'app-select-station',
  templateUrl: './select-station.component.html',
  styleUrls: ['./select-station.component.css'],
  providers: [TrafficstationService],
  standalone: false
})
export class SelectStationComponent implements OnInit {

  /** Traffic station bean */
  trafficStationBean = signal<TrafficStationBean | null>(null);


  constructor(private parentRoute: ActivatedRoute, private trafficstationService: TrafficstationService, private router: Router) { 

  }

  async ngOnInit() {
    const stationId = +this.parentRoute.snapshot.params['stationId'] || 0;
    this.loadStation(stationId);
}

private async loadStation(stationId: number) {
  try {
    const trafficParam = await this.trafficstationService.selectStationById(stationId);
    this.trafficStationBean.set(trafficParam);

  } catch (error: any) {
    if (error.status === 404) {
      this.router.navigate(['/error/404']);
    } else {
      console.error('Error fetching station:', error);
    }
  }
}

get isDataAvailable() {
  return !!this.trafficStationBean();
}



  /**
   * Method to call page update station.<br/>
   * 
   * @param event 
   * 
   */
  callUpdateStation(event) {
     this.router.navigate(['/stationdemo/updatestation', this.trafficStationBean()!.id]);
  }

  /**
   * Method to call the delete station.<br/>
   * 
   * @param event 
   */
  async callDeleteStation(event){
    const bean = this.trafficStationBean();
    if (bean) {
      const paramsDelete = { stationName: bean.station };

    //let paramsDelete = "{}";
    
      if (confirm(this.trafficstationService.translateMessage("STATION_DELETE_SUCCESS_CONFIRM", paramsDelete))) {
  
        await this.trafficstationService.deleteStation(this.trafficStationBean()!.id);

        // Success message
        window.alert(this.trafficstationService.translateMessage('STATION_DELETE_SUCCESS', {}));

        // Navigate after deletion
        this.router.navigate(['/stationdemo/searchstations', {}]);
      
      }
    }

  }

}
