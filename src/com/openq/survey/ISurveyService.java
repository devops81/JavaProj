package com.openq.survey;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

public interface ISurveyService {

public Map getSurvey(String surveyTitle);
public Survey setSurvey(String title,Map simpleText,Map agreementScale,Map multiple,Map ratingNum);
public QuestionDetails getQuestionFromId(String questionId);
public void saveSurvey(Map surveyFilledMap);
public Map  getSurvey(long surveyId);
public Survey[] getAllSurveys();
public Survey saveSurvey(String title,String type);
public NewSurvey[] getAllNewSurveys(long userGroupId,long userType);
public NewSurvey editNewSurvey(String surveyTitle,String surveyId,String surveyState,String surveyActive,JSONArray surveyobj,String surveyStartDate, String surveyEndDate, long userGroupId,long userType);
public int modifySurveyDates(String surveyId, String surveyStartDate, String surveyEndDate, long userGroupId,long userType);
public NewSurvey createNewSurvey(String surveyTitle,String surveyType, long userGroupId);
public void deleteSurvey(long surveyId, long userGroupId);
public HashMap getLaunchedSurveyMap(long userGroupId, long userType,boolean dateRestriction);
public NewSurvey getSurveyById(long surveyId, long userGroupId);
public NewSurvey getSurveyById(long surveyId, long userGroupId, long userType);
public NewSurvey[] getAllLaunchedSurveys(long userGroupId, long userType);
public void saveFilledSurveys(String interactionId,String jsonText, long userGroupId,long userId,Date createDate,Date updateDate);
public Map surveyIdsAndExpertIds(long interactionId, long userGroupId);
public void editFilledSurveys(String interactionId,String jsonText, long userGroupId,long userId,Date createDate,Date updateDate);
public List getSurveyInfoForExpertProfile(long expertid,long userGroupId);
public String getJSONText(long expertId,long surveyId,long userGroupId);
public NewSurvey[] getAllLaunchedSurveysByType(long userGroupId, long userType,String surveyType);
public Date deleteFilledSurvey(long interactionId);
}
