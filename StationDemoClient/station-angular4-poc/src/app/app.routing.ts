import { NgModule } from '@angular/core';
import { Routes, RouterModule , RouterLink } from '@angular/router';

import { StationAuthComponent } from './component/station-auth/station-auth.component';
import { SearchStationComponent } from './component/search-station/search-station.component';



const routes: Routes = [
    { path: '',redirectTo: '/stationdemo/home',  pathMatch: 'full' },
    { path: 'stationdemo/home', component: StationAuthComponent },
    { path: 'stationdemo/searchstations', component: SearchStationComponent }
    
  ];
  
  @NgModule({
    imports: [RouterModule.forRoot(routes)],
    exports: [RouterModule],
  })
  export class AppRoutingModule { }
 
  export const routingComponents = [];