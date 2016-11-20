package com.openq.geocode;

/**
 * This exception is raised if the address which has been specified for geo-coding
 * falls in a region which is not supported by the geocode service implementation. Eg -
 * <ul>
 * <li>Geocode US based implementations will throw this exception for addresses in Europe
 * <li>MS Virtual Earth based implementations could throw this exception for addresses in
 * 	   some of the Asian countries as coverage for those is not present yet 
 * </ul>
 * 
 * @author Amit Arora
 */
public class UnsupportedRegionException extends Exception {
	public UnsupportedRegionException(String message) {
		super(message);
	}
	
	public UnsupportedRegionException(Throwable exception) {
		super(exception);
	}
	
	public UnsupportedRegionException(String message, Throwable exception) {
		super(message, exception);
	}
}
