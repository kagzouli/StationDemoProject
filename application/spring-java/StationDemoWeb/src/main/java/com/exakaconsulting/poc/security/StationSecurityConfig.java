package com.exakaconsulting.poc.security;


import java.util.Arrays;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.core.GrantedAuthorityDefaults;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(securedEnabled = true, prePostEnabled = true, jsr250Enabled = true)
public class StationSecurityConfig extends WebSecurityConfigurerAdapter {
	
	@Autowired
    private JWTUnauthorizedAuthentEntryPoint unauthorizedHandler;

	@Autowired
	private JwtAuthenticationProvider authenticationProvider;


	@Bean
    @Override
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

	
	
	@Override
	public void configure(WebSecurity web) {
		web.ignoring().antMatchers(HttpMethod.OPTIONS, "/**").antMatchers("/health");
	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests().antMatchers("/health").permitAll().
		anyRequest().authenticated().and().
		addFilterBefore(this.authenticationTokenFilterBean(), UsernamePasswordAuthenticationFilter.class)
		.csrf().disable().
		exceptionHandling().authenticationEntryPoint(unauthorizedHandler).and().cors();
	}
	
	


}
