package com.exakaconsulting.poc.filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

public class ValidationAngularFilter implements Filter{
	
	private static final String INDEX_HTML = "/index.html";
	
	// All the static 
	private static final List<String> LIST_STATIC_CONTENT = Arrays.asList(".css", ".js" , ".gif" , ".jpeg" , ".png", ".html", ".html");

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// Not use anymore
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		
		 // Make to avoid loosing angular context when hashStrategy=false (PathStrategy)
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		final String uri = httpRequest.getRequestURI();
		
		if (uri != null && !LIST_STATIC_CONTENT.stream().anyMatch(staticContent -> uri.endsWith(staticContent))){
			 RequestDispatcher requestDispatcher=request.getRequestDispatcher(INDEX_HTML);  
			 requestDispatcher.include(request, response);  			
		}else{
			 chain.doFilter(request, response);			
		}
	}
	
	@Override
	public void destroy() {
		// Not use anymore		
	}


}
