package com.exakaconsulting.poc.service;

import java.io.Serializable;
import java.util.List;

public class CriteriaSearchTrafficStation extends AbstractCriteriaSearch implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -52183061212841692L;
	
	// equals
	private String reseau;
	
	// Starts with
	private String station;
	
	// Min traffic
	private Long trafficMin;
	
	// Max traffic
	private Long trafficMax;
	
	//Starts with
	private String ville;
	
	//Equals
	private Integer arrondiss;
	
	private List<OrderBean> orders;
	
	public CriteriaSearchTrafficStation(){
		super();
	}
	
	public CriteriaSearchTrafficStation(final Integer page, final Integer perPage){
		super(page, perPage);	
	}

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

	public Long getTrafficMin() {
		return trafficMin;
	}

	public void setTrafficMin(Long trafficMin) {
		this.trafficMin = trafficMin;
	}

	public Long getTrafficMax() {
		return trafficMax;
	}

	public void setTrafficMax(Long trafficMax) {
		this.trafficMax = trafficMax;
	}

	public String getVille() {
		return ville;
	}

	public void setVille(String ville) {
		this.ville = ville;
	}

	public Integer getArrondiss() {
		return arrondiss;
	}

	public void setArrondiss(Integer arrondiss) {
		this.arrondiss = arrondiss;
	}

	public List<OrderBean> getOrders() {
		return orders;
	}

	public void setOrders(List<OrderBean> orders) {
		this.orders = orders;
	}

	


}
