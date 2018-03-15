package com.exakaconsulting.poc.dao;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

public class WhereParamSql implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6957394731538007682L;

	private Map<String, Object> params;
	
	private List<String> listWhereClause;

	public Map<String, Object> getParams() {
		return params;
	}

	public void setParams(Map<String, Object> params) {
		this.params = params;
	}

	public List<String> getListWhereClause() {
		return listWhereClause;
	}

	public void setListWhereClause(List<String> listWhereClause) {
		this.listWhereClause = listWhereClause;
	}
	
	
	
	

}
