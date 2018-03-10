package com.exakaconsulting.poc;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.support.AnnotationConfigContextLoader;
import org.springframework.transaction.annotation.Transactional;

import com.exakaconsulting.poc.service.AlreadyStationExistsException;
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
	public void testInsertOkSelectsElements(){
		
		TrafficStationBean trafficStation = new TrafficStationBean();
		trafficStation.setReseau("metro");
		trafficStation.setStation("station");
		trafficStation.setTraffic(12929191L);
		trafficStation.setVille("SAINT REMY LES CHEVREUSES");
		
		CriteriaSearchTrafficStation emptyCriteria = new CriteriaSearchTrafficStation();


		List<TrafficStationBean> listStations = stationDemoService.findStations(emptyCriteria);
		assertTrue(listStations.size() == 369);

		
		try{
			int value = this.stationDemoService.insertTrafficStation(trafficStation);
			assertTrue(value > 0);
		}catch(AlreadyStationExistsException exception){
			assertEquals(true, false);
		}
		
		listStations = this.stationDemoService.findStations(emptyCriteria);
		assertTrue(listStations.size() == 370);
	}
	
	@Test
	public void testSelectReseauStation(){
		// Test Metro
		final String METRO = "Metro";
		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setReseau(METRO);
		List<TrafficStationBean> listStations = this.stationDemoService.findStations(criteria);
		assertTrue(listStations.size() == 303);

		final String RER = "RER";
		criteria.setReseau(RER);
		listStations = this.stationDemoService.findStations(criteria);
		assertTrue(listStations.size() == 66);
		
	}
	
	@Test
	public void testSelectStationName(){
		
		final String STATION = "PORTE DE CHOI";
		
		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setStation(STATION);
		
		List<TrafficStationBean> listStations = this.stationDemoService.findStations(criteria);
		assertTrue(listStations.size() == 1);
		
		TrafficStationBean trafficStationBean = listStations.get(0);
		assertEquals(trafficStationBean.getReseau(), "Metro");
		assertEquals(trafficStationBean.getStation() , "PORTE DE CHOISY");
	}
	
	@Test
	public void testSelectMinTraffic(){
		
		final Long TRAFFICMIN = 31115220L;

		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setTrafficMin(TRAFFICMIN);
		
		List<TrafficStationBean> listStations = this.stationDemoService.findStations(criteria);
		assertTrue(listStations.size() == 6);
	}
	
	@Test
	public void testSelectMaxTraffic(){
		
		final Long TRAFFICMAX = 31115220L;

		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setTrafficMax(TRAFFICMAX);
		
		List<TrafficStationBean> listStations = this.stationDemoService.findStations(criteria);
		assertTrue(listStations.size() == 363);
	}
	
	@Test
	public void testSelectVilleTraffic(){
		
		final String VILLE = "PAR";

		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setVille(VILLE);
		
		List<TrafficStationBean> listStations = this.stationDemoService.findStations(criteria);
		assertTrue(listStations.size() == 255);
	}

	@Test
	public void testSelectArrondTraffic(){
		
		final Integer ARRONDISS = 15;

		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setArrondiss(ARRONDISS);
		
		List<TrafficStationBean> listStations = this.stationDemoService.findStations(criteria);
		assertTrue(listStations.size() == 19);
	}
	
	@Test
	public void insertStationAlreadyExists(){
		
		TrafficStationBean trafficStation = new TrafficStationBean();
		trafficStation.setReseau("metro");
		trafficStation.setStation("GONCOURT");
		trafficStation.setTraffic(12929191L);
		trafficStation.setVille("Paris");
		trafficStation.setArrondissement(13);
			
		try{
			this.stationDemoService.insertTrafficStation(trafficStation);
			assertEquals(true, false);
		}catch(AlreadyStationExistsException exception){
			assertEquals(true, true);
		}
	}
	
	@Test
	public void testStationFindByIdNotExists(){
		final Integer id= 10100101;
		final TrafficStationBean trafficStationBean = this.stationDemoService.findStationById(id);
		assertNull(trafficStationBean);
	}

	
	@Test
	public void testStationFindByIdExists(){
		
		final String STATION = "PORTE DE CHOI";
		
		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setStation(STATION);
		
		List<TrafficStationBean> listStations = this.stationDemoService.findStations(criteria);
		assertTrue(listStations.size() == 1);

		final Integer id = listStations.get(0).getId();
		
		//Search for a station traffic by id.
		final TrafficStationBean trafficStationBean = this.stationDemoService.findStationById(id);
		assertNotNull(trafficStationBean);
		
		assertEquals(trafficStationBean.getStation(), "PORTE DE CHOISY");
		assertTrue(trafficStationBean.getTraffic()  > 0);
		
	}
	
}
