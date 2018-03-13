import { Component, OnInit } from '@angular/core';

import { ActivatedRoute, Router } from "@angular/router";

import { TrafficStationBean } from '../../bean/trafficstationbean';

import { TrafficstationService } from '../../service/trafficstation.service';
import { Params } from '@angular/router/src/shared';




@Component({
  selector: 'app-select-station',
  templateUrl: './select-station.component.html',
  styleUrls: ['./select-station.component.css'],
  providers: [TrafficstationService]
})
export class SelectStationComponent implements OnInit {

  stationId: number = 0;

  /** Traffic station bean */
  trafficStationBean : TrafficStationBean;

  constructor(private parentRoute: ActivatedRoute, private trafficstationService: TrafficstationService) { 

  }

  ngOnInit() {

      // Get the selected traffic station
      this.parentRoute.params.subscribe(params => {   
        this.stationId = params['stationId']; 
      });
  
      
      this.trafficstationService.selectStationById(this.stationId,
        (trafficParam: TrafficStationBean) => {
          this.trafficStationBean = trafficParam;
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
    let identifierUser = '';
   // this.router.navigate(['/operation/creditbanqueaccountuser',{userCodeSelected: identifierUser}]);
  }

  /**
   * Method to call the delete station.<br/>
   * 
   * @param event 
   */
  callDeleteStation(event){


  }

}
