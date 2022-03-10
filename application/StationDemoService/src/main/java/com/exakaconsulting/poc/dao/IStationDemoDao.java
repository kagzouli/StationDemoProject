package com.exakaconsulting.poc.dao;

import java.util.List;

import com.exakaconsulting.poc.service.CriteriaSearchTrafficStation;
import com.exakaconsulting.poc.service.TrafficStationBean;
import com.exakaconsulting.poc.service.TrafficStationNotExists;

public interface IStationDemoDao {
	
	
	/**
	 * Method to search for a lots of stations by criteria.<br/>
	 * 
	 * @param criteria Criteria to search.<br/>
	 * @return Return the list of station found.<br/>
	 */
	List<TrafficStationBean> findStations(CriteriaSearchTrafficStation criteria);

	/**
	 * Method to count the number of stations by criteria.<br/>
	 * 
	 * @param criteria Criteria to search.<br/>
	 * @return Return the number of stations found by criteria.<br/>
	 */

	public Integer countStations(CriteriaSearchTrafficStation criteria); 	
	
	/**
	 * Method to insert the trafficStation into database.<br/>
	 * 
	 * 
	 * @param trafficStationBean The traffic station to insert.<br/>
	 * @return
	 */
	Integer insertTrafficStation(TrafficStationBean trafficStationBean);
	
	
	/**
	 * Method to find a station by name.<br/>
	 * 
	 * @param name The name of the station to search.<br/>
	 * @return Return the station corresponding to the name.<br/>
	 */
	TrafficStationBean findStationByName(final String name) ;
	
	/**
	 * Method to find a station by id.<br/>
	 * 
	 * @param id The id of the station.<br/>
	 * @return Return the station corresponding to the id.<br/>
	 */
	TrafficStationBean findStationById(Integer id);
	
	/**
	 * Method to update the traffic station by id.<br/>
	 * 
	 * @param newTrafficValue The new traffic value.<br/>
	 * @param newCorr The new correspondance.<br/>
	 * @param id The technical id.<br/>
	 * @throws TrafficStationNotExists The id station does not exists.<br/>
	 */
	void updateTrafficStation(final Long newTrafficValue, final String newCorr, final Integer id) throws TrafficStationNotExists;


	/**
	 * Method to delete a traffic station.<br/>
	 * 
	 * @param id The id parameter.<br/>
	 * @throws TrafficStationNotExists The id station does not exists.<br/>
	 */
	void deleteTrafficStation(final Integer id) throws TrafficStationNotExists;

}
