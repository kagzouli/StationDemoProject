import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Error403ComponentComponent } from './error403-component.component';

describe('Error403ComponentComponent', () => {
  let component: Error403ComponentComponent;
  let fixture: ComponentFixture<Error403ComponentComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Error403ComponentComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Error403ComponentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
