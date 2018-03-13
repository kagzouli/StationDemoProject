import { Component, OnInit } from '@angular/core';

import { TrafficstationService } from '../../service/trafficstation.service';
import { TrafficStationBean } from '../../bean/trafficstationbean';
import { ActivatedRoute } from "@angular/router";

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

  constructor(private fb: FormBuilder , private parentRoute: ActivatedRoute, private trafficstationService: TrafficstationService) { 

    this.rForm = fb.group({
      'reseau' : [null, Validators.compose([Validators.required])],
      'station' : [null, Validators.compose([Validators.required , Validators.maxLength(128)])],
      'traffic' : [null, Validators.compose([Validators.required])],
      'correspondance' : [null,  Validators.maxLength(150)],
      'ville' : [null, Validators.compose([Validators.required, Validators.maxLength(150)])],
      'arrondissement' : [null, ]
    });

    this.launchAction = this.rForm.valid;
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
    return invalidform || this.launchAction; 
  }

  updateStation(form){
    console.log('Update');
  }

}
