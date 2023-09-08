package com.exakaconsulting.poc;

import org.apache.commons.lang3.StringUtils;
import org.springdoc.core.GroupedOpenApi;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.data.redis.connection.RedisPassword;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.jedis.JedisClientConfiguration;
import org.springframework.data.redis.connection.jedis.JedisClientConfiguration.JedisClientConfigurationBuilder;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import redis.clients.jedis.JedisPoolConfig;



@SpringBootApplication
//@PropertySource("classpath:application.properties")
@EnableTransactionManagement
public class Application extends AbstractApplication {

	@Value("${redis.hostname}")
	private String redisHostname;

	@Value("${redis.port}")
	private Integer redisPort;

	@Value("${redis.password}")
	private String redisSecret;
	
	@Value("${redis.usessl}")
	private Boolean redisUseSsl;
	
	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

	/** For swagger-ui **/
	@Bean
	public GroupedOpenApi  stationSwaggerUi() {

		return GroupedOpenApi.builder()
	              .group("station").
	              packagesToScan("com.exakaconsulting.poc.web")	              
	              .build();
	  
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

	private JedisPoolConfig jedisPoolConfig() {
		JedisPoolConfig config = new JedisPoolConfig();
		config.setMaxTotal(7);
		config.setTestOnBorrow(true);
		config.setTestOnReturn(true);
		return config;
	}

	@Bean
	public JedisConnectionFactory redisConnectionFactory() {
		// Configure the builder
		JedisClientConfigurationBuilder jedisClientConfigurationBuilder = JedisClientConfiguration.builder();

		// Configure the pool for the client.
		jedisClientConfigurationBuilder.usePooling().poolConfig(jedisPoolConfig());
		
		// Use the ssl
		if (redisUseSsl) {
			jedisClientConfigurationBuilder.useSsl();
		}

		// Configure name and port
		RedisStandaloneConfiguration redisStandaloneConfiguration = new RedisStandaloneConfiguration(this.redisHostname,
				this.redisPort);
		
		if (!StringUtils.isBlank(this.redisSecret)) {
			redisStandaloneConfiguration.setPassword(RedisPassword.of(this.redisSecret));
		}
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
