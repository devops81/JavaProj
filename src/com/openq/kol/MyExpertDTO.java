package com.openq.kol;



/** 
 * File Name 	:MyExpertDTO.java
 * Purpose		:This class is to display my expert list
 * Created on 	:May 16, 2005
 * Copyright (c) Openq 2005. All rights reserved Unauthorized reproduction
 * and/or distribution is strictly prohibited. 
 * 
 * description : 
 * Author		:Ravi Chandran.S
 */
public class MyExpertDTO  implements java.io.Serializable{
	
	private String expertName;
	private long expertId;
	private String speciality;
	private String engaged;
	private String phone;
	private String country;
	private float longitude;
	private float latitude;
	private int influenceLevel;
	
	private String firstName;
	private String lastName;
	private String city;
	private String State;
	private String zip;
	private String reference;
    private String location;
    private String kolId;

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    /**
	 * @return
	 */
	

	/**
	 * @return
	 */
	public String getExpertName() {
		return expertName;
	}

	/**
	 * @return
	 */
	

	/**
	 * @param i
	 */
	

	/**
	 * @param string
	 */
	public void setExpertName(String string) {
		expertName = string;
	}

	/**
	 * @param string
	 */
	

	/**
	 * @return
	 */
	public String getEngaged() {
		return engaged;
	}

	/**
	 * @param string
	 */
	public void setEngaged(String string) {
		engaged = string;
	}
	
	/**
	 * @return
	 */
	public String getCountry() {
		return country;
	}

	/**
	 * @return
	 */
	public String getPhone() {
		return phone;
	}

	/**
	 * @param string
	 */
	public void setCountry(String string) {
		country = string;
	}

	/**
	 * @param string
	 */
	public void setPhone(String string) {
		phone = string;
	}

	/**
	 * @return
	 */
	public int getInfluenceLevel() {
		return influenceLevel;
	}

	/**
	 * @param i
	 */
	public void setInfluenceLevel(int i) {
		influenceLevel = i;
	}
	

	/**
	 * @return
	 */
	public float getLatitude() {
		return latitude;
	}

	/**
	 * @return
	 */
	public float getLongitude() {
		return longitude;
	}

	/**
	 * @param f
	 */
	public void setLatitude(float f) {
		latitude = f;
	}

	/**
	 * @param f
	 */
	public void setLongitude(float f) {
		longitude = f;
	}
	
	

	/**
	 * @return
	 */
	public String getCity() {
		return city;
	}

	/**
	 * @param string
	 */
	public void setCity(String string) {
		city = string;
	}
	
	

	/**
	 * @return
	 */
	public String getFirstName() {
		return firstName;
	}

	/**
	 * @return
	 */
	public String getLastName() {
		return lastName;
	}

	/**
	 * @return
	 */
	public String getState() {
		return State;
	}

	/**
	 * @return
	 */
	public String getZip() {
		return zip;
	}

	/**
	 * @param string
	 */
	public void setFirstName(String string) {
		firstName = string;
	}

	/**
	 * @param string
	 */
	public void setLastName(String string) {
		lastName = string;
	}

	/**
	 * @param string
	 */
	public void setState(String string) {
		State = string;
	}

	/**
	 * @param string
	 */
	public void setZip(String string) {
		zip = string;
	}
	
	

	/**
	 * @return
	 */
	public String getReference() {
		return reference;
	}

	/**
	 * @param string
	 */
	public void setReference(String string) {
		reference = string;
	}

	public long getExpertId() {
		return expertId;
	}

	public void setExpertId(long expertId) {
		this.expertId = expertId;
	}

	public String getSpeciality() {
		return speciality;
	}

	public void setSpeciality(String speciality) {
		this.speciality = speciality;
	}

	public String getKolId() {
		return kolId;
	}

	public void setKolId(String kolId) {
		this.kolId = kolId;
	}

}
