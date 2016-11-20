package com.openq.geocode;

import java.sql.Timestamp;

/**
 * This class is used to encapsulate the data corresponding to an asynchronous
 * geocoding job submitted via the administration UI. When the user selects to geocode 
 * certain expert addresses from the web UI, an entry corresponding to an asynchronous
 * job is persisted in the DB which is then processed by a separate thread.  
 * 
 * @author Amit Arora
 */
public class AsynchGeocodeJob {
	/**
	 * Unique id (primary key) of this asynchronous geocoding job
	 */
	private long id;
	
	/**
	 * Time when the job was started
	 */
	private Timestamp startTime;
	
	/**
	 * Time when the job completed
	 */
	private Timestamp endTime;
	
	public AsynchGeocodeJob() {
		
	}
	
	public AsynchGeocodeJob(Timestamp startTime) {
		this.startTime = startTime;
	}
	
	public Timestamp getEndTime() {
		return endTime;
	}

	public void setEndTime(Timestamp endTime) {
		this.endTime = endTime;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public Timestamp getStartTime() {
		return startTime;
	}

	public void setStartTime(Timestamp startTime) {
		this.startTime = startTime;
	}
}
