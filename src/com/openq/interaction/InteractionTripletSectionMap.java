package com.openq.interaction;

public class InteractionTripletSectionMap implements java.io.Serializable{
	private long id;
	private String section;
	private long primaryLOVId;
	private long secondaryLOVId;
	private long tertiaryLOVId;
	
	/**
	 * @return the id
	 */
	public long getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(long id) {
		this.id = id;
	}
	/**
	 * @return the section
	 */
	public String getSection() {
		return section;
	}
	/**
	 * @param section the section to set
	 */
	public void setSection(String section) {
		this.section = section;
	}
	/**
	 * @return the primaryLOVId
	 */
	public long getPrimaryLOVId() {
		return primaryLOVId;
	}
	/**
	 * @param primaryLOVId the primaryLOVId to set
	 */
	public void setPrimaryLOVId(long primaryLOVId) {
		this.primaryLOVId = primaryLOVId;
	}
	/**
	 * @return the secondaryLOVId
	 */
	public long getSecondaryLOVId() {
		return secondaryLOVId;
	}
	/**
	 * @param secondaryLOVId the secondaryLOVId to set
	 */
	public void setSecondaryLOVId(long secondaryLOVId) {
		this.secondaryLOVId = secondaryLOVId;
	}
	/**
	 * @return the tertiaryLOVId
	 */
	public long getTertiaryLOVId() {
		return tertiaryLOVId;
	}
	/**
	 * @param tertiaryLOVId the tertiaryLOVId to set
	 */
	public void setTertiaryLOVId(long tertiaryLOVId) {
		this.tertiaryLOVId = tertiaryLOVId;
	}
	
	
}
