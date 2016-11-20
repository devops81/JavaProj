package com.openq.geocode;

import java.util.HashMap;

import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.user.UserAddress;

/**
 * The Geocode Service provides a mechanism to convert UserAddress objects into their
 * Geo-code counterparts. 
 * 
 * @author Amit Arora
 */
public interface IGeocodeService {
	
	/**
	 * Given a user address, this routine is used to convert it into the corresponding 
	 * GeocodeAddress.
	 * 
	 * @param address user address that needs to be mapped to it's geo-code counterpart
	 * 
	 * @return GeocodeAddress object corresponding to the input address
	 * 
	 * @throws UnsupportedRegionException if the addresses is in an unsupported region
	 * @throws UnparsableAddressException if the address cannot be parsed by the 
	 * 									  underlying Geocoder Service
	 * @throws AddressNotFoundException if the service was not able to find a match for 
	 * 									the specified address
	 */
	public GeocodeAddress geocode(UserAddress addresses) throws UnsupportedRegionException, 
								UnparsableAddressException, AddressNotFoundException; 
	
	/**
	 * Given a set of user addresses, this routine is used to convert them into their 
	 * geo-code counterparts. 
	 * 
	 * @param addresses an array of user addresses that need to be mapped to their geo-code counterparts
	 * @param ignoreErrors if set to false, any exceptions raised when geo-coding an address would
	 * 					   be propagated, else a null would be set corresponding to such an address 
	 * 
	 * @return an array of GeocodeAddress objects corresponding to the input addresses
	 */
	public GeocodeAddress[] geocode(UserAddress[] addresses, boolean ignoreErrors) 
		throws UnsupportedRegionException, UnparsableAddressException, AddressNotFoundException;
	
	/**
	 * Given a set of experts, this routine is used to convert their addresses into their 
	 * geo-code counterparts. The geocoding process is run in the background.
	 * 
	 * @param experts an array of expert users whose addresses need to be mapped to their 
	 * 		  geo-code counterparts
	 */
	public void geocodeExpertsAsynch(User[] experts);
	
	/**
	 * Get a HashMap of expertIds -> status of geocoding their address
	 * 
	 * @return
	 */
	public HashMap getAsynchGeocodeItemsStatus();
	
	/**
	 * Return the list of countries supported by the concrete implementation of the 
	 * IGeocodeService interface
	 * 
	 * @return list of countries supported by the concrete implementation
	 */
	public String[] getSupportedRegions(); 
	
	/**
	 * This routine is used to check if the specified country is supported by the Geocode 
	 * Service implementation
	 * 
	 * @param country the country to check for
	 * @return
	 */
	public boolean isCountrySupported(String country);
	
	// These are test-hooks
	void setUserService(IUserService userService);
}