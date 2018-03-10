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
	public List<TrafficStationBean> findStations(CriteriaSearchTrafficStation criteria) {
		
		Assert.notNull(criteria , "criteria has to be set");
		
		LOGGER.info("BEGIN of the method searchStations of the class " + StationDemoServiceImpl.class.getName());
				

		List<TrafficStationBean> listTrafficStations = stationDemoDao.findStations(criteria);

		LOGGER.info("END of the method searchStations of the class " + StationDemoServiceImpl.class.getName());
		
		return listTrafficStations;
	}

	@Override
	@Transactional(rollbackFor=Throwable.class, propagation = Propagation.REQUIRED, transactionManager=TRANSACTIONAL_DATASOURCE_STATION)

	public Integer insertTrafficStation(TrafficStationBean trafficStationBean) throws AlreadyStationExistsException {
		Assert.notNull(trafficStationBean , "The traffic station must be set");
		
		LOGGER.info("BEGIN of the method insertTrafficStation of the class " + StationDemoServiceImpl.class.getName());
		
		TrafficStationBean trafficSearch = stationDemoDao.findStationByName(trafficStationBean.getStation());
		if (trafficSearch != null && trafficSearch.getId() != null){
			throw new AlreadyStationExistsException("The station ['" + trafficStationBean.getStation() + "'] already exists");
		}
		

		int returnValue = stationDemoDao.insertTrafficStation(trafficStationBean);

		LOGGER.info("END of the method insertTrafficStation of the class " + StationDemoServiceImpl.class.getName());

		return returnValue;
	}

	@Override
	public TrafficStationBean findStationById(Integer id) {
		Assert.notNull(id , "The id station must be set");
		
		LOGGER.info("BEGIN of the method findStationById of the class " + StationDemoServiceImpl.class.getName() + " [id = '" + id + "']");
		

		TrafficStationBean trafficStation = stationDemoDao.findStationById(id);

		LOGGER.info("END of the method findStationById of the class " + StationDemoServiceImpl.class.getName() + " [id = '" + id + "']");
		
		return trafficStation;
	}

}
