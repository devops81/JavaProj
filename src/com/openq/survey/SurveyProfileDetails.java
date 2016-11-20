package com.openq.survey;

import java.util.Date;

public class SurveyProfileDetails implements java.io.Serializable{
	
	long id;
	
   String userName;
   
   String surveyName;
   
   Date date;
   
   long surveyId;
   
   
public Date getDate() {
	return date;
}

public void setDate(Date date) {
	this.date = date;
}

public String getSurveyName() {
	return surveyName;
}

public void setSurveyName(String surveyName) {
	this.surveyName = surveyName;
}

public String getUserName() {
	return userName;
}

public void setUserName(String userName) {
	this.userName = userName;
}

public long getId() {
	return id;
}

public void setId(long id) {
	this.id = id;
}

public long getSurveyId() {
	return surveyId;
}

public void setSurveyId(long surveyId) {
	this.surveyId = surveyId;
}
 

}
