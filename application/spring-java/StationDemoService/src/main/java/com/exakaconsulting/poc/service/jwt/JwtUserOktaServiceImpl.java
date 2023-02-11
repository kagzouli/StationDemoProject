package com.exakaconsulting.poc.service.jwt;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

import com.exakaconsulting.poc.service.ConstantStationDemo;
import com.okta.jwt.AccessTokenVerifier;
import com.okta.jwt.Jwt;

import java.util.List;
import java.util.Map;

import org.springframework.util.Assert;




@Service(ConstantStationDemo.JWT_USER_OKTA_SERVICE)
@Profile({ConstantStationDemo.JWT_USER_OKTA_PROFILE, "default"})
public class JwtUserOktaServiceImpl implements IJwtUserService {
	
	/** Logger **/
	private static final Logger LOGGER = LoggerFactory.getLogger(JwtUserOktaServiceImpl.class);


	@Value("${okta.issuerUrl}")
	private String issuerUrl;
	
	@Override
	public JwtUserDto parseToken(String token) {
		
		JwtUserDto jwtUserDto = null;
		try {
			
			// Initialise the JWT Verifier
			final AccessTokenVerifier jwtVerifier = JwtUserOktaVerifierHolder.getInstance().getInstanceJwtVerifier(this.issuerUrl);
			Assert.notNull(jwtVerifier, "The JWT verifier must be initialized.");
			
			final Jwt jwt = jwtVerifier.decode(token);
			Map<String, Object> claims = jwt.getClaims();
			
			if (claims != null && !claims.isEmpty()){
				jwtUserDto = new JwtUserDto();
				
				jwtUserDto.setUsername((String) claims.get("sub"));
				
				final List<String> listGroups = (List<String>) claims.get("groups");
				if (listGroups != null && !listGroups.isEmpty()){
					jwtUserDto.setRole(listGroups.get(0));
				}
			
			}
			
			
		} catch (Exception exception) {
			// We don't throw the exception.
			LOGGER.error(exception.getMessage(), exception);

		}
		
		
		return jwtUserDto;
	}
	
	
	

}
