package com.exakaconsulting.poc;


import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
@ComponentScan({"com.exakaconsulting.poc.service" ,  "com.exakaconsulting.poc.dao"})
@EnableAutoConfiguration
@Profile("test")
public class ApplicationTest {
	
	



}
