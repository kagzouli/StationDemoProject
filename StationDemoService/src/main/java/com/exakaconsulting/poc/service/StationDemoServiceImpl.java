package com.exakaconsulting.poc.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.exakaconsulting.poc.dao.IStationDemoDao;

import static com.exakaconsulting.poc.service.IConstantStationDemo.TRANSACTIONAL_DATASOURCE_STATION;


/**
 * 
 * @author Toto
 *
 */
@Service
public class StationDemoServiceImpl implements IStationDemoService{
	
	 private static final Logger LOGGER = LoggerFactory.getLogger(StationDemoServiceImpl.class);
	 
	 @Autowired
	 private IStationDemoDao stationDemoDao;

	@Override
	public List<TrafficStationBean> searchStations() {
		LOGGER.info("BEGIN of the method searchStations of the class " + StationDemoServiceImpl.class.getName());
		
		// TODO : test if the name already exists
		

		List<TrafficStationBean> listTrafficStations = stationDemoDao.searchStations();

		LOGGER.info("END of the method searchStations of the class " + StationDemoServiceImpl.class.getName());
		
		return listTrafficStations;
	}

	@Override
	@Transactional(rollbackFor=Throwable.class, propagation = Propagation.REQUIRED, transactionManager=TRANSACTIONAL_DATASOURCE_STATION)

	public Integer insertTrafficStation(TrafficStationBean trafficStationBean) {
		Assert.notNull(trafficStationBean , "The traffic station must be set");
		
		LOGGER.info("BEGIN of the method insertTrafficStation of the class " + StationDemoServiceImpl.class.getName());
		
		// TODO : test if the name already exists
		

		int returnValue = stationDemoDao.insertTrafficStation(trafficStationBean);

		LOGGER.info("END of the method insertTrafficStation of the class " + StationDemoServiceImpl.class.getName());

		return returnValue;
	}

}
