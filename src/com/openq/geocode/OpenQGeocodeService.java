package com.openq.geocode;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.eav.option.OptionLookup;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.user.UserAddress;

/**
 * This class is the abstract base class for all concrete implementations of IGeocodeService
 * used in the application. It has some common methods which are used by all 
 * derived instances
 * 
 * @see com.openq.geocode.IGeocodeService
 * 
 * @author Amit Arora
 *
 */
public abstract class OpenQGeocodeService extends HibernateDaoSupport implements IGeocodeService {

	/////////////////////////////////////////////////////////////////////////////////////
	//			Abstract Methods to be implemented by the derived classes
    /////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * @see IGeocodeService#geocode(UserAddress)
	 */
	public abstract GeocodeAddress geocode(UserAddress address) throws UnsupportedRegionException, 
						UnparsableAddressException, AddressNotFoundException;	
	
	/**
	 * @see IGeocodeService#isCountrySupported(String)
	 */
	public abstract boolean isCountrySupported(String country);
	
	
	/**
	 * @see IGeocodeService#getSupportedRegions()
	 */
	public abstract String[] getSupportedRegions();
	
	
    /////////////////////////////////////////////////////////////////////////////////////
	//		Methods which  are common across all derived classes
    /////////////////////////////////////////////////////////////////////////////////////
	
	IUserService userService;
	
	/**
	 * @see IGeocodeService#geocode(UserAddress[], boolean)
	 */
	public GeocodeAddress[] geocode(UserAddress[] addresses, boolean ignoreErrors) throws UnsupportedRegionException, UnparsableAddressException, AddressNotFoundException  {
		if((addresses ==null) || (addresses.length == 0))
			throw new IllegalArgumentException("Must pass valid addresses");
		
		GeocodeAddress[] geocodedAddresses = new GeocodeAddress[addresses.length];
		
		for(int i=0; i<addresses.length; i++) {
			try {
				geocodedAddresses[i] = geocode(addresses[i]);
			}
			catch(UnsupportedRegionException ure) {
				if(ignoreErrors) {
					ure.printStackTrace();
					geocodedAddresses[i] = null;
				}
				else
					throw ure;
			} catch (UnparsableAddressException uae) {
				if(ignoreErrors) {
					uae.printStackTrace();
					geocodedAddresses[i] = null;
				}
				else
					throw uae;
			} catch (AddressNotFoundException anfe) {
				if(ignoreErrors) {
					anfe.printStackTrace();
					geocodedAddresses[i] = null;
				}
				else
					throw anfe;
			} catch (IllegalArgumentException iae) {
				if(ignoreErrors) {
					iae.printStackTrace();
					geocodedAddresses[i] = null;
				}
				else
					throw iae;
			}
		}
		
		return geocodedAddresses;
	}
	
	/**
	 * @see IGeocodeService#geocodeExpertsAsynch(User[])
	 */
	public void geocodeExpertsAsynch(User[] experts) {
		// Start a new asynch job
		AsynchGeocodeJob job = new AsynchGeocodeJob(new Timestamp(System.currentTimeMillis()));
		getHibernateTemplate().save(job);
		long jobId = job.getId();
		
		logger.debug("Running asynch job : " + jobId);
		
		// Now add an asynch geocode item for each expert
		for(int i=0; i<experts.length; i++) {
			addAsynchGeocodeItem(jobId, experts[i].getId(), experts[i].getUserAddress());
		}
		
		// Now start a worker thread who will process these items one by one
		// in the background
		Thread t = new GeocodeWorkerThread(jobId, experts);
		t.start();
	}
	
	/**
	 * @see IGeocodeService#getAsynchGeocodeItemsStatus()
	 */
	public HashMap getAsynchGeocodeItemsStatus() {
		List result = getHibernateTemplate().find("select a " +
				" from AsynchGeocodeItem a" +
				" order by a.updateTime desc");
		
		HashMap expertStatusMap = new HashMap();
		for(int i=0; i<result.size(); i++) {
			AsynchGeocodeItem item = (AsynchGeocodeItem) result.get(i);
			// we want to use the latest status for a given expert, hence 
			// store this item if we don't already have one for this expert
			if(expertStatusMap.get(new Long(item.getExpertId())) == null)
				expertStatusMap.put(new Long(item.getExpertId()), item.getStatus());
		}
		
		return expertStatusMap;
	}
	
