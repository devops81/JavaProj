package com.openq.interactionData;

import java.io.Serializable;
import java.util.Date;

import com.openq.eav.option.OptionLookup;

public class UserRelationship implements Serializable {
	private long               id;
	private String        territory;
	private String         userId;
	private String  supervisorId;
	private String   reportLevel;
	private Date        beginDate;
	private Date          endDate;


	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}

	public String getTerritory() {
		return territory;
	}
	public void setTerritory(String territory) {
		this.territory = territory;
	}
 
	public String getReportLevel() {
		return reportLevel;
	}
	public void setReportLevel(String reportLevel) {
		this.reportLevel = reportLevel;
	}
	public String getSupervisorId() {
		return supervisorId;
	}
	public void setSupervisorId(String supervisorId) {
		this.supervisorId = supervisorId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getBeginDate() {
		return beginDate;
	}
	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	

	
}
