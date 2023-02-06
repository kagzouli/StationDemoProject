package com.exakaconsulting.poc.security;


import java.util.Arrays;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.core.GrantedAuthorityDefaults;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;


@Configuration
@EnableWebSecurity
@EnableMethodSecurity(securedEnabled = true, prePostEnabled = true, jsr250Enabled = true)
public class StationSecurityConfig  {
	
	
	@Autowired
    private JWTUnauthorizedAuthentEntryPoint unauthorizedHandler;

	@Autowired
	private JwtAuthenticationProvider authenticationProvider;


	@Bean
    public AuthenticationManager authenticationManager() throws Exception {

        return new ProviderManager(Arrays.asList(authenticationProvider));
    }

    @Bean
    public JwtAuthenticationTokenFilter authenticationTokenFilterBean() throws Exception {
        JwtAuthenticationTokenFilter authenticationTokenFilter = new JwtAuthenticationTokenFilter();
        authenticationTokenFilter.setAuthenticationManager(authenticationManager());
        authenticationTokenFilter.setAuthenticationSuccessHandler(new JwtAuthenticationSuccessHandler());
        return authenticationTokenFilter;
    }
    
    @Bean
    GrantedAuthorityDefaults grantedAuthorityDefaults() {
        return new GrantedAuthorityDefaults(""); // Remove the ROLE_ prefix
    }


    @Bean
    @Order(1)
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		
		return http.httpBasic().disable().
			   //addFilterBefore(this.authenticationTokenFilterBean(), UsernamePasswordAuthenticationFilter.class).
			   cors(cors -> cors.disable()).
			 //  formLogin(formLogin -> formLogin.disable()).
			   exceptionHandling().authenticationEntryPoint(unauthorizedHandler).and()
			 //  .csrf(csrf -> csrf.disable())
				.authorizeHttpRequests
				(requests -> 
				requests
				        .requestMatchers(HttpMethod.GET,"/health").permitAll()
				        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
				        .anyRequest().authenticated() 
				        
				 ).build();
		
	}
	
	


}
