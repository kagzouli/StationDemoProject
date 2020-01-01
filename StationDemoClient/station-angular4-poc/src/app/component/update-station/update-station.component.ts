import { Component, OnInit } from '@angular/core';

import { TrafficstationService } from '../../service/trafficstation.service';
import { TrafficStationBean } from '../../bean/trafficstationbean';
import { ActivatedRoute, Router } from "@angular/router";
import { HttpErrorResponse } from '@angular/common/http';


import { FormBuilder, FormGroup, Validators } from '@angular/forms';


@Component({
  selector: 'app-update-station',
  templateUrl: './update-station.component.html',
  styleUrls: ['./update-station.component.css'],
  providers: [TrafficstationService]
})
export class UpdateStationComponent implements OnInit {

  rForm: FormGroup;

   /** Traffic station bean */
  trafficStationBeanUpdate : TrafficStationBean;
   
  isDataAvailable : boolean;

  launchAction : boolean = false;

  constructor(private fb: FormBuilder , private parentRoute: ActivatedRoute, private trafficstationService: TrafficstationService, private router: Router) { 

     // Get the selected traffic station
     let stationId = 0;
     
     // Get the station id from parameter
     this.parentRoute.params.subscribe(params => {   
        stationId = params['stationId'];
     });

    
     // Call the select station id.
     this.trafficstationService.selectStationById(stationId).subscribe(
       (trafficParam: TrafficStationBean) => {
          this.trafficStationBeanUpdate = trafficParam;
          this.isDataAvailable = true;

         // Initialise the form
         this.rForm = fb.group({
          'traffic' : [this.trafficStationBeanUpdate.traffic, Validators.compose([Validators.required])],
          'correspondance' : [this.trafficStationBeanUpdate.listCorrespondance,  Validators.maxLength(150)]
          });
     });
  
  }

  ngOnInit() {

   

  }

  disableButton(invalidform : boolean){
    return this.isDataAvailable ?  (invalidform || this.launchAction) : false; 
  }

  updateStation(form){
     // Call the service crediting bank
     if (this.rForm.valid) {
      //Before the credit disable the button.
      
        // Method of callback to credit account number
        this.launchAction = true;

          // Method to create a station
          this.trafficstationService.updateStation(form.traffic, form.correspondance,this.trafficStationBeanUpdate.id).subscribe(
            (result: any) => {
                 window.alert(this.trafficstationService.translateMessage("STATION_UPDATE_SUCESSS", {}));
                 this.router.navigate(['/stationdemo/searchstations',{}]);  
                 this.launchAction = false;            
            },
            (error : HttpErrorResponse) => {
              this.launchAction = false;
            }  
          );
        }else {
        // Invalid data on form - we reset.
        this.rForm.reset();
    }
  }

}
