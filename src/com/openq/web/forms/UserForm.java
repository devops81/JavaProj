package com.openq.web.forms;

import com.openq.group.Groups;
import com.openq.user.UserAddress;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Created by IntelliJ IDEA.
 * User: abhrap
 * Date: Oct 9, 2006
 * Time: 12:50:29 PM
 * To change this template use File | Settings | File Templates.
 */
public class UserForm {
    private long id;
    private String userTypeId;

    private String userName;
    private String userPassword;
    private String firstName;
    private String middleInitial;
    private String lastName;
    private String prefix;
    private String suffix;
    private String birthDate;
    private String ssn;
    private String motherMaidenName;

    private Set groups = new HashSet();
    private String securityQuestion;
    private String answer;
    private String myRegions;
    private String bioData;
    private String dob;
    private String photo;

    private String emailAddress;

    private float longitude;
    private float latitude;
    private long influenceLevel;

    private String reference;
    private String title;


    private String staffid;

    private long kolid;


    private String speciality;

    private String phoneNumber;

    private String    address1;
	private String    address2;
	private String    suiteRoom;
	private String    city;
    private String zip;
    private String state;
    private String MSLDate;

    public String getState() {
        return state;
    }

   

	public void setState(String state) {
        this.state = state;
    }

    private String country;
    private String checkedGroups;

    public String getCheckedGroups() {
        return checkedGroups;
    }

    public void setCheckedGroups(String checkedGroups) {
        this.checkedGroups = checkedGroups;
    }

    public String getZip() {
        return zip;
    }

    public void setZip(String zip) {
        this.zip = zip;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getAddress1() {
        return address1;
    }

    public void setAddress1(String address1) {
        this.address1 = address1;
    }

    public String getAddress2() {
        return address2;
    }

    public void setAddress2(String address2) {
        this.address2 = address2;
    }

    public String getSuiteRoom() {
        return suiteRoom;
    }

    public void setSuiteRoom(String suiteRoom) {
        this.suiteRoom = suiteRoom;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getUserTypeId() {
        return userTypeId;
    }

    public void setUserTypeId(String userTypeId) {
        this.userTypeId = userTypeId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserPassword() {
        return userPassword;
    }

    public void setUserPassword(String userPassword) {
        this.userPassword = userPassword;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleInitial() {
        return middleInitial;
    }

    public void setMiddleInitial(String middleInitial) {
        this.middleInitial = middleInitial;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPrefix() {
        return prefix;
    }

    public void setPrefix(String prefix) {
        this.prefix = prefix;
    }

    public String getSuffix() {
        return suffix;
    }

    public void setSuffix(String suffix) {
        this.suffix = suffix;
    }

    public String getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(String birthDate) {
        this.birthDate = birthDate;
    }

    public String getSsn() {
        return ssn;
    }

    public void setSsn(String ssn) {
        this.ssn = ssn;
    }

    public String getMotherMaidenName() {
        return motherMaidenName;
    }

    public void setMotherMaidenName(String motherMaidenName) {
        this.motherMaidenName = motherMaidenName;
    }

    public Set getGroups() {
        return groups;
    }

    public void setGroups(Set groups) {
        this.groups = groups;
    }

    public String getSecurityQuestion() {
        return securityQuestion;
    }

    public void setSecurityQuestion(String securityQuestion) {
        this.securityQuestion = securityQuestion;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getMyRegions() {
        return myRegions;
    }

    public void setMyRegions(String myRegions) {
        this.myRegions = myRegions;
    }

    public String getBioData() {
        return bioData;
    }

    public void setBioData(String bioData) {
        this.bioData = bioData;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public float getLongitude() {
        return longitude;
    }

    public void setLongitude(float longitude) {
        this.longitude = longitude;
    }

    public float getLatitude() {
        return latitude;
    }

    public void setLatitude(float latitude) {
        this.latitude = latitude;
    }

    public long getInfluenceLevel() {
        return influenceLevel;
    }

    public void setInfluenceLevel(long influenceLevel) {
        this.influenceLevel = influenceLevel;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStaffid() {
        return staffid;
    }

    public void setStaffid(String staffid) {
        this.staffid = staffid;
    }

    public long getKolid() {
        return kolid;
    }

    public void setKolid(long kolid) {
        this.kolid = kolid;
    }

    public String getSpeciality() {
        return speciality;
    }

    public void setSpeciality(String speciality) {
        this.speciality = speciality;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    private String location;

	public String getMSLDate() {
		return MSLDate;
	}



	public void setMSLDate(String date) {
		MSLDate = date;
	}

	
}
