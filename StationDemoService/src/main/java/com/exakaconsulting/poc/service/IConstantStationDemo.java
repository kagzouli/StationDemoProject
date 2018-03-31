package com.exakaconsulting.poc.service;

public interface IConstantStationDemo {
	
	/** Datasource name **/
	static final String DATASOURCE_STATION = "datasourceStation";
	
	/** Transaction datasource station **/
	static final String TRANSACTIONAL_DATASOURCE_STATION = "txDatasourceStation";
	
	/** Insert traffic sql **/
	static final String INSERT_TRAFFIC_SQL = "INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values (? , ? , ? , ? , ? , ?)";
	
	/** Station already exists **/
	static final String STATION_ALREADY_EXISTS = "station.already.exists";
	
	/** JWT User simple service */
	static final String JWT_USER_SIMPLE_SERVICE = "jwt.user.simple.service";
	
	/** JWT User okta service **/
	static final String JWT_USER_OKTA_SERVICE = "jwt.user.okta.service";

}
