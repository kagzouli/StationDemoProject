import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

import { ActivatedRoute, Router } from "@angular/router";
import { UserService } from '../../service/user.service';

import { AuthenticateResponse } from '../../bean/authenticateresponse';


@Component({
  selector: 'app-station-auth',
  templateUrl: './station-auth.component.html',
  styleUrls: ['./station-auth.component.css'],
  providers: [UserService]
})
export class StationAuthComponent implements OnInit {

  rForm: FormGroup;
  
    post: any;
  
    constructor(private fb: FormBuilder , private userService: UserService , private router: Router) {
      this.rForm = fb.group({
        'login' : [null, Validators.compose([Validators.required, Validators.maxLength(150)])],
        'password' : [null, Validators.compose([Validators.required, Validators.maxLength(150)])],
      });
     }
  

  ngOnInit() {
  }

  authenticate(authenticateForm){
    
        if (this.rForm.valid) {

          this.userService.authenticateUser(authenticateForm.login, authenticateForm.password,  
          
            (authenticateResponse: AuthenticateResponse) => {
              const success = authenticateResponse.success;
              if (success) {
                 this.router.navigate(['/stationdemo/searchstations',{}]);
              }else {
                 window.alert('The user has a wrong authentification.');
              }
    
            }
          ); 
        }
      }
}
