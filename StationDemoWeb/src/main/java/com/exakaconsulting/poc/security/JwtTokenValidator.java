package com.exakaconsulting.poc.security;


import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.Claim;
import com.auth0.jwt.interfaces.DecodedJWT;


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
        	
        	// Normallement, on devrait checker la validite du token openidconnect dans un vrai projet
        	DecodedJWT jwt = JWT.decode(token);
            
        	final Map<String, Claim> claims = jwt.getClaims();
        	
        	LOGGER.info(claims.toString());

        	// Normallement recuperer par OAUTH - Va etre fait en base pour les tests.
        	final String login = claims.get("sub").asString();
            u = new JwtUserDto();
            u.setUsername(login);
            
            final List<String> listGroup = claims.get("groups").asList(String.class);
            if (listGroup != null && !listGroup.isEmpty()){
                u.setRole(listGroup.get(0));           	
            }
           
            
           // u.setRole((String) claims.get("role")); 

        } catch (Exception exception) {
        	LOGGER.error(exception.getMessage(), exception);
            
        }
        return u;
    }
}

