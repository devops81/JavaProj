package com.openq.geocode;

import java.net.MalformedURLException;
import java.rmi.RemoteException;
import java.util.HashMap;
import java.util.Iterator;

import javax.xml.rpc.ServiceException;

import net.mappoint.s.mappoint_30.Address;
import net.mappoint.s.mappoint_30.FindAddressSpecification;
import net.mappoint.s.mappoint_30.FindResults;
import net.mappoint.s.mappoint_30.FindServiceLocator;
import net.mappoint.s.mappoint_30.FindServiceSoap;
import net.mappoint.s.mappoint_30.FindServiceSoapStub;
import net.mappoint.s.mappoint_30.Location;

import org.apache.log4j.Logger;

import com.openq.user.UserAddress;

/**
 * This class provides a concrete implementation of the com.openq.geocode.IGeocodeService
 * by using the MS Mappoint webservice
 * 
 * @see com.openq.geocode.IGeocodeService
 * 
 * @author Amit Arora
 *
 */
public class MSMapPointGeocodeService extends OpenQGeocodeService {
	
	private static Logger logger = Logger.getLogger(MSMapPointGeocodeService.class);
	
	private FindServiceSoap findService = null;
	
	/**
	 * The username to use with the MS Mappoint service
	 */
	private static String userName = "122658";
	
	/**
	 * Password for the MS Mappoint WS account
	 */
	private static String password = "Openq-1234";
	
	/**
	 * Maintain a map of supported countries and the corresponding MapPoint Data Source to use
	 */
	private static HashMap countryDataSourceMap = new HashMap();
	
