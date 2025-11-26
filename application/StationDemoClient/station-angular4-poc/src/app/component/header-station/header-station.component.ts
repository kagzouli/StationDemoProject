
import { Component, OnInit } from '@angular/core';
import { UserBean } from '../../bean/user';
import { TranslateService } from '@ngx-translate/core';
import { Router } from "@angular/router";
import { AuthService , User  } from '@auth0/auth0-angular';

@Component({
  selector: 'app-header-station',
  templateUrl: './header-station.component.html',
  styleUrls: ['./header-station.component.css'],
  providers: []
})
export class HeaderStationComponent implements OnInit {

  roleStore: string = '';  

  paramsHelloMessage = {name: ""};
  
  paramsRoleMessage = {roleStore: this.roleStore};
  

  constructor(private authService: AuthService,private router : Router, private translateService : TranslateService) {
      this.roleStore = sessionStorage.getItem('Role');
      this.paramsRoleMessage = {roleStore: this.roleStore};
  } 


  ngOnInit() {

    // Subscribe to the user observable
    this.authService.user$.subscribe((user: User | null | undefined) => {
      if (user) {
        this.paramsHelloMessage = {name: user.nickname};
      }
    });
  }

  switchLanguage(lang : string){
    this.translateService.use(lang);
  }

 /**
   * Logout to the application
   */
  logout() {
      this.authService.logout();
  }

  
  /**
   * Go to home
   * 
   */
  goHome(){
    this.router.navigate(['/stationdemo/searchstations',{}]);  
  }

}
