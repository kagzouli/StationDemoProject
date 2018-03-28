package com.exakaconsulting.poc.dao;

import com.exakaconsulting.poc.service.User;

public interface IUserDao {
	
	/** 
	 * Method to find a user by login.<br/>
	 * 
	 * @param login The login to authenticate.<br/>
	 * @return Return the user authenticated, null otherwise.<br/>
	 */
	public User findUserByLogin(final String login);


}
