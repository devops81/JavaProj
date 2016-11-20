package com.openq.publication.data;

import java.io.Serializable;
import java.util.Date;


public class Publications implements Serializable {
	private long publicationId;
	private String issn;
	private long uniqueId;
	private String publicationType;
	private String source;
	private String journalName;
	private String title;
	private String abstractPublication;
	private String dateOfPublication;
	private int yearOfPublication;
	private String subjectHeading;
	private String countryOfPublication;
	private String language;
	private String authors;
	private long authorId;
	private String status;
	private int confidenceFactor;
	private int commit_flag;
	private Date createTime;
	private Date updateTime;
	private int deleteFlag;
	private int updaterId;
	private String institution;
	
	public String getInstitution() {
		return institution;
	}
	public void setInstitution(String institution) {
		this.institution = institution;
	}
	public long getAuthorId() {
		return authorId;
	}
	public void setAuthorId(long authorId) {
		this.authorId = authorId;
	}
	public int getCommit_flag() {
		return commit_flag;
	}
	public void setCommit_flag(int commit_flag) {
		this.commit_flag = commit_flag;
	}
	public int getConfidenceFactor() {
		return confidenceFactor;
	}
	public void setConfidenceFactor(int confidenceFactor) {
		this.confidenceFactor = confidenceFactor;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public int getDeleteFlag() {
		return deleteFlag;
	}
	public void setDeleteFlag(int deleteFlag) {
		this.deleteFlag = deleteFlag;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public int getUpdaterId() {
		return updaterId;
	}
	public void setUpdaterId(int updaterId) {
		this.updaterId = updaterId;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public String getAbstractPublication() {
		return abstractPublication;
	}
	public void setAbstractPublication(String abstractPublication) {
		this.abstractPublication = abstractPublication;
	}
	public String getAuthors() {
		return authors;
	}
	public void setAuthors(String authors) {
		this.authors = authors;
	}
	public String getCountryOfPublication() {
		return countryOfPublication;
	}
	public void setCountryOfPublication(String countryOfPublication) {
		this.countryOfPublication = countryOfPublication;
	}
	public String getDateOfPublication() {
		return dateOfPublication;
	}
	public void setDateOfPublication(String dateOfPublication) {
		this.dateOfPublication = dateOfPublication;
	}
	public String getIssn() {
		return issn;
	}
	public void setIssn(String issn) {
		this.issn = issn;
	}
	public String getJournalName() {
		return journalName;
	}
	public void setJournalName(String journalName) {
		this.journalName = journalName;
	}
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public long getPublicationId() {
		return publicationId;
	}
	public void setPublicationId(long publicationId) {
		this.publicationId = publicationId;
	}
	public String getPublicationType() {
		return publicationType;
	}
	public void setPublicationType(String publicationType) {
		this.publicationType = publicationType;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getSubjectHeading() {
		return subjectHeading;
	}
	public void setSubjectHeading(String subjectHeading) {
		this.subjectHeading = subjectHeading;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public long getUniqueId() {
		return uniqueId;
	}
	public void setUniqueId(long uniqueId) {
		this.uniqueId = uniqueId;
	}
	public int getYearOfPublication() {
		return yearOfPublication;
	}
	public void setYearOfPublication(int yearOfPublication) {
		this.yearOfPublication = yearOfPublication;
	}
	

}
