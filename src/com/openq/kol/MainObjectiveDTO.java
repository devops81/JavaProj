/*
 * MainObjectiveDTO
 *
 * March 18, 2006
 *
 * Copyright (C) Unpublished openQ. All rights reserved.
 * openQ, Confidential and Proprietary.
 * This software is subject to copyright protection
 * under the laws of the United States and other countries.
 * Unauthorized reproduction and/or distribution is strictly prohibited.
 * Unless otherwise explicitly stated, this software is provided
 * by openQ "AS IS".
 */

package com.openq.kol;

import java.io.Serializable;

public class MainObjectiveDTO implements Serializable {
	
	private long Id;
	private String mainObjective;
	private String description;
	private String TA;
	private String FA;
	private String region;
    private String objective;

	/**
	 * @return
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @return
	 */
	public long getId() {
		return Id;
	}

	/**
	 * @return
	 */
	public String getMainObjective() {
		return mainObjective;
	}

	/**
	 * @param string
	 */
	public void setDescription(String string) {
		description = string;
	}

	/**
	 * @param l
	 */
	public void setId(long l) {
		Id = l;
	}

	/**
	 * @param string
	 */
	public void setMainObjective(String string) {
		mainObjective = string;
	}

	

	public String getRegion() {
		return region;
	}

	public void setRegion(String region) {
		this.region = region;
	}

	public String getFA() {
		return FA;
	}

	public void setFA(String fa) {
		FA = fa;
	}

	public String getTA() {
		return TA;
	}

	public void setTA(String ta) {
		TA = ta;
	}

	public String getObjective() {
		return objective;
	}

	public void setObjective(String objective) {
		this.objective = objective;
	}

	

}
