package com.openq.web.forms;

/**
 * Created by IntelliJ IDEA.
 * User: abhrap
 * Date: Nov 8, 2006
 * Time: 11:48:02 AM
 * To change this template use File | Settings | File Templates.
 */
public class AdvancedSearchForm {
	private String keyWord;
    private String lastName;
    private String firstName;
    private String organisation;
    private String address;
    private String country;
    private String state;
    private String zip;
    private String amgenContact;
    private String ta;
    private String tier;
    private String topicExpertis;
    private String specialty;
    private String posAmgenScience;
    private String platform;
    private String publication;
    private String research;
    private String orgEntityId;

    public String getOrgEntityId() {
		return orgEntityId;
	}

	public void setOrgEntityId(String orgEntityId) {
		this.orgEntityId = orgEntityId;
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

    public String getOrganisation() {
        return organisation;
    }

    public void setOrganisation(String organisation) {
        this.organisation = organisation;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getZip() {
        return zip;
    }

    public void setZip(String zip) {
        this.zip = zip;
    }

    public String getAmgenContact() {
        return amgenContact;
    }

    public void setAmgenContact(String amgenContact) {
        this.amgenContact = amgenContact;
    }

    public String getTa() {
        return ta;
    }

    public void setTa(String ta) {
        this.ta = ta;
    }

    public String getTier() {
        return tier;
    }

    public void setTier(String tier) {
        this.tier = tier;
    }

    public String getTopicExpertis() {
        return topicExpertis;
    }

    public void setTopicExpertis(String topicExpertis) {
        this.topicExpertis = topicExpertis;
    }

    public String getSpecialty() {
        return specialty;
    }

    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }

    public String getPosAmgenScience() {
        return posAmgenScience;
    }

    public void setPosAmgenScience(String posAmgenScience) {
        this.posAmgenScience = posAmgenScience;
    }

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public String getPublication() {
        return publication;
    }

    public void setPublication(String publication) {
        this.publication = publication;
    }

    public String getResearch() {
        return research;
    }

    public void setResearch(String research) {
        this.research = research;
    }

	/**
	 * @return the keyWord
	 */
	public String getKeyWord() {
		return keyWord;
	}

	/**
	 * @param keyWord the keyWord to set
	 */
	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}
}
