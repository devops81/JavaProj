package com.openq.survey;

public class QuestionType implements java.io.Serializable{

private long id;
private String type;
public String getType() {
  return type;
}
public void setType(String type) {
  this.type = type;
}
public long getId() {
  return id;
}
public void setId(long id) {
  this.id = id;
}


}
