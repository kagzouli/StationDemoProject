package com.exakaconsulting.poc.dao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.util.Assert;
import org.apache.commons.lang3.StringUtils;


import com.exakaconsulting.poc.service.TechnicalException;
import com.exakaconsulting.poc.service.TrafficStationBean;

import static com.exakaconsulting.poc.service.IConstantStationDemo.DATASOURCE_STATION;
import static com.exakaconsulting.poc.service.IConstantStationDemo.INSERT_TRAFFIC_SQL;


public class StationDemoDaoImpl implements IStationDemoDao{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(StationDemoDaoImpl.class);
	
	private static final String REQUEST_ALL_SQL = "select * from TRAF_STAT";

	private NamedParameterJdbcTemplate jdbcTemplate;

	@Autowired
	@Qualifier(DATASOURCE_STATION)
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
	}
	
	@Override
	public Integer insertTrafficStation(TrafficStationBean trafficStationBean) throws TechnicalException {
		Assert.notNull(trafficStationBean, "The trafficStationBean must be set");

		try {
			
			Map<String, Object> params = new HashMap<>();
			params.put("TRAF_RESE", trafficStationBean.getReseau());
			params.put("TRAF_STAT", trafficStationBean.getStation());
			params.put("TRAF_TRAF", trafficStationBean.getTraffic());
			if (trafficStationBean.getListCorrespondance() != null){
				params.put("TRAF_CORR", StringUtils.join(trafficStationBean.getListCorrespondance(),","));
				
			}
			params.put("TRAF_VILL", trafficStationBean.getVille());
			params.put("TRAF_ARRO", trafficStationBean.getArrondissement());

			int returnValue = this.jdbcTemplate.update(INSERT_TRAFFIC_SQL, params);

			if (returnValue <= 0) {
				throw new TechnicalException("No insert has been done for accountOperation");
			}
			return returnValue;
		} catch (TechnicalException exception) {
			throw exception;
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception.getMessage());
		}

	}

	@Override
	public List<TrafficStationBean> searchStations() throws TechnicalException {

		// Assert.hasLength(identifierUser, "The identifier must be set");

		LOGGER.info("BEGIN of the method searchStations  of the class " + StationDemoDaoImpl.class.getName());

		List<TrafficStationBean> listAccountOperation = Collections.<TrafficStationBean>emptyList();
		try {
			Map<String, Object> params = new HashMap<>();

			List<String> listWhereVariable = new ArrayList<>();

			listAccountOperation = jdbcTemplate.query(REQUEST_ALL_SQL, params, new TrafficStationRowMapper());
			LOGGER.info("END of the method retrieveOperations of the class " + StationDemoDaoImpl.class.getName());
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception);
		}

		return listAccountOperation;
	}

}
