package com.exakaconsulting.poc;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.exakaconsulting.poc.service.AbstractCriteriaSearch;
import com.exakaconsulting.poc.service.AlreadyStationExistsException;
import com.exakaconsulting.poc.service.CriteriaSearchTrafficStation;
import com.exakaconsulting.poc.service.IStationDemoService;
import com.exakaconsulting.poc.service.TrafficStationBean;



public class TestStationDemoService extends AbstractServiceTest{
	
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
		final TrafficStationBean trafficUnicSta = this.getUnicTrafficStation(STATION);
		
		assertEquals(trafficUnicSta.getReseau(), "Metro");
		assertEquals(trafficUnicSta.getStation() , "PORTE DE CHOISY");
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
		
		// Search for a uniq traffic station and get his id.
		final String STATION = "PORTE DE CHOI";	
		final TrafficStationBean trafficUnicBean = this.getUnicTrafficStation(STATION);
		
		//Search for a station traffic by id.
		final TrafficStationBean trafficStationBean = this.stationDemoService.findStationById(trafficUnicBean.getId());
		assertNotNull(trafficStationBean);
		
		assertEquals(trafficStationBean.getStation(), "PORTE DE CHOISY");
		assertTrue(trafficStationBean.getTraffic()  > 0);
	}
	
	@Test
	public void testUpdateTrafficStation(){
		
		// Search for a uniq traffic station and get his id.
		final String STATION = "PORTE DE CHOI";	
		final TrafficStationBean trafficUnicBean =  this.getUnicTrafficStation(STATION);

		final Long newTraffic = 20L;
		final String newCorr= "L,A,Z";
		this.stationDemoService.updateTrafficStation(newTraffic, newCorr, trafficUnicBean.getId());
		
		//Search for the same station
		TrafficStationBean trafficJustUpdate = this.stationDemoService.findStationById(trafficUnicBean.getId());
		assertNotNull(trafficJustUpdate);
		assertEquals(trafficJustUpdate.getId(), trafficUnicBean.getId());
		assertEquals(trafficJustUpdate.getTraffic(), newTraffic);
		assertEquals(StringUtils.join(trafficJustUpdate.getListCorrespondance() , ","), newCorr);	
	}
	
	@Test
	public void testDeleteUpdateTrafficStation(){

		// Update a unic trafficStation
		final String STATION = "PORTE DE CHOI";	
		final TrafficStationBean trafficUnicBean =  this.getUnicTrafficStation(STATION);

		// Delete it
		this.stationDemoService.deleteTrafficStation(trafficUnicBean.getId());
		
		// Test that it does not exists anymore
		TrafficStationBean trafficDeleted = this.stationDemoService.findStationById(trafficUnicBean.getId());
		assertNull(trafficDeleted);
	}
	
	@Test
	public void testSearchWithPageAndMax(){
		
		// Test without page 
		final String METRO = "Metro";
		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setReseau(METRO);
		List<TrafficStationBean> listStations = this.stationDemoService.findStations(criteria);
		assertTrue(listStations.size() == 303);

		
		// Test with page
		criteria.setPage(1);
		listStations = this.stationDemoService.findStations(criteria);
		assertTrue(listStations.size() == AbstractCriteriaSearch.MAX_NUMBER_ELEMENTS);
		
		// Fix now the max elements < maxNumberElements
		int testMaxElements = AbstractCriteriaSearch.MAX_NUMBER_ELEMENTS -5;
		criteria.setNumberMaxElements(testMaxElements);
		listStations = this.stationDemoService.findStations(criteria);
		assertEquals(listStations.size(), testMaxElements);
		
		//Fix now the max elements > maxNumberElements
		testMaxElements = AbstractCriteriaSearch.MAX_NUMBER_ELEMENTS +5;
		criteria.setNumberMaxElements(testMaxElements);
		listStations = this.stationDemoService.findStations(criteria);
		assertTrue(listStations.size() == AbstractCriteriaSearch.MAX_NUMBER_ELEMENTS);
		
	}
	
	
	/**
	 * Method utils to get aunic traffic station
	 * 
	 * @return
	 */
	protected TrafficStationBean  getUnicTrafficStation(final String station){
		
		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setStation(station);
		
		List<TrafficStationBean> listStations = this.stationDemoService.findStations(criteria);
		assertTrue(listStations.size() == 1);
		return listStations.get(0);
	}
	
	
}
