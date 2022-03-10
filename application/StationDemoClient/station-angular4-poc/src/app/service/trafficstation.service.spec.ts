import { TestBed, inject } from '@angular/core/testing';

import { TrafficstationService } from './trafficstation.service';

describe('TrafficstationService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [TrafficstationService]
    });
  });

  it('should be created', inject([TrafficstationService], (service: TrafficstationService) => {
    expect(service).toBeTruthy();
  }));
});
