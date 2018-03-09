package com.exakaconsulting.poc;

import javax.sql.DataSource;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.lookup.JndiDataSourceLookup;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;


import static com.exakaconsulting.poc.service.IConstantStationDemo.DATASOURCE_STATION;
import static com.exakaconsulting.poc.service.IConstantStationDemo.TRANSACTIONAL_DATASOURCE_STATION;


import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@ComponentScan({"com.exakaconsulting.poc.service" , "com.exakaconsulting.poc.web", "com.exakaconsulting.poc.dao"})
@EnableWebMvc
@EnableSwagger2
public class Application implements WebMvcConfigurer{
	
	/** For swagger-ui **/
	@Bean
	public Docket banqueSwaggerApi(){
		return new Docket(DocumentationType.SWAGGER_2).select().apis(RequestHandlerSelectors.basePackage("com.exakaconsulting.poc.web"))
				/*.paths(PathSelectors.regex("/*"))*/
				.build();
	}
	
	
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
	    registry.addResourceHandler("swagger-ui.html")
	      .addResourceLocations("classpath:/META-INF/resources/");
	 
	    registry.addResourceHandler("/webjars/**")
	      .addResourceLocations("classpath:/META-INF/resources/webjars/");
	}
	
	@Bean(DATASOURCE_STATION)
	@Primary
	public DataSource datasource(){
		JndiDataSourceLookup jndiBanqueDatasourceLookup = new JndiDataSourceLookup();
		return jndiBanqueDatasourceLookup.getDataSource("java:comp/env/jdbc/StationDemoDb");
	}
	
	@Bean(TRANSACTIONAL_DATASOURCE_STATION)
	public PlatformTransactionManager transactionBanqueBean(final ApplicationContext appContext){
		return new DataSourceTransactionManager(appContext.getBean(TRANSACTIONAL_DATASOURCE_STATION, DataSource.class));
	}


}
