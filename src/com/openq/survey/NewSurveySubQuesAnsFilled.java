package com.openq.survey;

public class NewSurveySubQuesAnsFilled implements java.io.Serializable{
private long id;
private NewSurveyQuestionsFilled parentQuestion;
private String subQuestion;
private String answerOption;
public long getId() {
	return id;
}
public void setId(long id) {
	this.id = id;
}
public NewSurveyQuestionsFilled getParentQuestion() {
	return parentQuestion;
}
public void setParentQuestion(NewSurveyQuestionsFilled parentQuestion) {
	this.parentQuestion = parentQuestion;
}
public String getSubQuestion() {
	return subQuestion;
}
public void setSubQuestion(String subQuestion) {
	this.subQuestion = subQuestion;
}
public String getAnswerOption() {
	return answerOption;
}
public void setAnswerOption(String answerOption) {
	this.answerOption = answerOption;
}

}
