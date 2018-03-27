package com.exakaconsulting.poc.security;

import org.springframework.security.core.AuthenticationException;

public class JwtTokenMalformedException extends AuthenticationException {


    /**
	 * 
	 */
	private static final long serialVersionUID = 5339186400787345088L;

	public JwtTokenMalformedException(String msg) {
        super(msg);
    }
}

