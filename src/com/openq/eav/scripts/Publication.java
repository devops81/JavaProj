package com.openq.eav.scripts;

public class Publication {
	
	public Publication(){}
	private long id;
	private String olId;
	private String custnum;
	private String title;
	private String journal;
	private String journalReference;
	private String pubDate;
	private String type;
	private String sponsor;
	private String medlineId;
	private String createdBy;
	private String createDate;
	
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
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getJournal() {
		return journal;
	}
	public void setJournal(String journal) {
		this.journal = journal;
	}
	public String getJournalReference() {
		return journalReference;
	}
	public void setJournalReference(String journalReference) {
		this.journalReference = journalReference;
	}
	public String getMedlineId() {
		return medlineId;
	}
	public void setMedlineId(String medlineId) {
		this.medlineId = medlineId;
	}
	public String getOlId() {
		return olId;
	}
	public void setOlId(String olId) {
		this.olId = olId;
	}
	public String getPubDate() {
		return pubDate;
	}
	public void setPubDate(String pubDate) {
		this.pubDate = pubDate;
	}
	public String getSponsor() {
		return sponsor;
	}
	public void setSponsor(String sponsor) {
		this.sponsor = sponsor;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	}
