package com.exakaconsulting.poc.service;

import java.io.Serializable;

public class CriteriaSearchTrafficStation implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -52183061212841692L;
	
	// equals
	private String reseau;
	
	// Starts with
	private String station;

	public String getReseau() {
		return reseau;
	}

	public void setReseau(String reseau) {
		this.reseau = reseau;
	}

	public String getStation() {
		return station;
	}

	public void setStation(String station) {
		this.station = station;
	}
	
	
	

}
