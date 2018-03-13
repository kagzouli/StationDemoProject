import { Component, OnInit } from '@angular/core';

import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from "@angular/router";


import { CriteriaSearchStation } from '../../bean/criteriasearchstation';
import { TrafficStationBean } from '../../bean/trafficstationbean';


import { TrafficstationService } from '../../service/trafficstation.service';

import { StationWithoutPagDataSource } from '../../datasource/stationwithoutpagdatasource';

import {StringMapEntry} from '../../bean/stringmapentry';



@Component({
  selector: 'app-search-station',
  templateUrl: './search-station.component.html',
  styleUrls: ['./search-station.component.css'],
  providers: [TrafficstationService]
})
export class SearchStationComponent implements OnInit {

  displayedColumns = ['station', 'reseau', 'traffic', 'listCorrespondance', 'ville', 'arrond'];
  

  rForm: FormGroup;

  launchAction : boolean = false;

  dataSource = new StationWithoutPagDataSource();

  numberElementsFound: number = 0;

  mapReseaux: StringMapEntry[] = [ new StringMapEntry('Metro' , 'Metro') , new StringMapEntry('RER' , 'RER')];

  reseauChoose: string = '';
    

  constructor(private fb: FormBuilder, private trafficstationService: TrafficstationService, private router: Router) { 

    this.rForm = fb.group({
      'reseau' : [null, Validators.compose([Validators.maxLength(64)])],
      'station' : [null, ],
      'trafficMin' : [null, ],
      'trafficMax' : [null,  ],
      'ville' : [null, ],
    });

  }

  ngOnInit() {

  }

  disableButton(invalidform : boolean){
    return invalidform || this.launchAction; 
  }

  /** Method to create a station */
  createStation(event) {
     this.router.navigate(['/stationdemo/createstation',{}]);
  }

  searchTrafficStations(form ){
    
    
    if (this.rForm.valid) {
      this.launchAction = true;
           // Create the criteria
           let criteriaSearchStation : CriteriaSearchStation = new CriteriaSearchStation();
           criteriaSearchStation.reseau = form.reseau;
           criteriaSearchStation.station = form.station;
           criteriaSearchStation.trafficMin = form.trafficMin;
           criteriaSearchStation.trafficMax = form.trafficMax;
           criteriaSearchStation.ville = form.ville;
           // A changer et parametrer
           criteriaSearchStation.page = 1;
           criteriaSearchStation.numberMaxElements = 15;
           
           // Launch the search
           if (this.rForm.valid) {
             this.launchAction = true;
             this.trafficstationService.findTrafficStations(criteriaSearchStation,
             (listTrafficStation: TrafficStationBean[]) => {
             this.dataSource.updateValue(listTrafficStation);
             this.numberElementsFound = listTrafficStation.length;
             this.launchAction = false;
          }
        );

        }else {
           window.alert('There is a mistake in your input.');
           // Invalid data on form - we reset.
           this.rForm.reset();
           this.launchAction = false;
         }
       }
   
   }
  

   selectStation(id){
       this.router.navigate(['/stationdemo/selectstation' , id]);
   }
  

   
}
