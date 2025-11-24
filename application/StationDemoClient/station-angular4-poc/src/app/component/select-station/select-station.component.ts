import { Component, OnInit } from '@angular/core';

import { ActivatedRoute, Router } from "@angular/router";

import { TrafficStationBean } from '../../bean/trafficstationbean';

import { TrafficstationService } from '../../service/trafficstation.service';
import { Params } from '@angular/router';
import { HttpErrorResponse } from '@angular/common/http';

@Component({
  selector: 'app-select-station',
  templateUrl: './select-station.component.html',
  styleUrls: ['./select-station.component.css'],
  providers: [TrafficstationService]
})
export class SelectStationComponent implements OnInit {

  /** Traffic station bean */
  trafficStationBean : TrafficStationBean;

  isDataAvailable : boolean;

  constructor(private parentRoute: ActivatedRoute, private trafficstationService: TrafficstationService, private router: Router) { 

  }

  async ngOnInit() {

    // Get the parameter for stationId
    let stationId = 0;
    this.parentRoute.params.subscribe(params => {   
      stationId = params['stationId'];
    });

    try {
      const trafficParam: TrafficStationBean = await this.trafficstationService.selectStationById(stationId);
      this.trafficStationBean = trafficParam;
      this.isDataAvailable = true;

    }catch (error: any) {
      if (error.status === 404) {
        this.router.navigate(['/error/404', {}]);
      } else {
        console.error('Error fetching station:', error);
      }
    }
   
  }


  /**
   * Method to call page update station.<br/>
   * 
   * @param event 
   * 
   */
  callUpdateStation(event) {
     this.router.navigate(['/stationdemo/updatestation', this.trafficStationBean.id]);
  }

  /**
   * Method to call the delete station.<br/>
   * 
   * @param event 
   */
  async callDeleteStation(event){
    let paramsDelete = { stationName: this.trafficStationBean.station };
   //let paramsDelete = "{}";
   
    if (confirm(this.trafficstationService.translateMessage("STATION_DELETE_SUCCESS_CONFIRM", paramsDelete))) {
 
      await this.trafficstationService.deleteStation(this.trafficStationBean.id);

      // Success message
      window.alert(this.trafficstationService.translateMessage('STATION_DELETE_SUCCESS', {}));

      // Navigate after deletion
      this.router.navigate(['/stationdemo/searchstations', {}]);
    
    }

  }

}
