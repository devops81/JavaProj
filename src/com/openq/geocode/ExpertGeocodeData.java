package com.openq.geocode;

import java.io.Serializable;

import com.openq.user.User;

/**
 * This class is used to encapsulate expert geocoding data. It maintains the geocoding
 * status (success/failure/in progress/not geocoded) for each expert, along with a reference
 * to the User object corresponding to the expert.
 * 
 * @author Amit Arora
 */
public class ExpertGeocodeData implements Serializable {
	/**
	 * User object corresponding to the expert
	 */
	private User expert;
	
	/**
	 * Geocoding status (success/failure/in progress/not geocoded) for the expert
	 */
	private String geocodeStatus;
	
	public ExpertGeocodeData(User expert, String status) {
		this.expert = expert;
		this.geocodeStatus = status;
	}

	public User getExpert() {
		return expert;
	}

	public void setExpert(User expert) {
		this.expert = expert;
	}

	public String getGeocodeStatus() {
		return geocodeStatus;
	}

	public void setGeocodeStatus(String status) {
		this.geocodeStatus = status;
	}
}
