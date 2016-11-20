package com.openq.survey;

public class NewSurveySubQuestions implements java.io.Serializable{
private long id;
private String subQuestionText;
private NewSurveyQuestion parentQuestion;
public long getId() {
	return id;
}
public void setId(long id) {
	this.id = id;
}
public String getSubQuestionText() {
	return subQuestionText;
}
public void setSubQuestionText(String subQuestionText) {
	this.subQuestionText = subQuestionText;
}
public NewSurveyQuestion getParentQuestion() {
	return parentQuestion;
}
public void setParentQuestion(NewSurveyQuestion parentQuestion) {
	this.parentQuestion = parentQuestion;
}


}
