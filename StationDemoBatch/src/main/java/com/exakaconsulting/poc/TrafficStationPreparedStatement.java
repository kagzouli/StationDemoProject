package com.exakaconsulting.poc;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.apache.commons.lang3.StringUtils;
import org.springframework.batch.item.database.ItemPreparedStatementSetter;

import com.exakaconsulting.poc.service.TrafficStationBean;

public class TrafficStationPreparedStatement implements ItemPreparedStatementSetter<TrafficStationBean> {
	 
    @Override
    public void setValues(TrafficStationBean trafficStationBean, 
                          PreparedStatement preparedStatement) throws SQLException {
        preparedStatement.setString(1, trafficStationBean.getReseau());
        preparedStatement.setString(2, trafficStationBean.getStation());
        preparedStatement.setLong(3, trafficStationBean.getTraffic());
 
        if (trafficStationBean.getListCorrespondance() != null){
        	preparedStatement.setString(4, StringUtils.join(trafficStationBean.getListCorrespondance() , ","));
        }else{
        	preparedStatement.setString(4, "");
        }
        
        preparedStatement.setString(5, trafficStationBean.getVille());
        
        if (trafficStationBean.getArrondissement() != null){
        	preparedStatement.setInt(6, trafficStationBean.getArrondissement());
        }else{
        	preparedStatement.setNull(6, 0);        	
        }
        
    	
    }


}
