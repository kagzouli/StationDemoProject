package com.exakaconsulting.poc.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.core.GrantedAuthorityDefaults;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.stereotype.Component;

@Component
@Configuration
@EnableWebSecurity
@EnableMethodSecurity(securedEnabled = true, prePostEnabled = true, jsr250Enabled = true)
public class StationSecurityConfig {
	
	@Autowired
    private JWTUnauthorizedAuthentEntryPoint unauthorizedHandler;

	@Autowired
	private JwtAuthenticationTokenFilter jwtAuthenticationFilter;

	@Autowired
	private JwtAuthenticationProvider authenticationProvider;


	@Bean
	GrantedAuthorityDefaults grantedAuthorityDefaults() {
		return new GrantedAuthorityDefaults(""); // Remove the ROLE_ prefix
	}

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
	    http
	        // Disable form login
	        .formLogin(formLogin -> formLogin.disable())

	        // Disable CSRF (needed for stateless JWT)
	        .csrf(csrf -> csrf.disable())

	        // Authorization rules
	        .authorizeHttpRequests(auth -> auth
	            .requestMatchers(HttpMethod.GET, "/health").permitAll()
	            .requestMatchers("/actuator/**").permitAll() // includes /actuator
	            .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
	            .requestMatchers(HttpMethod.GET, "/v3/api-docs.yaml").permitAll()
	            .anyRequest().authenticated()
	        )

	        // Stateless session (JWT)
	        .sessionManagement(session -> session
	            .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
	        )

	        // Authentication provider
	        .authenticationProvider(authenticationProvider)

	        // JWT filter before UsernamePasswordAuthenticationFilter
	        .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)

	        // Custom unauthorized handler
	        .exceptionHandling(exceptions -> exceptions
	            .authenticationEntryPoint(unauthorizedHandler)
	        );

	    return http.build();
	}


}
