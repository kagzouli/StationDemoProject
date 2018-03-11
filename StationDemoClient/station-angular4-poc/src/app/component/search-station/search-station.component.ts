import { Component, OnInit } from '@angular/core';

import { FormBuilder, FormGroup, Validators } from '@angular/forms';


@Component({
  selector: 'app-search-station',
  templateUrl: './search-station.component.html',
  styleUrls: ['./search-station.component.css']
})
export class SearchStationComponent implements OnInit {

  displayedColumns = ['id','reseau', 'station', 'traffic', 'corresp', 'ville', 'arrond'];
  

  rForm: FormGroup;

  launchAction : boolean = false;
    

  constructor(private fb: FormBuilder) { 

    this.rForm = fb.group({
      'reseau' : [null, Validators.compose([Validators.maxLength(64)])],
      'station' : [null, ],
      'trafficMin' : [null, ],
      'trafficMax' : [null,  ],
      'ville' : [null, ],
    });

  }

  ngOnInit() {
  }

  disableButton(invalidform : boolean){
    return invalidform || this.launchAction; 
  }

}
