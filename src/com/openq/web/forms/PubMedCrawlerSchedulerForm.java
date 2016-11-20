package com.openq.web.forms;

/**
 * Encapsulate data corresponding to the form which is used for submitting
 * asynchronous pubmed crawler runs
 * 
 * @author Amit Arora
 *
 */
public class PubMedCrawlerSchedulerForm {
    private String scheduledTime;

	public String getScheduledTime() {
		return scheduledTime;
	}

	public void setScheduledTime(String scheduledTime) {
		this.scheduledTime = scheduledTime;
	}
    
    
}
