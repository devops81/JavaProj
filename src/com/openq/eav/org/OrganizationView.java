package com.openq.eav.org;

import java.io.Serializable;

public class OrganizationView implements Serializable {

private long id;
private String name;
private String acronym;
private String addrLine1;
private String addrLine2;
private String state;
private String city;
private String type;
private String zip;
private String country;
public long getId() {
	return id;
}
public void setId(long id) {
	this.id = id;
}
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public String getAcronym() {
	return acronym;
}
public void setAcronym(String acronym) {
	this.acronym = acronym;
}
public String getAddrLine1() {
	return addrLine1;
}
public void setAddrLine1(String addrLine1) {
	this.addrLine1 = addrLine1;
}
public String getAddrLine2() {
	return addrLine2;
}
public void setAddrLine2(String addrLine2) {
	this.addrLine2 = addrLine2;
}
public String getState() {
	return state;
}
public void setState(String state) {
	this.state = state;
}
public String getCity() {
	return city;
}
public void setCity(String city) {
	this.city = city;
}
public String getType() {
	return type;
}
public void setType(String type) {
	this.type = type;
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
	

}
