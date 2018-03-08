package com.exakaconsulting.poc;

import java.io.Serializable;

public class TrafficStationCsvBean implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 509196666163457622L;
	
	private Integer rang;
	
	private String reseau;
	
	private String station;
	
	private Long traffic;
	
	private Integer correspondance1;
	
	private Integer correspondance2;

	
	private Integer correspondance3;
	
	private Integer correspondance4;
	
	private Integer correspondance5;
	
	private String ville;
	
	private Integer arrondissement;

	public Integer getRang() {
		return rang;
	}

	public void setRang(Integer rang) {
		this.rang = rang;
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

	public Integer getCorrespondance1() {
		return correspondance1;
	}

	public void setCorrespondance1(Integer correspondance1) {
		this.correspondance1 = correspondance1;
	}

	public Integer getCorrespondance2() {
		return correspondance2;
	}

	public void setCorrespondance2(Integer correspondance2) {
		this.correspondance2 = correspondance2;
	}

	public Integer getCorrespondance3() {
		return correspondance3;
	}

	public void setCorrespondance3(Integer correspondance3) {
		this.correspondance3 = correspondance3;
	}

	public Integer getCorrespondance4() {
		return correspondance4;
	}

	public void setCorrespondance4(Integer correspondance4) {
		this.correspondance4 = correspondance4;
	}

	public Integer getCorrespondance5() {
		return correspondance5;
	}

	public void setCorrespondance5(Integer correspondance5) {
		this.correspondance5 = correspondance5;
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
