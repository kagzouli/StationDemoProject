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
	 * @return Return a list of stations.<br/>
	 */
	List<TrafficStationBean> searchStation();

}
