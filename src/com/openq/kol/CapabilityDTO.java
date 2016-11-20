package com.openq.kol;



/*
 * KOLDAOImpl
 *
 * Mar 17, 2006
 *
 * Copyright (C) Unpublished openQ. All rights reserved.
 * openQ, Confidential and Proprietary.
 * This software is subject to copyright protection
 * under the laws of the United States and other countries.
 * Unauthorized reproduction and/or distribution is strictly prohibited.
 * Unless otherwise explicitly stated, this software is provided
 * by openQ "AS IS".
*/

public class CapabilityDTO {
	
	private int activityId;
	private int expertId;
	private int tacticId;
	private int planId;
	
	private String activityName;
	private String location;
	private String activityDate;
	
	private String assessment;
	private String topics;
	
	private String tacticName;
	
	
	/**
	 * @return
	 */
	public String getActivityDate() {
		return activityDate;
	}

	/**
	 * @return
	 */
	public int getActivityId() {
		return activityId;
	}

	/**
	 * @return
	 */
	public String getActivityName() {
		return activityName;
	}

	/**
	 * @return
	 */
	public String getAssessment() {
		return assessment;
	}

	/**
	 * @return
	 */
	public String getLocation() {
		return location;
	}

	/**
	 * @return
	 */
	public int getPlanId() {
		return planId;
	}

	/**
	 * @return
	 */
	public int getTacticId() {
		return tacticId;
	}

	/**
	 * @return
	 */
	public String getTopics() {
		return topics;
	}

	/**
	 * @param date
	 */
	public void setActivityDate(String date) {
		activityDate = date;
	}

	/**
	 * @param i
	 */
	public void setActivityId(int i) {
		activityId = i;
	}

	/**
	 * @param string
	 */
	public void setActivityName(String string) {
		activityName = string;
	}

	/**
	 * @param string
	 */
	public void setAssessment(String string) {
		assessment = string;
	}

	/**
	 * @param string
	 */
	public void setLocation(String string) {
		location = string;
	}

	/**
	 * @param i
	 */
	public void setPlanId(int i) {
		planId = i;
	}

	/**
	 * @param i
	 */
	public void setTacticId(int i) {
		tacticId = i;
	}

	/**
	 * @param string
	 */
	public void setTopics(String string) {
		topics = string;
	}
	
	

	/**
	 * @return
	 */
	public String getTacticName() {
		return tacticName;
	}

	/**
	 * @param string
	 */
	public void setTacticName(String string) {
		tacticName = string;
	}
	
	

	/**
	 * @return
	 */
	public int getExpertId() {
		return expertId;
	}

	/**
	 * @param i
	 */
	public void setExpertId(int i) {
		expertId = i;
	}

}
