package com.openq.geocode;

/**
 * This exception is raised if the geocoding service cannot find the specified address
 * 
 * @author Amit Arora
 */
public class AddressNotFoundException extends Exception {
	public AddressNotFoundException(String message) {
		super(message);
	}
	
	public AddressNotFoundException(Throwable exception) {
		super(exception);
	}
	
	public AddressNotFoundException(String message, Throwable exception) {
		super(message, exception);
	}
}
