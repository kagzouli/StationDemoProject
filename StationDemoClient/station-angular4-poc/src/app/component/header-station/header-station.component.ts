
import { Component, OnInit } from '@angular/core';
import { OAuthService } from 'angular-oauth2-oidc';
import { UserBean } from '../../bean/user';
import { TranslateService } from '@ngx-translate/core';
import { Router } from "@angular/router";

@Component({
  selector: 'app-header-station',
  templateUrl: './header-station.component.html',
  styleUrls: ['./header-station.component.css'],
  providers: []
})
export class HeaderStationComponent implements OnInit {

  roleStore: string = '';  

  paramsHelloMessage = {name: this.givenName};
  
  paramsRoleMessage = {roleStore: this.roleStore};
  

  constructor(private oauthService: OAuthService,private router : Router, private translateService : TranslateService) {
      this.roleStore = sessionStorage.getItem('Role');
      this.paramsRoleMessage = {roleStore: this.roleStore};
  } 


  ngOnInit() {
  }

  switchLanguage(lang : string){
    this.translateService.use(lang);
  }

  get givenName() {
    const claims = this.oauthService.getIdentityClaims();
    if (!claims) {
      return null;
    }

    

    return claims['name'];
  }

 /**
   * Logout to the application
   */
  logout() {
      this.oauthService.logOut();
    }

  
  /**
   * Go to home
   * 
   */
  goHome(){
    this.router.navigate(['/stationdemo/searchstations',{}]);  
  }

}
