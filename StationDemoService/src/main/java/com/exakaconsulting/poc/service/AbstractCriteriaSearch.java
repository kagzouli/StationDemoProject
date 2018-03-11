package com.exakaconsulting.poc.service;

import java.io.Serializable;

public abstract class AbstractCriteriaSearch implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8756656122814264566L;
	
	public static final Integer MAX_NUMBER_ELEMENTS = 100; 
	
	/** Numero of page **/
	private Integer page;
	
	/** Number of max elements **/
	private Integer numberMaxElements;

	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public Integer getNumberMaxElements() {
		return numberMaxElements;
	}

	public void setNumberMaxElements(Integer numberMaxElements) {
		this.numberMaxElements = numberMaxElements;
	}
	
	
	
	

}
