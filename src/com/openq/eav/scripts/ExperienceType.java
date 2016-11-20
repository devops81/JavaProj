package com.openq.eav.scripts;

public class ExperienceType {
	
	public ExperienceType(){}
	private long id;
	private String custnum;
	private String exptype;
	private String description;
	private String sponsor;
	private String ta;
	private String therapy;
	private String position;
	private String expdate;
	private String createdBy;
	private String createDate;
	
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}
	public String getCustnum() {
		return custnum;
	}
	public void setCustnum(String custnum) {
		this.custnum = custnum;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getExpdate() {
		return expdate;
	}
	public void setExpdate(String expdate) {
		this.expdate = expdate;
	}
	public String getExptype() {
		return exptype;
	}
	public void setExptype(String exptype) {
		this.exptype = exptype;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getSponsor() {
		return sponsor;
	}
	public void setSponsor(String sponsor) {
		this.sponsor = sponsor;
	}
	public String getTa() {
		return ta;
	}
	public void setTa(String ta) {
		this.ta = ta;
	}
	public String getTherapy() {
		return therapy;
	}
	public void setTherapy(String therapy) {
		this.therapy = therapy;
	}
}
