package com.exakaconsulting.poc.service;

import java.security.MessageDigest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import com.exakaconsulting.poc.dao.IUserDao;

import static com.exakaconsulting.poc.service.IConstantStationDemo.USER_SERVICE_DATABASE;
import static com.exakaconsulting.poc.service.IConstantStationDemo.USER_DAO_DATABASE;

/**
 * Service for user on the database.<br/>
 * 
 * @author Toto
 *
 */
@Service(USER_SERVICE_DATABASE)
public class UserServiceDatabaseImpl implements IUserService{
	 private static final Logger LOGGER = LoggerFactory.getLogger(UserServiceDatabaseImpl.class);

	
	/** Cryptage MD5 **/
	protected static final String ENCRYPTION_MD5 = "MD5";

	/** Cryptage SHA-1 **/
	protected static final String ENCRYPTION_SHA_1 = "SHA1";

	@Autowired
	@Qualifier(USER_DAO_DATABASE)
	private IUserDao userDao;

	@Override
	public User findUserByLogin(String login) {
		
		Assert.hasLength(login, "The login must be set");
		
		User user = null;
		try {
			//final String encryptedPassword = this.getPasswordCrypted(password, ENCRYPTION_SHA_1);
			user = userDao.findUserByLogin(login);
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception);
		}
		return user;
	}
	
	
	/**
	 * Methode permettant de crypter le mot de passe.<br/>
	 * @param credential Le mot de passe en clair.<br/>
	 * @param typeEncryption Le type de cryptage (MD5 | SHA1 | TEXT)
	 * @return Retourne le mot de passe crypte.<br/>
	 */
	protected String getPasswordCrypted(final String credential, final String typeEncryption) {

		Assert.hasLength(credential , "The credentiel must be set");
		Assert.hasLength(typeEncryption , "The type of encryption must be set");
		String credentialCrypted = credential;

		try {

			switch(typeEncryption){
				case ENCRYPTION_MD5:
					MessageDigest md = MessageDigest.getInstance("MD5");
					byte[] md5hash = new byte[40];
					md5hash = md.digest(credential.getBytes("UTF-8"));
					credentialCrypted = this.hashToString(md5hash);
					break;
				case ENCRYPTION_SHA_1:
					md = MessageDigest.getInstance("SHA-1");
					byte[] sha1hash = new byte[40];
					sha1hash = md.digest(credential.getBytes("UTF-8"));
					credentialCrypted = this.hashToString(sha1hash);
					break;
				default:
					break;
			}

		} catch (Exception exception) {
			throw new TechnicalException(exception.getMessage());

		}

		return credentialCrypted;
	}


	/**
	 * Method use to get a string corresponding to the hash.<br/>
	 * @param md5hash The hash.<br/>
	 * @return Get a string corresponding to the hash.<br/>
	 */
	protected String hashToString(final byte[] md5hash) {
		StringBuffer hashString = new StringBuffer();

		for (int i = 0; i < md5hash.length; ++i) {
			String hex = Integer.toHexString(md5hash[i]);

			if (hex.length() == 1) {
				hashString.append('0');
				hashString.append(hex.charAt(hex.length() - 1));

			} else {
				hashString.append(hex.substring(hex.length() - 2));
			}

		}
		return hashString.toString();
	}

}
