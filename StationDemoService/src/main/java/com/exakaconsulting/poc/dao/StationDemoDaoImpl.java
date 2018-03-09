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
import org.springframework.stereotype.Repository;
import org.springframework.util.Assert;
import org.apache.commons.lang3.StringUtils;


import com.exakaconsulting.poc.service.TechnicalException;
import com.exakaconsulting.poc.service.TrafficStationBean;

import static com.exakaconsulting.poc.service.IConstantStationDemo.DATASOURCE_STATION;

@Repository
public class StationDemoDaoImpl implements IStationDemoDao{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(StationDemoDaoImpl.class);
	
	private static final String REQUEST_ALL_SQL = "select * from TRAF_STAT";
	
	static final String INSERT_TRAFFIC_SQL = "INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values (:reseau , :station , :traffic , :corres , :ville , :arron)";


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
			params.put("reseau", trafficStationBean.getReseau());
			params.put("station", trafficStationBean.getStation());
			params.put("traffic", trafficStationBean.getTraffic());
			if (trafficStationBean.getListCorrespondance() != null){
				params.put("corres", StringUtils.join(trafficStationBean.getListCorrespondance(),","));
			}else{
				params.put("corres", "");
			}
			params.put("ville", trafficStationBean.getVille());
			params.put("arron", trafficStationBean.getArrondissement());

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
