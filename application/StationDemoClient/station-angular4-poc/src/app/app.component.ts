import { Component } from '@angular/core';

import { OAuthService, AuthConfig } from 'angular-oauth2-oidc';
import { Router } from "@angular/router";
import { JwtHelperService } from '@auth0/angular-jwt';
import { TranslateService } from '@ngx-translate/core';

import { ConfigurationLoaderService } from './service/configuration-loader.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'app';

  jwtHelper = new JwtHelperService();

  constructor(private oauthService: OAuthService, private router : Router, private translateService : TranslateService, private readonly configurationLoaderService : ConfigurationLoaderService) {
    this.configurationLoaderService.loadConfigurations().subscribe(configuration =>
    {
      
      this.oauthService.configure({
        clientId: configuration.clientIdTrafStat,
        scope: 'openid profile email',
        issuer: `${configuration.oktaUrl}/oauth2/default`,
        redirectUri: window.location.origin + window.location.pathname, 
        oidc: true,
        responseType: 'code',   // Authorization Code Flow with PKCE
        showDebugInformation: true, // optional, for debugging
        strictDiscoveryDocumentValidation: false, // optional, depends on Okta setup
        disablePKCE: false
      });

 
      // Load Discovery Document and then try to login the user
      this.oauthService.loadDiscoveryDocument().then((doc) => {
        this.oauthService.tryLogin().then(_ => {

          const decodedToken = this.jwtHelper.decodeToken(this.oauthService.getAccessToken());  
        
          if (decodedToken != null){
            let groups : string[]  =  decodedToken['groups'];
            if (groups != null && groups.length > 0){
              sessionStorage.setItem('Role', groups[0]);
          }

          // Set the lang of the user
          const locale =  decodedToken['locale'];
          if (locale != null && locale.length >= 2){
            // On doit utiliser une classe Locale mais pour le POC, je fais simple.
            let substr = locale.substring(0,2);
            this.translateService.use(substr);
          }
        }
        this.router.navigate([this.router.url]);
      })
    });

    });
 }

 ngOnInit() {
}


   /**
    * Login to the application 
    *
    */
   login() {
      this.oauthService.initImplicitFlow();
   }


  /**
   * Get the given name
   * 
   */
  get givenName() {
    const claims = this.oauthService.getIdentityClaims();
    if (!claims) {
      return null;
    }
    return claims['name'];
  }

  }
  
