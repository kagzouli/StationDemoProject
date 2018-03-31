
import { Component, OnInit } from '@angular/core';
import { UserService } from '../../service/user.service';
import { OAuthService } from 'angular-oauth2-oidc';
import { UserBean } from '../../bean/user';
import { TranslateService } from '@ngx-translate/core';
import { Router } from "@angular/router";

@Component({
  selector: 'app-header-station',
  templateUrl: './header-station.component.html',
  styleUrls: ['./header-station.component.css'],
  providers: [UserService]
})
export class HeaderStationComponent implements OnInit {

  roleStore: string = '';  

  paramsHelloMessage = {name: this.givenName};
  
  paramsRoleMessage = {roleStore: this.roleStore};
  

  constructor(private userService : UserService, private oauthService: OAuthService,private router : Router, private translateService : TranslateService) {

     // Role store
     const claims = this.oauthService.getIdentityClaims();
     if (claims) {
       this.userService.retrieveRole().subscribe(
         (userBean : UserBean) => {
           this.roleStore = userBean.role;
 
           this.paramsRoleMessage = {roleStore: this.roleStore};
 
           // this language will be used as a fallback when a translation isn't found in the current language
           //translateService.setDefaultLang('en');
           this.switchLanguage('en');
 
         }
       );   
     }
  } 


  ngOnInit() {
  }

  switchLanguage(lang : string){
    this.translateService.use(lang);
  }

  get givenName() {
    let value = this.oauthService.authorizationHeader;

    const claims = this.oauthService.getIdentityClaims();
    if (!claims) {
      return null;
    }

    console.log('Test : ' + claims['sub']);
    console.log('Test2 : ' + claims['groups']);

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
