import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import {StringMapEntry} from '../../bean/stringmapentry';
import { TrafficstationService } from '../../service/trafficstation.service';
import { TrafficStationBean } from '../../bean/trafficstationbean';
import { HttpErrorResponse } from '@angular/common/http';


import { Router } from "@angular/router";



@Component({
  selector: 'app-create-station',
  templateUrl: './create-station.component.html',
  styleUrls: ['./create-station.component.css'],
  providers: [TrafficstationService]
})
export class CreateStationComponent implements OnInit {

  rForm: FormGroup;
  
  launchAction : boolean = false;

  
  
  mapReseaux: StringMapEntry[] = [ new StringMapEntry('' , ' ----------'), new StringMapEntry('Metro' , 'Metro') , new StringMapEntry('RER' , 'RER')];
  
  reseauChoose: string = '';
  
  errors : Array<string> = [];

  displayArron : boolean = false;

  constructor(private fb: FormBuilder , private trafficstationService: TrafficstationService , private router: Router) { 

    this.rForm = fb.group({
      'reseau' : [null, Validators.compose([Validators.required])],
      'station' : [null, Validators.compose([Validators.required , Validators.maxLength(128)])],
      'traffic' : [null, Validators.compose([Validators.required])],
      'correspondance' : [null,  Validators.maxLength(150)],
      'ville' : [null, Validators.compose([Validators.required, Validators.maxLength(150)])],
      'arrondissement' : [null, ]
    });


  }

  ngOnInit() {
  }

  disableButton(invalidform : boolean){
    return invalidform || this.launchAction; 
  }

  createStation(form){

     let trafficStationBean : TrafficStationBean = new TrafficStationBean();
     trafficStationBean.reseau  = form.reseau;
     trafficStationBean.station = form.station;
     trafficStationBean.traffic = form.traffic;
     if (form.correspondance != null){
      trafficStationBean.listCorrespondance = form.correspondance.split(",");
      
     }
     trafficStationBean.ville = form.ville;
     trafficStationBean.arrondissement = form.arrondissement;

     // Call the service crediting bank
     if (this.rForm.valid) {
      //Before the credit disable the button.

        // Make the tab empty
       this.errors.length = 0;
               
      
        // Method to create a station
        this.trafficstationService.createStation(trafficStationBean).subscribe(
          (trafficStationId: number) => {
            window.alert(this.trafficstationService.translateMessage("STATION_CREATE_SUCCESS" , {}));
            this.router.navigate(['/stationdemo/searchstations',{}]); 
            this.launchAction = false;         
          },
          (error : HttpErrorResponse) => {
            if (error.status === 409){
              this.errors.push(error.error);
              this.launchAction = false;           
            }
          }
        );
      }
      else {
        // Invalid data on form - we reset.
        this.rForm.reset();
      }
  }

  /**
   * Change ville
   * 
   */
  changeVille(event){
    
    let villeUpperCase =  event.toUpperCase();
    
    // Display the arrondissement
    if (villeUpperCase == 'PARIS' || villeUpperCase == 'LYON' || villeUpperCase == 'TOULOUSE' || villeUpperCase == 'MARSEILLE'){
        this.displayArron = true
    }else{
        this.displayArron = false;
    }
   
  }

}
