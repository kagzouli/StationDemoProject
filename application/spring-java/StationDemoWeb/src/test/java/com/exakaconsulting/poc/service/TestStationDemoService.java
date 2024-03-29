package com.exakaconsulting.poc.service;


import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;




public class TestStationDemoService extends AbstractServiceTest{
	
	
	@Autowired
	private IStationDemoService stationDemoService;
	
	/**
	 * Test the LOGGER with a mock
	 * 
	 */

	
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
			assertTrue(false);
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
		
		assertEquals("Metro" , trafficUnicSta.getReseau());
		assertEquals("PORTE DE CHOISY" , trafficUnicSta.getStation());
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
	public void testCountNumberElementsWithoutCrit(){

		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		
		Integer count = this.stationDemoService.countStations(criteria);
		assertTrue(count == 369);
	}

	
	@Test
	public void testCountNumberElementsWithCrit(){
		final Integer ARRONDISS = 15;

		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setArrondiss(ARRONDISS);
		
		Integer count = this.stationDemoService.countStations(criteria);
		assertTrue(count > 0);
	}
	
	@Test
	public void testCountNumberWithStationCrit(){
		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setStation(STATION_PORTE_CHOISY);
		
		Integer count = this.stationDemoService.countStations(criteria);
		assertTrue(count == 1);
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
			assertTrue(false);
		}catch(AlreadyStationExistsException exception){
			assertTrue(true);
		}
	}
	
	@Test
	public void testStationFindByIdNotExists(){
		final Integer id= 10100101;
		
		try{
			this.stationDemoService.findStationById(id);
		}catch(TrafficStationNotExists exception){
			assertTrue(true);
		}
	}

	
	@Test
	public void testStationFindByIdExists(){
		
		// Search for a uniq traffic station and get his id.
		final String STATION = "PORTE DE CHOI";	
		final TrafficStationBean trafficUnicBean = this.getUnicTrafficStation(STATION);
		
		//Search for a station traffic by id.
		TrafficStationBean trafficStationBean = null;
		try{
			trafficStationBean = this.stationDemoService.findStationById(trafficUnicBean.getId());
		}catch(TrafficStationNotExists exception){
			assertTrue(false);
		}
		
		
		controlPorteChoisy(trafficStationBean);
	}
	
	@Test
	public void testUpdateTrafficStation() throws TrafficStationNotExists{
		
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
	public void testDeleteUpdateTrafficStationExists(){

		// Update a unic trafficStation
		final String STATION = "PORTE DE CHOI";	
		final TrafficStationBean trafficUnicBean =  this.getUnicTrafficStation(STATION);

		// Delete it, exists
		try{
			this.stationDemoService.deleteTrafficStation(trafficUnicBean.getId());
		}catch(TrafficStationNotExists exception){
			assertTrue(false);
		}
		
		// Test that it does not exists anymore
		try{
			this.stationDemoService.findStationById(trafficUnicBean.getId());
		}catch(TrafficStationNotExists exception){
			assertTrue(true);
		}
	}
	
	@Test
	public void DeleteTrafficStationNotExists(){


		// Delete it, exists
		try{
			this.stationDemoService.deleteTrafficStation(100000);
		}catch(TrafficStationNotExists exception){
			assertTrue(true);
		}
		
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
		criteria.setPerPage(testMaxElements);
		listStations = this.stationDemoService.findStations(criteria);
		assertEquals(listStations.size(), testMaxElements);
		
		//Fix now the max elements > maxNumberElements
		testMaxElements = AbstractCriteriaSearch.MAX_NUMBER_ELEMENTS +5;
		criteria.setPerPage(testMaxElements);
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
