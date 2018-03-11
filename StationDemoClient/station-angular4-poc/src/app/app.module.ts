import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { CookieService } from 'ngx-cookie-service';
import {MatTableModule} from '@angular/material';


import { AppComponent } from './app.component';
import { StationAuthComponent } from './component/station-auth/station-auth.component';

import { AppRoutingModule, routingComponents } from './app.routing';


@NgModule({
  declarations: [
    AppComponent,
    StationAuthComponent
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
