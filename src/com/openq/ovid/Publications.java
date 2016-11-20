package com.openq.ovid;

import java.io.Serializable;
import java.util.Date;

public class Publications implements Serializable {
private String expertId;
private String type;
private String year;
private String author;
private String title;
private String citation;
    private String firstName;
    private String middleName;
    private String lastName;
    private int confidenceFactor;
    private String institution;
    private String abstarct;


    public String getAbstarct() {
        return abstarct;
    }

    public void setAbstarct(String abstarct) {
        this.abstarct = abstarct;
    }


    public String getInstitution() {
        return institution;
    }

    public void setInstitution(String institution) {
        this.institution = institution;
    }

    public int getConfidenceFactor() {
        return confidenceFactor;
    }

    public void setConfidenceFactor(int confidenceFactor) {
        this.confidenceFactor = confidenceFactor;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getNlmJournal() {
        return nlmJournal;
    }

    public void setNlmJournal(String nlmJournal) {
        this.nlmJournal = nlmJournal;
    }

    public String getJournalAbstract() {
        return journalAbstract;
    }

    public void setJournalAbstract(String journalAbstract) {
        this.journalAbstract = journalAbstract;
    }

    public String getSubjectHeading() {
        return subjectHeading;
    }

    public void setSubjectHeading(String subjectHeading) {
        this.subjectHeading = subjectHeading;
    }

    public String getCountryOfPublication() {
        return countryOfPublication;
    }

    public void setCountryOfPublication(String countryOfPublication) {
        this.countryOfPublication = countryOfPublication;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getDateOfPublication() {
        return dateOfPublication;
    }

    public void setDateOfPublication(String dateOfPublication) {
        this.dateOfPublication = dateOfPublication;
    }

    private int uniqueIdentifier;
    private String source;
    private String nlmJournal;
    private String journalAbstract;
    private String subjectHeading;
    private String countryOfPublication;
    private String language;
    private String dateOfPublication;

    public int getUniqueIdentifier() {
        return uniqueIdentifier;
    }

    public void setUniqueIdentifier(int uniqueIdentifier) {
        this.uniqueIdentifier = uniqueIdentifier;
    }

    /**
 * @return
 */
public String getAuthor() {
	return author;
}

/**
 * @return
 */
public String getCitation() {
	return citation;
}

/**
 * @return
 */
public String getExpertId() {
	return expertId;
}

/**
 * @return
 */
public String getTitle() {
	return title;
}

/**
 * @return
 */
public String getType() {
	return type;
}

/**
 * @return
 */
public String getYear() {
	return year;
}

/**
 * @param string
 */
public void setAuthor(String string) {
	author = string;
}

/**
 * @param string
 */
public void setCitation(String string) {
	citation = string;
}

/**
 * @param string
 */
public void setExpertId(String string) {
	expertId = string;
}

/**
 * @param string
 */
public void setTitle(String string) {
	title = string;
}

/**
 * @param string
 */
public void setType(String string) {
	type = string;
}

/**
 * @param string
 */
public void setYear(String string) {
	year = string;
}

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String toString() {
        StringBuffer buffer = new StringBuffer();
        buffer.append("Author = ").append(getAuthor()).append(" , ");
        buffer.append("Title = ").append(getTitle()).append(" , ");
        buffer.append("Year = ").append(getYear()).append(" , ");
        buffer.append("Type = ").append(getType());

        return buffer.toString();

    }
}
