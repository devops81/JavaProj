package com.openq.geocode;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.openq.user.UserAddress;

/**
 * This class provides a concrete implementation of the com.openq.geocode.IGeocodeService
 * by using the Yahoo Maps web service
 * 
 * @see com.openq.geocode.IGeocodeService
 * 
 * @author Amit Arora
 *
 */
public class YahooGeocodeService extends OpenQGeocodeService {
	
	private static final Logger logger = Logger.getLogger(YahooGeocodeService.class);

    // The URL of the geocoding service we will be using
    private static final String SERVICE_URL = "http://api.local.yahoo.com/MapsService/V1/geocode";

    // The encoding scheme that we will be using
    private static final String ENCODING_SCHEME = "ISO-8859-1";

    // Application id for using the yahoo geocoding APIs
    private String applicationId = "k6CU5RfV34Gdmu83uO61QuBoBUBLd_tNJclq11mAGdombwG82CuUbyvlgs9aOy326g";
    
    // All the regions supported by yahoo geocoding service
	private static final String[] SUPPORTED_REGIONS = {"ALL"};
	
	/**
	 * @see IGeocodeService#geocode(UserAddress)
	 */
	public GeocodeAddress geocode(UserAddress address) throws UnsupportedRegionException, 
						UnparsableAddressException, AddressNotFoundException {
		GeocodeAddress geoAdd = null;

        // Get the complete user address in a single String that can be passed to Yahoo for geocoding
        String location = getCompleteAddress(address);
        GeocodeAddress[] allMappings = geoCode(location);
        
        // Yahoo can return more than one mappings for a given address, we will use the first one
        if(allMappings.length > 0) {
            geoAdd = allMappings[0];
            logger.debug("Yahoo geocoded the address '" + location + "' to (" + geoAdd.getLatitude() + "," + geoAdd.getLongitude() + ")");
        }
        else {
            logger.debug("Could not geocode address '" + location + "'");
        }
		
		return geoAdd;
	}
    
    
    
    
    // -------------------------------------------------------------- Properties
    
    /**
     * <p>Return the application identifier to be passed to the geocoding
     * service.</p>
     */
    public String getApplicationId() {
        return this.applicationId;
    }
        
        
    /**
     * <p>Return an array of zero or more {@link GeoPoint} instances for results
     * that match a search for the specified location string.  This string can
     * be formatted in any of the following ways:</p>
     * <ul>
     * <li>city, state</li>
     * <li>city, state, zip</li>
     * <li>zip</li>
     * <li>street, city, state</li>
     * <li>street, city, state, zip</li>
     * <li>street, zip</li>
     * </ul>
     *
     * @param location Location string to search for
     *
     * @exception IllegalArgumentException if <code>location</code> does not conform to one of the specified patterns
     *                                     or if there is an error in encoding/parsing the request/results
     */
    public GeocodeAddress[] geoCode(String location) {
        
        // Return immediately if no location was specified
        if (location == null) {
            return null;
        }
                
        // URL encode the application id
        String applicationId = getApplicationId();
        
        try {
            applicationId = URLEncoder.encode(applicationId, ENCODING_SCHEME);
        } 
        catch (UnsupportedEncodingException e) {
            logger.warn("geoCoder.encodeApplicationId", e);
            throw new IllegalArgumentException(e.getMessage());
        }
        
        // URL encode the specified location
        try {
            location = URLEncoder.encode(location, ENCODING_SCHEME);
        } 
        catch (UnsupportedEncodingException e) {
            logger.warn("geoCoder.encodeLocation", e);
            throw new IllegalArgumentException(e.getMessage());
        }
        
        // Perform the actual service call and parse the response XML document,
        // then format and return the results
        Document document = null;
        StringBuffer sb = new StringBuffer(SERVICE_URL);
        
        sb.append("?appid=");
        sb.append(applicationId);
        sb.append("&location=");
        sb.append(location);
        
        try {
            document = parseResponse(sb.toString());
            return convertResults(document);
        } 
        catch (IllegalArgumentException e) {
            throw e;
        } 
        catch (IOException e) {
            throw new IllegalArgumentException(e.getMessage());
        } 
        catch (ParserConfigurationException e) {
            throw new IllegalArgumentException(e.getMessage());
        } 
        catch (SAXException e) {
            throw new IllegalArgumentException(e.getMessage());
        } 
    }
    
