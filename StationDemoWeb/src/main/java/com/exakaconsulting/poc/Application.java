package com.exakaconsulting.poc;

import com.exakaconsulting.poc.service.ConstantStationDemo;

import redis.clients.jedis.JedisPoolConfig;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.data.redis.connection.RedisPassword;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.jedis.JedisClientConfiguration;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.connection.jedis.JedisClientConfiguration.JedisClientConfigurationBuilder;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.jdbc.datasource.lookup.JndiDataSourceLookup;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
// @Import(StationSecurityConfig.class)
@PropertySource("classpath:application.properties")
@EnableTransactionManagement
public class Application extends AbstractApplication {

	@Value("${redis.hostname}")
	private String redisHostname;

	@Value("${redis.port}")
	private Integer redisPort;

	@Value("${redis.password}")
	private String redisSecret;

	/** For swagger-ui **/
	@Bean
	public Docket banqueSwaggerApi() {
		return new Docket(DocumentationType.SWAGGER_2).select()
				.apis(RequestHandlerSelectors.basePackage("com.exakaconsulting.poc.web"))
				/* .paths(PathSelectors.regex("/*")) */
				.build();
	}

	@Bean(ConstantStationDemo.DATASOURCE_STATION)
	@Primary
	public DataSource datasource() {
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

	private JedisPoolConfig jedisPoolConfig() {
		JedisPoolConfig config = new JedisPoolConfig();
		config.setMaxTotal(5);
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

		// Configure name and port
		RedisStandaloneConfiguration redisStandaloneConfiguration = new RedisStandaloneConfiguration(this.redisHostname,
				this.redisPort);
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
