package com.exakaconsulting.poc.service;

public abstract class FunctionalException extends Exception{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7722995722004115096L;

	public FunctionalException(final String message){
		super(message);
	}
	
}
