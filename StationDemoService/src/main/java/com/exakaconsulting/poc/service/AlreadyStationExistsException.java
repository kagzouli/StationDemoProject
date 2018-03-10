package com.exakaconsulting.poc.service;

public class AlreadyStationExistsException extends FunctionalException{

	/**
	 * 
	 */
	private static final long serialVersionUID = -1293901670431384851L;

	public AlreadyStationExistsException(Exception exception) {
		super(exception);
	}
	
	public AlreadyStationExistsException(String message) {
		super(message);
	}
	
}
