package com.openq.survey;

import java.util.Date;
import java.util.Set;

public class NewSurveyFilled implements java.io.Serializable{

private long id;
private long surveyId;
private long interactionId;
private long expertId;
private Set questionsFilled;
private long userId;
private Date startDate;
private Date updateDate;
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
public long getInteractionId() {
	return interactionId;
}
public void setInteractionId(long interactionId) {
	this.interactionId = interactionId;
}
public long getExpertId() {
	return expertId;
}
public void setExpertId(long expertId) {
	this.expertId = expertId;
}
public Set getQuestionsFilled() {
	return questionsFilled;
}
public void setQuestionsFilled(Set questionsFilled) {
	this.questionsFilled = questionsFilled;
}
public Date getStartDate() {
	return startDate;
}
public void setStartDate(Date startDate) {
	this.startDate = startDate;
}
public Date getUpdateDate() {
	return updateDate;
}
public void setUpdateDate(Date updateDate) {
	this.updateDate = updateDate;
}
public long getUserId() {
	return userId;
}
public void setUserId(long userId) {
	this.userId = userId;
}

}
