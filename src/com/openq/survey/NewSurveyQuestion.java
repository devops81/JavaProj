package com.openq.survey;

import java.util.Set;

public class NewSurveyQuestion implements java.io.Serializable{
private long id;
private NewSurvey parentSurvey;
private String questionText;
private long questionNumber;
private String questionType;
private String mandatory;
private Set answerOptions;
private Set subQuestions;
public long getId() {
	return id;
}
public void setId(long id) {
	this.id = id;
}

public String getQuestionText() {
	return questionText;
}
public void setQuestionText(String questionText) {
	this.questionText = questionText;
}
public long getQuestionNumber() {
	return questionNumber;
}
public void setQuestionNumber(long questionNumber) {
	this.questionNumber = questionNumber;
}
public String getQuestionType() {
	return questionType;
}
public void setQuestionType(String questionType) {
	this.questionType = questionType;
}
public String getMandatory() {
	return mandatory;
}
public void setMandatory(String mandatory) {
	this.mandatory = mandatory;
}
public Set getAnswerOptions() {
	return answerOptions;
}
public void setAnswerOptions(Set answerOptions) {
	this.answerOptions = answerOptions;
}
public Set getSubQuestions() {
	return subQuestions;
}
public void setSubQuestions(Set subQuestions) {
	this.subQuestions = subQuestions;
}
public NewSurvey getParentSurvey() {
	return parentSurvey;
}
public void setParentSurvey(NewSurvey parentSurvey) {
	this.parentSurvey = parentSurvey;
}



}
