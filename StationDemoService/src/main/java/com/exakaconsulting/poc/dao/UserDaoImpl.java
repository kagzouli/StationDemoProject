package com.exakaconsulting.poc.dao;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.util.Assert;

import com.exakaconsulting.poc.service.TechnicalException;
import com.exakaconsulting.poc.service.User;

import static com.exakaconsulting.poc.service.IConstantStationDemo.DATASOURCE_STATION;
import static com.exakaconsulting.poc.service.IConstantStationDemo.USER_DAO_DATABASE;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;


@Repository(USER_DAO_DATABASE)
public class UserDaoImpl implements IUserDao{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(UserDaoImpl.class);
	
	private static final String SQL = "SELECT user.USER_LOGI, role.ROLE_LABE FROM USER_STAT user, ROLE_STAT role WHERE user.USER_ROLE = role.ROLE_IDEN and user.USER_LOGI = :login";

	private NamedParameterJdbcTemplate jdbcTemplate;
	
	@Autowired
	@Qualifier(DATASOURCE_STATION)
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
	}
	
	@Override
	public User findUserByLogin(String login) {
		Assert.hasLength(login, "The login must be set");
		
		//parameters
		Map<String, Object> params = new HashMap<>();
		params.put("login", login);
		
		User user = null;		
		try{
			user = this.jdbcTemplate.queryForObject(SQL, params, new UserRowMapper());
		}catch(EmptyResultDataAccessException exception){
			LOGGER.warn("No user has been found for name = ['"+ login + "' and password = ['****']");
		}catch(Exception exception){
			LOGGER.error(exception.getMessage() , exception);
			throw new TechnicalException(exception);
		}
		return user;
	}

}
