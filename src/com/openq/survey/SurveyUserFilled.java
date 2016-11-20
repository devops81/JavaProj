package com.openq.survey;

import java.util.Date;

public class SurveyUserFilled {

private long id;
private long userId;
private long kolId;
private long interactionId;
private String answerValue;
private Survey surveyId;
private long questionId;
private Date filledDate;
public Date getFilledDate() {
  return filledDate;
}
public void setFilledDate(Date filledDate) {
  this.filledDate = filledDate;
}
public long getQuestionId() {
  return questionId;
}
public void setQuestionId(long questionId) {
  this.questionId = questionId;
}
public long getInteractionId() {
  return interactionId;
}
public void setInteractionId(long interactionId) {
  this.interactionId = interactionId;
}
public String getAnswerValue() {
  return answerValue;
}
public void setAnswerValue(String answerValue) {
  this.answerValue = answerValue;
}
public long getId() {
  return id;
}
public void setId(long id) {
  this.id = id;
}
public long getKolId() {
  return kolId;
}
public void setKolId(long kolId) {
  this.kolId = kolId;
}
public Survey getSurveyId() {
  return surveyId;
}
public void setSurveyId(Survey surveyId) {
  this.surveyId = surveyId;
}
public long getUserId() {
  return userId;
}
public void setUserId(long userId) {
  this.userId = userId;
}

}
