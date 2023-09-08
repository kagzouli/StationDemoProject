package com.exakaconsulting.poc.service;

public class ConstantStationDemo {
	
	private ConstantStationDemo(){
		
	}
		
	/** Insert traffic sql **/
	public static final String INSERT_TRAFFIC_SQL = "INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values (? , ? , ? , ? , ? , ?)";
	
	/** Station already exists **/
	public static final String STATION_ALREADY_EXISTS = "station.already.exists";
	
	/** JWT User simple service */
	public static final String JWT_USER_SIMPLE_SERVICE = "jwt.user.simple.service";
	public static final String JWT_USER_SIMPLE_PROFILE = "jwtSimple";
	
	/** JWT User okta service **/
	public static final String JWT_USER_OKTA_SERVICE = "jwt.user.okta.service";
	public static final String JWT_USER_OKTA_PROFILE = "jwtOkta";

}
