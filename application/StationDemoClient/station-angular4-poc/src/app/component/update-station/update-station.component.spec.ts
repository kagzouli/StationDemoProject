import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { UpdateStationComponent } from './update-station.component';

describe('UpdateStationComponent', () => {
  let component: UpdateStationComponent;
  let fixture: ComponentFixture<UpdateStationComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ UpdateStationComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UpdateStationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
