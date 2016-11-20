package com.openq.eav.scripts;

public class Therapies {
	
	public Therapies(){}
	private long id;
	private String olId;
	
	private String custnum;
	private String type;
	private String name;
	private String therapy;
	private String description;
	private String position;
	private String outcome;
	private String sponsor;
	private String diseaseState;
	private String startDate;
	private String endDate;
	private String createdBy;
	private String phase;
	private String createDate;
	

	public String getPhase() {
		return phase;
	}
	public void setPhase(String phase) {
		this.phase = phase;
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

	public String getDiseaseState() {
		return diseaseState;
	}
	public void setDiseaseState(String diseaseState) {
		this.diseaseState = diseaseState;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
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
	public String getOlId() {
		return olId;
	}
	public void setOlId(String olId) {
		this.olId = olId;
	}
	public String getOutcome() {
		return outcome;
	}
	public void setOutcome(String outcome) {
		this.outcome = outcome;
	}
	public String getSponsor() {
		return sponsor;
	}
	public void setSponsor(String sponsor) {
		this.sponsor = sponsor;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getTherapy() {
		return therapy;
	}
	public void setTherapy(String therapy) {
		this.therapy = therapy;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}

}
