package com.exakaconsulting.poc;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.support.AnnotationConfigContextLoader;
import org.springframework.transaction.annotation.Transactional;

import com.exakaconsulting.poc.service.IStationDemoService;
import com.exakaconsulting.poc.service.TrafficStationBean;

@RunWith(SpringRunner.class)
@ContextConfiguration(loader=AnnotationConfigContextLoader.class,classes=ApplicationTest.class)
@Transactional
public class TestStationDemoService {
	
	@Autowired
	private IStationDemoService stationDemoService;

	
	@Test
	public void testSelectElements(){
		List<TrafficStationBean> listStations = stationDemoService.searchStations();
		
		System.out.println("Numbers : "+ listStations);
	}
}
