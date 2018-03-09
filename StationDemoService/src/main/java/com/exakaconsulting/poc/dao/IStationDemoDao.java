package com.exakaconsulting.poc.dao;

import com.exakaconsulting.poc.service.TechnicalException;
import com.exakaconsulting.poc.service.TrafficStationBean;

public interface IStationDemoDao {
	
	/**
	 * Method to insert the trafficStation into database.<br/>
	 * 
	 * 
	 * @param trafficStationBean
	 * @return
	 * @throws TechnicalException
	 */
	Integer insertTrafficStation(TrafficStationBean trafficStationBean) throws TechnicalException;

}
