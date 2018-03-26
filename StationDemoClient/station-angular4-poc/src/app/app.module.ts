import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import {MatTableModule, MatPaginatorModule, MatProgressSpinnerModule, MatSortModule} from '@angular/material';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';


import { AppComponent } from './app.component';
import { StationAuthComponent } from './component/station-auth/station-auth.component';

import { AppRoutingModule, routingComponents } from './app.routing';
import { SearchStationComponent } from './component/search-station/search-station.component';
import { CreateStationComponent } from './component/create-station/create-station.component';
import { SelectStationComponent } from './component/select-station/select-station.component';
import { UpdateStationComponent } from './component/update-station/update-station.component';

import { AuthGuard } from './shared/auth/auth.guard.service';



import { OAuthModule } from 'angular-oauth2-oidc';



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
    MatPaginatorModule,
    AppRoutingModule,
    MatSortModule,
    MatProgressSpinnerModule,
    BrowserAnimationsModule,
    OAuthModule.forRoot()
  ],
  providers: [AuthGuard],
  bootstrap: [AppComponent],
})
export class AppModule { }
