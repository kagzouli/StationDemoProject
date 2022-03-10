import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HeaderStationComponent } from './header-station.component';

describe('HeaderStationComponent', () => {
  let component: HeaderStationComponent;
  let fixture: ComponentFixture<HeaderStationComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HeaderStationComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HeaderStationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
