import { NgModule } from '@angular/core';
import { Routes, RouterModule , RouterLink } from '@angular/router';

import { SearchStationComponent } from './component/search-station/search-station.component';

import { CreateStationComponent } from './component/create-station/create-station.component';
import { SelectStationComponent } from './component/select-station/select-station.component';
import { UpdateStationComponent } from './component/update-station/update-station.component';

import { AuthGuard } from './shared/auth/auth.guard.service';




const routes: Routes = [
    { path: '/',redirectTo: '/stationdemo/searchstations' },
    { path: '',redirectTo: '/stationdemo/searchstations' },
    { path: 'stationdemo/searchstations', component: SearchStationComponent},
    { path: 'stationdemo/createstation', component: CreateStationComponent , canActivate: [AuthGuard]},    
    { path: 'stationdemo/selectstation/:stationId', component: SelectStationComponent , canActivate: [AuthGuard]},    
    { path: 'stationdemo/updatestation/:stationId', component: UpdateStationComponent , canActivate: [AuthGuard]}    
    
  ];

  
  
  @NgModule({
    // Je me mets en HashLocalStrategy au lieu de PathLocalStrategy car lors du F5, la page reloade est en 404.
    // Le PathLocalStrategy necessite un parametrage cote serveur , mais est plus performant mais il faut parametrer
    // Dans le cas du POC, je vais partir sur une hash strategy plus simple a mettre en place.
    imports: [RouterModule.forRoot(routes,{useHash: true , initialNavigation: false}) ],
    exports: [RouterModule],
    providers: [AuthGuard]
    
  })
  export class AppRoutingModule { }
 
  export const routingComponents = [];