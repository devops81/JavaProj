/*
 * Expert
 *
 * April 9, 2006
 *
 * Copyright (C) Unpublished openQ. All rights reserved.
 * openQ, Confidential and Proprietary.
 * This software is subject to copyright protection
 * under the laws of the United States and other countries.
 * Unauthorized reproduction and/or distribution is strictly prohibited.
 * Unless otherwise explicitly stated, this software is provided
 * by openQ "AS IS".
 */
package com.openq.pubmed;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.openq.expertdna.util.StringUtil;


/**
 * Container class for all properties gathered on an Expert during the segmentation process.
 */
public class Expert implements Serializable {

	private static final long serialVersionUID = 7556255514526367802L;
	private long expertID;
	private String lastName;
	private String firstName;
	private String firstInitials;
    private String middleInitials;
    private int    yearsToSearch;
    private String pharmacalogicalAction;
    private String substanceName;
    private String location;
    
    private String therapeauticArea; // TA value got from the EAV-schema
	private String extraKeyword;
	private List  publications = new ArrayList();
	private List scholarArticles = new ArrayList();
	private List missingArticles = new ArrayList();
	private List clinicalTrials = new ArrayList();
	private List ascoAbstracts = new ArrayList();
	private double publicationScore;
	private double citationScore;
	private double clinicalTrialScore;
	private double abstractScore;
	private double publicationRawScore;
	private double citationRawScore;
	private double clinicalTrialRawScore;
	private double abstractRawScore;
	
	private Date lastFetchTime;
	
	public Date getLastFetchTime() {
		return lastFetchTime;
	}
	public void setLastFetchTime(Date lastFetchTime) {
		this.lastFetchTime = lastFetchTime;
	}
	public double getAbstractScore() {
		return abstractScore;
	}
	public void setAbstractScore(double abstractScore) {
		this.abstractScore = abstractScore;
	}
	public List getMissingArticles() {
		return missingArticles;
	}
	public double getCitationScore() {
		return citationScore;
	}
	public void setCitationScore(double citationScore) {
		this.citationScore = citationScore;
	}
	public double getClinicalTrialScore() {
		return clinicalTrialScore;
	}
	public void setClinicalTrialScore(double clinicalTrialScore) {
		this.clinicalTrialScore = clinicalTrialScore;
	}
	public double getPublicationScore() {
		return publicationScore;
	}
	public void setPublicationScore(double publicationScore) {
		this.publicationScore = publicationScore;
	}
	public List getPublications() {
		return publications;
	}
	public void setPublications(List publications) {
		this.publications = publications;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
		if(firstInitials == null && !StringUtil.isEmptyString(firstName))
		{
			firstInitials = firstName.substring(0, 1);
		}
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public long getExpertID() {
		return expertID;
	}
	public void setExpertID(long expertID) {
		this.expertID = expertID;
	}
	public String getExtraKeyword() {
		return extraKeyword;
	}
	public void setExtraKeyword(String extraKeyword) {
		this.extraKeyword = extraKeyword;
	}
	public List getScholarArticles() {
		return scholarArticles;
	}
	public void setScholarArticles(List scholarArticles) {
		this.scholarArticles = scholarArticles;
	}
	public List getClinicalTrials() {
		return clinicalTrials;
	}
	public void setClinicalTrials(List clinicalTrials) {
		this.clinicalTrials = clinicalTrials;
	}
	public void setMissingArticles(List missingArticles) {
		this.missingArticles = missingArticles;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public List getAscoAbstracts() {
		return ascoAbstracts;
	}
	public void setAscoAbstracts(List ascoAbstracts) {
		this.ascoAbstracts = ascoAbstracts;
	}
	public String getFirstInitials() {
		return firstInitials;
	}
	public void setFirstInitials(String pubMedInitials) {
		this.firstInitials = pubMedInitials;
		if(firstName == null)
		{
			firstName = firstInitials;
		}
	}
	public static long getSerialVersionUID() {
		return serialVersionUID;
	}
	public double getAbstractRawScore() {
		return abstractRawScore;
	}
	public void setAbstractRawScore(double abstractRawScore) {
		this.abstractRawScore = abstractRawScore;
	}
	public double getCitationRawScore() {
		return citationRawScore;
	}
	public void setCitationRawScore(double citationRawScore) {
		this.citationRawScore = citationRawScore;
	}
	public double getClinicalTrialRawScore() {
		return clinicalTrialRawScore;
	}
	public void setClinicalTrialRawScore(double clinicalTrialRawScore) {
		this.clinicalTrialRawScore = clinicalTrialRawScore;
	}
	public double getPublicationRawScore() {
		return publicationRawScore;
	}
	public void setPublicationRawScore(double publicationRawScore) {
		this.publicationRawScore = publicationRawScore;
	}
    public String getMiddleInitials()
    {
        return middleInitials;
    }
    public void setMiddleInitials(String middleInitials)
    {
        this.middleInitials = middleInitials;
    }
    public String getPharmacalogicalAction()
    {
        return pharmacalogicalAction;
    }
    public void setPharmacalogicalAction(String pharmacalogicalAction)
    {
        this.pharmacalogicalAction = pharmacalogicalAction;
    }
    public String getSubstanceName()
    {
        return substanceName;
    }
    public void setSubstanceName(String substanceName)
    {
        this.substanceName = substanceName;
    }
    public int getYearsToSearch()
    {
        return yearsToSearch;
    }
    public void setYearsToSearch(int yearsToSearch)
    {
        this.yearsToSearch = yearsToSearch;
    }
    public String getTherapeauticArea() {
        return therapeauticArea;
    }
    public void setTherapeauticArea(String therapeauticArea) {
        this.therapeauticArea = therapeauticArea;
    }
	
}
