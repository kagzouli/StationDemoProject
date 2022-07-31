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
	 * Method to count the stations.<br/>
	 * 
	 * @param criteria Criteria of the search.<br/>
	 * @return Return the number of stations.<br/>
	 */
	Integer countStations(CriteriaSearchTrafficStation criteria);

	
	/**
	 * Method to insert a traffic station in the database.<br/>
	 * 
	 * @param trafficStationBean The traffic stationBean.<br/>
	 * @return Return the number of insert.<br/>
	 * @throws AlreadyStationExistsException A station with the same name already exists.<br/>
	 */
	Integer insertTrafficStation(final TrafficStationBean trafficStationBean) throws AlreadyStationExistsException;

	
	/**
	 * Method to search for a station by his technical id.<br/>
	 * 
	 * @param id Technical id<br/>
	 * @return Return the station corresponding to this id.<br/>
	 * @throws Traffic does not exists.<br/>
	 */
	TrafficStationBean findStationById(final Integer id) throws TrafficStationNotExists;
	
	/**
	 * Method to update the traffic station by id.<br/>
	 * 
	 * @param newTrafficValue The new traffic value.<br/>
	 * @param newCorr The new correspondance.<br/>
	 * @param id The technical id.<br/>
	 * @throws The trafficStation does not exists.
	 */
	void updateTrafficStation(final Long newTrafficValue, final String newCorr, final Integer id) throws TrafficStationNotExists;
	
	/**
	 * Method to delete a traffic station.<br/>
	 * 
	 * @param id The id parameter.<br/>
	 * @throws The trafficStation does not exists.
	 */
	void deleteTrafficStation(final Integer id) throws TrafficStationNotExists;
		
}
