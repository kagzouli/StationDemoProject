package com.exakaconsulting.poc.security;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.web.authentication.preauth.AbstractPreAuthenticatedProcessingFilter;

public class JwtAuthenticationFilter extends AbstractPreAuthenticatedProcessingFilter{

	@Override
	protected Object getPreAuthenticatedCredentials(HttpServletRequest request) {
		return null;
	}

	@Override
	protected Object getPreAuthenticatedPrincipal(HttpServletRequest request) {
		final String authorization = request.getHeader("Authorization");
		
		
		
		return authorization;
	}

}
