package com.openq.kol;

import java.io.Serializable;

/**
 * File : SearchDTO.java
 * 
 * Purpose : This class is created to search for Event and Expert search
 * 
 * Created on Apr 20, 2005
 * 
 * Copyright (c) Openq 2005. All rights reserved Unauthorized reproduction
 * and/or distribution is strictly prohibited.
 * 
 * description :
 * 
 * author : basavarajk
 * 
 */
public class SearchDTO implements Serializable {

	private int userid;

	private String title;

	private String expertName;

	private String specialty;

	private String location;

	private int expertId;

	private String venueName;

	private String userName;

	private long statusId;

	private String statusName;

	private String cdate;

	private String eventType;

	private long eventId;

	private String eventName;

	private long eventTypeId;

	private String eventTypeName;

	private long hierarchyId;

	private int attId;

	private String attName;

	private String labelName;

	private String attDataType;

	private String attSize;

	private String attType;

	private String expertRates;

	private String expertSpeciality;

	private String options;

	private String ids;

	private float longitude;

	private float latitude;

	private int influenceLevel;
	private String residence;  	
	private String brand;
	private String travel;
	private String notravel;
	private int requestId;
	private String activity;
	private String topics;
	private String engagedDates;
	private String status;
	private String  ReviewStatus;
	private String state;
	private String institution;
	private String city;
	private String country;
	private String pcode;
	private String email;
	private String address;
	private String fax;
	private String phone;
	private String classification;
    private String lastName;

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getResidence() {
        return residence;
    }

