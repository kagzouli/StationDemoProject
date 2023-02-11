package com.exakaconsulting.poc.service.jwt;

import java.io.IOException;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

import com.okta.jwt.AccessTokenVerifier;
import com.okta.jwt.JwtVerifiers;

/**
 * Single to hold the okta verifiers.<br/>
 * 
 * @author Toto
 *
 */
public class JwtUserOktaVerifierHolder {
	
	
	private static final JwtUserOktaVerifierHolder INSTANCE = new JwtUserOktaVerifierHolder();

	private static Map<String , AccessTokenVerifier> mapJwtVerifiers = new HashMap<>();
	
	protected JwtUserOktaVerifierHolder(){
		super();
	}
	
	public static JwtUserOktaVerifierHolder getInstance(){
		return INSTANCE;
	}
	
	/**
	 * Method to get the JWT Verifier.<br/>
	 * 
	 * @param issuerUrl
	 * @param oktaClientId
	 * @throws ParseException
	 * @throws IOException
	 */
	protected synchronized AccessTokenVerifier getInstanceJwtVerifier(final String issuerUrl){
		
		// Generate the key associated to this 2 parameters
		final String keyCache = issuerUrl;
		
		
		return mapJwtVerifiers.computeIfAbsent(keyCache, jwtVerifier->  {
			
					return JwtVerifiers.accessTokenVerifierBuilder()
						    .setIssuer(issuerUrl)
			                 // defaults to 'api://default'
						    .setConnectionTimeout(Duration.ofSeconds(5))    // defaults to 5s
						    .setRetryMaxAttempts(2)                     // defaults to 2
						    .setRetryMaxElapsed(Duration.ofSeconds(10)) // defaults to 10s
						    
						    .build();
					/*return new JwtHelper()
						    .setIssuerUrl(issuerUrl)
						    .setAudience("api://default")  
						    .setConnectionTimeout(1000)    
						    .setReadTimeout(1000)          
						    .setClientId(oktaClientId) 
						    .build();*/
				
		});
		
	}
}
