package com.exakaconsulting.poc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication
@PropertySource("classpath:configServices.properties")
public class Batch {
	
	
	 public static void main(String[] args) {
	        SpringApplication.run(Batch.class, args);
	 }

}
