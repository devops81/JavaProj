package com.openq.utils;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import sun.misc.BASE64Encoder;

/**
 * Utility to encrypt the plainText into cipherText
 * 
 * @author Tarun
 * 
 */
public class EncryptionUtil {

    public static String encrypt(final String message)
            throws EncryptionException {
        MessageDigest messageDigest = null;
        try {
            messageDigest = MessageDigest.getInstance("SHA-1");
            messageDigest.update(message.getBytes("UTF-8"));
        } catch (NoSuchAlgorithmException e) {
            throw new EncryptionException(e);
        } catch (UnsupportedEncodingException e) {
            throw new EncryptionException(e);
        }
        final byte raw[] = messageDigest.digest();
        return new BASE64Encoder().encode(raw);
    }

    public static class EncryptionException extends Exception {
        public EncryptionException(final Throwable cause) {
            super(cause);
        }
    }
    
    private EncryptionUtil(){
        
    }

}
