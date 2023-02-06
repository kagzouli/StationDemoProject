package com.exakaconsulting.poc.security;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;


import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class JwtAuthenticationTokenFilter extends OncePerRequestFilter {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(JwtAuthenticationTokenFilter.class);
	
	@Autowired
	private JwtAuthenticationProvider authenticationProvider;

    /**
     * Attempt to authenticate request - basically just pass over to another method to authenticate request headers
     * @throws ServletException 
     * @throws IOException 
     */
    @Override
    public final void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        String header = request.getHeader("Authorization");

        if (header == null || !header.startsWith("Bearer ") || header.length() < 8) {
            filterChain.doFilter(request, response);
            return;
        }

        try {
        	String authToken = header.substring(7);

        	JwtAuthenticationTokenBean authRequest = new JwtAuthenticationTokenBean(authToken);

        	final Authentication authentication = this.authenticationProvider.authenticate(authRequest);
        	SecurityContextHolder.getContext().setAuthentication(authentication);
        	
        	filterChain.doFilter(request, response);
        }catch(Exception exception) {
        	LOGGER.error(exception.getMessage() , exception);
        	response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
        }
    }
}

