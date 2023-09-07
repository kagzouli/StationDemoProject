package com.exakaconsulting.poc;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@ComponentScan({"com.exakaconsulting.poc.service" , "com.exakaconsulting.poc.web", "com.exakaconsulting.poc.dao" , "com.exakaconsulting.poc.security"})
@EnableWebMvc
public class AbstractApplication implements WebMvcConfigurer{
		
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
	    registry.addResourceHandler("swagger-ui.html")
	      .addResourceLocations("classpath:/META-INF/resources/");
	 
	    registry.addResourceHandler("/webjars/**")
	      .addResourceLocations("classpath:/META-INF/resources/webjars/");
	}
	
}