    public void setResidence(String residence) {
        this.residence = residence;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getTravel() {
        return travel;
    }

    public void setTravel(String travel) {
        this.travel = travel;
    }

    public String getNotravel() {
        return notravel;
    }

    public void setNotravel(String notravel) {
        this.notravel = notravel;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public String getActivity() {
        return activity;
    }

    public void setActivity(String activity) {
        this.activity = activity;
    }

    public String getTopics() {
        return topics;
    }

    public void setTopics(String topics) {
        this.topics = topics;
    }

    public String getEngagedDates() {
        return engagedDates;
    }

    public void setEngagedDates(String engagedDates) {
        this.engagedDates = engagedDates;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReviewStatus() {
        return ReviewStatus;
    }

    public void setReviewStatus(String reviewStatus) {
        ReviewStatus = reviewStatus;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getInstitution() {
        return institution;
    }

    public void setInstitution(String institution) {
        this.institution = institution;
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

    public String getPcode() {
        return pcode;
    }

    public void setPcode(String pcode) {
        this.pcode = pcode;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getClassification() {
        return classification;
    }

    public void setClassification(String classification) {
        this.classification = classification;
    }

    public String getSuffix() {
        return suffix;
    }

    public void setSuffix(String suffix) {
        this.suffix = suffix;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    private String suffix;
	private int user_id;
    private String firstName;
    private String middleName;

    /**
	 * @return expertName
	 */
	public String getExpertName() {
		return expertName;
	}

	/**
	 * @return location
	 */
	public String getLocation() {
		return location;
	}

	/**
	 * @return specialty
	 */
	public String getSpecialty() {
		return specialty;
	}

	/**
	 * @return title
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * @param string
	 */
	public void setExpertName(String string) {
		expertName = string;
	}

	/**
	 * @param string
	 */
	public void setLocation(String string) {
		location = string;
	}

	/**
	 * @param string
	 */
	public void setSpecialty(String string) {
		specialty = string;
	}

	/**
	 * @param string
	 */
	public void setTitle(String string) {
		title = string;
	}

	/**
	 * @return eventId
	 */
	public long getEventId() {
		return eventId;
	}

	/**
	 * @return eventType
	 */
	public String getEventType() {
		return eventType;
	}

	/**
	 * @return userName
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @return venueName
	 */
	public String getVenueName() {
		return venueName;
	}

	/**
	 * @param l
	 */
	public void setEventId(long l) {
		eventId = l;
	}

	/**
	 * @param string
	 */
	public void setEventType(String string) {
		eventType = string;
	}

	/**
	 * @param string
	 */
	public void setUserName(String string) {
		userName = string;
	}

	/**
	 * @param string
	 */
	public void setVenueName(String string) {
		venueName = string;
	}

	/**
	 * @return cdate
	 */
	public String getCdate() {
		return cdate;
	}

	/**
	 * @return eventName
	 */
	public String getEventName() {
		return eventName;
	}

	/**
	 * @param string
	 */
	public void setCdate(String string) {
		cdate = string;
	}

	/**
	 * @param string
	 */
	public void setEventName(String string) {
		eventName = string;
	}

	/**
	 * @return eventTypeId
	 */
	public long getEventTypeId() {
		return eventTypeId;
	}

	/**
	 * @return eventTypeName
	 */
	public String getEventTypeName() {
		return eventTypeName;
	}

	/**
	 * @param l
	 */
	public void setEventTypeId(long l) {
		eventTypeId = l;
	}

	/**
	 * @param string
	 */
	public void setEventTypeName(String string) {
		eventTypeName = string;
	}

	/**
	 * @return statusId
	 */
	public long getStatusId() {
		return statusId;
	}

	/**
	 * @return statusName
	 */
	public String getStatusName() {
		return statusName;
	}

	/**
	 * @param l
	 */
	public void setStatusId(long l) {
		statusId = l;
	}

	/**
	 * @param string
	 */
	public void setStatusName(String string) {
		statusName = string;
	}

	/**
	 * @return attDataType
	 */
	public String getAttDataType() {
		return attDataType;
	}

	/**
	 * @return attName
	 */
	public String getAttName() {
		return attName;
	}

	/**
	 * @return labelName
	 */
	public String getLabelName() {
		return labelName;
	}

	/**
	 * @param string
	 */
	public void setAttDataType(String string) {
		attDataType = string;
	}

	/**
	 * @param string
	 */
	public void setAttName(String string) {
		attName = string;
	}

	/**
	 * @param string
	 */
	public void setLabelName(String string) {
		labelName = string;
	}

	/**
	 * @return attId
	 */
	public int getAttId() {
		return attId;
	}

	/**
	 * @param i
	 */
	public void setAttId(int i) {
		attId = i;
	}

	/**
	 * @return attSize
	 */
	public String getAttSize() {
		return attSize;
	}

	/**
	 * @param string
	 */
	public void setAttSize(String string) {
		attSize = string;
	}

	/**
	 * @return attType
	 */
	public String getAttType() {
		return attType;
	}

	/**
	 * @param string
	 */
	public void setAttType(String string) {
		attType = string;
	}

	/**
	 * @return expertRates
	 */
	public String getExpertRates() {
		return expertRates;
	}

	/**
	 * @return expertSpeciality
	 */
	public String getExpertSpeciality() {
		return expertSpeciality;
	}

	/**
	 * @param string
	 */
	public void setExpertRates(String string) {
		expertRates = string;
	}

	/**
	 * @param string
	 */
	public void setExpertSpeciality(String string) {
		expertSpeciality = string;
	}

	/**
	 * @return userid
	 */
	public int getUserid() {
		return userid;
	}

	/**
	 * @param i
	 */
	public void setUserid(int i) {
		userid = i;
	}

	/**
	 * @return expertId
	 */
	public int getExpertId() {
		return expertId;
	}

	/**
	 * @param i
	 */
	public void setExpertId(int i) {
		expertId = i;
	}

	/**
	 * @return hierarchyId
	 */
	public long getHierarchyId() {
		return hierarchyId;
	}

	/**
	 * @param l
	 */
	public void setHierarchyId(long l) {
		hierarchyId = l;
	}

	/**
	 * @return options
	 */
	public String getOptions() {
		return options;
	}

	/**
	 * @param string
	 */
	public void setOptions(String string) {
		options = string;
	}

	/**
	 * @return ids
	 */
	public String getIds() {
		return ids;
	}

	/**
	 * @param string
	 */
	public void setIds(String string) {
		ids = string;
	}

	/**
	 * @return
	 */
	public int getInfluenceLevel() {
		return influenceLevel;
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
	 * @param i
	 */
	public void setInfluenceLevel(int i) {
		influenceLevel = i;
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

	/*
	 * Convert to string. Useful for comparing two beans of this type.  
	 * 
	 * @see java.lang.Object#toString()
	 */
	/*
	public String toString() {
		return "SeacrhDTO(" + userid + ", " + title + ", " + expertName + ", "
				+ specialty + ", " + location + ", " + expertId + ", "
				+ venueName + ", " + userName + ", " + statusId + ", "
				+ statusName + ", " + cdate + ", " + eventType + ", " + eventId
				+ ", " + eventName + ", " + eventTypeId + ", " + eventTypeName
				+ ", " + hierarchyId + ", " + attId + ", " + attName + ", "
				+ labelName + ", " + attDataType + ", " + attSize + ", "
				+ attType + ", " + expertRates + ", " + expertSpeciality + ", "
				+ options + ", " + ids + ", " + longitude + ", " + latitude
				+ ", " + influenceLevel + ")";
	}*/
}
