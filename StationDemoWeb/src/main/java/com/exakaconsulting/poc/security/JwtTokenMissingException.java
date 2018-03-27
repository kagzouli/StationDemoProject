package com.exakaconsulting.poc.security;

import org.springframework.security.core.AuthenticationException;

public class JwtTokenMissingException extends AuthenticationException {


    /**
	 * 
	 */
	private static final long serialVersionUID = 1713500154212725363L;

	public JwtTokenMissingException(String msg) {
        super(msg);
    }
}

