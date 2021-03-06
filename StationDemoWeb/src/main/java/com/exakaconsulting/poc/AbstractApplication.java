package com.exakaconsulting.poc;

import com.exakaconsulting.poc.service.ConstantStationDemo;

import javax.sql.DataSource;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
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
	
	
	@Bean(ConstantStationDemo.TRANSACTIONAL_DATASOURCE_STATION)
	public PlatformTransactionManager transactionBanqueBean(final ApplicationContext appContext){
		return new DataSourceTransactionManager(appContext.getBean(ConstantStationDemo.DATASOURCE_STATION, DataSource.class));
	}


}
