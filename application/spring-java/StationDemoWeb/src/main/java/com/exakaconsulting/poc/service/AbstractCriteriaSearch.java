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
	private Integer perPage;

	public Integer getPage() {
		return page;
	}
	
	public AbstractCriteriaSearch(){
		super();
	}
	
	public AbstractCriteriaSearch(final Integer page, final Integer perPage){
		this.page = page;
		this.perPage = perPage;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public Integer getPerPage() {
		return perPage;
	}

	public void setPerPage(Integer perPage) {
		this.perPage = perPage;
	}

	
	
	
	
	

}
