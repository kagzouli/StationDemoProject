package com.exakaconsulting.poc;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Profile;

import com.exakaconsulting.poc.service.ConstantStationDemo;
import com.exakaconsulting.poc.service.jwt.IJwtUserService;
import com.exakaconsulting.poc.service.jwt.JwtUserDto;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

@Profile(ConstantStationDemo.JWT_USER_SIMPLE_PROFILE)
public class TestJwtUserSimpleService extends AbstractServiceTest{
	
	@Autowired
	private IJwtUserService jwtUserSimpleService;
	
	
	private static final String INVALID_TOKEN = "InvalidToken";
		
	
	@Test
	public void testInvalidOktaToken(){
		JwtUserDto jwtUserTokenValid = jwtUserSimpleService.parseToken(INVALID_TOKEN);
		assertNull(jwtUserTokenValid);
	}
	

}
