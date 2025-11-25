import { Component, OnInit } from '@angular/core';
import { AuthService } from '@auth0/auth0-angular';
import { Router } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';
import { Observable, of } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { ConfigurationLoaderService } from './service/configuration-loader.service';
import { JwtHelperService } from '@auth0/angular-jwt';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'app';

  isAuthenticated$: Observable<boolean> = this.authService.isAuthenticated$;
  user$ = this.authService.user$;
  roles: string[] = [];

  jwtHelper = new JwtHelperService();

  constructor(
    private authService: AuthService,
    private router: Router,
    private translateService: TranslateService,
    private readonly configurationLoaderService: ConfigurationLoaderService
  ) {}

  ngOnInit(): void {
    // Set language
    this.translateService.use('fr');

    // Subscribe to ID token claims to get roles
    this.authService.isAuthenticated$
      .pipe(
        switchMap(isAuth => {
          if (!isAuth) return of(null); // user not authenticated
          return this.authService.idTokenClaims$;
        })
      )
      .subscribe(claims => {
        if (claims) {
          this.roles = claims['roles'] || [];
          const role = this.roles[0] || '';
          sessionStorage.setItem('Role', role);
          console.log('User roles:', this.roles);
        }
      });

    // Optional: fetch access token (JWT) correctly
    this.authService.isAuthenticated$
      .pipe(
        switchMap(isAuth => {
          if (!isAuth) return of(null);
          return this.authService.getAccessTokenSilently();
        })
      )
      .subscribe({
        next: token => {
          if (token) {
            // If you really need to decode:
            const decodedToken = this.jwtHelper.decodeToken(token);
            console.log("decoded Token : " + decodedToken);
          }
        },
        error: err => console.error('Error getting access token:', err)
      });
  }

  /** Login to the application */
  login(): void {
    this.authService.loginWithRedirect();
  }
}
