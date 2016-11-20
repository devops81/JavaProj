package com.openq.pubmed;

import java.util.Date;

public class AsynchPubMedCrawlerJobItem {
	public static final String STATUS_IN_PROGRESS = "IN_PROGRESS";
	public static final String STATUS_SUCCESS = "SUCCESS";
	public static final String STATUS_FAILED = "FAILED";
	
	private long id;
	private long jobId;
	private long olId;
	private String status = "";
	private long fetchTime;

	public long getId() {
		return id;
	}
	
	public void setId(long id) {
		this.id = id;
	}
	
	public long getJobId() {
		return jobId;
	}
	
	public void setJobId(long jobId) {
		this.jobId = jobId;
	}
	
	public long getOlId() {
		return olId;
	}
	
	public void setOlId(long olId) {
		this.olId = olId;
	}
		
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}

	public void setFetchTime(long fetchTime) {
		this.fetchTime = fetchTime;
	}

	public long getFetchTime() {
		return fetchTime;
	}
	
	public Date getFetchDate(){
		return new Date(fetchTime);
	}
}
