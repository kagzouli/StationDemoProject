package com.exakaconsulting.poc.service.jwt;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.Claim;
import com.auth0.jwt.interfaces.DecodedJWT;

import static com.exakaconsulting.poc.service.IConstantStationDemo.JWT_USER_SIMPLE_SERVICE;
import static com.exakaconsulting.poc.service.IConstantStationDemo.JWT_USER_SIMPLE_PROFILE;


@Service(JWT_USER_SIMPLE_SERVICE)
@Profile({JWT_USER_SIMPLE_PROFILE, "default"})
public class JwtUserSimpleServiceImpl implements IJwtUserService {
	
	/** Logger **/
	private static final Logger LOGGER = LoggerFactory.getLogger(JwtUserSimpleServiceImpl.class);


	@Override
	public JwtUserDto parseToken(String token) {
		JwtUserDto userDto = null;

		try {

			// Normallement, on devrait checker la validite du token
			// openidconnect dans un vrai projet
			DecodedJWT jwt = JWT.decode(token);

			final Map<String, Claim> claims = jwt.getClaims();

			
			// Normallement recuperer par OAUTH - Va etre fait en base pour les
			// tests.
			final String login = claims.get("sub").asString();
			userDto = new JwtUserDto();
			userDto.setUsername(login);

			final List<String> listGroup = claims.get("groups").asList(String.class);
			if (listGroup != null && !listGroup.isEmpty()) {
				userDto.setRole(listGroup.get(0));
			}

		} catch (Exception exception) {
			// We don't throw the exception.
			LOGGER.error(exception.getMessage(), exception);
		}
		return userDto;
	}

}
