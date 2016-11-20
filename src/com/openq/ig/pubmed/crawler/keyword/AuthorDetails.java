package com.openq.ig.pubmed.crawler.keyword;

import java.util.ArrayList;

/**
 * This is a DAO class used to maintain specific information related to 
 * a particular author 
 *  
 * @author Amit
 *
 */
public class AuthorDetails implements Comparable {
    private int pubCount;
    private ArrayList medicalfocus;

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    private String authorName;
    
    public AuthorDetails(ArrayList medicalfocus, int count, String authorName) {
        this.medicalfocus = medicalfocus;
        this.pubCount = count;
        this.authorName = authorName;

    }

    public ArrayList getMedicalfocus() {
        return medicalfocus;
    }

    public void setMedicalfocus(ArrayList medicalfocus) {
        this.medicalfocus = medicalfocus;
    }

    public int getPubCount() {
        return pubCount;
    }

    public void setPubCount(int pubCount) {
        this.pubCount = pubCount;
    }
    
    public void incrementPubCount() {
        pubCount++;
    }

    public int compareTo(Object arg0) {
		return -(this.pubCount - ((AuthorDetails)arg0).getPubCount());
	}
}
