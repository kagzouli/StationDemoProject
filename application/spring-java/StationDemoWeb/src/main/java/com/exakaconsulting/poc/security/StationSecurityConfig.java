package com.exakaconsulting.poc.security;


import java.util.Arrays;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.core.GrantedAuthorityDefaults;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.exakaconsulting.poc.web.StationDemoController;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(securedEnabled = true, prePostEnabled = true, jsr250Enabled = true)
public class StationSecurityConfig  {
	
	/** Logger **/
	private static final Logger LOGGER = LoggerFactory.getLogger(StationSecurityConfig.class);
	
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


	public SecurityFilterChain configure(HttpSecurity http) throws Exception {
		
		HttpSecurity authorizeHttpRequests = http.authorizeHttpRequests((authz) -> {
			try {
				authz
				        .requestMatchers("/health").permitAll()
				        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
				        .anyRequest().authenticated().and().csrf().disable().
				addFilterBefore(this.authenticationTokenFilterBean(), UsernamePasswordAuthenticationFilter.class)
				.exceptionHandling().authenticationEntryPoint(unauthorizedHandler).and().cors();
			} catch (Exception e) {
				LOGGER.error(e.getMessage() ,e );
			}
		});
		
		return http.build();
	}
	
	


}
