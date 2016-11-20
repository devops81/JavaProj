package com.openq.survey;

public class QuestionDetails implements java.io.Serializable{

private long id;
private QuestionType type;
private String text;
public QuestionType getType() {
  return type;
}
public void setType(QuestionType type) {
  this.type = type;
}
public String getText() {
  return text;
}
public void setText(String text) {
  this.text = text;
}
public long getId() {
  return id;
}
public void setId(long id) {
  this.id = id;
}
}
