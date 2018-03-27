package com.exakaconsulting.poc.security;

import java.io.IOException;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.nimbusds.oauth2.sdk.ParseException;
import com.okta.jwt.JoseException;
import com.okta.jwt.Jwt;
import com.okta.jwt.JwtHelper;
import com.okta.jwt.JwtVerifier;

@Component
public class JwtTokenValidator {
	
	/** Logger **/
	private static final Logger LOGGER = LoggerFactory.getLogger(JwtTokenValidator.class);




    @Value("${okta.issuerUrl}")
    private String issuerUrl;
  
    @Value("${okta.clientId}")
    private String oktaClientId;
    
   /**
     * Tries to parse specified String as a JWT token. If successful, returns User object with username, id and role prefilled (extracted from token).
     * If unsuccessful (token is invalid or not containing all required user properties), simply returns null.
     *
     * @param token the JWT token to parse
     * @return the User object extracted from specified token or null if a token is invalid.
     */
    public JwtUserDto parseToken(String token) {
    	
    	
    	
        JwtUserDto u = null;

        try {
         	JwtVerifier jwtVerifier = new JwtHelper()
        		    .setIssuerUrl(this.issuerUrl)
        		    .setConnectionTimeout(3000)    // defaults to 1000ms
        		    .setReadTimeout(3000)          // defaults to 1000ms
        		    .setClientId(this.oktaClientId) // optional
        		    .build();
         	
         	Jwt jwt = jwtVerifier.decodeAccessToken(token);
         	if (jwt == null){
         		throw new JwtTokenMalformedException("The token is wrong");
         	}
         	
         	Map<String, Object> claims = jwt.getClaims();

            /*u = new JwtUserDto();
            u.setUsername(body.getSubject());
            u.setId(Long.parseLong((String) body.get("userId")));
            u.setRole((String) body.get("role")); */

        } catch (JwtTokenMalformedException | ParseException | IOException | JoseException exception) {
        	LOGGER.error(exception.getMessage(), exception);
            
        }
        return u;
    }
}

