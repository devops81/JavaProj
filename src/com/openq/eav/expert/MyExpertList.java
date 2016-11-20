package com.openq.eav.expert;

import java.io.Serializable;


public class MyExpertList implements Serializable {
	
	public MyExpertList() {}
	
	
	private long id;
	
	private String staffid;
	
	private long kolid;
	
	private String name;
	
	private String speciality;
	
	private String phone;
	
	private String location;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getKolid() {
		return kolid;
	}

	public void setKolid(long kolid) {
		this.kolid = kolid;
	}

	
	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getSpeciality() {
		return speciality;
	}

	public void setSpeciality(String speciality) {
		this.speciality = speciality;
	}

	public String getStaffid() {
		return staffid;
	}

	public void setStaffid(String staffid) {
		this.staffid = staffid;
	}
	
}
