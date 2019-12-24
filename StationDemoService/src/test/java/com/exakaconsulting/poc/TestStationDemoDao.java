package com.exakaconsulting.poc;

import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;


import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.exakaconsulting.poc.dao.IStationDemoDao;
import com.exakaconsulting.poc.service.CriteriaSearchTrafficStation;
import com.exakaconsulting.poc.service.OrderBean;
import com.exakaconsulting.poc.service.TrafficStationBean;

public class TestStationDemoDao extends AbstractServiceTest{
	
	
	
	@Autowired
	private IStationDemoDao stationDemoDao;
	
	@Test
	public void testWithWithoutCriteria(){
		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		List<TrafficStationBean> listTrafficStation = stationDemoDao.findStations(criteria);
		assertTrue(listTrafficStation != null && listTrafficStation.size() == 369);
	}
	
	@Test
	public void testWithAllCriteriaSet(){
		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setReseau(NETWORK_PORTECHOISY);
		criteria.setStation(STATION_PORTE_CHOISY);
		criteria.setTrafficMin(1L);
		criteria.setPage(1);
		criteria.setPerPage(100);
		criteria.setOrders(Arrays.asList(new OrderBean("station" , "asc") , new OrderBean("reseau" , "asc") , new OrderBean("ville" , "desc")));
		criteria.setTrafficMax(5000000000L);
		criteria.setVille(VILLE_PORTE_CHOISY);
		criteria.setArrondiss(ARROND_PORTE_CHOISY);
		List<TrafficStationBean> listTrafficStation = stationDemoDao.findStations(criteria);
		assertTrue(listTrafficStation != null && listTrafficStation.size() == 1);
		final TrafficStationBean trafficStationBean = listTrafficStation.get(0);
		controlPorteChoisy(trafficStationBean);
	}
	
	

}
