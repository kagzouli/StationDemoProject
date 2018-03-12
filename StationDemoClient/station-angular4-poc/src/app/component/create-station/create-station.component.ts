import { Component, OnInit } from '@angular/core';

import { FormBuilder, FormGroup, Validators } from '@angular/forms';

import {StringMapEntry} from '../../bean/stringmapentry';



@Component({
  selector: 'app-create-station',
  templateUrl: './create-station.component.html',
  styleUrls: ['./create-station.component.css']
})
export class CreateStationComponent implements OnInit {

  rForm: FormGroup;
  
  launchAction : boolean = false;

  
  
  mapReseaux: StringMapEntry[] = [ new StringMapEntry('Metro' , 'Metro') , new StringMapEntry('RER' , 'RER')];
  
  reseauChoose: string = '';
  
  

  constructor(private fb: FormBuilder) { 

    this.rForm = fb.group({
      'reseau' : [null, Validators.compose([Validators.required])],
      'station' : [null, ],
      'traffic' : [null, ],
      'correspondance' : [null,  ],
      'ville' : [null, ],
      'arrondissement' : [null, ]
    });


  }

  ngOnInit() {
  }

  disableButton(invalidform : boolean){
    return invalidform || this.launchAction; 
  }

}
