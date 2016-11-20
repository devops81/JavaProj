package com.openq.eav.audit;

import java.io.Serializable;
import java.util.Date;

public class AuditInfo implements Serializable {
	
	public AuditInfo(){}
	
	private long id;
	private long editedEntityId;
	private String userName;
	private long userId;
	private Date updateTime;
	public long getEditedEntityId() {
		return editedEntityId;
	}
	public void setEditedEntityId(long editedEntityId) {
		this.editedEntityId = editedEntityId;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public long getUserId() {
		return userId;
	}
	public void setUserId(long userId) {
		this.userId = userId;
	}

}
