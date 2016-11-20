package com.openq.survey;

import java.util.Set;

public class Survey implements java.io.Serializable{

private long surveyId;
private String name;
private Set questionsAnswers;
private String type;
private String state;
public long getSurveyId() {
  return surveyId;
}
public void setSurveyId(long surveyId) {
  this.surveyId = surveyId;
}
public Set getQuestionsAnswers() {
  return questionsAnswers;
}
public void setQuestionsAnswers(Set questionsAnswers) {
  this.questionsAnswers = questionsAnswers;
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


}