	static {
		// Add all the countries that are supported in Europe
		countryDataSourceMap.put("Austria".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Belgium".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Czech Republic".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Denmark".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Finland".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("France".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Germany".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Italy".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Luxembourg".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("The Netherlands".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Norway".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Portugal".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Spain".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Sweden".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Switzerland".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("Greece".toUpperCase(), "MapPoint.EU");
		countryDataSourceMap.put("United Kingdom".toUpperCase(), "MapPoint.EU");
		
		// Add all the different name combinations of US to be mapped to North America
		countryDataSourceMap.put("United States".toUpperCase(), "MapPoint.NA");
		countryDataSourceMap.put("US".toUpperCase(), "MapPoint.NA");
		countryDataSourceMap.put("USA".toUpperCase(), "MapPoint.NA");
		countryDataSourceMap.put("United States of America".toUpperCase(), "MapPoint.NA");
		
		// Other countries in the world
		countryDataSourceMap.put("India".toUpperCase(), "MapPoint.World");
	}
	
	/**
	 * Instantiate the underlying MS Mappoint Finder service
	 * 
	 * @throws MalformedURLException
	 * @throws ServiceException
	 */
	public MSMapPointGeocodeService() throws MalformedURLException, ServiceException {		
		findService = new FindServiceLocator().getFindServiceSoap();
	    
	    ((FindServiceSoapStub) findService).setUsername(userName);
	    ((FindServiceSoapStub) findService).setPassword(password);
	}
	
	/**
	 * @see IGeocodeService#geocode(UserAddress)
	 */
	public GeocodeAddress geocode(UserAddress userAddress)
			throws UnsupportedRegionException, UnparsableAddressException,
			AddressNotFoundException {
		
		GeocodeAddress geoAdd = null;
		
		// First check if this is a valid address
		if(isValidAddress(userAddress)) {
		
			// Set the data source that corresponds to the given country
		    FindAddressSpecification findSpec = new FindAddressSpecification();
		    
		    String dataSourceName = (String) countryDataSourceMap.get(userAddress.getCountry().getOptValue().toUpperCase());
		    findSpec.setDataSourceName(dataSourceName);
	
		    // Construct an Address from the various fields.
		    Address address = null;
		    
		    
		    String country = userAddress.getCountry().getOptValue();
		    
		    // US only
		    if((country.equalsIgnoreCase("US")) || (country.equalsIgnoreCase("United States")) ||
		    		(country.equalsIgnoreCase("USA")) || (country.equalsIgnoreCase("United States of America"))){
		    	address = getUSSearchableAddress(userAddress);
		    }
		    else if(country.equals("United Kingdom")) {
		    	address = getUKSearchableAddress(userAddress);
		    }
		    else {
		    	address = getEuropeSearchableAddress(userAddress);
		    }
		    
		    address.setCountryRegion(userAddress.getCountry().getOptValue());
		    findSpec.setInputAddress(address);
		    
		    // Call the MapPoint .NET server to find the specified address
		    FindResults results = null;
		    try {
			    results = findService.findAddress(findSpec);
		    }
		    catch(RemoteException e) {
		    	// There was a problem accessing the MS MapPoint Web Service
		    	logger.error(e);
		    	throw new IllegalStateException("Could not contact the MS MapPoint service");
		    }
		    
			Location location = null;
		      
		    if ((results == null) || (results.getNumberFound() == 0)) {
		    	// not found
		    	throw new AddressNotFoundException(getCompleteAddress(userAddress) + " was not found by the MS MapPoint service");
		    } 
		    else {
		      // get first result
		      location = results.getResults()[0].getFoundLocation();
		      String completeAddress = getCompleteAddress(userAddress);
		      geoAdd = new GeocodeAddress(location.getLatLong().getLatitude().doubleValue(), location.getLatLong().getLongitude().doubleValue(), completeAddress);
		    }
		}
		return geoAdd;
	}

	/**
	 * @see IGeocodeService#getSupportedRegions()
	 */
	public String[] getSupportedRegions() {
		String[] supportedRegions = new String[countryDataSourceMap.size()];
		Iterator iter = countryDataSourceMap.keySet().iterator();
		int index = 0;
		while(iter.hasNext()) {
			supportedRegions[index++] = (String) iter.next();
		}
		
		return supportedRegions;
	}

	/**
	 * @see IGeocodeService#isCountrySupported(String)
	 */
	public boolean isCountrySupported(String country) {
		Object dataSourceForCountry = countryDataSourceMap.get(country.toUpperCase());
		if(dataSourceForCountry == null)
			return false; // The country is not defined in the map, hence it is not supported
		
		return true; // We found a corresponding data source for the country, and hence it is supported
	}
	
	/**
	 * Create a new Address object with all relevant fields set that are required for geocoding a valid US address
	 * 
	 * @param userAddress
	 * @return
	 */
	private Address getUSSearchableAddress(UserAddress userAddress) {
		Address address = new Address();
		address.setAddressLine(getAddressLine(userAddress));
	    address.setPrimaryCity(userAddress.getCity());
    	
	    if(userAddress.getState() != null)
	    	address.setSubdivision(userAddress.getState().getOptValue());
	    
    	if((userAddress.getZip() != null) && (!userAddress.getZip().equals("")))
    		address.setPostalCode(userAddress.getZip());
    	
	    address.setCountryRegion(userAddress.getCountry().getOptValue());
	    
	    return address;
	}
	
	/**
	 * Create a new Address object with all relevant fields set that are required for geocoding a valid UK address
	 * 
	 * @param userAddress
	 * @return
	 */
	private Address getUKSearchableAddress(UserAddress userAddress) {
		Address address = new Address();
		address.setPrimaryCity(getAddressLine(userAddress));
    	address.setSecondaryCity(userAddress.getCity());
    	address.setCountryRegion(userAddress.getCountry().getOptValue());
    	
    	return address;
	}
	
	/**
	 * Create a new Address object with all relevant fields set that are required for geocoding a valid europeon address
	 * 
	 * @param userAddress
	 * @return
	 */
	private Address getEuropeSearchableAddress(UserAddress userAddress) {
		Address address = new Address();
		address.setPrimaryCity(userAddress.getCity());
    	address.setCountryRegion(userAddress.getCountry().getOptValue());
    	
    	return address;
	}
	
	/**
	 * Create the address line field by concatenating the address 1 and address 2 fields if they
	 * are available
	 * 
	 * @param uAdd
	 * @return
	 */
	private String getAddressLine(UserAddress uAdd) {
		if((uAdd.getAddress1() == null) && (uAdd.getAddress2() == null))
			return "";
		else if(uAdd.getAddress1() == null)
			return uAdd.getAddress2();
		else if(uAdd.getAddress2() == null)
			return uAdd.getAddress1();
		else
			return uAdd.getAddress1() + ", " + uAdd.getAddress2();
	}
}