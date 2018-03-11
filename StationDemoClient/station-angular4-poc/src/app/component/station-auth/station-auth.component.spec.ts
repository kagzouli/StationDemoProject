import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { StationAuthComponent } from './station-auth.component';

describe('StationAuthComponent', () => {
  let component: StationAuthComponent;
  let fixture: ComponentFixture<StationAuthComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ StationAuthComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(StationAuthComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
