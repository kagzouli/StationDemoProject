package com.exakaconsulting.poc.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;

import org.apache.commons.lang3.StringUtils;
import org.springframework.jdbc.core.RowMapper;

import com.exakaconsulting.poc.service.TrafficStationBean;

public class TrafficStationRowMapper implements RowMapper<TrafficStationBean>{

	
	@Override
	public TrafficStationBean mapRow(ResultSet rs, int rowNum) throws SQLException {
		TrafficStationBean trafficStationBean = new TrafficStationBean(); 
		
		trafficStationBean.setId(rs.getInt("TRAF_IDEN"));
		
		trafficStationBean.setReseau(rs.getString("TRAF_RESE"));
		
		trafficStationBean.setStation(rs.getString("TRAF_STAT"));
		
		trafficStationBean.setTraffic(rs.getLong("TRAF_TRAF"));
		
		final String correspondance = rs.getString("TRAF_CORR");
		if (!StringUtils.isBlank(correspondance)){
			trafficStationBean.setListCorrespondance(Arrays.asList(correspondance.split(",")));
		}
		trafficStationBean.setVille(rs.getString("TRAF_VILL"));
		
		final int arrondissement = rs.getInt("TRAF_ARRO");
		trafficStationBean.setArrondissement(arrondissement != 0 ? arrondissement : null);		
		return trafficStationBean;
	}

}
