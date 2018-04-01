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

import com.exakaconsulting.poc.service.AbstractCriteriaSearch;
import com.exakaconsulting.poc.service.CriteriaSearchTrafficStation;
import com.exakaconsulting.poc.service.OrderBean;
import com.exakaconsulting.poc.service.TechnicalException;
import com.exakaconsulting.poc.service.TrafficStationBean;

import static com.exakaconsulting.poc.service.IConstantStationDemo.DATASOURCE_STATION;

@Repository
public class StationDemoDaoImpl implements IStationDemoDao{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(StationDemoDaoImpl.class);
	
	private static final String REQUEST_ALL_SQL = "select * from TRAF_STAT";
	
	private static final String COUNT_ALL_SQL = "select count(1) from TRAF_STAT";
	
	static final String INSERT_TRAFFIC_SQL = "INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values (:reseau , :station , :traffic , :corres , :ville , :arron)";

	static final String BEGIN_UPDATE_SQL = "update TRAF_STAT SET ";

	static final String DELETE_TRAFFIC_SQL = "delete from TRAF_STAT WHERE TRAF_IDEN = :id";
	
	static final String ERROR_CRITERIA_MUSTSET = "The criteria must be set";
	static final String ERROR_ID_MUSTBESET     = "The id must be set";
	
	static final String RESEAU_PARAM  = "reseau";
	static final String STATION_PARAM = "station";
	static final String TRAFFIC_PARAM = "traffic";

	
	private NamedParameterJdbcTemplate jdbcTemplate;

