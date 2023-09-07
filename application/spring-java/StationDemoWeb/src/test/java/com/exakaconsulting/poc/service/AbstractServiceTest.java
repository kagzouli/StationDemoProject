package com.exakaconsulting.poc.service;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.Arrays;
import java.util.List;

import org.junit.Before;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.slf4j.Logger;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.support.AnnotationConfigContextLoader;
import org.springframework.transaction.annotation.Transactional;

import com.exakaconsulting.poc.service.TrafficStationBean;
import com.exakaconsulting.poc.ApplicationTest;

@RunWith(SpringRunner.class)
@ContextConfiguration(loader=AnnotationConfigContextLoader.class,classes=ApplicationTest.class)
@Transactional
@ActiveProfiles("test")
public abstract class AbstractServiceTest {
	
	static final String NETWORK_PORTECHOISY = "Metro";
	static final String STATION_PORTE_CHOISY = "PORTE DE CHOISY"; 
	static final Long TRAFFIC_PORTE_CHOISY = 3094950L;
	static final List<String> CORRESPOND_PORTE_CHOISY = Arrays.asList("7");
	static final String VILLE_PORTE_CHOISY = "Paris"; 
	static final Integer ARROND_PORTE_CHOISY = 13;
	
	@MockBean
	private RedisTemplate<String, TrafficStationBean> redisTemplate;

	@MockBean
	private ValueOperations<String, TrafficStationBean> valuesOperation;
	
	@Before
	public void beforeTest(){
		
		Logger logger = Mockito.mock(Logger.class);
        Mockito.when(logger.isInfoEnabled()).thenReturn(true);
        
        Mockito.when(this.redisTemplate.opsForValue()).thenReturn(valuesOperation);
        
	}

	
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
