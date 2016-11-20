package com.openq.eav.scripts;

public class Topics {
	public void Topics() {};
	private long id;
	private String olId;
	private String custId;
    private String cmaId;
    private String topic;
    private String createdBy;
    private String createdDate;
	public String getCmaId() {
		return cmaId;
	}
	public void setCmaId(String cmaId) {
		this.cmaId = cmaId;
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
	public String getCustId() {
		return custId;
	}
	public void setCustId(String custId) {
		this.custId = custId;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getOlId() {
		return olId;
	}
	public void setOlId(String olId) {
		this.olId = olId;
	}
	public String getTopic() {
		return topic;
	}
	public void setTopic(String topic) {
		this.topic = topic;
	}
    
   
}
