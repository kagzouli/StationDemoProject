package com.exakaconsulting.poc;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Profile;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import com.exakaconsulting.poc.service.TrafficStationBean;

@Configuration
@ComponentScan({ "com.exakaconsulting.poc.service", "com.exakaconsulting.poc.dao" })
@EnableAutoConfiguration
@Profile("test")
public class ApplicationTest {

	@Bean
	@Primary
	public RedisTemplate<String, TrafficStationBean> redisTemplate() {
		RedisTemplate<String, TrafficStationBean> template = mock(RedisTemplate.class);
		ValueOperations<String, TrafficStationBean> valueOps = mock(ValueOperations.class);
		when(template.opsForValue()).thenReturn(valueOps);
		return template;
	}

}
