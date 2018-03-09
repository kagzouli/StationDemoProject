package com.exakaconsulting.poc;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.support.AnnotationConfigContextLoader;
import org.springframework.transaction.annotation.Transactional;

import com.exakaconsulting.poc.service.IStationDemoService;

@RunWith(SpringRunner.class)
@ContextConfiguration(loader=AnnotationConfigContextLoader.class,classes=Application.class)
@Transactional
public class TestStationDemoService {
	
	@Autowired
	private IStationDemoService stationDemoService;

	
	@Test
	public void testSelectElements(){
		stationDemoService.searchStations();
	}
}
