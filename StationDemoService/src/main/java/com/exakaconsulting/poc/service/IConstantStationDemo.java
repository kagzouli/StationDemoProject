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
	
	/** User not exists **/
	static final String USER_NOT_EXISTS = "user.not.exists";
	
	/** User database service **/
	static final String USER_SERVICE_DATABASE = "userServiceDatabase";
	
	/** User database service **/
	static final String USER_DAO_DATABASE = "userDaoDatabase";


}
