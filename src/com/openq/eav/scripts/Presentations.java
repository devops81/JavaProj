package com.openq.eav.scripts;

import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;

public class Presentations implements Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "city", "country", "createdBy", "createdDate",
            "custId", "dateOfPresentation", "description", "position", "sponsor", "state", "therapy", "type" });

	public void Presentations() {};
	private long id;
	private String custId;
    private String type;
    private String description;
    private String sponsor;
    private String therapy;
    private String position;
    private String dateOfPresentation;
    private String city;
    private String state;
    private String country;
    private String createdBy;
    private String createdDate;
    
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
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
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getSponsor() {
		return sponsor;
	}
	public void setSponsor(String sponsor) {
		this.sponsor = sponsor;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getTherapy() {
		return therapy;
	}
	public void setTherapy(String therapy) {
		this.therapy = therapy;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getDateOfPresentation() {
		return dateOfPresentation;
	}
	public void setDateOfPresentation(String dateOfPresentation) {
		this.dateOfPresentation = dateOfPresentation;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field));
    }
}
