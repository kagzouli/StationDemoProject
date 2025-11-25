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

import { AuthModule , AuthClientConfig  } from '@auth0/auth0-angular';
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

export function authConfigFactory(configService: ConfigurationLoaderService) {
  const cfg =  {
    domain: configService.get('oktaUrl'),
    clientId: configService.get('clientIdTrafStat'),
    redirectUri: window.location.origin + "/station-angular4-poc/",
    useRefreshTokens: true,   // <-- enable refresh tokens
    cacheLocation: 'localstorage', // required if using refresh tokens
    useRefreshTokensFallback: false, // optional, but recommended
    authorizationParams: {
      audience: `https://${configService.get('oktaUrl')}/api/v2/`,
      scope: "openid profile email"
    }
  };

  return {
    get: () => cfg // provide the old `.get()` API
  };

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
    AuthModule.forRoot(), // leave empty here
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
    {
      provide: AuthClientConfig,
      useFactory: authConfigFactory,
      deps: [ConfigurationLoaderService]
    }
  ],
  bootstrap: [AppComponent],
})
export class AppModule {}
