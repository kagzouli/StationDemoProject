package com.exakaconsulting.poc.dao;

import java.util.List;

import com.exakaconsulting.poc.service.CriteriaSearchTrafficStation;
import com.exakaconsulting.poc.service.TechnicalException;
import com.exakaconsulting.poc.service.TrafficStationBean;

public interface IStationDemoDao {
	
	
	/**
	 * Method to search for a lots of stations by criteria.<br/>
	 * 
	 * @param criteria Criteria to search.<br/>
	 * @return Return the list of station found.<br/>
	 * @throws TechnicalException
	 */
	List<TrafficStationBean> searchStations(CriteriaSearchTrafficStation criteria) throws TechnicalException;
	
	/**
	 * Method to insert the trafficStation into database.<br/>
	 * 
	 * 
	 * @param trafficStationBean The traffic station to insert.<br/>
	 * @return
	 * @throws TechnicalException
	 */
	Integer insertTrafficStation(TrafficStationBean trafficStationBean) throws TechnicalException;

}
