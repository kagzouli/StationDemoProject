package com.exakaconsulting.poc;

import static com.exakaconsulting.poc.service.IConstantStationDemo.DATASOURCE_STATION;
import static com.exakaconsulting.poc.service.IConstantStationDemo.TRANSACTIONAL_DATASOURCE_STATION;

import javax.sql.DataSource;

import org.h2.Driver;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.transaction.PlatformTransactionManager;

@Configuration
@ComponentScan({"com.exakaconsulting.poc.service" ,  "com.exakaconsulting.poc.dao"})
public class ApplicationTest {
	
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
	
	@Bean(TRANSACTIONAL_DATASOURCE_STATION)
	public PlatformTransactionManager transactionBanqueBean(final ApplicationContext appContext){
		return new DataSourceTransactionManager(appContext.getBean(DATASOURCE_STATION, DataSource.class));
	}


}
