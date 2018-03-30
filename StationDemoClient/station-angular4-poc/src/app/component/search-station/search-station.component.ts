import { Component, OnInit, ViewChild } from '@angular/core';

import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from "@angular/router";


import { CriteriaSearchStation } from '../../bean/criteriasearchstation';
import { TrafficStationBean } from '../../bean/trafficstationbean';


import { TrafficstationService } from '../../service/trafficstation.service';

import {StringMapEntry} from '../../bean/stringmapentry';
import { StationWithPagDataSource } from '../../datasource/stationwithpagdatasource';
import { tap } from 'rxjs/operators/tap';
import { MatPaginator, MatSort } from '@angular/material';
import { OrderBean } from '../../bean/orderbean';

import {merge} from "rxjs/observable/merge";

import { OAuthService } from 'angular-oauth2-oidc';
import { UserService } from '../../service/user.service';
import { UserBean } from '../../bean/user';



@Component({
  selector: 'app-search-station',
  templateUrl: './search-station.component.html',
  styleUrls: ['./search-station.component.css'],
  providers: [TrafficstationService, UserService]
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

  roleStore: string = '';

  @ViewChild(MatPaginator) paginator: MatPaginator;

  @ViewChild(MatSort) sort: MatSort;
    

  constructor(private fb: FormBuilder, private trafficstationService: TrafficstationService, private userService : UserService, private router: Router, private oauthService: OAuthService) { 

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
    criteriaSearchStation.numberMaxElements = this.NUMBER_MAX_ELEMENTS_TAB;
    this.criteriaSearch = criteriaSearchStation;
    this.dataSource.findStations(criteriaSearchStation);

    // Count the number of stations of the pagination
    this.countStationsByCrit(criteriaSearchStation);

  }

  ngAfterViewInit() {
    if (this.givenName != null) {
      // reset the paginator after sorting
      this.sort.sortChange.subscribe(() => this.paginator.pageIndex = 0);
      
      merge(this.sort.sortChange, this.paginator.page)
          .pipe(
              tap(() => this.loadStationsPage())
          )
          .subscribe();
    }

    // Role store
    this.roleStore = localStorage.getItem('roleStore');
    const claims = this.oauthService.getIdentityClaims();
    if (claims && claims['name'] != null) {
        this.userService.retrieveRole(claims['email']).subscribe(
          (userBean : UserBean) => {
             this.roleStore = userBean.role;
             localStorage.setItem('roleStore', this.roleStore);
          }
        );

    } 
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
            this.paginator.pageIndex = 0;
            let criteriaSearchStation : CriteriaSearchStation = new CriteriaSearchStation(form.reseau, form.station , form.trafficMin,
              form.trafficMax , form.ville , 1 , this.NUMBER_MAX_ELEMENTS_TAB);

             // Ajout critere recherche
             criteriaSearchStation.orders.length = 0;
             criteriaSearchStation.orders.push(new OrderBean(this.sort.active , this.sort.direction));

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
     
     this.criteriaSearch.orders.length = 0;
     this.criteriaSearch.orders.push(new OrderBean(this.sort.active , this.sort.direction));
     
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
  

  async login() {
    await this.oauthService.initImplicitFlow();
  }

  logout() {
    this.oauthService.logOut();
  }


  get givenName() {
    let value = this.oauthService.authorizationHeader;

    const claims = this.oauthService.getIdentityClaims();
    if (!claims) {
      return null;
    }
    return claims['name'];
  }

}

