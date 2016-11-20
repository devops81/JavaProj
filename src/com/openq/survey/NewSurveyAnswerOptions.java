package com.openq.survey;

public class NewSurveyAnswerOptions implements java.io.Serializable{

private long id;
private String answerOptionText;
private NewSurveyQuestion parentQuestion;
private long optionOrder;
public long getId() {
	return id;
}
public void setId(long id) {
	this.id = id;
}
public String getAnswerOptionText() {
	return answerOptionText;
}
public void setAnswerOptionText(String answerOptionText) {
	this.answerOptionText = answerOptionText;
}
public NewSurveyQuestion getParentQuestion() {
	return parentQuestion;
}
public void setParentQuestion(NewSurveyQuestion parentQuestion) {
	this.parentQuestion = parentQuestion;
}
public long getOptionOrder() {
	return optionOrder;
}
public void setOptionOrder(long optionOrder) {
	this.optionOrder = optionOrder;
}


}
