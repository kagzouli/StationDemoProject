package com.exakaconsulting.poc.service;

import java.util.List;

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
	public List<TrafficStationBean> searchStation() {
		LOGGER.info("Start searchStation");
		return null;
		
	}

}
