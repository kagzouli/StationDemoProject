package com.exakaconsulting.poc.service.jwt;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.exakaconsulting.poc.service.TechnicalException;
import com.nimbusds.oauth2.sdk.ParseException;
import com.okta.jwt.JwtHelper;
import com.okta.jwt.JwtVerifier;

/**
 * Single to hold the okta verifiers.<br/>
 * 
 * @author Toto
 *
 */
public class JwtUserOktaVerifierHolder {
	
	 private static final Logger LOGGER = LoggerFactory.getLogger(JwtUserOktaVerifierHolder.class);

	
	private static final JwtUserOktaVerifierHolder INSTANCE = new JwtUserOktaVerifierHolder();

	private static Map<String , JwtVerifier> mapJwtVerifiers = new HashMap<>();
	
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
	protected synchronized JwtVerifier getInstanceJwtVerifier(final String issuerUrl , final String oktaClientId){
		
		// Generate the key associated to this 2 parameters
		final String keyCache = issuerUrl + "/" + oktaClientId;
		
		
		return mapJwtVerifiers.computeIfAbsent(keyCache, jwtVerifier->  {
				try {
					return new JwtHelper()
						    .setIssuerUrl(issuerUrl)
						    .setAudience("api://default")  
						    .setConnectionTimeout(1000)    
						    .setReadTimeout(1000)          
						    .setClientId(oktaClientId) 
						    .build();
				} catch (ParseException | IOException exception) {
					LOGGER.error(exception.getMessage());
					throw new TechnicalException(exception);
				}
		});
		
	}
}
