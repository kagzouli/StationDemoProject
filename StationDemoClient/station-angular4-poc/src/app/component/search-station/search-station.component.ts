import { Component, OnInit, ViewChild } from '@angular/core';

import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from "@angular/router";


import { CriteriaSearchStation } from '../../bean/criteriasearchstation';
import { TrafficStationBean } from '../../bean/trafficstationbean';


import { TrafficstationService } from '../../service/trafficstation.service';

import {StringMapEntry} from '../../bean/stringmapentry';
import { StationWithPagDataSource } from '../../datasource/stationwithpagdatasource';
import { tap } from 'rxjs/operators/tap';
import { MatPaginator } from '@angular/material';



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

  dataSource : StationWithPagDataSource;

  numberElementsFound: number = 0;

  mapReseaux: StringMapEntry[] = [ new StringMapEntry('' , ' ----------'), new StringMapEntry('Metro' , 'Metro') , new StringMapEntry('RER' , 'RER')];

  reseauChoose: string = '';

  /** Store the actual search **/
  criteriaSearch : CriteriaSearchStation;

  NUMBER_MAX_ELEMENTS_TAB = 15;

  @ViewChild(MatPaginator) paginator: MatPaginator;
    

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

    this.dataSource = new StationWithPagDataSource(this.trafficstationService);
   
    // Call the service findStations using the datasource.
    let criteriaSearchStation : CriteriaSearchStation = new CriteriaSearchStation();
    criteriaSearchStation.page = 1;
    criteriaSearchStation.numberMaxElements = 15;
    this.criteriaSearch = criteriaSearchStation;
    this.dataSource.findStations(criteriaSearchStation);

    // Count the number of stations of the pagination
    this.countStationsByCrit(criteriaSearchStation);

  }

  ngAfterViewInit() {
    this.paginator.page
        .pipe(
            tap(() => this.loadStationsPage())
        )
        .subscribe();
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
           
           
           // Launch the search
           if (this.rForm.valid) {
             // Create the criteria for the search
            let criteriaSearchStation : CriteriaSearchStation = new CriteriaSearchStation(form.reseau, form.station , form.trafficMin,
              form.trafficMax , form.ville , 1 , this.NUMBER_MAX_ELEMENTS_TAB);

             // Launch the search
             this.launchAction = true;
             this.dataSource.findStations(criteriaSearchStation);
             this.criteriaSearch = criteriaSearchStation;

             // Count the number of stations of the pagination
             this.countStationsByCrit(criteriaSearchStation);
    

             this.launchAction = false;
        }else {
           window.alert('There is a mistake in your input.');
           // Invalid data on form - we reset.
           this.rForm.reset();
           this.launchAction = false;
         }
       } 
   }

   /**
    * Load to load the stations for pagination
    */
   loadStationsPage() {
     
     // Change the criteria pageIndex and pageSize
     this.criteriaSearch.page = this.paginator.pageIndex + 1;
     this.criteriaSearch.numberMaxElements = this.paginator.pageSize;

     this.dataSource.findStations(this.criteriaSearch);
   }

   countStationsByCrit(criteria : CriteriaSearchStation){
    this.trafficstationService.countStations(criteria).subscribe(
      (countStation : number) => {
         this.numberElementsFound = countStation;
      }
    );
   }
  

   selectStation(id){
       this.router.navigate(['/stationdemo/selectstation' , id]);
   }

   onStationClicked(trafficStation){
    //TODO : Put your code here
   
  
  }
  

   
}
