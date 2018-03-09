package com.exakaconsulting.poc;

import org.springframework.beans.factory.annotation.Autowired;

import com.exakaconsulting.poc.service.IStationDemoService;

public class TestStationDemoService {
	
	@Autowired
	private IStationDemoService stationDemoService;

	
	
	public void testSelectElements(){
		stationDemoService.searchStations();
	}
}
