package com.exakaconsulting.poc.service.jwt;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

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
	protected synchronized JwtVerifier getInstanceJwtVerifier(final String issuerUrl , final String oktaClientId) throws ParseException, IOException{
		
		// Generate the key associated to this 2 parameters
		final String keyCache = issuerUrl + "/" + oktaClientId;
		
		JwtVerifier jwtVerifier = mapJwtVerifiers.get(keyCache);
		if (jwtVerifier == null){
			jwtVerifier = new JwtHelper()
				    .setIssuerUrl(issuerUrl)
				    .setAudience("api://default")  
				    .setConnectionTimeout(1000)    
				    .setReadTimeout(1000)          
				    .setClientId(oktaClientId) 
				    .build();
			mapJwtVerifiers.put(keyCache, jwtVerifier);

		}
		return jwtVerifier;
	}
}
