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
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.util.Assert;
import org.apache.commons.lang3.StringUtils;

import com.exakaconsulting.poc.service.CriteriaSearchTrafficStation;
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
	public List<TrafficStationBean> searchStations(CriteriaSearchTrafficStation criteria) throws TechnicalException {

		Assert.notNull(criteria, "The criteria must be set");

		LOGGER.info("BEGIN of the method searchStations  of the class " + StationDemoDaoImpl.class.getName());

		List<TrafficStationBean> listStationsSearch = Collections.<TrafficStationBean>emptyList();
		try {
			Map<String, Object> params = new HashMap<>();

			List<String> listWhereVariable = new ArrayList<>();
			
			if (!StringUtils.isBlank(criteria.getReseau())){
				listWhereVariable.add("TRAF_RESE = :reseau");
				params.put("reseau", criteria.getReseau());				
			}
			
			if (!StringUtils.isBlank(criteria.getStation())){
				listWhereVariable.add("TRAF_STAT like :station");
				params.put("station", criteria.getStation() + "%");				
				
			}
			
			if (criteria.getTrafficMin() != null){
				listWhereVariable.add("TRAF_TRAF >= :trafficMin");
				params.put("trafficMin", criteria.getTrafficMin());				
				
			}
			
			if (criteria.getTrafficMax() != null){
				listWhereVariable.add("TRAF_TRAF <= :trafficMax");
				params.put("trafficMax", criteria.getTrafficMax());				
			}
			
			if (criteria.getVille() != null){
				listWhereVariable.add("upper(TRAF_VILL) like :trafficVille");
				params.put("trafficVille", StringUtils.upperCase(criteria.getVille()) + "%");				
			}
			
			if (criteria.getArrondiss() != null){
				listWhereVariable.add("TRAF_ARRO = :arrondiss");
				params.put("arrondiss", criteria.getArrondiss());				
			}


			
			StringBuilder requestSql = new StringBuilder(64);
			requestSql.append(REQUEST_ALL_SQL);
			if (listWhereVariable != null && !listWhereVariable.isEmpty()) {
				requestSql.append(" WHERE ");
				requestSql.append(StringUtils.join(listWhereVariable, " AND "));
				requestSql.append(" ORDER BY TRAF_IDEN ASC");
			}
			
			LOGGER.info("Request SQL search  :" + requestSql.toString());


			listStationsSearch = this.jdbcTemplate.query(requestSql.toString(), params, new TrafficStationRowMapper());
			LOGGER.info("END of the method retrieveOperations of the class " + StationDemoDaoImpl.class.getName());
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception);
		}

		return listStationsSearch;
	}

	@Override
	public TrafficStationBean findStationByName(String name) throws TechnicalException {
		Assert.notNull(name, "The name must be set");
		
		final String SQL = REQUEST_ALL_SQL + "  WHERE TRAF_STAT = :station";
		
		//parameters
		Map<String, Object> params = new HashMap<>();
		params.put("station", name);	
		
		TrafficStationBean trafficStation = null;
		
		try{
			trafficStation = this.jdbcTemplate.queryForObject(SQL, params, new TrafficStationRowMapper());
		}catch(EmptyResultDataAccessException exception){
			LOGGER.warn("No traffic has been found for name = ['"+ name + "']");
		}catch(Exception exception){
			LOGGER.error(exception.getMessage() , exception);
			throw new TechnicalException(exception);
		}
		return trafficStation;
	}

	@Override
	public TrafficStationBean findStationById(Integer id) throws TechnicalException {
		// TODO Auto-generated method stub
		return null;
	}
		
		

}
