package com.openq.publication.data;

import java.io.Serializable;
import java.util.Date;

public class Request implements Serializable {
	long requestId;
	long userId;
	String queryType;
	Date requestTimeStamp;
	String status;
	String priority;
	Date requestCompeleted;
	
	public Date getRequestCompeleted() {
		return requestCompeleted;
	}
	public void setRequestCompeleted(Date requestCompeleted) {
		this.requestCompeleted = requestCompeleted;
	}
	public String getPriority() {
		return priority;
	}
	public void setPriority(String priority) {
		this.priority = priority;
	}
	public String getQueryType() {
		return queryType;
	}
	public void setQueryType(String queryType) {
		this.queryType = queryType;
	}
	public long getRequestId() {
		return requestId;
	}
	public void setRequestId(long requestId) {
		this.requestId = requestId;
	}
	public Date getRequestTimeStamp() {
		return requestTimeStamp;
	}
	public void setRequestTimeStamp(Date requestTimeStamp) {
		this.requestTimeStamp = requestTimeStamp;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public long getUserId() {
		return userId;
	}
	public void setUserId(long userId) {
		this.userId = userId;
	}
	

}
