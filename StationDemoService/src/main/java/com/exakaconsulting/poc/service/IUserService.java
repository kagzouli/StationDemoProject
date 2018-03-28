package com.exakaconsulting.poc.service;

public interface IUserService {
	
	/** 
	 * Method to get a user by login.<br/>
	 * 
	 * @param login The login to authenticate.<br/>
	 * @param password The password to authenticate.<br/>
	 * @return Return the user authenticated, null otherwise.<br/>
	 */
	public User findUserByLogin(final String login);

}
