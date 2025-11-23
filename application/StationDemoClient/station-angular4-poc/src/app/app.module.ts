import { BrowserModule } from '@angular/platform-browser';
import { NgModule,APP_INITIALIZER  } from '@angular/core';

import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule, HttpClient } from '@angular/common/http';

// Angular material
import { MatTableModule } from '@angular/material/table';
import { MatPaginatorModule } from '@angular/material/paginator';
import { MatSortModule } from '@angular/material/sort';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';


import { AppComponent } from './app.component';

import { AppRoutingModule, routingComponents } from './app.routing';
import { SearchStationComponent } from './component/search-station/search-station.component';
import { CreateStationComponent } from './component/create-station/create-station.component';
import { SelectStationComponent } from './component/select-station/select-station.component';
import { UpdateStationComponent } from './component/update-station/update-station.component';

import { OAuthModule } from 'angular-oauth2-oidc';
import { AuthModule } from '@auth0/auth0-angular';
import {TranslateModule, TranslateLoader} from '@ngx-translate/core';
import {TranslateHttpLoader} from '@ngx-translate/http-loader';
import { HeaderStationComponent } from './component/header-station/header-station.component';
import { ConfigurationLoaderService } from './service/configuration-loader.service';
import { ErrorComponent } from './component/error/error.component';

// AoT requires an exported function for factories
export function createTranslateLoader(http: HttpClient) {
  return new TranslateHttpLoader(http, './assets/i18n/', '.json');
}

export function initializeApp(configService: ConfigurationLoaderService) {
  return () => configService.loadConfigurations();
}


@NgModule({
  declarations: [
    AppComponent,
    SearchStationComponent,
    CreateStationComponent,
    SelectStationComponent,
    UpdateStationComponent,
    HeaderStationComponent,
    ErrorComponent
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
    OAuthModule.forRoot(),
    AuthModule.forRoot({
      domain: '',      // will be replaced dynamically
      clientId: '',    // will be replaced dynamically
      authorizationParams: {
        redirect_uri: window.location.origin,
        audience: ''   // dynamically replaced
      }
    }),
    TranslateModule.forRoot({
      loader: {
        provide: TranslateLoader,
        useFactory: createTranslateLoader,
        deps: [HttpClient]
      }
    })
  ],
  providers: [
    ConfigurationLoaderService,
    {
      provide: APP_INITIALIZER,
      useFactory: initializeApp,
      deps: [ConfigurationLoaderService],
      multi: true
    },
  ],
  bootstrap: [AppComponent],
})
export class AppModule {
  constructor(configService: ConfigurationLoaderService) {
    // Dynamically patch the AuthModule configuration
    const authModuleConfig = (AuthModule as any)._forRootConfig;
    if (authModuleConfig) {
      authModuleConfig.domain = configService.get('oktaUrl')
      authModuleConfig.clientId = configService.get('clientIdTrafStat');
      authModuleConfig.authorizationParams.audience = '';
    }
  }

 }
