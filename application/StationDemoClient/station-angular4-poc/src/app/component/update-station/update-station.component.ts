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

  }

  async ngOnInit() {

    // Get the selected traffic station
    let stationId = 0;
    this.parentRoute.params.subscribe(params => {   
      stationId = params['stationId'];
    });

    try {
      const trafficParam: TrafficStationBean = await this.trafficstationService.selectStationById(stationId);

      this.trafficStationBeanUpdate = trafficParam;
      this.isDataAvailable = true;

      // Initialise the form
      this.rForm = this.fb.group({
        'traffic': [this.trafficStationBeanUpdate.traffic, Validators.compose([Validators.required])],
        'correspondance': [this.trafficStationBeanUpdate.listCorrespondance, Validators.maxLength(150)]
      });

    } catch (error: any) {
      console.error('Error fetching station:', error);
      // Optionally handle HTTP errors
      // e.g., if (error.status === 404) { this.router.navigate(['/error/404']); }
    }
  
  }

  disableButton(invalidform : boolean){
    return this.isDataAvailable ?  (invalidform || this.launchAction) : false; 
  }

  async updateStation(form: any) {
    if (!this.rForm.valid) {
      // Invalid form: reset
      this.rForm.reset();
      return;
    } 

    this.launchAction = true;

    try {
      await this.trafficstationService.updateStation(
        form.traffic,
        form.correspondance,
        this.trafficStationBeanUpdate.id
      );

      window.alert(this.trafficstationService.translateMessage("STATION_UPDATE_SUCESSS", {}));
      this.router.navigate(['/stationdemo/searchstations', {}]);

    } catch (error: any) {
      console.error('Error updating station:', error);
      // Optionally handle specific HTTP errors here
    } finally {
      this.launchAction = false;
    }
  }
}
