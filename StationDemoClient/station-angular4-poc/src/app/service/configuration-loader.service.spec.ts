import { TestBed, inject } from '@angular/core/testing';

import { ConfigurationLoaderService } from './configuration-loader.service';

describe('ConfigurationLoaderService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [ConfigurationLoaderService]
    });
  });

  it('should be created', inject([ConfigurationLoaderService], (service: ConfigurationLoaderService) => {
    expect(service).toBeTruthy();
  }));
});
