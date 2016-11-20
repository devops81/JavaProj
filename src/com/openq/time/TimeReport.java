package com.openq.time;

import java.io.Serializable;
import java.util.Date;

public class TimeReport implements Serializable, Comparable {

	public TimeReport(){}
	
	private long id;
	private long userId;
	private Date activityDate;
	private long activityId;
	private long percentage;
	private String comments;
	private String finishedFlag;
	private Date createDate;
	private Date updateDate;
	private String deleteFlag;
	
	/* AAG: Commented out needless extra variable below
	 * private long timeSpent;
	 */
	

	public String getComments() {
		return comments;
	}
	
	public void setComments(String comments) {
		this.comments = comments;
	}
	
	public Date getCreateDate() {
		return createDate;
	}
	
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	
	public boolean isFinished() {
		if(finishedFlag.compareToIgnoreCase("y")==0) {
			return true; 
		}
		return false;
	}
	
	public long getId() {
		return id;
	}
	
	public void setId(long id) {
		this.id = id;
	}
	
	public long getUserId() {
		return userId;
	}
	
	public void setUserId(long userId) {
		this.userId = userId;
	}
	
	public Date getActivityDate() {
		return activityDate;
	}
	
	public void setActivityDate(Date activityDate) {
		this.activityDate = activityDate;
	}
	
	public Date getUpdateDate() {
		return updateDate;
	}
	
	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}
	
	public long getActivityId() {
		return activityId;
	}
	
	public void setActivityId(long activityId) {
		this.activityId = activityId;
	}
	
	public long getPercentage() {
		return percentage;
	}
	
	public void setPercentage(long percentage) {
		this.percentage = percentage;
	}
	
	public boolean isFlagSetDelete() {
		if(deleteFlag.compareToIgnoreCase("y")==0) {		
			return true;
		}
		return false;
	}
	
	public void setDeleteFlag(String deleteFlag) {
		this.deleteFlag = deleteFlag;
	}
	/* AAG: no variable -> no method
	public long getTimeSpent() {
		return timeSpent;
	}
	
	public void setTimeSpent(long timeSpent) {
		this.timeSpent = timeSpent;
	}
	*/

	public String getFinishedFlag() {
		return finishedFlag;
	}

	public void setFinishedFlag(String finishedFlag) {
		this.finishedFlag = finishedFlag;
	}

	public String getDeleteFlag() {
		return deleteFlag;
	}
	
	public int compareTo(Object item) {
		return(this.getActivityDate().compareTo(((TimeReport) item).getActivityDate()));
	}
	
	
}
