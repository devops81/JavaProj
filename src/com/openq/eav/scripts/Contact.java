package com.openq.eav.scripts;

public class Contact {

	public Contact(){}
	private long id;
	private String olId;
	private String cmaId;
	private String custnum;
	private String contactType;
	private String contactInfo;
	private String preferred;
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
	public String getCmaId() {
		return cmaId;
	}
	public void setCmaId(String cmaId) {
		this.cmaId = cmaId;
	}
	public String getContactInfo() {
		return contactInfo;
	}
	public void setContactInfo(String contactInfo) {
		this.contactInfo = contactInfo;
	}
	public String getContactType() {
		return contactType;
	}
	public void setContactType(String contactType) {
		this.contactType = contactType;
	}
	public String getCustnum() {
		return custnum;
	}
	public void setCustnum(String custnum) {
		this.custnum = custnum;
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
	public String getPreferred() {
		return preferred;
	}
	public void setPreferred(String preferred) {
		this.preferred = preferred;
	}
}
