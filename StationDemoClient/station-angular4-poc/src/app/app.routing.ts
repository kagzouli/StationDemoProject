import { NgModule } from '@angular/core';
import { Routes, RouterModule , RouterLink } from '@angular/router';

import { StationAuthComponent } from './component/station-auth/station-auth.component';




const routes: Routes = [
    { path: '',redirectTo: '/stationdemo/home',  pathMatch: 'full' },
    { path: 'stationdemo/home', component: StationAuthComponent }
  ];
  
  @NgModule({
    imports: [RouterModule.forRoot(routes)],
    exports: [RouterModule],
  })
  export class AppRoutingModule { }
 
  export const routingComponents = [];