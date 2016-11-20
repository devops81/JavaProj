package com.openq.eav.scripts;

public class Position {
	public void Position() {};
	private long id;
	private String custId;
    private String posDate;
    private String therapy;
    private String platform;
    private String publication;
    private String research;
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
	public String getPlatform() {
		return platform;
	}
	public void setPlatform(String platform) {
		this.platform = platform;
	}
	public String getPosDate() {
		return posDate;
	}
	public void setPosDate(String posDate) {
		this.posDate = posDate;
	}
	public String getPublication() {
		return publication;
	}
	public void setPublication(String publication) {
		this.publication = publication;
	}
	public String getResearch() {
		return research;
	}
	public void setResearch(String research) {
		this.research = research;
	}
	public String getTherapy() {
		return therapy;
	}
	public void setTherapy(String therapy) {
		this.therapy = therapy;
	}
   
}
