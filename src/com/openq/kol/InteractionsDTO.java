package com.openq.kol;

/**

* File : InteractionsDTO.java

* Purpose : 
* 
* Created on Jul 15, 2005
* 
* Copyright (c) Openq 2005. All rights reserved Unauthorized reproduction
* and/or distribution is strictly prohibited. 
* 
* description :
* 
* author : vpadmavati
* 
*/

public class InteractionsDTO  implements java.io.Serializable{

	private int userId;

    public String toString() {
        return "";
    }

    private String userName;
	private int interactionId;
	private String interactionType;
	private String interactionDate;
	private String notes;
	private String issues;
	private String nextSteps;
	private String outcome;
	private String planCost;
	//For Development Plan
	private int devPlanId;
	private String year;
	private String trimester;
	private String activity;
	private String role;
	private String strategy;
	private String dueDate;
    private String owner;
    private String therapy;
    private String staffId;
    private String activityId;

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    private String comment;

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getAmgenOwnerUserId() {
        return amgenOwnerUserId;
    }

    public void setAmgenOwnerUserId(String amgenOwnerUserId) {
        this.amgenOwnerUserId = amgenOwnerUserId;
    }

    private String amgenOwnerUserId;

    public String getPlanId() {
        return planId;
    }

    public void setPlanId(String planId) {
        this.planId = planId;
    }

    private String planId;

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    private String fullName;

    public String getStaffId() {
        return staffId;
    }

    public void setStaffId(String staffId) {
        this.staffId = staffId;
    }

    public String getTherapyName() {
        return therapyName;
    }

    public void setTherapyName(String therapyName) {
        this.therapyName = therapyName;
    }

    private String therapyName;
    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }

    private String statusName;
    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    private String roleName;
    public String getDueDate() {
        return dueDate;
    }

    public void setDueDate(String dueDate) {
        this.dueDate = dueDate;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public String getTherapy() {
        return therapy;
    }

    public void setTherapy(String therapy) {
        this.therapy = therapy;
    }

    long expertId;
	
	///
	private String status;
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	///
	
	public String getPlanCost() {
		return planCost;
	}
	
	public void setPlanCost(String cost) {
		planCost = cost;
	}
	
	/**
	 * @return
	 */
	public String getInteractionDate() {
		return interactionDate;
	}

	/**
	 * @return
	 */
	public String getInteractionType() {
		return interactionType;
	}

	/**
	 * @return
	 */
	public String getIssues() {
		return issues;
	}

	/**
	 * @return
	 */
	public String getNextSteps() {
		return nextSteps;
	}

	/**
	 * @return
	 */
	public String getNotes() {
		return notes;
	}

	/**
	 * @return
	 */
	public String getOutcome() {
		return outcome;
	}

	/**
	 * @return
	 */
	public int getUserId() {
		return userId;
	}

	/**
	 * @param string
	 */
	public void setInteractionDate(String string) {
		interactionDate = string;
	}

	/**
	 * @param string
	 */
	public void setInteractionType(String string) {
		interactionType = string;
	}

	/**
	 * @param string
	 */
	public void setIssues(String string) {
		issues = string;
	}

	/**
	 * @param string
	 */
	public void setNextSteps(String string) {
		nextSteps = string;
	}

	/**
	 * @param string
	 */
	public void setNotes(String string) {
		notes = string;
	}

	/**
	 * @param string
	 */
	public void setOutcome(String string) {
		outcome = string;
	}

	/**
	 * @param string
	 */
	public void setUserId(int userId) {
		this.userId = userId;
	}

	/**
	 * @return
	 */
	public int getInteractionId() {
		return interactionId;
	}

	/**
	 * @param i
	 */
	public void setInteractionId(int i) {
		interactionId = i;
	}

	/**
	 * @return
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @param string
	 */
	public void setUserName(String string) {
		userName = string;
	}

	/**
	 * getActivity
	 * String
	 * @return
	 */
	public String getActivity() {
		return activity;
	}

	/**
	 * getRole
	 * String
	 * @return
	 */
	public String getRole() {
		return role;
	}

	/**
	 * getTrimester
	 * String
	 * @return
	 */
	public String getTrimester() {
		return trimester;
	}

	/**
	 * getYear
	 * String
	 * @return
	 */
	public String getYear() {
		return year;
	}

	/**
	 * setActivity
	 * void
	 * @param string
	 */
	public void setActivity(String string) {
		activity = string;
	}

	/**
	 * setRole
	 * void
	 * @param string
	 */
	public void setRole(String string) {
		role = string;
	}

	/**
	 * setTrimester
	 * void
	 * @param string
	 */
	public void setTrimester(String string) {
		trimester = string;
	}

	/**
	 * setYear
	 * void
	 * @param i
	 */
	public void setYear(String i) {
		year = i;
	}

	/**
	 * @return
	 */
	public int getDevPlanId() {
		return devPlanId;
	}

	/**
	 * @param i
	 */
	public void setDevPlanId(int i) {
		devPlanId = i;
	}

	/**
	 * @return
	 */
	public String getStrategy() {
		return strategy;
	}

	/**
	 * @param string
	 */
	public void setStrategy(String string) {
		strategy = string;
	}

	public long getExpertId() {
		return expertId;
	}

	public void setExpertId(long expertId) {
		this.expertId = expertId;
	}
	
}

