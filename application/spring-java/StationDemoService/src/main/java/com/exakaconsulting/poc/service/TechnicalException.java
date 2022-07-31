package com.exakaconsulting.poc.service;

public class TechnicalException extends RuntimeException{
	
	

	/**
	 * 
	 */
	private static final long serialVersionUID = 1432800323695112770L;

	public TechnicalException(final String message){
		super(message);
	}
	
	public TechnicalException(final Exception exception){
		super(exception);
	}
	
	public TechnicalException(final String message, final Exception exception){
		super(message , exception);
	}

}
