package com.openq.pubmed;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class AsynchPubMedCrawlerJob {
	public static final String STATUS_TO_BE_SCHEDULED = "TO_BE_SCHEDULED";
	public static final String STATUS_RUNNING = "RUNNING";
	public static final String STATUS_DONE = "DONE";
	
	private static final SimpleDateFormat jobDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm a");
	
	private long id;
	private long scheduledTime;
	private String status = STATUS_TO_BE_SCHEDULED;
    private long totalOLCount;
    private long crawledOLCount;
	
	public AsynchPubMedCrawlerJob() {
		
	}
	
	public AsynchPubMedCrawlerJob(String date, String time) throws ParseException {
		Date d = jobDateFormat.parse(date + " " + time);
		scheduledTime = d.getTime();
	}

	public long getId() {
		return id;
	}
	
	public void setId(long id) {
		this.id = id;
	}
	
	public long getScheduledTime() {
		return scheduledTime;
	}
	
	public void setScheduledTime(long scheduledTime) {
		this.scheduledTime = scheduledTime;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}

    public long getTotalOLCount() {
        return totalOLCount;
    }

    public void setTotalOLCount(long totalOLCount) {
        this.totalOLCount = totalOLCount;
    }

    public long getCrawledOLCount() {
        return crawledOLCount;
    }

    public void setCrawledOLCount(long crawledOLCount) {
        this.crawledOLCount = crawledOLCount;
    }

    
    public String getScheduledTimeForDisplay() {
		Date d = new Date(scheduledTime);
		return jobDateFormat.format(d);
	}
}
