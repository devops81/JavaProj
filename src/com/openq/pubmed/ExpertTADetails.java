/*
 * ExpertTADetails
 *
 *
 * Copyright (C) Unpublished openQ. All rights reserved.
 * openQ, Confidential and Proprietary.
 * This software is subject to copyright protection
 * under the laws of the United States and other countries.
 * Unauthorized reproduction and/or distribution is strictly prohibited.
 * Unless otherwise explicitly stated, this software is provided
 * by openQ "AS IS".
 */
package com.openq.pubmed;

import java.io.Serializable;


/**
 * Bean class to hold details for a Expert TA Details from expert_ta_view
 */

public class ExpertTADetails implements Serializable {

	private static final long serialVersionUID = 1536853189433187888L;
	private long id;
	private long kolId;
	private String lastName;
	private String firstName;
	private String addressLine1;
    private String addressLine2;
    private String addressCity;
    private String addressState;
    private String addressCountry;
    private String addressPostalCode;
    private String ta;
    private String primaryEmail;
    private String primaryPhone;
    
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public long getKolId() {
		return kolId;
	}
	public void setKolId(long kolId) {
		this.kolId = kolId;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getAddressLine1() {
		return addressLine1;
	}
	public void setAddressLine1(String addressLine1) {
		this.addressLine1 = addressLine1;
	}
	public String getAddressLine2() {
		return addressLine2;
	}
	public void setAddressLine2(String addressLine2) {
		this.addressLine2 = addressLine2;
	}
	public String getAddressCity() {
		return addressCity;
	}
	public void setAddressCity(String addressCity) {
		this.addressCity = addressCity;
	}
	public String getAddressState() {
		return addressState;
	}
	public void setAddressState(String addressState) {
		this.addressState = addressState;
	}
	public String getAddressCountry() {
		return addressCountry;
	}
	public void setAddressCountry(String addressCountry) {
		this.addressCountry = addressCountry;
	}
	public String getAddressPostalCode() {
		return addressPostalCode;
	}
	public void setAddressPostalCode(String addressPostalCode) {
		this.addressPostalCode = addressPostalCode;
	}
	public String getTa() {
		return ta;
	}
	public void setTa(String ta) {
		this.ta = ta;
	}
	public String getPrimaryEmail() {
		return primaryEmail;
	}
	public void setPrimaryEmail(String primaryEmail) {
		this.primaryEmail = primaryEmail;
	}
	public String getPrimaryPhone() {
		return primaryPhone;
	}
	public void setPrimaryPhone(String primaryPhone) {
		this.primaryPhone = primaryPhone;
	}
    
}
