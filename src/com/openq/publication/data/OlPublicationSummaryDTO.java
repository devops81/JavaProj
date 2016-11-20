package com.openq.publication.data;

import java.io.Serializable;
import java.util.Date;

public class OlPublicationSummaryDTO implements Serializable{
	private long summaryid;
	private long expertId;
	private String expertName;
	private int publicationInProfile;
	private int totalUncommitedPublications;
	private int newPublications;
	private Date lastCapture;
	private Date lastUpdate;
	private String lastUpdater;
	
	
	public String getExpertName() {
		return expertName;
	}
	public void setExpertName(String expertName) {
		this.expertName = expertName;
	}
	public Date getLastCapture() {
		return lastCapture;
	}
	public void setLastCapture(Date lastCapture) {
		this.lastCapture = lastCapture;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	public String getLastUpdater() {
		return lastUpdater;
	}
	public void setLastUpdater(String lastUpdater) {
		this.lastUpdater = lastUpdater;
	}
	public int getNewPublications() {
		return newPublications;
	}
	public void setNewPublications(int newPublications) {
		this.newPublications = newPublications;
	}
	public int getPublicationInProfile() {
		return publicationInProfile;
	}
	public void setPublicationInProfile(int publicationInProfile) {
		this.publicationInProfile = publicationInProfile;
	}
	public int getTotalUncommitedPublications() {
		return totalUncommitedPublications;
	}
	public void setTotalUncommitedPublications(int totalUncommitedPublications) {
		this.totalUncommitedPublications = totalUncommitedPublications;
	}

	public long getExpertId() {
		return expertId;
	}

	public void setExpertId(long expertId) {
		this.expertId = expertId;
	}
	public long getSummaryid() {
		return summaryid;
	}
	public void setSummaryid(long summaryid) {
		this.summaryid = summaryid;
	}

}
