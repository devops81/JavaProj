package com.openq.user;

import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;
import com.openq.eav.option.OptionLookup;

public class UserAddress implements java.io.Serializable, Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "address1", "address2", "cellPhoneNumber", "city",
            "country", "emailAddress", "faxNumber", "fullprofile", "phoneNumber", "state", "suiteRoom", "userId", "zip" });

	public UserAddress(){}
	
	private long              id;
	private long              userId;
	private String            address1;
	private String            address2;
	private String            suiteRoom;
	private String            city;
	private OptionLookup      state;
	private OptionLookup      country;
	private String            zip;
	private String	          phoneNumber;
	private String	          emailAddress;	
	private String            cellPhoneNumber;
	private String	          faxNumber;

  

    private boolean fullprofile;
	/**
	 * Returns the addressId.
	 * 
	 * @return Returns the addressId.
	 */
	
	/**
	 * Returns the userId.
	 * 
	 * @return Returns the userId.
	 */
	public long getUserId() {
		return userId;
	}
	
	/**
	 * The userId to set.
	 * 
	 * @param userId The userId to set.
	 */
	public void setUserId(long userId) {
		this.userId = userId;
	}
	
	/**
	 * Returns the address1.
	 * 
	 * @return Returns the address1.
	 */
	public String getAddress1() {
		return address1;
	}
	
	/**
	 * The address1 to set.
	 * 
	 * @param address1 The address1 to set.
	 */
	public void setAddress1(String address1) {
		this.address1 = address1;
	}
	
	/**
	 * Returns the address2.
	 * 
	 * @return Returns the address2.
	 */
	public String getAddress2() {
		return address2;
	}
	
	/**
	 * The address2 to set.
	 * 
	 * @param address2 The address2 to set.
	 */
	public void setAddress2(String address2) {
		this.address2 = address2;
	}
	
	/**
	 * Returns the suiteRoom.
	 * 
	 * @return Returns the suiteRoom.
	 */
	public String getSuiteRoom() {
		return suiteRoom;
	}	
	
	/**
	 * The suiteRoom to set.
	 * 
	 * @param suiteRoom The suiteRoom to set.
	 */
	public void setSuiteRoom(String suiteRoom) {
		this.suiteRoom = suiteRoom;
	}
	
	/**
	 * Returns the city.
	 * 
	 * @return Returns the city.
	 */
	public String getCity() {
		return city;
	}
	
	/**
	 * The city to set.
	 * 
	 * @param city The city to set.
	 */
	public void setCity(String city) {
		this.city = city;
	}
	
	/**
	 * Returns the state.
	 * 
	 * @return Returns the state.
	 */
	
	/**
	 * Returns the zip.
	 * 
	 * @return Returns the zip.
	 */
	public String getZip() {
		return zip;
	}
	
	/**
	 * The zip to set.
	 * 
	 * @param zip The zip to set.
	 */
	public void setZip(String zip) {
		this.zip = zip;
	}

	/**
	 * @return phoneNumber
	 */
	public String getPhoneNumber() {
		return phoneNumber;
	}

	/**
	 * @param emailAddress
	 */
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	/**
	 * @return emailAddress
	 */
	public String getEmailAddress() {
		return emailAddress;
	}

	/**
	 * @param phoneNumber
	 */
	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}
			
	
	
	/**
	 * @return
	 */
	public String getCellPhoneNumber() {
		return cellPhoneNumber;
	}

	/**
	 * @return
	 */
	public String getFaxNumber() {
		return faxNumber;
	}

	/**
	 * @param string
	 */
	public void setCellPhoneNumber(String string) {
		cellPhoneNumber = string;
	}

	/**
	 * @param string
	 */
	public void setFaxNumber(String string) {
		faxNumber = string;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public boolean isFullprofile() {
		return fullprofile;
	}

	public void setFullprofile(boolean fullprofile) {
		this.fullprofile = fullprofile;
	}

	public OptionLookup getCountry() {
		return country;
	}

	public void setCountry(OptionLookup country) {
		this.country = country;
	}

	public OptionLookup getState() {
		return state;
	}

	public void setState(OptionLookup state) {
		this.state = state;
	}

	public String getDisplayableAddress() {
		StringBuffer location = new StringBuffer();
		
		appendStringToBuffer(location, address1, ", ");
		appendStringToBuffer(location, address2, ", ");
		appendStringToBuffer(location, city, ", ");
		
		if(state != null)
			appendStringToBuffer(location, state.getOptValue(), ", ");
		
		if(country != null)
			appendStringToBuffer(location, country.getOptValue(), ", ");
		
		appendStringToBuffer(location, zip, " - ");
		
		return location.toString();
	}
	
	private void appendStringToBuffer(StringBuffer buffer, String text, String delimiter) {
		if(text != null) {
			if(buffer.length() > 0)
				buffer.append(delimiter);
			
			buffer.append(text);
		}
	}

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field));
    }
}
