package com.openq.eav.scripts.organization;


public class OrganizationFromOrion {
	public OrganizationFromOrion() {}
	

	private long id;
	private String         name;
	private String         street_address;
	private String         city;
	private String         state;
	private String         zipcode;
	private String         email;
	private String         phonenumber;
	private String         faxnumber;
	private String         url;
	private String major_segment;
	private String minor_segment;
	private String acct_type;
	private String acctCma;
	private String orionAcctId;
	
	
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}


	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPhonenumber() {
		return phonenumber;
	}
	public void setPhonenumber(String phonenumber) {
		this.phonenumber = phonenumber;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getStreet_address() {
		return street_address;
	}
	public void setStreet_address(String street_address) {
		this.street_address = street_address;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getZipcode() {
		return zipcode;
	}
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	public String getFaxnumber() {
		return faxnumber;
	}
	public void setFaxnumber(String faxnumber) {
		this.faxnumber = faxnumber;
	}
	public String getAcct_type() {
		return acct_type;
	}
	public void setAcct_type(String acct_type) {
		this.acct_type = acct_type;
	}
	public String getMajor_segment() {
		return major_segment;
	}
	public void setMajor_segment(String major_segment) {
		this.major_segment = major_segment;
	}
	public String getMinor_segment() {
		return minor_segment;
	}
	public void setMinor_segment(String minor_segment) {
		this.minor_segment = minor_segment;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getAcctCma() {
		return acctCma;
	}
	public void setAcctCma(String acctCma) {
		this.acctCma = acctCma;
	}
	public String getOrionAcctId() {
		return orionAcctId;
	}
	public void setOrionAcctId(String orionAcctId) {
		this.orionAcctId = orionAcctId;
	}

}
