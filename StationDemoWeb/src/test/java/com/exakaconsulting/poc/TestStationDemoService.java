package com.exakaconsulting.poc;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.support.AnnotationConfigContextLoader;
import org.springframework.transaction.annotation.Transactional;

import com.exakaconsulting.poc.service.CriteriaSearchTrafficStation;
import com.exakaconsulting.poc.service.IStationDemoService;
import com.exakaconsulting.poc.service.TrafficStationBean;

import static org.junit.Assert.*;


@RunWith(SpringRunner.class)
@ContextConfiguration(loader=AnnotationConfigContextLoader.class,classes=ApplicationTest.class)
@Transactional
public class TestStationDemoService {
	
	@Autowired
	private IStationDemoService stationDemoService;

	
	@Test
	public void testSelectElements(){
		
		TrafficStationBean trafficStation = new TrafficStationBean();
		trafficStation.setReseau("metro");
		trafficStation.setStation("station");
		trafficStation.setTraffic(12929191L);
		trafficStation.setVille("Saint Remy Les chevreuses");
		
		CriteriaSearchTrafficStation emptyCriteria = new CriteriaSearchTrafficStation();


		List<TrafficStationBean> listStations = stationDemoService.searchStations(emptyCriteria);
		assertTrue(listStations.size() == 369);

		
		int value = stationDemoService.insertTrafficStation(trafficStation);
		assertTrue(value > 0);
		
		
		listStations = stationDemoService.searchStations(emptyCriteria);
		assertTrue(listStations.size() == 370);
	}
	
	@Test
	public void testSelectReseauStation(){
		// Test Metro
		final String METRO = "Metro";
		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setReseau(METRO);
		List<TrafficStationBean> listStations = stationDemoService.searchStations(criteria);
		assertTrue(listStations.size() == 303);

		final String RER = "RER";
		criteria.setReseau(RER);
		listStations = stationDemoService.searchStations(criteria);
		assertTrue(listStations.size() == 66);
		
	}
	
	@Test
	public void testSelectStationName(){
		
		final String STATION = "PORTE DE CHOI";
		
		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setStation(STATION);
		
		List<TrafficStationBean> listStations = stationDemoService.searchStations(criteria);
		assertTrue(listStations.size() == 1);
	}
}
