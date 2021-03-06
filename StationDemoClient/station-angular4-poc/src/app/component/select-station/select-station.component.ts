import { Component, OnInit } from '@angular/core';

import { ActivatedRoute, Router } from "@angular/router";

import { TrafficStationBean } from '../../bean/trafficstationbean';

import { TrafficstationService } from '../../service/trafficstation.service';
import { Params } from '@angular/router/src/shared';
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

  ngOnInit() {

      // Get the parameter for stationId
      let stationId = 0;
      this.parentRoute.params.subscribe(params => {   
         stationId = params['stationId'];
      });

      // Call the select station id.
      this.trafficstationService.selectStationById(stationId).subscribe(
        (trafficParam: TrafficStationBean) => {
          this.trafficStationBean = trafficParam;
          this.isDataAvailable = true;
       },
       (error : HttpErrorResponse) => {
        if (error.status === 404){
          this.router.navigate(['/error/404',{}]);                         
        }
      }
      );
   
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
  callDeleteStation(event){
    let paramsDelete = { stationName: this.trafficStationBean.station };
   //let paramsDelete = "{}";
   
    if (confirm(this.trafficstationService.translateMessage("STATION_DELETE_SUCCESS_CONFIRM", paramsDelete))) {
 
           // Method to create a station
        this.trafficstationService.deleteStation(this.trafficStationBean.id).subscribe(
          (result: any) => {
               window.alert(this.trafficstationService.translateMessage('STATION_DELETE_SUCCESS' , {}));
               this.router.navigate(['/stationdemo/searchstations',{}]);               
          },
          (error : HttpErrorResponse) => {
          }
        );
    
    }

  }

}
