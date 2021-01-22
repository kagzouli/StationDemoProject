package com.exakaconsulting.poc;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisPassword;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.jedis.JedisClientConfiguration;
import org.springframework.data.redis.connection.jedis.JedisClientConfiguration.JedisClientConfigurationBuilder;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import redis.clients.jedis.JedisPoolConfig;
@Configuration
public class RedisConfiguration {
		
	@Value("${redis.hostname}")
	private String redisHostname;

	@Value("${redis.port}")
	private Integer redisPort;
	
	@Value("${redis.password}")	
	private String redisSecret;


	@Bean
	private JedisPoolConfig jedisPoolConfig() {
		JedisPoolConfig config = new JedisPoolConfig();
		config.setMaxTotal(5);
		config.setTestOnBorrow(true);
		config.setTestOnReturn(true);
		return config;
	}
	
	@Bean
	private JedisConnectionFactory redisConnectionFactory() {
		// Configure the builder
		JedisClientConfigurationBuilder jedisClientConfigurationBuilder = JedisClientConfiguration.builder();
		
		// Configure the pool for the client.
		jedisClientConfigurationBuilder.usePooling().poolConfig(jedisPoolConfig());

		// Configure name and port
		RedisStandaloneConfiguration redisStandaloneConfiguration = new RedisStandaloneConfiguration(this.redisHostname, this.redisPort);
	    redisStandaloneConfiguration.setPassword(RedisPassword.of(this.redisSecret));
	    return new JedisConnectionFactory(redisStandaloneConfiguration, jedisClientConfigurationBuilder.build());
	}

	@Bean
	public RedisTemplate<?, ?> redisTemplate() {
		final RedisTemplate<?, ?> redisTemplate = new RedisTemplate<>();
		redisTemplate.setConnectionFactory(redisConnectionFactory());
		redisTemplate.setEnableTransactionSupport(true);
		redisTemplate.setKeySerializer(new StringRedisSerializer());
		redisTemplate.setValueSerializer(new GenericJackson2JsonRedisSerializer());
		return redisTemplate;
	}
	

}
