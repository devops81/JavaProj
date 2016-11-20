package com.openq.authorization;

/**
 * This exception is raised if no privilege is found in the System which matches the
 * specified user group, user type, feature triplet
 * 
 * @author Amit Arora
 *
 */
public class PrivilegeNotFoundException extends Exception {
	
	public PrivilegeNotFoundException(String message) {
		super(message);
	}
	
	public PrivilegeNotFoundException(String message, Throwable exception) {
		super(message, exception);
	}
	
	public PrivilegeNotFoundException(Throwable exception) {
		super(exception);
	}
}
