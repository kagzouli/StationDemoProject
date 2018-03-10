package com.exakaconsulting.poc.service;

import java.util.List;

/**
 * Interface to search the station.<br/>
 * 
 * @author Toto
 *
 */
public interface IStationDemoService {
	
	/**
	 * Method to search for a stations.<br/>
	 * 
	 * @param criteria Criteria of the search.<br/>
	 * @return Return a list of stations.<br/>
	 */
	List<TrafficStationBean> searchStations(CriteriaSearchTrafficStation criteria);
	
	/**
	 * Method to insert a traffic station in the database.<br/>
	 * 
	 * @param trafficStationBean The traffic stationBean.<br/>
	 * @return Return the key of this record.<br/>
	 */
	Integer insertTrafficStation(final TrafficStationBean trafficStationBean);

}
