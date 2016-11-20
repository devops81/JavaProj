package com.openq.batchNotification;

public class InteractionRegistry implements java.io.Serializable{

	long id;
	
	long userId;

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
	

}
