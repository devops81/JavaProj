package com.openq.eav.scripts;

public class InterestDescription {
	public void InterestDescription() {};
	private long id;
    private String olId;
    private String custId;
    private String InterestDesc;
    private String frequency;
    private String createdBy;
    private String createdDate;
    
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
	public String getCustId() {
		return custId;
	}
	public void setCustId(String custId) {
		this.custId = custId;
	}
	public String getFrequency() {
		return frequency;
	}
	public void setFrequency(String frequency) {
		this.frequency = frequency;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getInterestDesc() {
		return InterestDesc;
	}
	public void setInterestDesc(String interestDesc) {
		InterestDesc = interestDesc;
	}
	public String getOlId() {
		return olId;
	}
	public void setOlId(String olId) {
		this.olId = olId;
	}
}
