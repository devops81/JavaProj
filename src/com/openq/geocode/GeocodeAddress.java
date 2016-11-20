package com.openq.geocode;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.StringTokenizer;

/**
 * This class is used to store information about a geocoded-address. This address 
 * is then used to plot the corresponding location on the map.
 * 
 * @author Amit Arora
 */
public class GeocodeAddress implements Serializable {
	/**
	 * The latitude corresponding to the location
	 */
	private double latitude;
	
	/**
	 * The longitude corresponding to the location
	 */
	private double longitude;
	
	/**
	 * The label/name for this address object
	 */
	private String label;
	
	/**
	 * The description for this address
	 */
	private String description;
	
	/**
	 * URL linking back to the profile of the OL to whom this address corresponds
	 */
	private String profileURL;
	
	public GeocodeAddress(double latitude, double longitude, String label) {
		this.latitude = latitude;
		this.longitude = longitude;
		this.label = label;
	}

	public double getLatitude() {
		return latitude;
	}
	
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	
	public double getLongitude() {
		return longitude;
	}
	
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getProfileURL() {
		return profileURL;
	}

	public void setProfileURL(String profileURL) {
		this.profileURL = profileURL;
	}	
	
	/**
	 * Override the default serialization routine
	 * 
	 * @param out
	 * @throws IOException
	 */
	private void writeObject(ObjectOutputStream out) throws IOException {
		String serialized = this.latitude + ";" + this.longitude + ";" +
					this.label + ";" + this.description;;
		out.writeChars(serialized);
	}
	
	/**
	 * Override the default de-serialization routine
	 * @param in
	 * @throws IOException
	 * @throws ClassNotFoundException
	 */
	private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException {
		String serialized = in.readUTF();
		StringTokenizer st = new StringTokenizer(serialized, ";");
		if(st.countTokens() == 4) {
			this.latitude = Double.parseDouble(st.nextToken());
			this.longitude = Double.parseDouble(st.nextToken());
			this.label = st.nextToken();
			this.description = st.nextToken();
		}
		else {
			throw new IllegalStateException("Can't deserialize GeocodeAddress : " + serialized + " properly. It has " + st.countTokens() + " tokens");
		}
	}
}
