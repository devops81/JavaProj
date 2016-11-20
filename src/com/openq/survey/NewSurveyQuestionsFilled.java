package com.openq.survey;

import java.util.Set;

public class NewSurveyQuestionsFilled implements java.io.Serializable{

private long id;
private NewSurveyFilled parentSurvey;
private long questionId;
private String answerText;
private Set subQuesAnsFilled;
public long getId() {
	return id;
}
public void setId(long id) {
	this.id = id;
}

public long getQuestionId() {
	return questionId;
}
public void setQuestionId(long questionId) {
	this.questionId = questionId;
}
public String getAnswerText() {
	return answerText;
}
public void setAnswerText(String answerText) {
	this.answerText = answerText;
}
public Set getSubQuesAnsFilled() {
	return subQuesAnsFilled;
}
public void setSubQuesAnsFilled(Set subQuesAnsFilled) {
	this.subQuesAnsFilled = subQuesAnsFilled;
}
public NewSurveyFilled getParentSurvey() {
	return parentSurvey;
}
public void setParentSurvey(NewSurveyFilled parentSurvey) {
	this.parentSurvey = parentSurvey;
}
}
