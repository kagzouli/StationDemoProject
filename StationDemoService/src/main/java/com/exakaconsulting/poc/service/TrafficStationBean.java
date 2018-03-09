package com.exakaconsulting.poc.service;

import java.io.Serializable;
import java.util.List;

public class TrafficStationBean implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8820607214452314228L;
	
	private Integer id;
	
	private String reseau;
	
	private String station;
	
	private Long traffic;
	
	private List<String> listCorrespondance;
		
	private String ville;
	
	private Integer arrondissement;
	
	

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
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

	public Long getTraffic() {
		return traffic;
	}

	public void setTraffic(Long traffic) {
		this.traffic = traffic;
	}


	public List<String> getListCorrespondance() {
		return listCorrespondance;
	}

	public void setListCorrespondance(List<String> listCorrespondance) {
		this.listCorrespondance = listCorrespondance;
	}

	public String getVille() {
		return ville;
	}

	public void setVille(String ville) {
		this.ville = ville;
	}

	public Integer getArrondissement() {
		return arrondissement;
	}

	public void setArrondissement(Integer arrondissement) {
		this.arrondissement = arrondissement;
	}
	
	
}
