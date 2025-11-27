package com.exakaconsulting.poc.service.jwt;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

import com.auth0.jwk.JwkProvider;
import com.auth0.jwk.UrlJwkProvider;
import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.Claim;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.exakaconsulting.poc.service.ConstantStationDemo;
import com.auth0.jwt.interfaces.JWTVerifier;

import java.util.List;
import java.util.Map;

import org.springframework.util.Assert;




@Service(ConstantStationDemo.JWT_USER_OKTA_SERVICE)
@Profile({ConstantStationDemo.JWT_USER_OKTA_PROFILE, "default"})
public class JwtUserOktaServiceImpl implements IJwtUserService {
	
	/** Logger **/
	private static final Logger LOGGER = LoggerFactory.getLogger(JwtUserOktaServiceImpl.class);


	@Value("${okta.issuerDomain}")
	private String issuerDomain;
	
	@Override
	public JwtUserDto parseToken(String token) {
		
		JwtUserDto jwtUserDto = null;
		try {
			
				
			
			final JWTVerifier jwtVerifier = JwtUserOktaVerifierHolder.getInstance().getInstanceJwtVerifier(token, this.issuerDomain);
			Assert.notNull(jwtVerifier, "The JWT verifier must be initialized.");
			
			final DecodedJWT jwt = jwtVerifier.verify(token);
			Map<String, Claim> claims = jwt.getClaims();
			
			if (claims != null && !claims.isEmpty()){
				jwtUserDto = new JwtUserDto();
				jwtUserDto.setUsername(jwt.getClaim("https://station.com/nickname").asString());				
				// Get role
				final List<String> listRoles = jwt.getClaim("https://station.com/roles").asList(String.class);
				if (listRoles != null && !listRoles.isEmpty()){
					jwtUserDto.setRole(listRoles.get(0));
				}
			
			}
			
			
		} catch (Exception exception) {
			// We don't throw the exception.
			LOGGER.error(exception.getMessage(), exception);

		}
		
		
		return jwtUserDto;
	}
	
	
	

}
