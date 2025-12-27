package com.exakaconsulting.poc.service;

import java.io.Serializable;
import java.util.List;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;


public class TrafficStationBean implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8820607214452314228L;
	
	private Integer id;
	
	@NotBlank(message="The reseau must be set")
	private String reseau;
	
	@NotBlank(message="The station must be set")
	private String station;
	
	@NotNull(message="The traffic must be set")
	private Long traffic;
	
	private List<String> listCorrespondance;
	
	@NotBlank(message="The ville must be set")
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
