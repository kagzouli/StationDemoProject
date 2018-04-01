package com.exakaconsulting.poc;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;


import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.exakaconsulting.poc.dao.IStationDemoDao;
import com.exakaconsulting.poc.service.CriteriaSearchTrafficStation;
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

}
