package com.exakaconsulting.poc.web;

import static com.exakaconsulting.poc.service.IConstantStationDemo.DATASOURCE_STATION;

import javax.sql.DataSource;

import org.h2.Driver;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.exakaconsulting.poc.AbstractApplication;

@Configuration
public class ApplicationWebTest extends AbstractApplication{
	
	@Bean(DATASOURCE_STATION)
	@Primary
	public DataSource datasource(){
		DriverManagerDataSource banqueDatasource = new DriverManagerDataSource();
		banqueDatasource.setDriverClassName(Driver.class.getName());
		banqueDatasource.setUrl("jdbc:h2:~/data/trafstats1;INIT=create schema if not exists users1\\;RUNSCRIPT FROM 'classpath:db-data-h2-trafstat-test.sql'");
		banqueDatasource.setUsername("sa");
		banqueDatasource.setPassword("");
		return banqueDatasource;

	}

}
