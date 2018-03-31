import { Component } from '@angular/core';

import { OAuthService, JwksValidationHandler } from 'angular-oauth2-oidc';
import { Router } from "@angular/router";
import { JwtHelperService } from '@auth0/angular-jwt';
import { TranslateService } from '@ngx-translate/core';



@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'app';

  jwtHelper = new JwtHelperService();

  constructor(private oauthService: OAuthService, private router : Router, private translateService : TranslateService) {
    this.oauthService.clientId = '0oaeg3yghaL9mQalz0h7';
    this.oauthService.scope = 'openid profile email';
  //  this.oauthService.setStorage(sessionStorage);
    this.oauthService.issuer = 'https://dev-884254.oktapreview.com/oauth2/default';
    this.oauthService.redirectUri = window.location.origin +  window.location.pathname;
    //this.oauthService.redirectUri = window.location.origin +  "/station-angular4-poc",
    this.oauthService.oidc= true,
    this.oauthService.tokenValidationHandler = new JwksValidationHandler();


    // Load Discovery Document and then try to login the user
    this.oauthService.loadDiscoveryDocument().then((doc) => {
      this.oauthService.tryLogin().then(_ => {

        const decodedToken = this.jwtHelper.decodeToken(this.oauthService.getAccessToken());  
        
        if (decodedToken['groups'] != null){
            let groups : string[]  =  decodedToken['groups'];
            if (groups.length > 0){
              sessionStorage.setItem('Role', groups[0]);
            }
        }

        // Set the lang of the user
        const locale =  decodedToken['locale'];

        if (locale != null){
          // On doit utiliser une classe Locale mais pour le POC, je fais simple.
          let substr = locale.substring(0,2);
          this.translateService.use(substr);
        }
        
        
        this.router.navigate(['/stationdemo/searchstations']);
    })
    });
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
    let value = this.oauthService.authorizationHeader;

    const claims = this.oauthService.getIdentityClaims();
    if (!claims) {
      return null;
    }
    return claims['name'];
  }

  }
  
