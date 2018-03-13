import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { CookieService } from 'ngx-cookie-service';
import {MatTableModule} from '@angular/material';


import { AppComponent } from './app.component';
import { StationAuthComponent } from './component/station-auth/station-auth.component';

import { AppRoutingModule, routingComponents } from './app.routing';
import { SearchStationComponent } from './component/search-station/search-station.component';
import { CreateStationComponent } from './component/create-station/create-station.component';
import { SelectStationComponent } from './component/select-station/select-station.component';
import { UpdateStationComponent } from './component/update-station/update-station.component';


@NgModule({
  declarations: [
    AppComponent,
    StationAuthComponent,
    SearchStationComponent,
    CreateStationComponent,
    SelectStationComponent,
    UpdateStationComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    MatTableModule,
    AppRoutingModule 

  ],
  providers: [CookieService],
  bootstrap: [AppComponent],
})
export class AppModule { }
