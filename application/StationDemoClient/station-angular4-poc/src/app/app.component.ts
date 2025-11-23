import { Component } from '@angular/core';

import { AuthService } from '@auth0/auth0-angular';
import { Router } from "@angular/router";
import { JwtHelperService } from '@auth0/angular-jwt';
import { TranslateService } from '@ngx-translate/core';
import { Observable } from 'rxjs';

import { ConfigurationLoaderService } from './service/configuration-loader.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'app';

  isAuthenticated$: Observable<boolean> = this.authService.isAuthenticated$;
  user$ = this.authService.user$;

  jwtHelper = new JwtHelperService();

  constructor(private authService: AuthService, private router : Router, private translateService : TranslateService, private readonly configurationLoaderService : ConfigurationLoaderService) {
      
    this.authService.getAccessTokenSilently().subscribe({
      next: (token) => {
          const decodedToken = this.jwtHelper.decodeToken(token);  
        
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
      },
      error: (err) => console.error('Error getting access token', err)
    });


    }



  //NgOnInit
  async ngOnInit() {
  }
  


   /**
    * Login to the application 
    *
    */
   login() {
      this.authService.loginWithRedirect();
   }


}
  
