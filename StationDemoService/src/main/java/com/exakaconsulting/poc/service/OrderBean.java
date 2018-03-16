package com.exakaconsulting.poc.service;

import java.io.Serializable;

public class OrderBean implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -4870541169922839680L;
	
	private String column;
	
	private String direction;

	public String getColumn() {
		return column;
	}

	public void setColumn(String column) {
		this.column = column;
	}

	public String getDirection() {
		return direction;
	}

	public void setDirection(String direction) {
		this.direction = direction;
	}
	
	

}
