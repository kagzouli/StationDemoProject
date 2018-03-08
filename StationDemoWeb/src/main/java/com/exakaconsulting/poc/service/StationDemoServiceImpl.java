package com.exakaconsulting.poc.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * 
 * @author Toto
 *
 */
@Service
public class StationDemoServiceImpl implements IStationDemoService{
	
	 private static final Logger LOGGER = LoggerFactory.getLogger(StationDemoServiceImpl.class);

	@Override
	public void searchStation() {
		LOGGER.info("Start searchStation");
		
	}

}
