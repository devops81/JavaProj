package com.openq.survey;

import java.util.Set;

public class NewSurvey implements java.io.Serializable{
private long id;
private String name;
private String type;
private String state;
private String active;
private Set questions;
private String surveyStartDate;
private String surveyEndDate;

public String getSurveyStartDate()
{
	return surveyStartDate;
}
public void setSurveyStartDate(String ssd)
{
	this.surveyStartDate=ssd;
}
public String getSurveyEndDate()
{
	return surveyEndDate;
}
public void setSurveyEndDate(String sed)
{
	this.surveyEndDate=sed;
}
public long getId() {
	return id;
}
public void setId(long id) {
	this.id = id;
}
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public String getType() {
	return type;
}
public void setType(String type) {
	this.type = type;
}
public String getState() {
	return state;
}
public void setState(String state) {
	this.state = state;
}
public String getActive() {
	return active;
}
public void setActive(String active) {
	this.active = active;
}
public Set getQuestions() {
	return questions;
}
public void setQuestions(Set questions) {
	this.questions = questions;
}

}
