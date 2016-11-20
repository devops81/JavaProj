package com.openq.authorization;

/**
 * This Exception is thrown if an attempt is made to set a new privilege which is not 
 * compatible with some of the existing privileges in the system
 * 
 * @author Amit Arora
 *
 */
public class NonCompatiblePrivilegeException extends Exception {
	
	public NonCompatiblePrivilegeException(String message) {
		super(message);
	}
	
	public NonCompatiblePrivilegeException(String message, Throwable exception) {
		super(message, exception);
	}
	
	public NonCompatiblePrivilegeException(Throwable exception) {
		super(exception);
	}
}