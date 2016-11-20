package com.openq.geocode;

/**
 * This exception is raised if :
 * <ul>
 * <li> All of address1, city, state and country are not specified in the UserAddress
 * <li> The provided cannot be parsed by the geocoder service
 * </ul>
 * 
 * @author Amit Arora
 */
public class UnparsableAddressException extends Exception {
	public UnparsableAddressException(String message) {
		super(message);
	}
	
	public UnparsableAddressException(Throwable exception) {
		super(exception);
	}
	
	public UnparsableAddressException(String message, Throwable exception) {
		super(message, exception);
	}
}
