package com.openq.kol;

import java.io.Serializable;

public class NodeDTO implements Serializable {
	
	private int segmentId;
	private int parentId;
	private String 	parentName;
	private String 	description;
	private String 	createdBy;
	private String createdDate;
	private String strategyLevel;
	private String strategyStatus;
	
	private String countryName;
	private String segmentName;
	private String statedStrategy;
	private String segmentObjective;
	private String keyMessages;
	private int creatorId;
	
	
	private String childPresent;
	
	private String taId;
	private String taName;
	private String faId;
	private String faName;	
	private String regionId;
	private String regionName;
	
	/**
	 * @return
	 */
	public String getCreatedBy() {
		return createdBy;
	}

	/**
	 * @return
	 */
	public String getCreatedDate() {
		return createdDate;
	}

	/**
	 * @return
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @return
	 */
	public String getParentName() {
		return parentName;
	}

	/**
	 * @param string
	 */
	public void setCreatedBy(String string) {
		createdBy = string;
	}

	/**
	 * @param string
	 */
	public void setCreatedDate(String string) {
		createdDate = string;
	}

	/**
	 * @param string
	 */
	public void setDescription(String string) {
		description = string;
	}

	/**
	 * @param string
	 */
	public void setParentName(String string) {
		parentName = string;
	}

	/**
	 * @return
	 */
	public int getSegmentId() {
		return segmentId;
	}

	/**
	 * @param i
	 */
	public void setSegmentId(int i) {
		segmentId = i;
	}

	/**
	 * @return
	 */
	public int getParentId() {
		return parentId;
	}

	/**
	 * @param i
	 */
	public void setParentId(int i) {
		parentId = i;
	}

	/**
	 * @return
	 */
	public String getStrategyLevel() {
		return strategyLevel;
	}
	
	/**
	 * @return
	 */
	public String getCountryName() {
		return countryName;
	}

	/**
	 * @return
	 */
	public String getSegmentName() {
		return segmentName;
	}

	/**
	 * @return
	 */
	public String getSegmentObjective() {
		return segmentObjective;
	}

	

	/**
	 * @param string
	 */
	public void setCountryName(String string) {
		countryName = string;
	}

	/**
	 * @param string
	 */
	public void setSegmentName(String string) {
		segmentName = string;
	}

	/**
	 * @param string
	 */
	public void setSegmentObjective(String string) {
		segmentObjective = string;
	}

	
	/**
	 * @param string
	 */
	public void setStatedStrategy(String string) {
		statedStrategy = string;
	}
	
	

	/**
	 * @return
	 */
	public String getStatedStrategy() {
		return statedStrategy;
	}

	/**
	 * @param string
	 */
	public void setStrategyLevel(String string) {
		strategyLevel = string;
	}

	/**
	 * @return
	 */
	public String getKeyMessages() {
		return keyMessages;
	}

	/**
	 * @param string
	 */
	public void setKeyMessages(String string) {
		keyMessages = string;
	}

	/**
	 * @return
	 */
	public String getStrategyStatus() {
		return strategyStatus;
	}

	/**
	 * @param string
	 */
	public void setStrategyStatus(String string) {
		strategyStatus = string;
	}

	/**
	 * @return
	 */
	public String getChildPresent() {
		return childPresent;
	}

	/**
	 * @param string
	 */
	public void setChildPresent(String string) {
		childPresent = string;
	}

	public int getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(int creatorId) {
		this.creatorId = creatorId;
	}

	public String getFaId() {
		return faId;
	}

	public void setFaId(String faId) {
		this.faId = faId;
	}

	public String getFaName() {
		return faName;
	}

	public void setFaName(String faName) {
		this.faName = faName;
	}

	public String getRegionId() {
		return regionId;
	}

	public void setRegionId(String regionId) {
		this.regionId = regionId;
	}

	public String getRegionName() {
		return regionName;
	}

	public void setRegionName(String regionName) {
		this.regionName = regionName;
	}

	public String getTaId() {
		return taId;
	}

	public void setTaId(String taId) {
		this.taId = taId;
	}

	public String getTaName() {
		return taName;
	}

	public void setTaName(String taName) {
		this.taName = taName;
	}

	

} // end of UserDTO