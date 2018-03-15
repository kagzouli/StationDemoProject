import { NgModule } from '@angular/core';
import { Routes, RouterModule , RouterLink } from '@angular/router';

import { StationAuthComponent } from './component/station-auth/station-auth.component';
import { SearchStationComponent } from './component/search-station/search-station.component';

import { CreateStationComponent } from './component/create-station/create-station.component';
import { SelectStationComponent } from './component/select-station/select-station.component';
import { UpdateStationComponent } from './component/update-station/update-station.component';





const routes: Routes = [
    { path: '',redirectTo: '/stationdemo/home',  pathMatch: 'full' },
    { path: 'stationdemo/home', component: StationAuthComponent },
    { path: 'stationdemo/searchstations', component: SearchStationComponent},
    { path: 'stationdemo/createstation', component: CreateStationComponent },    
    { path: 'stationdemo/selectstation/:stationId', component: SelectStationComponent },    
    { path: 'stationdemo/updatestation/:stationId', component: UpdateStationComponent }    
    
  ];
  
  @NgModule({
    // Je me mets en HashLocalStrategy au lieu de PathLocalStrategy car lors du F5, la page reloade est en 404.
    // Le PathLocalStrategy necessite un parametrage cote serveur , mais est plus performant mais il faut parametrer
    // Dans le cas du POC, je vais partir sur une hash strategy plus simple a mettre en place.
    imports: [RouterModule.forRoot(routes,{useHash: true})],
    exports: [RouterModule],
  })
  export class AppRoutingModule { }
 
  export const routingComponents = [];