package com.exakaconsulting.poc.service.jwt;

/**
 * Interface JWT user service
 * 
 *
 */
public interface IJwtUserService {
	

	/**
	 * Method to get a user using a token.<br/>
	 * 
	 * @param token
	 * @return
	 */
	JwtUserDto parseToken(final String token);

}
