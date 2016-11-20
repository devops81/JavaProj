package com.openq.geocode;

import java.sql.Timestamp;

/**
 * This class is used to encapsulate the data corresponding to a single asynchronous
 * geocoding item. When the user selects to geocode certain expert addresses from the web UI,
 * entries corresponding to those experts are stored in the DB and then processed 
 * asynchronously by a separate thread. 
 * 
 * @author Amit Arora
 */
public class AsynchGeocodeItem {
	/**
	 * Unique id (primary key) for this item in the DB
	 */
	private long id;
	
	/**
	 * Foreign key to the asynchronous geocode job as a part of which this item was submitted
	 */
	private long jobId;
	
	/**
	 * Id of the expert whose address should be geocoded
	 */
	private long expertId;
	
	/**
	 * Address Line 1 for the specified expert
	 */
	private String address1;
	
	/**
	 * Address Line 2 for the specified expert
	 */
	private String address2;
	
	/**
	 * City for the specified expert
	 */
	private String city;
	
	/**
	 * State for the specified expert
	 */
	private String state;
	
	/**
	 * Country for the specified expert
	 */
	private String country;
	
	/**
	 * Zip for the specified expert
	 */
	private String zip;
	
	/**
	 * Geocoding Status (failed/succeeded/in progress) for this item
	 */
	private String status;
	
	/**
	 * Time when this item was last updated
	 */
	private Timestamp updateTime;

	public AsynchGeocodeItem() {
		
	}
	
	public AsynchGeocodeItem(long jobId, long expertId, String address1, String address2, String city, String state, String country, String zip, String status) {
		super();
		
		this.jobId = jobId;
		this.expertId = expertId;
		this.address1 = address1;
		this.address2 = address2;
		this.city = city;
		this.state = state;
		this.country = country;
		this.zip = zip;
		this.status = status;
	}
	
	public String getAddress1() {
		return address1;
	}

	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	public String getAddress2() {
		return address2;
	}

	public void setAddress2(String address2) {
		this.address2 = address2;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public long getExpertId() {
		return expertId;
	}

	public void setExpertId(long expertId) {
		this.expertId = expertId;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getZip() {
		return zip;
	}

	public void setZip(String zip) {
		this.zip = zip;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public Timestamp getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Timestamp updateDate) {
		this.updateTime = updateDate;
	}

	public long getJobId() {
		return jobId;
	}

	public void setJobId(long jobId) {
		this.jobId = jobId;
	}
}
