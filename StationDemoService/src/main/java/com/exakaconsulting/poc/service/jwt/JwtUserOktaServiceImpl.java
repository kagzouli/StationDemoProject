package com.exakaconsulting.poc.service.jwt;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.nimbusds.oauth2.sdk.ParseException;
import com.okta.jwt.JoseException;
import com.okta.jwt.Jwt;
import com.okta.jwt.JwtHelper;
import com.okta.jwt.JwtVerifier;

import net.minidev.json.JSONArray;

import static com.exakaconsulting.poc.service.IConstantStationDemo.JWT_USER_OKTA_SERVICE;

import java.io.IOException;
import java.util.Map;

import org.springframework.util.Assert;


@Service
public class JwtUserOktaServiceImpl implements IJwtUserService {
	
	/** Logger **/
	private static final Logger LOGGER = LoggerFactory.getLogger(JwtUserOktaServiceImpl.class);


	@Value("${okta.issuerUrl}")
	private String issuerUrl;

	@Value("${okta.clientId}")
	private String oktaClientId;
	
	@Override
	public JwtUserDto parseToken(String token) {
		
		JwtUserDto jwtUserDto = null;
		try {
			
			// Initialise the JWT Verifier
			final JwtVerifier jwtVerifier = JwtUserOktaVerifierHolder.getInstance().getInstanceJwtVerifier(this.issuerUrl , this.oktaClientId);
			Assert.notNull(jwtVerifier, "The JWT verifier must be initialized.");
			
			final Jwt jwt = jwtVerifier.decodeAccessToken(token);
			Map<String, Object> claims = jwt.getClaims();
			
			if (claims != null && !claims.isEmpty()){
				jwtUserDto = new JwtUserDto();
				
				jwtUserDto.setUsername((String) claims.get("sub"));
				
				final JSONArray jsonArrayGroups = (JSONArray) claims.get("groups");
				if (jsonArrayGroups != null && !jsonArrayGroups.isEmpty()){
					jwtUserDto.setRole((String) jsonArrayGroups.get(0));
				}
			}
			
			
		} catch (Exception exception) {
			// We don't throw the exception.
			LOGGER.error(exception.getMessage(), exception);

		}
		
		
		return jwtUserDto;
	}
	
	
	

}
