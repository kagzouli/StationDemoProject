import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-error',
  templateUrl: './error.component.html',
  styleUrls: ['./error.component.css'],
  standalone: false
})
export class ErrorComponent implements OnInit {

  subscriptionRoute : Subscription;

  code : number;
  msg  : string;

  constructor(private readonly parentRoute: ActivatedRoute )
  { 

    // Get the error code message
    this.subscriptionRoute = this.parentRoute.params.subscribe(params => {
      this.code = Number(params['code']);
    });

    // Fill the message msg
    if (this.code === 400){
       this.msg = "BAD REQUEST";
    }else if (this.code === 401) {
        this.msg = "UNAUTHORIZED";
    } else if (this.code === 403) {
        this.msg = "FORBIDDEN";
    } else if (this.code === 404) {
        this.msg = "NOT FOUND";
    } else if (this.code === 500) {
      this.msg = "SERVER INTERNAL ERROR";
    }else{
      this.msg = "UNKNOWN";
    }
  }

  ngOnInit() {
  }

  ngOnDestroy() {
    this.subscriptionRoute.unsubscribe();
  }

}
