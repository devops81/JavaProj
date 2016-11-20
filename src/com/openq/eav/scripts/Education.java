package com.openq.eav.scripts;

public class Education {
	public Education(){}
	private long id;
	private String olId;
	private String cmaId;
	private String custnum;
	private String type;
	private String description;
	private String institution;
	private String degree;
	private String location;
	private String beginYear;
	private String endYear;
	private String createdBy;
	private String createdDate;
	
	
	public String getBeginYear() {
		return beginYear;
	}
	public void setBeginYear(String beginYear) {
		this.beginYear = beginYear;
	}
	
	public String getCmaId() {
		return cmaId;
	}
	public void setCmaId(String cmaId) {
		this.cmaId = cmaId;
	}
	public String getCustnum() {
		return custnum;
	}
	public void setCustnum(String custnum) {
		this.custnum = custnum;
	}
	public String getDegree() {
		return degree;
	}
	public void setDegree(String degree) {
		this.degree = degree;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getEndYear() {
		return endYear;
	}
	public void setEndYear(String endYear) {
		this.endYear = endYear;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getInstitution() {
		return institution;
	}
	public void setInstitution(String institution) {
		this.institution = institution;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getOlId() {
		return olId;
	}
	public void setOlId(String olId) {
		this.olId = olId;
	}
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}
	public String getCreatedDate() {
		return createdDate;
	}
	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}

}
