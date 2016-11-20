package com.openq.survey;

import java.util.Set;

public class QuestionAnswer implements java.io.Serializable{

private long id;
private Survey surveyId;
//private Set subQuestionIdsSet;
private QuestionDetails questionId;
private String answerValues;
private long displayOrder;
private String subQuestionIds;
/*public Set getSubQuestionIdsSet() {
  return subQuestionIdsSet;
}
public void setSubQuestionIdsSet(Set subQuestionIdsSet) {
  this.subQuestionIdsSet = subQuestionIdsSet;
}*/
public String getAnswerValues() {
  return answerValues;
}
public void setAnswerValues(String answerValues) {
  this.answerValues = answerValues;
}
public long getDisplayOrder() {
  return displayOrder;
}
public void setDisplayOrder(long displayOrder) {
  this.displayOrder = displayOrder;
}
public QuestionDetails getQuestionId() {
  return questionId;
}
public void setQuestionId(QuestionDetails questionId) {
  this.questionId = questionId;
}
public String getSubQuestionIds() {
  return subQuestionIds;
}
public void setSubQuestionIds(String subQuestionIds) {
  this.subQuestionIds = subQuestionIds;
}
public Survey getSurveyId() {
  return surveyId;
}
public void setSurveyId(Survey surveyId) {
  this.surveyId = surveyId;
}
public long getId() {
  return id;
}
public void setId(long id) {
  this.id = id;
}

}
