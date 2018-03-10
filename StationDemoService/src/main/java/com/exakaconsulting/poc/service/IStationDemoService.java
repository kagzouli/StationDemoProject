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
	List<TrafficStationBean> findStations(CriteriaSearchTrafficStation criteria);
	
	/**
	 * Method to insert a traffic station in the database.<br/>
	 * 
	 * @param trafficStationBean The traffic stationBean.<br/>
	 * @return Return the key of this record.<br/>
	 * @throws AlreadyStationExistsException A station with the same name already exists.<br/>
	 */
	Integer insertTrafficStation(final TrafficStationBean trafficStationBean) throws AlreadyStationExistsException;

	
	/**
	 * Method to search for a station by his technical id.<br/>
	 * 
	 * @param id Technical id<br/>
	 * @return Return the station corresponding to this id.<br/>
	 */
	TrafficStationBean findStationById(final Integer id);
		
}
