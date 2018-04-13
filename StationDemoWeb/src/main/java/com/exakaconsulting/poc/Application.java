package com.exakaconsulting.poc;

import com.exakaconsulting.poc.service.ConstantStationDemo;

import javax.sql.DataSource;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.jdbc.datasource.lookup.JndiDataSourceLookup;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
// @Import(StationSecurityConfig.class)
@PropertySource("classpath:configServices.properties")
@EnableTransactionManagement
public class Application extends AbstractApplication{
	
	/** For swagger-ui **/
	@Bean
	public Docket banqueSwaggerApi(){
		return new Docket(DocumentationType.SWAGGER_2).select().apis(RequestHandlerSelectors.basePackage("com.exakaconsulting.poc.web"))
				/*.paths(PathSelectors.regex("/*"))*/
				.build();
	}
	
		
	@Bean(ConstantStationDemo.DATASOURCE_STATION)
	@Primary
	public DataSource datasource(){
		JndiDataSourceLookup jndiBanqueDatasourceLookup = new JndiDataSourceLookup();
		return jndiBanqueDatasourceLookup.getDataSource("java:comp/env/jdbc/StationDemoDb");
	}
	
    @Bean
    public MessageSource messageSource() {
        ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
        messageSource.setBasename("classpath:/message");
        messageSource.setDefaultEncoding("UTF-8");
        messageSource.setUseCodeAsDefaultMessage(true);
        return messageSource;
    }
    
    @Bean 
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
    return new PropertySourcesPlaceholderConfigurer();
    }
    
    
	
}
