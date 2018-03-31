import { Component } from '@angular/core';

import { OAuthService, JwksValidationHandler } from 'angular-oauth2-oidc';
import { Router } from "@angular/router";


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'app';

  constructor(private oauthService: OAuthService, private router : Router) {
    this.oauthService.clientId = '0oaeg3yghaL9mQalz0h7';
    this.oauthService.scope = 'openid profile email';
    this.oauthService.setStorage(sessionStorage);
    this.oauthService.issuer = 'https://dev-884254.oktapreview.com';
    this.oauthService.redirectUri = window.location.origin +  window.location.pathname;
    //this.oauthService.redirectUri = window.location.origin +  "/station-angular4-poc",
    this.oauthService.oidc= true,
    this.oauthService.tokenValidationHandler = new JwksValidationHandler();
    // Load Discovery Document and then try to login the user
    this.oauthService.loadDiscoveryDocument().then((doc) => {
      this.oauthService.tryLogin().then(_ => {
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
  
