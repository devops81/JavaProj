package com.openq.geocode;

import java.rmi.RemoteException;

import javax.xml.rpc.ServiceException;

import us.geocoder.rpc.Geo.Coder.US.GeoCode_BindingStub;
import us.geocoder.rpc.Geo.Coder.US.GeoCode_ServiceLocator;
import us.geocoder.rpc.Geo.Coder.US.GeocoderAddressResult;


import com.openq.user.UserAddress;

/**
 * This class provides a concrete implementation of the com.openq.geocode.IGeocodeService
 * by using the Geocoder US webservice
 * 
 * @see com.openq.geocode.IGeocodeService
 * 
 * @author Amit Arora
 *
 */
public class GeocoderUSGeocodeService extends OpenQGeocodeService {

	private static final String[] SUPPORTED_REGIONS = {"United States", "US", "USA", "United States of America"};
	
	/**
	 * @see IGeocodeService#geocode(UserAddress)
	 */
	public GeocodeAddress geocode(UserAddress address) throws UnsupportedRegionException, 
						UnparsableAddressException, AddressNotFoundException {
		GeocodeAddress geoAdd = null;
		
		// First check if the address is valid
		if(isValidAddress(address)) {
			String completeAddress = getCompleteAddress(address);
			
	        try {
				GeoCode_BindingStub binding = (GeoCode_BindingStub) new GeoCode_ServiceLocator().getGeoCode_Port();
		        binding.setTimeout(60000); // Time out after a minute
				
		        GeocoderAddressResult[] values = binding.geocode_address(completeAddress);
				if(values.length == 0){
					// If the address cannot be parsed, an empty list is returned 
					// by the Geocoder US service
					throw new UnparsableAddressException(completeAddress + " cannot be parsed by the Geocoder US service");
				}
				else {
					//some values are returned by Geocoder US, we will use the first one

					// check if the service was unable to find a match for the specified address
					if((values[0].getLat() == 0) && (values[0].get_long() == 0))
						throw new AddressNotFoundException(completeAddress + " was not found by the Geocoder US service");
					
					// The address was found, so return it
					geoAdd = new GeocodeAddress(values[0].getLat(), values[0].get_long(), completeAddress);
				}
			} 
	        catch (RemoteException e) {
				throw new IllegalStateException("Could not contact the Geocoder US service");
			}
	        catch (ServiceException e) {
				throw new IllegalStateException("Could not contact the Geocoder US service");
			}
		}
		
		return geoAdd;
	}
	
	/**
	 * @see IGeocodeService#isCountrySupported(String)
	 */
	public boolean isCountrySupported(String country) {
		if(country == null)
			throw new IllegalArgumentException("Must specify a valid country");
		
		for(int i=0; i<SUPPORTED_REGIONS.length; i++) {
			if(country.equalsIgnoreCase(SUPPORTED_REGIONS[i]))
				return true;
		}
		
		return false;
	}
	
	/**
	 * @see IGeocodeService#getSupportedRegions()
	 */
	public String[] getSupportedRegions() {
		return SUPPORTED_REGIONS;
	}
}
