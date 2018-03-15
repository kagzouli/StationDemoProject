import { Component, OnInit } from '@angular/core';

import { ActivatedRoute, Router } from "@angular/router";

import { TrafficStationBean } from '../../bean/trafficstationbean';

import { TrafficstationService } from '../../service/trafficstation.service';
import { Params } from '@angular/router/src/shared';
import { DeleteStationResponse } from '../../bean/deletestationresponse';

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

      // Get the selected traffic station
      this.parentRoute.params.subscribe(params => {   
        this.trafficstationService.selectStationById(params['stationId'](
          (trafficParam: TrafficStationBean) => {
            this.trafficStationBean = trafficParam;
            this.isDataAvailable = true;
         }));
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
    if (confirm("Are you sure to delete  the station '" + this.trafficStationBean.station + "'?")) {
 
           // Method to create a station
        this.trafficstationService.deleteStation(this.trafficStationBean.id).subscribe(
          (jsonResult: DeleteStationResponse) => {
            const success = jsonResult.success;
            if (success) {
               window.alert('The station has been delete with success');
               this.router.navigate(['/stationdemo/searchstations',{}]);               
             }else {
               let messageError = jsonResult.errors[0];
               window.alert('Error --> ' + messageError);
            }  
        }
        );
    
    }

  }

}