    /**
     * <p>Convert the parsed XML results into the appropriate output from
     * our <code>geoCode()</code> method.  If there were no results (and no
     * exception was thrown), a zero-length array will be returned.</p>
     *
     * @param document Parsed XML document representing the response from
     *  the geocoding service
     *
     * @exception IllegalArgumentException if an unrecognized XML element
     *  is encountered
     */
    private GeocodeAddress[] convertResults(Document document) {
        
        List results = new ArrayList();
        GeocodeAddress point = null;
        
        logger.debug("Converting results");
        
        // Acquire and validate the top level "ResultSet" element
        Element root = document.getDocumentElement();
        if (!"ResultSet".equals(root.getTagName())) {
            throw new IllegalArgumentException(root.getTagName());
        }
        
        // Iterate over the child "Result" components, creating a new
        // GeoPoint instance for each of them
        NodeList outerList = root.getChildNodes();
        for (int i = 0; i < outerList.getLength(); i++) {            
            // Validate the outer "Result" element
            Node outer = outerList.item(i);
            if (!"Result".equals(outer.getNodeName())) {
                throw new IllegalArgumentException(outer.getNodeName());
            }
            
            // Create a new GeocodeAddress for this element
            point = new GeocodeAddress(-360, -360, "");
            
            // Iterate over the inner elements to set properties
            NodeList innerList = outer.getChildNodes();
            for (int j = 0; j < innerList.getLength(); j++) {
                Node inner = innerList.item(j);
                String name = inner.getNodeName();
                String text = null;
                NodeList bottomList = inner.getChildNodes();
                for (int k = 0; k < bottomList.getLength(); k++) {
                    Node bottom = bottomList.item(k);
                    if ("#text".equals(bottom.getNodeName())) {
                        text = bottom.getNodeValue().trim();
                        if (text.length() < 1) {
                            text = null;
                        }
                        break;
                    }
                }
                if ("Latitude".equals(name)) {
                    if (text != null) {
                        point.setLatitude(Double.valueOf(text).doubleValue());
                    }
                } else if ("Longitude".equals(name)) {
                    if (text != null) {
                        point.setLongitude(Double.valueOf(text).doubleValue());
                    }
                } else if ("Address".equals(name)) {
                    point.setDescription(text);
                }
            }
            results.add(point);
        }

        // Return the accumulated point information
        return (GeocodeAddress[]) results.toArray(new GeocodeAddress[results.size()]);
    }
    
    
    /**
     * <p>Parse the XML content at the specified URL into an XML
     * <code>Document</code>, which can be further processed to extract
     * the necessary content.</p>
     *
     * @param url URL of the resource to be parsed
     *
     * @exception IOException if an input/output error occurs
     * @exception MalformedURLException if the specified URL is invalid
     * @exception ParserConfigurationException if thrown by the XML parser configuration mechanism
     * @exception SAXException if a parsing error occurs
     */
    private Document parseResponse(String url)
    throws IOException, MalformedURLException, ParserConfigurationException, SAXException {
        
        DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
        InputStream stream = null;
        stream = new URL(url).openStream();
        return db.parse(stream);
    }
	
	/**
	 * @see IGeocodeService#isCountrySupported(String)
	 */
	public boolean isCountrySupported(String country) {
		if(country == null)
			throw new IllegalArgumentException("Must specify a valid country");
		
		// Yahoo supports geocoding across all countries, so always return true
		return true;
	}
	
	/**
	 * @see IGeocodeService#getSupportedRegions()
	 */
	public String[] getSupportedRegions() {
		return SUPPORTED_REGIONS;
	}
}