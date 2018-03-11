import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { StationAuthComponent } from './component/station-auth/station-auth.component';
import { UserComponent } from './service/user/user.component';

@NgModule({
  declarations: [
    AppComponent,
    StationAuthComponent,
    UserComponent
  ],
  imports: [
    BrowserModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
