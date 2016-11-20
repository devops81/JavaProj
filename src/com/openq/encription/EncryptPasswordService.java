package com.openq.encription;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.naming.ServiceUnavailableException;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import sun.misc.BASE64Encoder;

/**
 * Plain text password is passed as parameter and it returns a encrypted string using SHA-1 encryption algorithm
 * @param  plaintext  user password in plain text
 * @return String     encrypted password
 * @author vaibhav , borrowed from Deepak
 *
 */


public class EncryptPasswordService implements IEncryptPasswordService
{
	public String encryptPassword(String plaintext)	throws ServiceUnavailableException 
	{
		MessageDigest md = null;
		try {
			md = MessageDigest.getInstance("SHA-1");
		} catch (NoSuchAlgorithmException e) {
			throw new ServiceUnavailableException(e.getMessage());
		}
		try {
			md.update(plaintext.getBytes("UTF-8"));
		} catch (UnsupportedEncodingException e) {
			throw new ServiceUnavailableException(e.getMessage());
		}

		byte raw[] = md.digest();
		String hash = (new BASE64Encoder()).encode(raw);
		return hash;
	}
}