	@Autowired
	@Qualifier(DATASOURCE_STATION)
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
	}
	
	@Override
	public Integer insertTrafficStation(TrafficStationBean trafficStationBean) {
		Assert.notNull(trafficStationBean, "The trafficStationBean must be set");

		try {
			
			Map<String, Object> params = new HashMap<>();
			params.put(RESEAU_PARAM, trafficStationBean.getReseau());
			if (trafficStationBean.getStation() != null){
			   params.put(STATION_PARAM, StringUtils.upperCase(trafficStationBean.getStation()));
			}
			params.put(TRAFFIC_PARAM, trafficStationBean.getTraffic());
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
	public List<TrafficStationBean> findStations(CriteriaSearchTrafficStation criteria){

		Assert.notNull(criteria, ERROR_CRITERIA_MUSTSET);

		LOGGER.info("BEGIN of the method searchStations  of the class " + StationDemoDaoImpl.class.getName());

		List<TrafficStationBean> listStationsSearch = Collections.<TrafficStationBean>emptyList();
		try {
			
			WhereParamSql whereParamSql =  this.createWhereParamSql(criteria);
			
			StringBuilder requestSql = new StringBuilder(128);
			requestSql.append(REQUEST_ALL_SQL);
			final List<String> listWhereVariable = whereParamSql.getListWhereClause();
			final Map<String, Object> params = whereParamSql.getParams();
			if (listWhereVariable != null && !listWhereVariable.isEmpty()) {
				requestSql.append(" WHERE ");
				requestSql.append(StringUtils.join(listWhereVariable, " AND "));
			}
			
			final List<OrderBean> listOrderBean = criteria.getOrders();
			
			if (listOrderBean != null && !listOrderBean.isEmpty()){
				requestSql.append(this.createListOrder(listOrderBean));
			}else{
				requestSql.append(" ORDER BY TRAF_TRAF DESC");				
			}
			
			
			
			if (criteria.getPage() != null){
				
				// Avoid getting to much data
				Integer numberMaxElements = criteria.getNumberMaxElements();
				if (numberMaxElements == null || numberMaxElements < 0 || numberMaxElements > AbstractCriteriaSearch.MAX_NUMBER_ELEMENTS){
					numberMaxElements = AbstractCriteriaSearch.MAX_NUMBER_ELEMENTS;
				}

				
				final int offset = (criteria.getPage() - 1) * numberMaxElements ;
				
				requestSql.append(" LIMIT ");
				requestSql.append(numberMaxElements);
				requestSql.append(" OFFSET ");
				requestSql.append(offset);
			}
			
			if (LOGGER.isInfoEnabled()){
				LOGGER.info("Request SQL search  :" + requestSql.toString());				
			}


			listStationsSearch = this.jdbcTemplate.query(requestSql.toString(), params, new TrafficStationRowMapper());
			LOGGER.info("END of the method searchStations of the class " + StationDemoDaoImpl.class.getName());
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception);
		}

		return listStationsSearch;
	}
	
	@Override
	public Integer countStations(CriteriaSearchTrafficStation criteria) {
		
		Assert.notNull(criteria, ERROR_CRITERIA_MUSTSET);

		LOGGER.info("BEGIN of the method countStations  of the class " + StationDemoDaoImpl.class.getName());

		Integer countStations = 0;
		try {
			
			WhereParamSql whereParamSql =  this.createWhereParamSql(criteria);
			
			StringBuilder requestSql = new StringBuilder(128);
			requestSql.append(COUNT_ALL_SQL);
			final List<String> listWhereVariable = whereParamSql.getListWhereClause();
			final Map<String, Object> params = whereParamSql.getParams();
			if (listWhereVariable != null && !listWhereVariable.isEmpty()) {
				requestSql.append(" WHERE ");
				requestSql.append(StringUtils.join(listWhereVariable, " AND "));
			}
			
			
			if (LOGGER.isInfoEnabled()){
				LOGGER.info("Request SQL search  :" + requestSql.toString());				
			}

			countStations = this.jdbcTemplate.queryForObject(requestSql.toString(), params, Integer.class);
			LOGGER.info("END of the method countStations of the class " + StationDemoDaoImpl.class.getName());
		} catch(EmptyResultDataAccessException exception){
			LOGGER.warn(exception.getMessage());
		}catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception);
		}
		return countStations;

	}

	@Override
	public TrafficStationBean findStationByName(String name)  {
		Assert.notNull(name, "The name must be set");
		
		final String SQL = REQUEST_ALL_SQL + "  WHERE TRAF_STAT = :station";
		
		//parameters
		Map<String, Object> params = new HashMap<>();
		params.put(STATION_PARAM, name);	
		
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
	public TrafficStationBean findStationById(Integer id)  {
		Assert.notNull(id, ERROR_ID_MUSTBESET);

		final String SQL = REQUEST_ALL_SQL + "  WHERE TRAF_IDEN = :id";		
		//parameters
		Map<String, Object> params = new HashMap<>();
		params.put("id", id);	

		
		TrafficStationBean trafficStation = null;
		try{
			trafficStation = this.jdbcTemplate.queryForObject(SQL, params, new TrafficStationRowMapper());
		}catch(EmptyResultDataAccessException exception){
			LOGGER.warn("No traffic has been found for id = ['"+ id + "']");
		}catch(Exception exception){
			LOGGER.error(exception.getMessage() , exception);
			throw new TechnicalException(exception);
		}
		return trafficStation;

	
	}

	@Override
	public void updateTrafficStation(Long newTrafficValue, String newCorr, Integer id) {
		Assert.notNull(id, ERROR_ID_MUSTBESET);
		
		Map<String, Object> params = new HashMap<>();

		
		List<String> listUpdateVariable = new ArrayList<>();

		if (newTrafficValue != null){
			listUpdateVariable.add("TRAF_TRAF = :newTraffic");
			params.put("newTraffic", newTrafficValue);				
		}
		
		// Update the correspondance
		listUpdateVariable.add("TRAF_CORR = :newCorr");
		params.put("newCorr", newCorr);				
			
		params.put("id", id);
		
		final String SQL= BEGIN_UPDATE_SQL + StringUtils.join(listUpdateVariable , " ,") + " WHERE TRAF_IDEN = :id";
		
		try{
			this.jdbcTemplate.update(SQL, params);
		}catch(Exception exception){
			LOGGER.error(exception.getMessage() , exception);
			throw new TechnicalException(exception);
		}

		
	}

	@Override
	public void deleteTrafficStation(Integer id) {
		Assert.notNull(id, ERROR_ID_MUSTBESET);

		try{
			Map<String, Object> params = new HashMap<>();
			params.put("id", id);
			
			this.jdbcTemplate.update(DELETE_TRAFFIC_SQL, params);
		}catch(Exception exception){
			LOGGER.error(exception.getMessage() , exception);
			throw new TechnicalException(exception);
		}

	}
	
	/**
	 * Method to create the where param sql.<br/>
	 * 
	 * @param criteria The criteria.<br/>
	 * @return Return the where param sql.<br/>
	 */
	private WhereParamSql createWhereParamSql(final CriteriaSearchTrafficStation criteria){
		Assert.notNull(criteria, ERROR_CRITERIA_MUSTSET);

		WhereParamSql whereParamSql = new WhereParamSql();
		
		Map<String, Object> params = new HashMap<>();

		List<String> listWhereVariable = new ArrayList<>();
		
		if (!StringUtils.isBlank(criteria.getReseau())){
			listWhereVariable.add("TRAF_RESE = :reseau");
			params.put(RESEAU_PARAM, criteria.getReseau());				
		}
		
		if (!StringUtils.isBlank(criteria.getStation())){
			listWhereVariable.add("TRAF_STAT like :station");
			params.put(STATION_PARAM, criteria.getStation() + "%");				
			
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
		
		whereParamSql.setListWhereClause(listWhereVariable);
		whereParamSql.setParams(params);
		
		return whereParamSql;
	}

	
	private String createListOrder(List<OrderBean> listOrder){
		
		StringBuilder builder = new StringBuilder(64);
		
		boolean firstElement = true;
		if (listOrder != null && !listOrder.isEmpty()){
			
			// Order by
			builder.append(" ORDER BY ");
			
			for (OrderBean orderBean : listOrder){
				String order = "";
				switch(orderBean.getColumn()){
					case STATION_PARAM:
						order = "TRAF_STAT ";
						break;
					case RESEAU_PARAM:
						order = "TRAF_RESE ";
						break;
					case "ville":
						order = "TRAF_VILL ";
						break;
					default:
						order = "TRAF_TRAF ";
						break;
						
				}
				order = order + " " + StringUtils.upperCase(orderBean.getDirection());	
				
				// Order
				if (!firstElement){
					builder.append(" , ");
				}
				builder.append(order);
				firstElement = false;
			}
			
			
			
		
			
		}
		
		
		
		return builder.toString();
		
	}
		
		

}
