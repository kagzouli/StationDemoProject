package com.exakaconsulting.poc.dao;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.exakaconsulting.poc.service.User;

public class UserRowMapper implements RowMapper<User>{

	
	@Override
	public User mapRow(ResultSet rs, int rowNum) throws SQLException {
		User user = new User(); 
		
		user.setLogin(rs.getString("USER_LOGI"));
		user.setRole(rs.getString("ROLE_LABE"));
		return user;
	}


}
