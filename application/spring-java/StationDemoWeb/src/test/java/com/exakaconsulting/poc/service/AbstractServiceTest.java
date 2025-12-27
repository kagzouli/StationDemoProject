package com.exakaconsulting.poc.service;


import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.util.Arrays;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.slf4j.Logger;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

import com.exakaconsulting.poc.ApplicationTest;

@SpringBootTest(classes = ApplicationTest.class)
@Transactional
@TestPropertySource(locations="classpath:test.properties")
@Sql(scripts = {"/db-data-h2-trafstat-test.sql"})
@EnableTransactionManagement
@ActiveProfiles("test")
public abstract class AbstractServiceTest {
	
	static final String NETWORK_PORTECHOISY = "Metro";
	static final String STATION_PORTE_CHOISY = "PORTE DE CHOISY"; 
	static final Long TRAFFIC_PORTE_CHOISY = 3094950L;
	static final List<String> CORRESPOND_PORTE_CHOISY = Arrays.asList("7");
	static final String VILLE_PORTE_CHOISY = "Paris"; 
	static final Integer ARROND_PORTE_CHOISY = 13;
	
	@Mock
	private RedisTemplate<String, TrafficStationBean> redisTemplate;

	@Mock
	private ValueOperations<String, TrafficStationBean> valuesOperation;
	
	@BeforeEach
	public  void beforeTest(){
		
		Logger logger = Mockito.mock(Logger.class);
        Mockito.when(logger.isInfoEnabled()).thenReturn(true);
       
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
