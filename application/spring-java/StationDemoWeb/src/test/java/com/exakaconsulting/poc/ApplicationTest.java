package com.exakaconsulting.poc;


import javax.sql.DataSource;

import org.h2.Driver;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Profile;
import org.springframework.context.annotation.PropertySource;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.transaction.PlatformTransactionManager;

import com.exakaconsulting.poc.service.ConstantStationDemo;

@Configuration
@ComponentScan({"com.exakaconsulting.poc.service" ,  "com.exakaconsulting.poc.dao"})
@PropertySource("classpath:application.properties")
@Profile("test")
public class ApplicationTest {
	
	@Bean(ConstantStationDemo.DATASOURCE_STATION)
	@Primary
	public DataSource datasource(){
		DriverManagerDataSource banqueDatasource = new DriverManagerDataSource();
		banqueDatasource.setDriverClassName(Driver.class.getName());
		banqueDatasource.setUrl("jdbc:h2:~/data/trafstats1test;INIT=create schema if not exists users1\\;RUNSCRIPT FROM 'classpath:db-data-h2-trafstat-test.sql'");
		banqueDatasource.setUsername("sa");
		banqueDatasource.setPassword("");
		return banqueDatasource;

	}
	
	@Bean(ConstantStationDemo.TRANSACTIONAL_DATASOURCE_STATION)
	public PlatformTransactionManager transactionBanqueBean(final ApplicationContext appContext){
		return new DataSourceTransactionManager(appContext.getBean(ConstantStationDemo.DATASOURCE_STATION, DataSource.class));
	}
	



}