	public void setUserService(IUserService userService) {
		this.userService = userService;
	}
	

	/**
	 * This routine is used to check if all required fields are set in the UserAddress
	 * object, and if the specified country is supported by the Geocoder US service
	 * 
	 * @param address

	 * @return true if it is a valid address and is supported by Geocoder US, false otherwise
	 */
	protected boolean isValidAddress(UserAddress address) throws UnsupportedRegionException {
		String address1 = address.getAddress1();
		String address2 = address.getAddress2();
		String city = address.getCity();
		String state = null;
		String country = null;
		
		if(address.getState() != null)
			state = address.getState().getOptValue();
		
		if(address.getCountry() != null)
			country = address.getCountry().getOptValue();

		// Check that all required fields are set in the address object
		if((address1 == null) && (address2 == null))
			throw new IllegalArgumentException("Address1 or Address 2 field must be specified");
		
		if(city == null)
			throw new IllegalArgumentException("city field must be specified");
		
		/*if(state == null)
			throw new IllegalArgumentException("state field must be specified");*/
		
		if(country == null) {
			// Ideally the address data should be specified properly.
			// However, there can be issues while importing address data from feeds
			// Hence, if the country field is not specified, we will try using US
			
			// TODO: switch back to throwing an exception once the address data issues
			// while load time are resolved
			//throw new IllegalArgumentException("country field must be specified");
			OptionLookup countryOption = new OptionLookup();
			countryOption.setOptValue("United States");
			address.setCountry(countryOption);
			country = "United States";
		}
		
		// Throw an exception if the address is not in a supported region
		if(!isCountrySupported(country))
			throw new UnsupportedRegionException("The specified country '" + country + "' is not supported");
		
		return true;
	}
	
	/**
	 * Return the complete address in a String format after appending all relevant fields
	 * 
	 * @param address
	 * @return
	 */
	protected String getCompleteAddress(UserAddress address) {
		StringBuffer location = new StringBuffer();
		
		appendStringToBuffer(location, address.getAddress1(), ", ");
		appendStringToBuffer(location, address.getAddress2(), ", ");
		appendStringToBuffer(location, address.getCity(), ", ");
		
		if(address.getState() != null)
			appendStringToBuffer(location, address.getState().getOptValue(), ", ");
		
		return location.toString();
	}
	
	/**
	 * Persist a new asynchronous geocoding item corresponding to the given expert, 
	 * in the DB 
	 *  
	 * @param jobId id of the asynchronous job to which this item belongs
	 * @param expertId id of the expert whose address should be geocoded
	 * @param add user address for the expert
	 */
	private void addAsynchGeocodeItem(long jobId, long expertId, UserAddress add) {
		String add1 = "";
		String add2 = "";
		String city = "";
		String state = "";
		String country = "US";
		String zip = "";
		
		if(add == null)
			throw new IllegalArgumentException("Address cannot be null");
		
		if(add.getAddress1() != null)
			add1 = add.getAddress1();
		
		if(add.getAddress2() != null)
			add2 = add.getAddress2();
		
		if(add.getCity() != null)
			city = add.getCity();
		
		if(add.getState() != null)
			state = add.getState().getOptValue();
		
		if(add.getCountry() != null)
			country = add.getCountry().getOptValue();
		
		if(add.getZip() != null)
			zip = add.getZip();
		
		AsynchGeocodeItem item = new AsynchGeocodeItem(jobId, expertId, add1,
					add2, city, state,
					country, zip, "Geocoding Pending");
		
		logger.debug("Saving the async item");
		
		getHibernateTemplate().save(item);
		
		logger.debug("Saved the item");
	}
	
