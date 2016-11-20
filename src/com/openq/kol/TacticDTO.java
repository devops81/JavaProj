/*
 * Created on Mar 2, 2006
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.openq.kol;

import java.io.Serializable;

/**
 * @author ravipm
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class TacticDTO implements Serializable{

	private int tacticId;
	
	private String tacticName;
	private String tacticDate;
	private String tacticDetail;
	
	private int tacticYear;
	
	
	private int segmentTacticId;
	private int segmentId;
	private String quarter;
	private String role;
	private String region;
	private String budget;
	
	public int userId;
	public int expertId;
	
	private String FA;
	private String TA;
	private String objective;
	private int objectiveId;
    private String roleName;

    public String getActivity() {
        return activity;
    }

    public void setActivity(String activity) {
        this.activity = activity;
    }

    private String activity;


    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    private String tacticDueDate;

    public String getTacticDueDate() {
        return tacticDueDate;
    }

    public void setTacticDueDate(String tacticDueDate) {
        this.tacticDueDate = tacticDueDate;
    }

    /**
	 * @return
	 */
	public String getTacticDate() {
		return tacticDate;
	}

	/**
	 * @return
	 */
	public String getTacticDetail() {
		return tacticDetail;
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
	public String getTacticName() {
		return tacticName;
	}

	/**
	 * @return
	 */
	public int getTacticYear() {
		return tacticYear;
	}

	/**
	 * @param string
	 */
	public void setTacticDate(String string) {
		tacticDate = string;
	}

	/**
	 * @param string
	 */
	public void setTacticDetail(String string) {
		tacticDetail = string;
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
	public void setTacticName(String string) {
		tacticName = string;
	}

	/**
	 * @param i
	 */
	public void setTacticYear(int i) {
		tacticYear = i;
	}
	
	

	/**
	 * @return
	 */
	public String getBudget() {
		return budget;
	}

	/**
	 * @return
	 */
	public String getQuarter() {
		return quarter;
	}

	/**
	 * @return
	 */
	public String getRegion() {
		return region;
	}

	/**
	 * @return
	 */
	public String getRole() {
		return role;
	}

	/**
	 * @return
	 */
	public int getSegmentId() {
		return segmentId;
	}

	/**
	 * @return
	 */
	public int getSegmentTacticId() {
		return segmentTacticId;
	}

	/**
	 * @param string
	 */
	public void setBudget(String string) {
		budget = string;
	}

	/**
	 * @param string
	 */
	public void setQuarter(String string) {
		quarter = string;
	}

	/**
	 * @param string
	 */
	public void setRegion(String string) {
		region = string;
	}

	/**
	 * @param string
	 */
	public void setRole(String string) {
		role = string;
	}

	/**
	 * @param i
	 */
	public void setSegmentId(int i) {
		segmentId = i;
	}

	/**
	 * @param i
	 */
	public void setSegmentTacticId(int i) {
		segmentTacticId = i;
	}
	
	

	/**
	 * @return
	 */
	public int getExpertId() {
		return expertId;
	}

	/**
	 * @return
	 */
	public int getUserId() {
		return userId;
	}

	/**
	 * @param i
	 */
	public void setExpertId(int i) {
		expertId = i;
	}

	/**
	 * @param i
	 */
	public void setUserId(int i) {
		userId = i;
	}

	public String getFA() {
		return FA;
	}

	public void setFA(String fa) {
		FA = fa;
	}

	public String getObjective() {
		return objective;
	}

	public void setObjective(String objective) {
		this.objective = objective;
	}

	public String getTA() {
		return TA;
	}

	public void setTA(String ta) {
		TA = ta;
	}

	public int getObjectiveId() {
		return objectiveId;
	}

	public void setObjectiveId(int objectiveId) {
		this.objectiveId = objectiveId;
	}



}
