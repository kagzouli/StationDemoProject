import { Component, OnInit } from '@angular/core';

import { TrafficstationService } from '../../service/trafficstation.service';
import { TrafficStationBean } from '../../bean/trafficstationbean';
import { ActivatedRoute, Router } from "@angular/router";

import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { UpdateStationResponse } from '../../bean/updatestationresponse';



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

    this.rForm = fb.group({
      'traffic' : [null, Validators.compose([Validators.required])],
      'correspondance' : [null,  Validators.maxLength(150)]
    });

  }

  ngOnInit() {

      // Get the selected traffic station
      this.parentRoute.params.subscribe(params => {   
        this.trafficstationService.selectStationById(params['stationId'],
         (trafficParam: TrafficStationBean) => {
            this.trafficStationBeanUpdate = trafficParam;
            this.isDataAvailable = true;
         }
       );         
      
     });

  }

  disableButton(invalidform : boolean){
    console.log('InvalidForm ' + invalidform);
    return this.isDataAvailable ?  (invalidform || this.launchAction) : false; 
   

  }

  updateStation(form){
     // Call the service crediting bank
     if (this.rForm.valid) {
      //Before the credit disable the button.
      
        // Method of callback to credit account number
        this.launchAction = true;
        this.trafficstationService.updateStation(form.traffic, form.correspondance,this.trafficStationBeanUpdate.id,
        (jsonResult: UpdateStationResponse) => {
            const success = jsonResult.success;
            if (success) {
               window.alert('The station has been update with success');
               this.router.navigate(['/stationdemo/searchstations',{}]);               
             }else {
               let messageError = jsonResult.errors[0];
               window.alert('Error --> ' + messageError);
            }
            this.launchAction = false;

          }
        );
        

   }else {
        // Invalid data on form - we reset.
        this.rForm.reset();
    }
  }

}
