package com.exakaconsulting.poc;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@ComponentScan({"com.exakaconsulting.poc.service" , "com.exakaconsulting.poc.web."})
@EnableSwagger2
public class Application {
	
	/** For swagger-ui **/
	@Bean
	public Docket banqueSwaggerApi(){
		return new Docket(DocumentationType.SWAGGER_2).select().apis(RequestHandlerSelectors.basePackage("com.exakaconsulting.poc.web"))
				/*.paths(PathSelectors.regex("/*"))*/
				.build();
	}


}
