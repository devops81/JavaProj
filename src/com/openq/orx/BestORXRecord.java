package com.openq.orx;

public class BestORXRecord implements Comparable {
	
	public BestORXRecord() {}
	
	private String           ssoid;
	private String           ssname;
	private long             agoid;
	
	private String         fullName;
	private String         firstName;
	private String         preferredName;
	private String         middleName;
	private String         lastName;
	private String         address;
	private String         specialty;
	private String         phone;
	private String         location;
	private String         country;
	private String         locality;
	private String         postalCode;
	private String         province;
	private String         streetAddress;
	
	public String getStreetAddress() {
		return streetAddress;
	}
	
	public void setStreetAddress(String streetAddress) {
		this.streetAddress = streetAddress;
	}
	
	public String getProvince() {
		return province;
	}
	
	public void setProvince(String province) {
		this.province = province;
	}
	
	public String getPostalCode() {
		return postalCode;
	}
	
	public void setPostalCode(String postalCode) {
		this.postalCode = postalCode;
	}
	
	public String getLocality() {
		return locality;
	}
	
	public void setLocality(String locality) {
		this.locality = locality;
	}
	
	public String getCountry() {
		return country;
	}
	
	public void setCountry(String country) {
		this.country = country;
	}
	
	public String getAddress() {
		return address;
	}
	
	public void setAddress(String address) {
		this.address = address;
	}
	
	public String getFirstName() {
		return firstName;
	}
	
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	
	public String getFullName() {
		return fullName;
	}
	
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	
	public String getLastName() {
		return lastName;
	}
	
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	
	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getMiddleName() {
		return middleName;
	}

	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getPreferredName() {
		return preferredName;
	}

	public void setPreferredName(String preferredName) {
		this.preferredName = preferredName;
	}

	public String getSpecialty() {
		return specialty;
	}

	public void setSpecialty(String specialty) {
		this.specialty = specialty;
	}

	public String getSsname() {
		return ssname;
	}

	public void setSsname(String ssname) {
		this.ssname = ssname;
	}

	public String getSsoid() {
		return ssoid;
	}

	public void setSsoid(String ssoid) {
		this.ssoid = ssoid;
	}

	public long getAgoid() {
		return agoid;
	}

	public void setAgoid(long agoid) {
		this.agoid = agoid;
	}

	public int compareTo(Object o) {
		return this.lastName.compareTo(((BestORXRecord) o).lastName);
	}

    public String toString()
    {
        StringBuffer stringBuffer = new StringBuffer(300);
        stringBuffer.append(" ssoid ").append(ssname)
                    .append(" ssname ").append(ssname)
                    .append(" agoid ").append(agoid)
                    .append(" full name").append(fullName)
                    .append(" firstNamest ").append(firstName)
                    .append(" lastName ").append(lastName)
                    .append(" location ").append(location)
                    .append(" locality ").append(locality)
                    .append(" province/state ").append(province);
        
        return  stringBuffer.toString();
    }
}
