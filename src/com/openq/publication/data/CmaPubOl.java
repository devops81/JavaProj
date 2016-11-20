package com.openq.publication.data;

import java.io.Serializable;

public class CmaPubOl  implements Serializable {
	private long auto_id;
	private long cmaId;
	private String firstName;
	private String lastName;
	private String speciality;
	
	public long getCmaId() {
		return cmaId;
	}
	public void setCmaId(long cmaId) {
		this.cmaId = cmaId;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getSpeciality() {
		return speciality;
	}
	public void setSpeciality(String speciality) {
		this.speciality = speciality;
	}
	public long getAuto_id() {
		return auto_id;
	}
	public void setAuto_id(long auto_id) {
		this.auto_id = auto_id;
	}

}
