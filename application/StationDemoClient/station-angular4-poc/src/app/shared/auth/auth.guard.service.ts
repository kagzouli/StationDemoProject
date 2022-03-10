
import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, CanActivate, Router, RouterStateSnapshot } from '@angular/router';
import { OAuthService } from 'angular-oauth2-oidc';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private oauthService: OAuthService, private router: Router) {}
  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean {
    if (this.oauthService.hasValidIdToken()) {

      // Get the roles authorized for this route
      const componentRoles = route.data["roles"] as Array<string>;

      const userRoles = sessionStorage.getItem('Role');

      const authorized : boolean = this.isUserRoleAuthorized(componentRoles, userRoles);

      if (!authorized){
        this.router.navigate(['/error/403']);
      }

      return authorized;
    }
    return false;
  }

  public isUserRoleAuthorized(componentRoles, userRoles) : boolean{
    
    let roleOk = false;
    if (userRoles != null){
      if (componentRoles == null){
        roleOk = true;
      }else if (typeof componentRoles === 'string'){
          roleOk = userRoles === componentRoles;
      }else if (Array.isArray(componentRoles)){
          roleOk = componentRoles.filter(componentRole => componentRole === userRoles).length > 0;
      }
    }

    return roleOk;
  }

}