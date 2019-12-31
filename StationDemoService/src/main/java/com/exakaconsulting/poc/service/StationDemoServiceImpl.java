package com.exakaconsulting.poc.service;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.exakaconsulting.poc.dao.IStationDemoDao;

import static com.exakaconsulting.poc.service.ConstantStationDemo.TRANSACTIONAL_DATASOURCE_STATION;


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
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("BEGIN of the method findStations of the class %s", StationDemoServiceImpl.class.getName()));			
		}
		
		// Set the station to Maj to make the test
		if (criteria.getStation() != null){
			criteria.setStation(StringUtils.upperCase(criteria.getStation()));
		}
				

		List<TrafficStationBean> listTrafficStations = stationDemoDao.findStations(criteria);

		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("END of the method findStations of the class %s",StationDemoServiceImpl.class.getName()));
		}
		
		return listTrafficStations;
	}
	
	@Override
	public Integer countStations(CriteriaSearchTrafficStation criteria) {
		Assert.notNull(criteria , "criteria has to be set");
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("BEGIN of the method countStations of the class %s" , StationDemoServiceImpl.class.getName()));
		}
			
		// Set the station to Maj to make the test
		if (criteria.getStation() != null){
			criteria.setStation(StringUtils.upperCase(criteria.getStation()));
		}
				

		Integer countStations = stationDemoDao.countStations(criteria);

		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("END of the method countStations of the class %s",StationDemoServiceImpl.class.getName()));
		}
		
		return countStations;

	}


	@Override
	@Transactional(rollbackFor=Throwable.class, propagation = Propagation.REQUIRED, transactionManager=TRANSACTIONAL_DATASOURCE_STATION)

	public Integer insertTrafficStation(TrafficStationBean trafficStationBean) throws AlreadyStationExistsException {
		Assert.notNull(trafficStationBean , "The traffic station must be set");
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("BEGIN of the method insertTrafficStation of the class %s", StationDemoServiceImpl.class.getName()));
		}
			
		TrafficStationBean trafficSearch = stationDemoDao.findStationByName(trafficStationBean.getStation());
		if (trafficSearch != null && trafficSearch.getId() != null){
			throw new AlreadyStationExistsException("The station ['" + trafficStationBean.getStation() + "'] already exists");
		}
		

		int returnValue = stationDemoDao.insertTrafficStation(trafficStationBean);
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("END of the method insertTrafficStation of the class %s" , StationDemoServiceImpl.class.getName()));
		}
		
		return returnValue;
	}

	@Override
	public TrafficStationBean findStationById(Integer id) {
		Assert.notNull(id , "The id station must be set");

		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("BEGIN of the method findStationById of the class %s [id = '%s']" , StationDemoServiceImpl.class.getName(), id));			
		}
		

		TrafficStationBean trafficStation = stationDemoDao.findStationById(id);

		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("END of the method findStationById of the class %s [id = '%s']" , StationDemoServiceImpl.class.getName() , id));			
		}
		
		return trafficStation;
	}

	@Override
	public void updateTrafficStation(Long newTrafficValue, String newCorr, Integer id) throws TrafficStationNotExists{
		Assert.notNull(id , "The id has to be set");
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("BEGIN of the method updateTrafficStation of the class %s" , StationDemoServiceImpl.class.getName()));
		}		

		stationDemoDao.updateTrafficStation(newTrafficValue, newCorr , id);

		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("END of the method updateTrafficStation of the class %s" , StationDemoServiceImpl.class.getName()));
		}

		
	}

	@Override
	public void deleteTrafficStation(Integer id) throws TrafficStationNotExists{
		Assert.notNull(id , "The id has to be set");
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("BEGIN of the method deleteTrafficStation of the class %s"  , StationDemoServiceImpl.class.getName()));
		}
		
		stationDemoDao.deleteTrafficStation(id);
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("END of the method deleteTrafficStation of the class %s" , StationDemoServiceImpl.class.getName()));
		}
	}


}
