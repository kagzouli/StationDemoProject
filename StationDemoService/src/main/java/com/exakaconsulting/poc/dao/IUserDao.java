package com.exakaconsulting.poc.dao;

import com.exakaconsulting.poc.service.User;

public interface IUserDao {
	
	/** 
	 * Method to know if a user is authenticated.<br/>
	 * 
	 * @param login The login to authenticate.<br/>
	 * @param password The password to authenticate.<br/>
	 * @return Return the user authenticated, null otherwise.<br/>
	 */
	public User authenticate(final String login, final String password);


}
