package com.exakaconsulting.poc;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Application {
	
	/** For swagger-ui **/
	@Bean
	public Docket banqueSwaggerApi(){
		return new Docket(DocumentationType.SWAGGER_2).select().apis(RequestHandlerSelectors.basePackage("com.exakaconsulting.poc.web"))
				/*.paths(PathSelectors.regex("/*"))*/
				.build();
	}


}
