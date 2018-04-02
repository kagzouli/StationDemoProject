package com.exakaconsulting.poc;

import java.io.UnsupportedEncodingException;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.batch.item.database.ItemPreparedStatementSetter;

import com.exakaconsulting.poc.service.IStationDemoService;
import com.exakaconsulting.poc.service.TrafficStationBean;



public class TrafficStationPreparedStatement implements ItemPreparedStatementSetter<TrafficStationBean> {

	private static final Logger LOGGER = LoggerFactory.getLogger(TrafficStationPreparedStatement.class);

    @Override
    public void setValues(TrafficStationBean trafficStationBean, 
                          PreparedStatement preparedStatement) throws SQLException {
    	
    	final String reseau = StringUtils.endsWith(trafficStationBean.getReseau() , "tro") ? "Metro" : trafficStationBean.getReseau();
        preparedStatement.setString(1, reseau);
        preparedStatement.setString(2, trafficStationBean.getStation());
        preparedStatement.setLong(3, trafficStationBean.getTraffic());
 
        if (trafficStationBean.getListCorrespondance() != null){
        	preparedStatement.setString(4, StringUtils.join(trafficStationBean.getListCorrespondance() , ","));
        }else{
        	preparedStatement.setString(4, "");
        }
        
        try {
			preparedStatement.setString(5, new String(trafficStationBean.getVille().getBytes(), "UTF-8"));
		} catch (UnsupportedEncodingException exception) {
			preparedStatement.setString(5, "");
			LOGGER.warn(exception.getMessage() , exception);
		}
        
        if (trafficStationBean.getArrondissement() != null){
        	preparedStatement.setInt(6, trafficStationBean.getArrondissement());
        }else{
        	preparedStatement.setNull(6, 0);        	
        }
        
    	
    }


}
