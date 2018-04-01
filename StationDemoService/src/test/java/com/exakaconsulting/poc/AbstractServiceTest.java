package com.exakaconsulting.poc;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.Arrays;
import java.util.List;

import org.junit.runner.RunWith;
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.support.AnnotationConfigContextLoader;
import org.springframework.transaction.annotation.Transactional;

import com.exakaconsulting.poc.service.TrafficStationBean;
import com.exakaconsulting.poc.test.ApplicationTest;

@RunWith(SpringRunner.class)
@ContextConfiguration(loader=AnnotationConfigContextLoader.class,classes=ApplicationTest.class)
@Transactional
public abstract class AbstractServiceTest {
	
	static final String NETWORK_PORTECHOISY = "Metro";
	static final String STATION_PORTE_CHOISY = "PORTE DE CHOISY"; 
	static final Long TRAFFIC_PORTE_CHOISY = 3094950L;
	static final List<String> CORRESPOND_PORTE_CHOISY = Arrays.asList("7");
	static final String VILLE_PORTE_CHOISY = "Paris"; 
	static final Integer ARROND_PORTE_CHOISY = 13;
	
	protected void controlPorteChoisy(final TrafficStationBean trafficStationBean){
		assertNotNull(trafficStationBean);
		assertEquals(NETWORK_PORTECHOISY, trafficStationBean.getReseau());
		assertEquals(STATION_PORTE_CHOISY, trafficStationBean.getStation());
		assertEquals(CORRESPOND_PORTE_CHOISY, trafficStationBean.getListCorrespondance());
		assertEquals(TRAFFIC_PORTE_CHOISY, trafficStationBean.getTraffic());
		assertEquals(VILLE_PORTE_CHOISY,trafficStationBean.getVille());
		assertEquals(ARROND_PORTE_CHOISY, trafficStationBean.getArrondissement());
	}


}