	/**
	 * Mark the status (in progress/failure/success) for the asynchronous geocode item
	 * corresponding to the specified jobId and expertId
	 * 
	 * @param jobId
	 * @param expertId
	 * @param status
	 */
	private void markStatusForGeocodeItem(long jobId, long expertId, String status) {
		List result = getHibernateTemplate().find(
				" from AsynchGeocodeItem a" +
				" where a.jobId = " + jobId +
				" and a.expertId = " + expertId);
		
		AsynchGeocodeItem item = (AsynchGeocodeItem) result.get(0);
		item.setStatus(status);
		item.setUpdateTime(new Timestamp(System.currentTimeMillis()));
		
		logger.debug("Updating geocoding status for expert '" + expertId + "' to " + status);
		getHibernateTemplate().update(item);
		logger.debug("Updated geocoding status");
	}
	
	/**
	 * Mark the specified asynchronous geocoding job as having completed
	 * 
	 * @param jobId
	 */
	private void markAsynchJobDone(long jobId) {
		List result = getHibernateTemplate().find(
				" from AsynchGeocodeJob a" +
				" where a.id = " + jobId);
		
		AsynchGeocodeJob job = (AsynchGeocodeJob) result.get(0);
		job.setEndTime(new Timestamp(System.currentTimeMillis()));
		
		getHibernateTemplate().update(job);
	}
	
	
	
	/**
	 * If the specified "text" is not-null, add it to the given buffer
	 * 
	 * @param buffer
	 * @param text
	 * @param delimiter
	 */
	private void appendStringToBuffer(StringBuffer buffer, String text, String delimiter) {
		if(text != null) {
			if(buffer.length() > 0)
				buffer.append(delimiter);
			
			buffer.append(text);
		}
	}
	
	/**
	 * Get a hashmap with geocoding status of all experts for which an asynchronous
	 * geocoding request was submitted
	 * 
	 * @return
	 */
	private HashMap getPendingAsynchGeocodeItems() {
		List result = getHibernateTemplate().find("select a " +
				" from AsynchGeocodeItem a, AsynchGeocodeJob j" +
				" where a.jobId = j.id " +
				" and j.endTime is null");
		
		HashMap expertStatusMap = new HashMap();
		for(int i=0; i<result.size(); i++) {
			AsynchGeocodeItem item = (AsynchGeocodeItem) result.get(i);
			expertStatusMap.put(new Long(item.getExpertId()), item.getStatus());
		}
		
		return expertStatusMap;
	}
	
	/**
	 * A worker thread that picks up geocode items corresponding to the specific
	 * asynchronous job, and processes them sequentially
	 * 
	 * @author Amit Arora
	 */
	class GeocodeWorkerThread extends Thread {
		/**
		 * Id of the asynchronous geocoding job that should be processed by this thread
		 */
		private long jobId;
		
		/**
		 * A list of experts that should be processed by this thread 
		 */
		private User[] expertsToGeocode;
		
		/**
		 * Create a new Geocoder Worker thread
		 * 
		 * @param jobId
		 * @param experts
		 */
		GeocodeWorkerThread(long jobId, User[] experts) {
			this.jobId = jobId;
			this.expertsToGeocode = experts;
		}
		
		
		public void run() {
			// Geocode the addresses for all specified experts sequentially
			// so that we can keep providing progress information to the user
			for(int i=0; i<expertsToGeocode.length; i++) {
				// Geocode the addresses one by one 
				UserAddress add = expertsToGeocode[i].getUserAddress();
				try {
					logger.debug("Geocoding address.....");
					GeocodeAddress[] geocodedAdd = geocode(new UserAddress[] {add}, false);
					logger.debug("Geocoded to : " + geocodedAdd[0].getLatitude() + ", " + geocodedAdd[0].getLongitude());
					// Mark the address in the DB as having succeeded geocoding
					markStatusForGeocodeItem(jobId, expertsToGeocode[i].getId(), "Geocoding Successful");
					
					// Update the address in the user table
					userService.updateGeocodeAddressForUser(expertsToGeocode[i].getId(), 
							(float) geocodedAdd[0].getLatitude(), (float) geocodedAdd[0].getLongitude());
				}
				catch (Exception e) {
					e.printStackTrace();
					// Mark the address in the DB as having failed geocoding
					markStatusForGeocodeItem(jobId, expertsToGeocode[i].getId(), "Geocoding Failed");
				}
			}
			
			// Now since all items have been geocoded, mark the job as done
			markAsynchJobDone(jobId);
		}
	}
	
}