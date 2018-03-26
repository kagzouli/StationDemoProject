import { Component } from '@angular/core';

import { OAuthService, JwksValidationHandler } from 'angular-oauth2-oidc';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'app';

  constructor(private oauthService: OAuthService) {
    this.oauthService.clientId = '0oaeg3yghaL9mQalz0h7';
    this.oauthService.scope = 'openid profile email';
    this.oauthService.setStorage(sessionStorage);
    this.oauthService.issuer = 'https://dev-884254.oktapreview.com';
    this.oauthService.redirectUri = window.location.origin + '/index.html',
    this.oauthService.oidc= true,
    this.oauthService.tokenValidationHandler = new JwksValidationHandler();
    // Load Discovery Document and then try to login the user
    this.oauthService.loadDiscoveryDocument().then((doc) => {
      this.oauthService.tryLogin();
      console.debug('discovery succeeded', doc);
    });
   }
  }
  
