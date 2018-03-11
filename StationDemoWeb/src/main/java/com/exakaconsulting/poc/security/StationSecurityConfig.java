package com.exakaconsulting.poc.security;

import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

public class StationSecurityConfig extends WebSecurityConfigurerAdapter {
	
	/* @Bean
	InMemoryUserDetailsManager userDetailsManager() {

		UserBuilder builder = User.withDefaultPasswordEncoder();

		UserDetails administrator = builder.username("administrator").password("adMinisTrator35#").roles("useradministrator").build();
		UserDetails banque = builder.username("banque").password("baNqUe35#").roles("userbank").build();

		return new InMemoryUserDetailsManager(administrator, banque);
	}*/
	
	@Override
	public void configure(WebSecurity web) {
		web.ignoring().antMatchers(HttpMethod.OPTIONS, "/**");
	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests().anyRequest().authenticated().and().httpBasic();
		http.csrf().disable();
		http.cors();
	}


}
