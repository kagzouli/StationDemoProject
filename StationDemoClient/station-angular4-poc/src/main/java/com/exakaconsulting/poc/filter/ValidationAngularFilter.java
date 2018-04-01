package com.exakaconsulting.poc.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class ValidationAngularFilter implements Filter{
	
	private static final String INDEX_HTML = "/index.html";

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// Not use anymore
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		
		// Make to avoid loosing angular context when hashStrategy=false (PathStrategy)
		request.getRequestDispatcher(INDEX_HTML).forward(request, response);
		
		 chain.doFilter(request, response);
		
	}
	
	@Override
	public void destroy() {
		// Not use anymore		
	}


}
