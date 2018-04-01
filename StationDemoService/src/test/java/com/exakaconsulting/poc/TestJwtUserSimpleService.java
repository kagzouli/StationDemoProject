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
	
	private static final String VALID_TOKEN = "eyJraWQiOiJ2S2stYTdDMnpHaV8tME0yM0FZVDNvUi05dHVwX1RZbE1CcmlNckhpNkNnIiwiYWxnIjoiUlMyNTYifQ.eyJ2ZXIiOjEsImp0aSI6IkFULmJmc1lBZEloX2V5MXN0QXJmOTZfYTFNMEpCZl8zSjNrUVVzMnhRUkJlV1kiLCJpc3MiOiJodHRwczovL2Rldi04ODQyNTQub2t0YXByZXZpZXcuY29tL29hdXRoMi9kZWZhdWx0IiwiYXVkIjoiYXBpOi8vZGVmYXVsdCIsImlhdCI6MTUyMjU2NTM2MywiZXhwIjoxNTIyNTY4OTYzLCJjaWQiOiIwb2FlZzN5Z2hhTDltUWFsejBoNyIsInVpZCI6IjAwdWVncm50NHBtM3JWaXpLMGg3Iiwic2NwIjpbInByb2ZpbGUiLCJvcGVuaWQiLCJlbWFpbCJdLCJzdWIiOiJkaWRpZXJAZXhha2EuY29tIiwiZ3JvdXBzIjpbInVzZXIiXSwibG9jYWxlIjoiZW5fVVMifQ.cTUaawxZIiVdpO07kjCmwmAxoLYOb7AOYzJzXi0r0PjGSNkjAwVUUw5xCiQbBynPJI8EBupLTQGRVbVRqJM1ZB7V_QyKbNI6f4_26q5hx_X8_663BRN5nOWvX-dNu6iQAd7FlV5KA2C0w0NOzWZ4Mp5QdDfyeaS1QLjTC7un8i7lsgCkT3stRLtbcsqIoVp9hoQHaYZkbvNDDNwiLrURY9I4uHGruDofjI6-VKweNVGyYnSgJrll8spUtiEcVJTLM9dtsPy26clkts5AZ02mj9mpA52I8NFJy-CisdeIsonL1bsRWvoF_-70LRDmDlsYBl5osCZSYum3S8fdWRyB-A";
	
	private static final String INVALID_TOKEN = "InvalidToken";
	
	private static final String USER_TOKEN_VALID = "didier@exaka.com";
	private static final String ROLE_TOKEN_VALID = "user";
	
	@Test
	public void testValidOktaToken(){
		JwtUserDto jwtUserTokenValid = jwtUserSimpleService.parseToken(VALID_TOKEN);
		assertNotNull(jwtUserTokenValid);
		assertEquals(USER_TOKEN_VALID, jwtUserTokenValid.getUsername());
		assertEquals(ROLE_TOKEN_VALID, jwtUserTokenValid.getRole());
	}
	
	@Test
	public void testInvalidOktaToken(){
		JwtUserDto jwtUserTokenValid = jwtUserSimpleService.parseToken(INVALID_TOKEN);
		assertNull(jwtUserTokenValid);
	}
	

}
