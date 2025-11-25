package com.exakaconsulting.poc.service.jwt;

import java.io.IOException;
import java.security.interfaces.RSAPublicKey;
import java.util.HashMap;
import java.util.Map;

import com.auth0.jwk.Jwk;
import com.auth0.jwk.JwkException;
import com.auth0.jwk.JwkProvider;
import com.auth0.jwk.UrlJwkProvider;
import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.JWTVerifier;
import com.exakaconsulting.poc.security.exception.JwtTokenMalformedException;

/**
 * Single to hold the okta verifiers.<br/>
 * 
 * @author Toto
 *
 */
public class JwtUserOktaVerifierHolder {

	private static final JwtUserOktaVerifierHolder INSTANCE = new JwtUserOktaVerifierHolder();

	private static Map<String, JWTVerifier> mapJwtVerifiers = new HashMap<>();

	protected JwtUserOktaVerifierHolder() {
		super();
	}

	public static JwtUserOktaVerifierHolder getInstance() {
		return INSTANCE;
	}

	/**
	 * Method to get the JWT Verifier.<br/>
	 * 
	 * @param issuerDomain
	 * @param oktaClientId
	 * @throws ParseException
	 * @throws IOException
	 */
	protected synchronized JWTVerifier getInstanceJwtVerifier(final String token,final String issuerDomain) {

		// Generate the key associated to this 2 parameters
		final String keyCache = token + "-" + issuerDomain;

		return mapJwtVerifiers.computeIfAbsent(keyCache, jwtVerifier -> {

			// Initialise the JWT Verifier
			JwkProvider provider = new UrlJwkProvider(issuerDomain);
			DecodedJWT jwt = JWT.decode(token);
			JWTVerifier jwtVerifierTemp = null;
			try {
				Jwk jwk = provider.get(jwt.getKeyId());
				Algorithm algorithm = Algorithm.RSA256((RSAPublicKey) jwk.getPublicKey(), null);

				jwtVerifierTemp =  JWT.require(algorithm).withIssuer(issuerDomain + "/").withAudience(issuerDomain + "/api/v2/")
						.build();
			} catch (JwkException exception) {
				throw new JwtTokenMalformedException(exception.getMessage());
			}
			return jwtVerifierTemp;
			

		});

	}
}
