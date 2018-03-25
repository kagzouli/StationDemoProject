import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

import { ActivatedRoute, Router } from "@angular/router";
import { UserService } from '../../service/user.service';

import { AuthenticateResponse } from '../../bean/authenticateresponse';

import { OAuthService } from 'angular-oauth2-oidc';




@Component({
  selector: 'app-station-auth',
  templateUrl: './station-auth.component.html',
  styleUrls: ['./station-auth.component.css'],
  providers: []
})
export class StationAuthComponent implements OnInit {

  /** Formulaire **/
  rForm: FormGroup;
  
  post: any;

  launchAction : boolean = false;

  errors : Array<String> = [];
  
  
   /* constructor(private fb: FormBuilder , private userService: UserService , private router: Router) {
      this.rForm = fb.group({
        'login' : [null, Validators.compose([Validators.required, Validators.maxLength(150)])],
        'password' : [null, Validators.compose([Validators.required, Validators.maxLength(150)])],
      });
     }
  */

  constructor(private oauthService: OAuthService){

  }

  

  ngOnInit() {
  }


  login() {
    this.oauthService.initImplicitFlow();
  }

  logout() {
    this.oauthService.logOut();
  }


  get givenName() {
    const claims = this.oauthService.getIdentityClaims();
    if (!claims) {
      return null;
    }
    return claims['name'];
  }
}
