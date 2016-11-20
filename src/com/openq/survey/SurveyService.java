package com.openq.survey;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;
import java.text.SimpleDateFormat;
import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import com.openq.authorization.IFeaturePermissionService;
import com.openq.web.ActionKeys;
import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.web.controllers.Constants;

public class SurveyService extends HibernateDaoSupport implements ISurveyService {
	IFeaturePermissionService  featurePermissionService;
	
	public IFeaturePermissionService getFeaturePermissionService() {
		return featurePermissionService;
	}

	public void setFeaturePermissionService(
		IFeaturePermissionService featurePermissionService) {
		this.featurePermissionService = featurePermissionService;
	}


	private static Logger logger = Logger.getLogger(SurveyService.class);
	 private boolean checkDates(String sDate, String eDate)
	    {
	    	try
	    	{
		    	
		    	Date currDate= new Date();
		    	SimpleDateFormat  dateFormat= new SimpleDateFormat("MM/dd/yyyy");
		    	String cDate = dateFormat.format(currDate);
		    	Date currentDate= dateFormat.parse(cDate);
		    	Date startDate=dateFormat.parse(sDate);
		    	Date endDate=dateFormat.parse(eDate);
		    	if(currentDate.compareTo(startDate)>=0&& currentDate.compareTo(endDate)<=0)
		    	{
		    		return true;
		    	}
		    	else
		    	{
		    		return false;
		    	}
	    	}
	    	catch(Exception e)
	    	{
	    		System.out.println(e.getMessage());
	    	}
	    	return false;
	    		
	    }
  
public NewSurvey[] getAllLaunchedSurveysByType(long userGroupId,long userType,String surveyType)
{
	    final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.SURVEY_PERMISSION_ID, userGroupId);
		 List resultList= new ArrayList();  
		 resultList = getHibernateTemplate().find("from NewSurvey s where s.state = '"+Constants.LAUNCHED+"' and s.type= '"+surveyType+"' and s.id "+ PERMISSION_APPEND_QUERY);		 
		 if(resultList!=null&&resultList.size()>0)
		 {
			 ArrayList surveyList= new ArrayList();
			 for(int i=0;i<resultList.size();i++)
			 {
				 NewSurvey survey = (NewSurvey)resultList.get(i);
				 if(checkDates(survey.getSurveyStartDate(),survey.getSurveyEndDate())|| userType==Constants.ADMIN_TYPE)
				 {
					 surveyList.add(survey);
				 }
			 }
			 return (NewSurvey[])(surveyList.toArray(new NewSurvey[surveyList.size()]));
		 }
		 return null;
}	 
  public NewSurvey[] getAllNewSurveys(long userGroupId, long userType) {
	  final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.SURVEY_PERMISSION_ID, userGroupId);
	  List resultList= new ArrayList();  
	  resultList = getHibernateTemplate().find("from NewSurvey s where s.id "+PERMISSION_APPEND_QUERY);
	  if(resultList!=null&&resultList.size()>0)
	   {
	     for(int i=0;i<resultList.size();i++)
	     { 
	       NewSurvey survey = (NewSurvey)resultList.get(i);
	       if(survey!=null)
	       {
	    	   if(checkDates(survey.getSurveyStartDate(),survey.getSurveyEndDate())|| userType==Constants.ADMIN_TYPE)
	    	   {
		          //System.out.println(survey.getName()+"Name of New survey");
		          //System.out.println(survey.getId()+"New Survey Id");
		          Set questionsSet = survey.getQuestions();
		          Iterator itr = questionsSet.iterator();
		          while(itr.hasNext())
		          {
		            NewSurveyQuestion question = (NewSurveyQuestion)itr.next();
		            if(question!=null)
		            {
		            	//System.out.println("question"+question.getQuestionText());
		                Set answerOptions = question.getAnswerOptions();
		                if(answerOptions!=null&&answerOptions.size()>0)
		                {
		                	Iterator ansOptionsItr = answerOptions.iterator();
		                	while(ansOptionsItr.hasNext())
		                	{
		                		NewSurveyAnswerOptions answerOption = (NewSurveyAnswerOptions)ansOptionsItr.next();
		                	    //System.out.println("answerOption"+answerOption.getAnswerOptionText());
		                	}
		                }
		            }
		          }
	         }
	    	   
	       }
	      }
	     }
	  if(resultList!=null)   
	     return (NewSurvey[])resultList.toArray(new NewSurvey[resultList.size()]);
	  return null; 
	  
	}

  
 public NewSurvey getSurveyById(long surveyId, long userGroupId, long userType)
 {
	 final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.SURVEY_PERMISSION_ID, userGroupId);
	 List resultList= new ArrayList();  
	 resultList = getHibernateTemplate().find("from NewSurvey s where s.id="+surveyId+ "and s.id "+ PERMISSION_APPEND_QUERY);
	 if(resultList!=null&&resultList.size()>0)
	 {
		 
			NewSurvey survey = (NewSurvey)resultList.get(0);
			if(checkDates(survey.getSurveyStartDate(),survey.getSurveyEndDate())|| userType==Constants.ADMIN_TYPE)
			{
				return survey;
			}
	 }
	 return null;
 } 
 public NewSurvey getSurveyById(long surveyId, long userGroupId)
 {
	 final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.SURVEY_PERMISSION_ID, userGroupId);
	 List resultList= new ArrayList();  
	 resultList = getHibernateTemplate().find("from NewSurvey s where s.id="+surveyId+ "and s.id "+ PERMISSION_APPEND_QUERY);
	 if(resultList!=null&&resultList.size()>0)
	return((NewSurvey)resultList.get(0));
	return null;
 } 
 
 public void deleteSurvey(long surveyId, long userGroupId)
 {
	 NewSurvey survey = getSurveyById(surveyId, userGroupId);
	 if(survey!=null)
		 deleteSurveyContent(survey);
	getHibernateTemplate().delete(survey); 
	 
 }
 
 public void deleteSurveyContent(NewSurvey survey)
 {
	 if(survey!=null)
	 {
		 Set questionsSet = survey.getQuestions();
		 if(questionsSet!=null&&questionsSet.size()>0)
		 {
			 Iterator questionIterator = questionsSet.iterator();
			 while(questionIterator.hasNext())
			 {
				 NewSurveyQuestion questionObj = (NewSurveyQuestion)questionIterator.next();	 
			     Set subquestionsSet = questionObj.getSubQuestions(); 
			     Set answerOptionSet = questionObj.getAnswerOptions();
			     if(subquestionsSet!=null&&subquestionsSet.size()>0)
			     {
			    	 Iterator subQuestionsIterator = subquestionsSet.iterator();
			    	 while(subQuestionsIterator.hasNext())
			    	 {
			           NewSurveySubQuestions subQuestionsObj = (NewSurveySubQuestions)subQuestionsIterator.next();  		 
			    	   getHibernateTemplate().delete(subQuestionsObj); 
			    	 }
			     }
			     if(answerOptionSet!=null&&answerOptionSet.size()>0)
			     {
			    	 Iterator answerOptionsIterator = answerOptionSet.iterator();
			    	 while(answerOptionsIterator.hasNext())
			    	 {
			           NewSurveyAnswerOptions answerOptionsObj = (NewSurveyAnswerOptions)answerOptionsIterator.next();  		 
			    	   getHibernateTemplate().delete(answerOptionsObj); 
			    	 }
			     }
			   getHibernateTemplate().delete(questionObj);
			 }
			 
		 }
	 }
 }
 public int modifySurveyDates(String surveyId,String surveyStartDate, String surveyEndDate, long userGroupId, long userType)
 {
	 
   NewSurvey survey = getSurveyById(Long.parseLong(surveyId),userGroupId,userType);

   if(survey!=null)
   {
	   survey.setSurveyStartDate(surveyStartDate);
       survey.setSurveyEndDate(surveyEndDate);
       getHibernateTemplate().update(survey);
       return 1;
   }
   return -1;
 }
 public NewSurvey editNewSurvey(String surveyTitle,String surveyId,String surveyState,String surveyActive,JSONArray questionobjs,String surveyStartDate, String surveyEndDate, long userGroupId, long userType)
 {
	 
   NewSurvey survey = getSurveyById(Long.parseLong(surveyId),userGroupId,userType);

   if(survey!=null)
   {
	   deleteSurveyContent(survey);
       survey.setName(surveyTitle);
       survey.setState(surveyState);
       survey.setActive(surveyActive);
       survey.setSurveyStartDate(surveyStartDate);
       survey.setSurveyEndDate(surveyEndDate);
       getHibernateTemplate().update(survey);
	   if(questionobjs!=null)
       {
    	   for (int i=0;i<questionobjs.length();i++)
    	   {
	              JSONObject jsObject = JSONObject.fromObject(questionobjs.get(i));
	              if(jsObject!=null)  
	              {
	            	String questionType =jsObject.getString("questionType");
	            	String questionText = jsObject.getString("questionText");
	            	String questionMandatory = jsObject.getString("mandatory");
	            	NewSurveyQuestion newQuestion = new NewSurveyQuestion();
	            	newQuestion.setQuestionText(questionText);
	            	newQuestion.setQuestionType(questionType);
	            	newQuestion.setQuestionNumber(i+1);
	            	newQuestion.setMandatory(questionMandatory);
	            	newQuestion.setParentSurvey(survey);
	            	getHibernateTemplate().save(newQuestion);
	            	if(jsObject.has("answerOptions"))
	            	{
	            		JSONArray jArray = JSONArray.fromObject(jsObject.get("answerOptions"));

	            	    for(int j=0;j<jArray.length();j++)
	            	    {
	            	    	 
		                 if(questionType.equals(Constants.LIKERT4SCALE))
		                 {
		                	 NewSurveySubQuestions newSubQuestions = new NewSurveySubQuestions();
		                     newSubQuestions.setSubQuestionText((String)jArray.get(j));
		                     newSubQuestions.setParentQuestion(newQuestion);
		                     getHibernateTemplate().save(newSubQuestions);
		                     NewSurveyAnswerOptions newAnswerOptions = new NewSurveyAnswerOptions();
			                 newAnswerOptions.setAnswerOptionText(Constants.STRAGREE);
			                 newAnswerOptions.setParentQuestion(newQuestion);
			                 getHibernateTemplate().save(newAnswerOptions); 
			                 newAnswerOptions = new NewSurveyAnswerOptions();
			                 newAnswerOptions.setAnswerOptionText(Constants.DISAGREE);
			                 newAnswerOptions.setParentQuestion(newQuestion);
			                 getHibernateTemplate().save(newAnswerOptions);
			                 newAnswerOptions = new NewSurveyAnswerOptions();
			                 newAnswerOptions.setAnswerOptionText(Constants.AGREE);
			                 newAnswerOptions.setParentQuestion(newQuestion);
			                 getHibernateTemplate().save(newAnswerOptions); 
			                 newAnswerOptions = new NewSurveyAnswerOptions();
			                 newAnswerOptions.setAnswerOptionText(Constants.STRDISAGREE);
			                 newAnswerOptions.setParentQuestion(newQuestion);
			                 getHibernateTemplate().save(newAnswerOptions);  
		                 } 
		                 if(questionType.equals(Constants.LIKERT5SCALE))
		                 {
		                	 NewSurveySubQuestions newSubQuestions = new NewSurveySubQuestions();
		                     newSubQuestions.setSubQuestionText((String)jArray.get(j));
		                     newSubQuestions.setParentQuestion(newQuestion);
		                     getHibernateTemplate().save(newSubQuestions);
		                     NewSurveyAnswerOptions newAnswerOptions = new NewSurveyAnswerOptions();
			                 newAnswerOptions.setAnswerOptionText(Constants.STRAGREE);
			                 newAnswerOptions.setParentQuestion(newQuestion);
			                 getHibernateTemplate().save(newAnswerOptions); 
			                 newAnswerOptions = new NewSurveyAnswerOptions();
			                 newAnswerOptions.setAnswerOptionText(Constants.DISAGREE);
			                 newAnswerOptions.setParentQuestion(newQuestion);
			                 getHibernateTemplate().save(newAnswerOptions);
			                 newAnswerOptions = new NewSurveyAnswerOptions();
			                 newAnswerOptions.setAnswerOptionText(Constants.AGREE);
			                 newAnswerOptions.setParentQuestion(newQuestion);
			                 getHibernateTemplate().save(newAnswerOptions); 
			                 newAnswerOptions = new NewSurveyAnswerOptions();
			                 newAnswerOptions.setAnswerOptionText(Constants.STRDISAGREE);
			                 newAnswerOptions.setParentQuestion(newQuestion);
			                 getHibernateTemplate().save(newAnswerOptions); 
			                 newAnswerOptions = new NewSurveyAnswerOptions();
			                 newAnswerOptions.setAnswerOptionText(Constants.NEUTRAL);
			                 newAnswerOptions.setParentQuestion(newQuestion);
			                 getHibernateTemplate().save(newAnswerOptions);  
		                 }
		                 if(questionType.equals(Constants.MULTIOPTMULTISEL))
		                 {
		                	NewSurveyAnswerOptions newAnswerOptions = new NewSurveyAnswerOptions();
		                	newAnswerOptions.setAnswerOptionText((String)jArray.get(j));
		                    newAnswerOptions.setParentQuestion(newQuestion);
		                    newAnswerOptions.setOptionOrder(j+1);
		                    getHibernateTemplate().save(newAnswerOptions);
		                 } 
		                 
		                 if(questionType.equals(Constants.MULTIOPTSISEL))
		                 {
		                	NewSurveyAnswerOptions newAnswerOptions = new NewSurveyAnswerOptions();
		                	newAnswerOptions.setAnswerOptionText((String)jArray.get(j));
		                    newAnswerOptions.setParentQuestion(newQuestion);
		                    newAnswerOptions.setOptionOrder(j+1);
		                    getHibernateTemplate().save(newAnswerOptions);
		                 } 
	            	    
	            	   }
	            	}
	            	
	              }
	              
    	   }
       }
	   
	   
	   return survey;
   }
return null;	 
 } 
 
public Survey setSurvey(String title, Map simpleText, Map agreementScale, Map multiple,Map ratingMap) {
    // TODO Auto-generated method stub

    Survey survey = new Survey();
    survey.setName(title);
    getHibernateTemplate().save(survey);
    if(simpleText!=null&&simpleText.size()>0)
    {
       Set keys = simpleText.keySet();
       Iterator iterator = keys.iterator();
       while(iterator.hasNext())
       {
            String displayOrder = (String)iterator.next();
            Object[] question = (Object[])simpleText.get(displayOrder);
            QuestionAnswer questionAnswer = setTextQuestion(question);
            if(questionAnswer!=null)
            {
              questionAnswer.setSurveyId(survey);
              getHibernateTemplate().save(questionAnswer);
            }
       }
    }
  
  if(agreementScale!=null&&agreementScale.size()>0)
  {
     Set keys = agreementScale.keySet();
     Iterator iterator = keys.iterator();
     while(iterator.hasNext())
     {
         String displayOrder = (String)iterator.next();
         Object[] agreementQuestionsData = (Object[])agreementScale.get(displayOrder);
         setAgreementQuestion(displayOrder, agreementQuestionsData,survey);
     }
  }
 
  if(ratingMap!=null&&ratingMap.size()>0)
  {
     Set keys = ratingMap.keySet();
     Iterator iterator = keys.iterator();
     while(iterator.hasNext())
     {
         String displayOrder = (String)iterator.next();
         Object[] ratingMapQuestionsData = (Object[])ratingMap.get(displayOrder);
         setRatingNumQuestion(displayOrder, ratingMapQuestionsData,survey);
     }
  }
 
  if(multiple!=null&&multiple.size()>0)
  {
     Set keys = multiple.keySet();
     Iterator iterator = keys.iterator();
     while(iterator.hasNext())
     {
         String displayOrder = (String)iterator.next();
         Object[] multiQuestionsData = (Object[])multiple.get(displayOrder);
         setMultipleQuestion(displayOrder, multiQuestionsData,survey);
     }
  }
  
  return survey; 
  }

  private void setMultipleQuestion(String displayOrder, Object[] multiQuestionsData,Survey survey)
  {
    
    if(multiQuestionsData!=null&&multiQuestionsData.length>0)
    {
       String multipleMainQ = (String) multiQuestionsData[0];
       String[] subQuestions = (String[]) multiQuestionsData[1];
       String questionTypeLocal=(String) multiQuestionsData[2];
       if(subQuestions!=null&&subQuestions.length>0&&!multipleMainQ.equals(""))
       {
         String answerValues = "";
         for(int i=0;i<subQuestions.length;i++)
         {
             answerValues+=subQuestions[i]+"||";
         }
         answerValues = answerValues.substring(0,answerValues.length()-2);
         List questionTypeList = getHibernateTemplate().find("from QuestionType q where q.id="+Long.parseLong(questionTypeLocal.trim())); 
         if(questionTypeList!=null&&questionTypeList.size()>0)
         {
           QuestionType questionType = (QuestionType) questionTypeList.get(0);
           QuestionDetails questionDetails = new QuestionDetails();
           questionDetails.setType(questionType);
           questionDetails.setText(multipleMainQ);
           getHibernateTemplate().save(questionDetails);
           QuestionAnswer questionAnswer = new QuestionAnswer();
           questionAnswer.setQuestionId(questionDetails);
           questionAnswer.setSurveyId(survey);
           questionAnswer.setDisplayOrder(Long.parseLong(displayOrder.trim()));
           questionAnswer.setAnswerValues(answerValues);
           getHibernateTemplate().save(questionAnswer);
         }
       } 
  }
 } 
 private void setAgreementQuestion(String displayOrder,Object[] agreementQuestionsData,Survey survey)
 {
   if(agreementQuestionsData!=null&&agreementQuestionsData.length>0)
   {
      String agreementMainQ = (String) agreementQuestionsData[0];
      String[] subQuestions = (String[]) agreementQuestionsData[1];
      String subQuestionIds = "";
      if(subQuestions!=null&&subQuestions.length>0)
      {
        
        List questionTypeList = getHibernateTemplate().find("from QuestionType q where q.id=1"); 
        if(questionTypeList!=null&&questionTypeList.size()>0)
        {
           QuestionType questionType = (QuestionType) questionTypeList.get(0);
          for(int i=0;i<subQuestions.length;i++)
          {
 
            QuestionDetails questionDetails = new QuestionDetails();
            questionDetails.setType(questionType);
            questionDetails.setText(subQuestions[i]);
            getHibernateTemplate().save(questionDetails);
            subQuestionIds += questionDetails.getId()+",";
          }
        }
      }
  if(!subQuestionIds.equals(""))
  {
    List questionTypeList = getHibernateTemplate().find("from QuestionType q where q.id=5"); 
    if(questionTypeList!=null&&questionTypeList.size()>0)
    {
       QuestionType questionType = (QuestionType) questionTypeList.get(0);
       QuestionDetails questionDetails = new QuestionDetails();
       questionDetails.setType(questionType);
       questionDetails.setText(agreementMainQ);
       getHibernateTemplate().save(questionDetails);
       QuestionAnswer questionAnswer = new QuestionAnswer();
       questionAnswer.setDisplayOrder(Long.parseLong(displayOrder.trim()));
       questionAnswer.setQuestionId(questionDetails);
       questionAnswer.setSurveyId(survey);
       questionAnswer.setSubQuestionIds(subQuestionIds);
       questionAnswer.setAnswerValues("Stronglyagree||Agree||Disagree||StronglyDisagree");
       getHibernateTemplate().save(questionAnswer);
    }
  }
      
   }
 }
 
 private void setRatingNumQuestion(String displayOrder,Object[] ratingQuestionsData,Survey survey)
 {
   if(ratingQuestionsData!=null&&ratingQuestionsData.length>0)
   {
      String ratingNUmMainQ = (String) ratingQuestionsData[0];
      String[] subQuestions = (String[]) ratingQuestionsData[1];
      String questionTypeLocal = "6";
      String subQuestionIds = "";
      
      if(subQuestions!=null&&subQuestions.length>0)
      {
        
        List questionTypeList = getHibernateTemplate().find("from QuestionType q where q.id=3"); 
        if(questionTypeList!=null&&questionTypeList.size()>0)
        {
           QuestionType questionType = (QuestionType) questionTypeList.get(0);
          for(int i=0;i<subQuestions.length;i++)
          {
            
            QuestionDetails questionDetails = new QuestionDetails();
            questionDetails.setType(questionType);
            questionDetails.setText(subQuestions[i]);
            getHibernateTemplate().save(questionDetails);
            subQuestionIds += questionDetails.getId()+",";
          }
          subQuestionIds=subQuestionIds.substring(0,subQuestionIds.length()-1);
        }
      }
  if(!subQuestionIds.equals(""))
  {
    List questionTypeList = getHibernateTemplate().find("from QuestionType q where q.id=6"); 
    if(questionTypeList!=null&&questionTypeList.size()>0)
    {
       QuestionType questionType = (QuestionType) questionTypeList.get(0);
       QuestionDetails questionDetails = new QuestionDetails();
       questionDetails.setType(questionType);
       questionDetails.setText(ratingNUmMainQ);
       getHibernateTemplate().save(questionDetails);
       QuestionAnswer questionAnswer = new QuestionAnswer();
       questionAnswer.setDisplayOrder(Long.parseLong(displayOrder.trim()));
       questionAnswer.setQuestionId(questionDetails);
       questionAnswer.setSurveyId(survey);
       questionAnswer.setSubQuestionIds(subQuestionIds);
       getHibernateTemplate().save(questionAnswer);
    }
  }
      
   }
   

 }

 
 
 
 
 private QuestionAnswer setTextQuestion(Object[] questionObjects)
  {
      
     String question=(String)questionObjects[0];
     String displayOrder = (String)questionObjects[1];
     String type = (String)questionObjects[2];
     List questionTypeList = getHibernateTemplate().find("from QuestionType q where q.id="+(Long.parseLong(type.trim())));
     {
       if(questionTypeList!=null&&questionTypeList.size()>0)
       {
          QuestionType questionType = (QuestionType) questionTypeList.get(0);
          QuestionDetails questionDetails = new QuestionDetails();
          questionDetails.setType(questionType);
          questionDetails.setText(question);
          getHibernateTemplate().save(questionDetails);
          QuestionAnswer questionAnswer = new QuestionAnswer();
          questionAnswer.setQuestionId(questionDetails);
          try
          {
            questionAnswer.setDisplayOrder(Long.parseLong(displayOrder.trim()));
          }
          catch(Exception e)
          {
            logger.error(e.getLocalizedMessage());
          }
          return questionAnswer;
       }    
       
     }
   return null;
  }
 public HashMap getLaunchedSurveyMap(long userGroupId,long userType,boolean dateRestricted)
 {
	 final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.SURVEY_PERMISSION_ID, userGroupId);
	 List resultList= new ArrayList();  
	 resultList = getHibernateTemplate().find("from NewSurvey s where s.state = '"+Constants.LAUNCHED+"' and s.id "+ PERMISSION_APPEND_QUERY);
	 if(resultList!=null&&resultList.size()>0)
	 {
		 HashMap launchedSurveysMap= new HashMap();
		 
		// List nameList = new ArrayList();
		 for(int i=0;i<resultList.size();i++)
	     { 
	       NewSurvey survey = (NewSurvey)resultList.get(i);
	       if (survey!=null&&survey.getName()!=null&& survey.getSurveyStartDate()!=null&& survey.getSurveyEndDate()!=null)
	       {
	           boolean dateValid = true;
	           if(dateRestricted)
	           {
	             dateValid = checkDates(survey.getSurveyStartDate(),survey.getSurveyEndDate())|| userType==Constants.ADMIN_TYPE;   
	           }
	    	   if(dateValid)
	    	   {
	    		   launchedSurveysMap.put(survey.getName(), new Long(survey.getId()));
	    	   }
	       }	       
	     }
		 return launchedSurveysMap;
	 }
	 return null;
 }

  public Map  getSurvey(String surveyTitle) {
    // TODO Auto-generated method stub
    
    List results = getHibernateTemplate().find("from Survey s where s.name like '"+surveyTitle+"'");
       if(results!=null&&results.size()>0)
       {
         Survey survey = (Survey)(results.get(0));
         
         Set questionAnswersSet = survey.getQuestionsAnswers();
         if(questionAnswersSet!=null&&questionAnswersSet.size()>0)
         {
           logger.debug(questionAnswersSet.size()+"This is the size of the qa set");
         }
         else
           logger.debug("Qa set is gone!");

         Map surveyQuestionsMap = generateMap(survey);
         surveyQuestionsMap.put("survey", survey);
         
         return surveyQuestionsMap;
       
         //}
       
      
    }
  return null;
  }
  
public QuestionDetails getQuestionFromId(String questionId)
 {
  QuestionDetails question = new QuestionDetails();
  question.getId();
  if(questionId!=null&&!questionId.equals(""))
  {
    List resultList =  getHibernateTemplate().find("from QuestionDetails qD where qD.id="+(Long.parseLong(questionId.trim()))); 
    if(resultList!=null&&resultList.size()>0)
    {
      return (QuestionDetails)resultList.get(0);
    }
  }
  return null; 
 }


public Map generateMap(Survey survey)
{
  Map questionsMap = new HashMap();
if(survey!=null&&survey.getQuestionsAnswers()!=null&&survey.getQuestionsAnswers().size()>0)
{
  
     Set questionsSet = survey.getQuestionsAnswers();
     Iterator itr = questionsSet.iterator();
    while(itr.hasNext())
    {
      QuestionAnswer qA = (QuestionAnswer)itr.next();      
      QuestionDetails qD = qA.getQuestionId();
      QuestionType qT = qD.getType();
      
      if(qT.getId()==4||qT.getId()==3)
      {
        Object[] questionObj = new Object[3];
        questionObj[0] = qT.getId()+"";
        questionObj[1] = qD.getId()+"";
        questionObj[2] = qD.getText();
        questionsMap.put(qA.getDisplayOrder()+"", questionObj);
      }
      else if(qT.getId()==5)
      {
        Object[] questionObj = new Object[4];
        questionObj[0] = 5+"";
        questionObj[1] = qD.getId()+"";
        questionObj[2] = qD.getText();
        String subQuestions = qA.getSubQuestionIds();  
        String[] subQuestionsSplit = subQuestions.split("\\,");
        QuestionDetails[] subQuestionDetails = new QuestionDetails[subQuestionsSplit.length];
        for(int i=0;i<subQuestionsSplit.length;i++)
        {
           subQuestionDetails[i] = getQuestionFromId(subQuestionsSplit[i]);
           logger.debug("Obtained the question"+ subQuestionDetails[i].getId()+":"+subQuestionDetails[i].getText());
        }
        questionObj[3]= subQuestionDetails;
        questionsMap.put(qA.getDisplayOrder()+"", questionObj);
      }
      else if(qT.getId()==6)
      {
        Object[] questionObj = new Object[4];
        questionObj[0] = 6+"";
        questionObj[1] = qD.getId()+"";
        questionObj[2] = qD.getText();
        String subQuestions = qA.getSubQuestionIds();  
        String[] subQuestionsSplit = subQuestions.split("\\,");
        QuestionDetails[] subQuestionDetails = new QuestionDetails[subQuestionsSplit.length];
        for(int i=0;i<subQuestionsSplit.length;i++)
        {
           subQuestionDetails[i] = getQuestionFromId(subQuestionsSplit[i]);
           logger.debug("Obtained the question"+ subQuestionDetails[i].getId()+":"+subQuestionDetails[i].getText());
        }
        questionObj[3]= subQuestionDetails;
        questionsMap.put(qA.getDisplayOrder()+"", questionObj);
      }
      
      else if(qT.getId()==1||qT.getId()==7||qT.getId()==2)
      {
        Object[] questionObj = new Object[4];
        questionObj[0]=qT.getId()+"";
        questionObj[1]=qD.getId()+"";
        questionObj[2]=qD.getText()+"";
        String questionOptions = qA.getAnswerValues();  
        logger.debug("QuestionText"+qD.getText());
        logger.debug("Question ID"+qD.getId());
        logger.debug("Before Split"+questionOptions);
        int currIndex = 0;
        List stringList = new ArrayList();
        int fromIndex = 0;
        while(currIndex<questionOptions.length())
        {
          
          int tempIndex =  questionOptions.indexOf("||",fromIndex);
          if(tempIndex>0)
          {
            currIndex=tempIndex;
          }
          else if(fromIndex>=0)
          {
            logger.debug("Adding"+ questionOptions.substring(fromIndex));
            stringList.add(questionOptions.substring(fromIndex));
            currIndex=-1;
          }
          if(currIndex>0&&currIndex<questionOptions.length()&&fromIndex>-1)
          {
          logger.debug("Adding" +questionOptions.substring(fromIndex, currIndex));
          stringList.add(questionOptions.substring(fromIndex, currIndex)) ;
          fromIndex = currIndex+2;
          }
          else
          {
            logger.debug("breaking");
            break;
          }
        }
        String[] questionOptionsSplit = (String[])stringList.toArray(new String[stringList.size()]);
        logger.debug("After split"+ questionOptionsSplit.length );
        questionObj[3]= questionOptionsSplit;
        questionsMap.put(qA.getDisplayOrder()+"", questionObj);
      }
    
    }
return questionsMap;   
}
  
  
  return null;

}


public void saveSurvey(Map surveyFilledMap)
{
  if(surveyFilledMap!=null&&surveyFilledMap.size()>0)
  {
    Survey survey = (Survey)surveyFilledMap.get("survey");
    surveyFilledMap.remove("survey");
    String userId = (String)surveyFilledMap.get("userId");
    surveyFilledMap.remove("userId");
    String kolId = (String)surveyFilledMap.get("kolId");
    surveyFilledMap.remove("kolId");
    String interactionId = (String)surveyFilledMap.get("interactionId");
    surveyFilledMap.remove("interactionId");

    if(kolId!=null)
    {
      String[] splitIds = kolId.split("_");
      if(splitIds!=null&&splitIds.length>2)
      {
          logger.debug("This is the kolId"+splitIds[1]);
          kolId=splitIds[1];
      }
    }
    
    if(surveyFilledMap.size()>0)
    {
       Set questionsKeySet = surveyFilledMap.keySet();
       Iterator iterator = questionsKeySet.iterator();
       while(iterator.hasNext())
       {
         String questionId = (String)iterator.next();  
         String answerValue = (String)surveyFilledMap.get(questionId);
         if(userId!=null&&!userId.equals("")&&questionId!=null&&!questionId.equals("")&&kolId!=null&&!kolId.equals("")&&interactionId!=null&&!interactionId.equals(""))
         {
           if(answerValue!=null&&!answerValue.equals(""))
            {
             SurveyUserFilled surveyUserFilled = new SurveyUserFilled();
             logger.debug("Parsing "+interactionId);
             surveyUserFilled.setInteractionId(Long.parseLong(interactionId.trim()));
             surveyUserFilled.setKolId(Long.parseLong(kolId.trim()));
             surveyUserFilled.setQuestionId(Long.parseLong(questionId.trim()));
             surveyUserFilled.setSurveyId(survey);
             surveyUserFilled.setAnswerValue(answerValue);
             surveyUserFilled.setUserId(Long.parseLong(userId.trim()));
             surveyUserFilled.setFilledDate(new Date(System.currentTimeMillis()));
             getHibernateTemplate().save(surveyUserFilled);
            }
          }
       }
    }
  }
  
}

public Survey[] getAllSurveys()
{
   List resultList = getHibernateTemplate().find("from Survey s");  
   if(resultList!=null&&resultList.size()>0)
   {
     for(int i=0;i<resultList.size();i++)
     { 
       Survey survey = (Survey)resultList.get(i);
       if(survey!=null)
       {
          logger.debug(survey.getName()+"Name of survey");
          logger.debug(survey.getSurveyId()+"Survey Id");
       }
     }
     
     return (Survey[])resultList.toArray(new Survey[resultList.size()]);
   }
return null;
}


public Map  getSurvey(long surveyId) {
  // TODO Auto-generated method stub
  logger.debug("Inside surveyService\n\n\n");   
  List results = getHibernateTemplate().find("from Survey s where s.surveyId="+surveyId);
     if(results!=null&&results.size()>0)
     {
       Survey survey = (Survey)(results.get(0));
       logger.debug(survey.getName()+"Name of the survey");
       Set questionAnswersSet = survey.getQuestionsAnswers();
       if(questionAnswersSet!=null&&questionAnswersSet.size()>0)
       {
         logger.debug(questionAnswersSet.size()+"This is the size of the qa set");
       }
       else
         logger.debug("Qa set is gone!");

       logger.debug("leaving surveyService class");
       Map surveyQuestionsMap = generateMap(survey);
       surveyQuestionsMap.put("survey", survey);
       
       return surveyQuestionsMap;
     
       //}
     
    
  }
return null;
}
/*@This function saves just the survey title and type the first time.
 *
 */
public Survey saveSurvey(String title,String type)
{
Survey survey = new Survey();
survey.setName(title);
survey.setType(type);
survey.setState("Saved");
getHibernateTemplate().save(survey);
return survey;
}

public NewSurvey createNewSurvey(String surveyTitle,String surveyType, long userGroupId)
{
  List resultList = getHibernateTemplate().find("from NewSurvey s where lower(s.name)='"+surveyTitle.toLowerCase()+"'");
  if(resultList==null||resultList.size()==0)
  {
	  NewSurvey survey = new NewSurvey();
	  survey.setName(surveyTitle);
	  survey.setActive("true");
	  survey.setType(surveyType);
	  survey.setState("Saved");
      getHibernateTemplate().save(survey);
      return survey; 
  }
  else
  {
	  logger.debug("survey already exisits");
  }
  return null;
}

private Map getSubQuestions(NewSurveyQuestion surveyQuestion)
{
	    Set subQuestionIds = surveyQuestion.getSubQuestions();
	    Iterator subQuestionsIteratore = subQuestionIds.iterator();
	    Map subQuestionIdMap = new HashMap();
	    while(subQuestionsIteratore.hasNext())
	    {
	    	NewSurveySubQuestions subQuestion = (NewSurveySubQuestions)subQuestionsIteratore.next();
	    	subQuestionIdMap.put(subQuestion.getSubQuestionText(), subQuestion.getId()+"");
	    }	 
return subQuestionIdMap;
}
private Map getAnswerOptions(NewSurveyQuestion surveyQuestion)
{
	 Map subQuestionAnswersIdMap = new HashMap();
	   Set subQuestionAnswerIds = surveyQuestion.getAnswerOptions();
	   Iterator subQuestAnswerIterator = subQuestionAnswerIds.iterator();
	   //System.out.println("For question *************\n\n");
	   //System.out.println(surveyQuestion.getQuestionText()+"  \n"+surveyQuestion.getQuestionType());
	   while(subQuestAnswerIterator.hasNext())
	   {
	     NewSurveyAnswerOptions answerOption = (NewSurveyAnswerOptions)subQuestAnswerIterator.next();
	     //System.out.println(" "+answerOption.getAnswerOptionText());
	     if(!subQuestionAnswersIdMap.containsKey(answerOption.getAnswerOptionText()))
	     {
	    	 subQuestionAnswersIdMap.put(answerOption.getAnswerOptionText(), answerOption.getId()+"");
	     }
	   }	 
return subQuestionAnswersIdMap;
}

public void saveFilledSurveys(String interactionId,String jsonText, long userGroupId,long userId,Date createDate,Date updateDate)
{
//System.out.println("To be saved***************\n\n"+jsonText);	 

	 
if(jsonText!=null)
{
 try
 {
	  JSONArray jsonSurveysArray = JSONArray.fromString(jsonText);
	  if(jsonSurveysArray!=null&&jsonSurveysArray.length()>0)
	  {
		  for(int i=0;i<jsonSurveysArray.length();i++)
		  {
			  JSONObject surveyObject = jsonSurveysArray.getJSONObject(i);
			  if(surveyObject!=null)
			  {
				 String surveyId = null,expertId=null;
				 if(surveyObject.has("surveyId"))
				 {
					surveyId = surveyObject.getString("surveyId");
				 } 
			     if(surveyObject.has("expertId"))
			     {
			    	 expertId = surveyObject.getString("expertId");
			     }
			     if(surveyObject.has("questions"))
			     {
			    	 JSONArray questionsArray = JSONArray.fromObject(surveyObject.get("questions"));
			         if(questionsArray!=null&&questionsArray.length()>0)
			         {
			        	 NewSurvey surveyToBeFilled = getSurveyById(Long.parseLong(surveyId),userGroupId);
			             NewSurveyFilled surveyFilled = new NewSurveyFilled();
			             surveyFilled.setExpertId(Long.parseLong(expertId));
			             surveyFilled.setInteractionId(Long.parseLong(interactionId));
			             surveyFilled.setSurveyId(Long.parseLong(surveyId));
			             surveyFilled.setUserId(userId);
			             surveyFilled.setStartDate(createDate);
			             surveyFilled.setUpdateDate(updateDate);
			             //surveyFilled.setQuestionsFilled(questionsArray.toString());
			        	 getHibernateTemplate().save(surveyFilled);
			             Set questionObjects = surveyToBeFilled.getQuestions();
			        	 Iterator questionItr = questionObjects.iterator();
			    	     List questionObjectsMap = new ArrayList();
			    	       Comparator comparator =new  Comparator() {
			   				public int compare(Object o1, Object o2) {
			   					NewSurveyQuestion dto1 = (NewSurveyQuestion) o1;
			   					NewSurveyQuestion dto2 = (NewSurveyQuestion) o2;
			   					return new Long(dto1.getQuestionNumber()).compareTo(
			   							new Long(dto2.getQuestionNumber()));
			   				}
			   			 };
			    	       SortedSet questionObjectsSet = new TreeSet(comparator);
			    	       questionObjectsSet.addAll(questionObjects);
			               Iterator iterator = questionObjectsSet.iterator();
			        	   for(int j=0;j<questionsArray.length();j++)
			        	  {
			        		 JSONObject question = (JSONObject) questionsArray.get(j);
			        		 NewSurveyQuestion currentQuestion = null;
			        		 if(question!=null)
			        		 {
			        			String questionType = null;
			        			NewSurveyQuestionsFilled surveyAnswers = new NewSurveyQuestionsFilled();
			        			surveyAnswers.setParentSurvey(surveyFilled);
			        			if(iterator.hasNext())
			        			{
			        				NewSurveyQuestion questionObject = (NewSurveyQuestion)iterator.next();
			        			    //System.out.println("Question at DB: "+questionObject.getQuestionText());
			        			    //System.out.println("Question at client "+question.getString("questionText"));
			        			    currentQuestion = questionObject;
			        			    surveyAnswers.setQuestionId(currentQuestion.getId());
			        			    //System.out.println("Setting surveyAnswer");
			        			    
			        			}
			        			getHibernateTemplate().save(surveyAnswers);
			        			if(question.has("questionType"))
			        			{
			        				questionType = question.getString("questionType");
			        				
			        			} 
			        			if(question.has("answers"))
	        			        {
			        				if(questionType.equals(Constants.LIKERT4SCALE)||questionType.equals(Constants.LIKERT5SCALE))
			        				{
			        				
			        				Map subQuestionsMap = getSubQuestions(currentQuestion);
			        				Map answerOptionsMap = getAnswerOptions(currentQuestion);
			        				JSONArray answersArray = (JSONArray)question.get("answers");
	        			        	if(answersArray!=null&&answersArray.length()>0)
	        			        	{
	        			        		  for(int k=0;k<answersArray.length();k++) 
				        			       {
	        			        			  if(!answersArray.get(k).toString().trim().equals(""))
	        			        			  {
				        			    	   NewSurveySubQuesAnsFilled subQuestionsAnsFilled = new NewSurveySubQuesAnsFilled();
				        			    	   subQuestionsAnsFilled.setParentQuestion(surveyAnswers);
				        			    	   JSONObject answerObject = answersArray.getJSONObject(k);
				        			    	   if(answerObject!=null)
				        			    	   {
				        			    		   if(answerObject.has("text"))
				        			    		   {
				        			    			 String subQuestionText = answerObject.getString("text");
				        			    			 if(answerObject.has("answer"))
				        			    			 {
				        			    			  String subQuestionAnswer = answerObject.getString("answer");
				        			    			  String subQuestionId = (String)subQuestionsMap.get(subQuestionText);
				        			    			  String answerOptionId = (String)answerOptionsMap.get(subQuestionAnswer); 
				        			    			  //System.out
														//.println("SubQuestion "+subQuestionText+" id is"+subQuestionId+"\n\n");
				        			    			  //System.out
														//.println("SubAnswer"+subQuestionAnswer+" id is"+answerOptionId+"\n\n");
			        			    			      subQuestionsAnsFilled.setSubQuestion(subQuestionId);
			        			    			      subQuestionsAnsFilled.setAnswerOption(answerOptionId);
			        			    			      getHibernateTemplate().save(subQuestionsAnsFilled);
				        			    			 }   
				        			    		   }
				        			    	       
				        			    	   }
				        			       }
	        			        		  } 		
				        					
	        			        	}
	        			         }
			        				else if(questionType.equals(Constants.MULTIOPTMULTISEL)||questionType.equals(Constants.MULTIOPTSISEL))
			        				{
			        					JSONArray answersArray =  (JSONArray)question.get("answers");
			        					Map answerOptionsIds = getAnswerOptions(currentQuestion);
			        				    if(answersArray!=null&&answersArray.length()>0)
			        				    {
			        				    	for(int k=0;k<answersArray.length();k++)
			        				    	{
			        				    		NewSurveySubQuesAnsFilled subQuestionsAnsFilled = new NewSurveySubQuesAnsFilled();
					        			    	subQuestionsAnsFilled.setParentQuestion(surveyAnswers);
			        				    		String selectedAnswer = answersArray.getString(k);
			        				    		String selectedAnswerId = (String)answerOptionsIds.get(selectedAnswer);
			        				    		//System.out.println("Checked answer"+ selectedAnswer+" Id is"+answerOptionsIds.get(selectedAnswer));
			        				    		subQuestionsAnsFilled.setAnswerOption(selectedAnswerId);
			        				    		getHibernateTemplate().save(subQuestionsAnsFilled);
			        				    	}
			        				    	
			        				    }
			        				}
			        				else if(questionType.equals(Constants.NUMTEXT)||questionType.equals(Constants.OPENTEXT))
			        				{
			        					try{
			        						String answerObject = (String)question.get("answers");
			        						surveyAnswers.setAnswerText(answerObject);
			        				    	
			        				}catch(Exception e)
			        				{
			        					System.out.println(e.getMessage());
			        				}	
			        				}	
	        			        }
			        		 getHibernateTemplate().update(surveyAnswers);
			        		 }
			        	 }
			        	   //System.out.println("surveyFilled"+surveyFilled.getId());
			        	   //System.out.println(surveyFilled.getQuestionsFilled());
			        	   if(surveyFilled.getQuestionsFilled()!=null)
			        	   {
			        		   //System.out.println("size of answers"+surveyFilled.getQuestionsFilled().size());
			        	   }
			        	   
			        	   //System.out.println("**********************************\n\n");
						   //getSurveyAnswerForQuestion(84813013l);
			        	   //loadFilledSurvey(getFilledSurveyById(surveyFilled.getId()),surveyToBeFilled);
						   //System.out.println("************************************\n\n");
			         //getHibernateTemplate().save(surveyFilled);
			        	   
			         }
			      }
			    
			     //System.out.println("Expert Id is"+expertId+"  Survey Id:"+surveyId+" ---");
			  }
		  }
		  
	  }
 }
catch(JSONException e)
{
	 System.out.println(e.getMessage());
}

}	 
	 
	 
}

public Map getQuestionIdsMap(long surveyId)
{
	List resultList = getHibernateTemplate().find("from NewSurvey s where s.id="+surveyId);
   if(resultList!=null)
   {
	   NewSurvey survey = (NewSurvey)resultList.get(0);
	   Map questionsMap = new HashMap();
	   Map subQuestionsMap = new HashMap();
	   Map answerOptionsMap = new HashMap();
	   Set surveyQuestions = survey.getQuestions();
	   if(surveyQuestions!=null)
	   {
		 Iterator surveyQuestionsIterator = surveyQuestions.iterator();
		 while(surveyQuestionsIterator.hasNext())
		 {
			NewSurveyQuestion question = (NewSurveyQuestion)surveyQuestionsIterator.next();
            if(question!=null)
            {
                 questionsMap.put(question.getId()+"",question);	
            }			
		 }
	   return questionsMap;
	   }
   }
return new HashMap();
} 

public Map getSubQuesAnswerOptIdsMap(NewSurveyQuestion surveyQuestion)
{
if(surveyQuestion!=null)
{	
 Set subQuestionsSet = surveyQuestion.getSubQuestions();
 Set answerOptionsSet = surveyQuestion.getAnswerOptions();
Map subQuestionsMap = new HashMap();
Map answerOptionsMap = new HashMap();
 if(subQuestionsSet!=null)
{
  Iterator subQuestionsIterator = subQuestionsSet.iterator();
  while(subQuestionsIterator.hasNext())
  {
	  NewSurveySubQuestions subQuestion = (NewSurveySubQuestions)subQuestionsIterator.next();
     //System.out.println("Adding the subQuestion"+subQuestion.getId()+" "+subQuestion.getSubQuestionText());
	  subQuestionsMap.put(subQuestion.getId()+"", subQuestion);
  }
}
if(answerOptionsSet!=null)
{
	Iterator answerOptionsIterator = answerOptionsSet.iterator();
	  while(answerOptionsIterator.hasNext())
	  {
		  NewSurveyAnswerOptions answerOption = (NewSurveyAnswerOptions)answerOptionsIterator.next();
	      //System.out.println("Adding the answerOption"+answerOption.getId()+"  "+answerOption.getAnswerOptionText());
	      answerOptionsMap.put(answerOption.getId()+"", answerOption);
	  }
}
Map subQuesAnsMap = new HashMap();
subQuesAnsMap.put("subQuestions", subQuestionsMap);
subQuesAnsMap.put("answerOptions", answerOptionsMap);
return subQuesAnsMap;
}
return new HashMap();
}	

public Map surveyIdsAndExpertIds(long interactionId, long userGroupId)
{
List resultList = getHibernateTemplate().find("from NewSurveyFilled s where s.interactionId="+interactionId);
Map surveyExpertsMap = new HashMap();
Map surveyNameIdMap = new HashMap();
if(resultList!=null&&resultList.size()>0)
{
for(int i=0;i<resultList.size();i++)
{
	NewSurveyFilled survey = (NewSurveyFilled)resultList.get(i);
	Set newSet = survey.getQuestionsFilled();
	//System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
	//System.out.println("\nSurvey number "+i+1+"\n");
	//System.out.println("Survey for expert"+survey.getExpertId()+"\n");
	Map questIdObjsMap = getQuestionIdsMap(survey.getSurveyId());
	Map answersFilledMap = new HashMap();
	if(newSet!=null)
	{
		//System.out.println("Size of the questionsFilled is"+newSet.size());
	    Iterator questionFilledIterator = newSet.iterator();
	    while(questionFilledIterator.hasNext())
	    {
	    	NewSurveyQuestionsFilled questionFilled = (NewSurveyQuestionsFilled)questionFilledIterator.next();
	        if(questionFilled!=null&&questIdObjsMap!=null)
	        {
	        	//System.out.println("******************");
	        	//System.out.println("Question Id:"+questionFilled.getQuestionId());
	        	NewSurveyQuestion surveyQuestion = (NewSurveyQuestion)questIdObjsMap.get(questionFilled.getQuestionId()+"");
	        	//List surveyQuestionList = getHibernateTemplate().find("from NewSurveyQuestion s where s.id="+questionFilled.getQuestionId());
	        	if(surveyQuestion!=null)
	        	{
	        		//surveyQuestion = (NewSurveyQuestion)surveyQuestionList.get(0);
	        	    //System.out.println("Question :"+surveyQuestion.getQuestionNumber()+"  "+surveyQuestion.getQuestionText());
	        	    String questionType = surveyQuestion.getQuestionType();
	        	    //System.out.println("Type is :"+questionType);
	        	    if(questionType.equals(Constants.OPENTEXT)||questionType.equals(Constants.NUMTEXT))
	        	    { 
	        	    	answersFilledMap.put(surveyQuestion.getQuestionNumber()+"", questionFilled.getAnswerText());
	        	    	//System.out.println("\nAnswerText  "+questionFilled.getAnswerText()+"\n");
	        	    }   
	        	    Set subQuestionsFilled = questionFilled.getSubQuesAnsFilled();
		        	if(subQuestionsFilled!=null)
		        	{
		        		Iterator subQuestionsFilledIterator = subQuestionsFilled.iterator();
		        		Map subQuestionAnswerIdsMap = getSubQuesAnswerOptIdsMap(surveyQuestion);
		        		while(subQuestionsFilledIterator.hasNext())
		        		{
		        			NewSurveySubQuesAnsFilled newSurveySubQuesAnsFilled = (NewSurveySubQuesAnsFilled)subQuestionsFilledIterator.next();
		        			if(questionType.equals(Constants.LIKERT4SCALE)||questionType.equals(Constants.LIKERT5SCALE))
		        			{
		        				String subQuestionId = newSurveySubQuesAnsFilled.getSubQuestion();
		        				String answerOptionId = newSurveySubQuesAnsFilled.getAnswerOption();
		        				Map subQuestionIdsMap = (Map)subQuestionAnswerIdsMap.get("subQuestions");
		        				Map answerOptionIdsMap = (Map)subQuestionAnswerIdsMap.get("answerOptions");
		        				if(subQuestionIdsMap!=null&&answerOptionIdsMap!=null)
		        				{
		        					//System.out.println("Printing out the SubQuestions with answer");
		        					NewSurveyAnswerOptions surveyAnswerOptions = (NewSurveyAnswerOptions)answerOptionIdsMap.get(answerOptionId);
			        				NewSurveySubQuestions surveySubQuestions = (NewSurveySubQuestions)subQuestionIdsMap.get(subQuestionId);
			        				if(surveySubQuestions!=null&&surveyAnswerOptions!=null)
			        				{
			        					//System.out.println("SubQuestion  "+surveySubQuestions.getSubQuestionText());
					        			//System.out.println("AnswerOption "+surveyAnswerOptions.getAnswerOptionText());	
			        				    if(answersFilledMap.get(surveyQuestion.getQuestionNumber()+"")!=null)
			        				    {
			        				    	List prevFilled = (List)answersFilledMap.get(surveyQuestion.getQuestionNumber()+"");
			        				    	answersFilledMap.remove(surveyQuestion.getQuestionNumber()+"");
			        				    	Map subQFill = new HashMap();
			        				    	subQFill.put("text",surveySubQuestions.getSubQuestionText());
			        				    	subQFill.put("answer",surveyAnswerOptions.getAnswerOptionText());
			        				    	prevFilled.add(subQFill);
			        				    	answersFilledMap.put(surveyQuestion.getQuestionNumber()+"", prevFilled);
			        				    }
			        				    else
			        				    {   
			        				    	Map subQFill = new HashMap();
			        				    	List prevFill = new ArrayList();
			        				    	subQFill.put("text",surveySubQuestions.getSubQuestionText());
			        				    	subQFill.put("answer",surveyAnswerOptions.getAnswerOptionText());
			        				    	prevFill.add(subQFill);
			        				    	answersFilledMap.put(surveyQuestion.getQuestionNumber()+"", prevFill);		    	
			        				    }
			        				}
			        				else
			        				{
			        					//System.out.println("Getting from map failed"+ subQuestionId+"\n");
			        				}		
		        				}	
		        			}
		        			else if(questionType.equals(Constants.MULTIOPTMULTISEL)||questionType.equals(Constants.MULTIOPTSISEL))
		        			{
		        				String answerOptionId = newSurveySubQuesAnsFilled.getAnswerOption();
		        				Map answerOptionIdsMap = (Map)subQuestionAnswerIdsMap.get("answerOptions");
		        				//System.out.println("AnswerOption "+answerOptionId);				
		        				if(answerOptionIdsMap!=null)
		        				{
		        					//System.out.println("Printing out the answer Opts");
		        					NewSurveyAnswerOptions surveyAnswerOptions = (NewSurveyAnswerOptions)answerOptionIdsMap.get(answerOptionId);
			        				if(surveyAnswerOptions!=null)
			        				{
			        					//System.out.println("AnswerOption "+surveyAnswerOptions.getAnswerOptionText());	
			        					if(answersFilledMap.get(surveyQuestion.getQuestionNumber()+"")!=null)
			        				    {
			        						List prevFilled = (List)answersFilledMap.get(surveyQuestion.getQuestionNumber()+"");
			        						answersFilledMap.remove(surveyQuestion.getQuestionNumber()+"");
			        						prevFilled.add(surveyAnswerOptions.getAnswerOptionText());
			        						answersFilledMap.put(surveyQuestion.getQuestionNumber()+"",prevFilled);
			        				    }
			        					else
			        					{
			        						List prevFilled = new ArrayList();
			        						prevFilled.add(surveyAnswerOptions.getAnswerOptionText());
			        						answersFilledMap.put(surveyQuestion.getQuestionNumber()+"",prevFilled);
			        					}
			        				}
			        				else
			        				{
			        					//System.out.println("Map didnot contain"+answerOptionId);
			        				}		
		        				}
		        			}
		        			
		        			
		        		}
		        	}
		        	//System.out.println("******************");
	        	}
	        	
	        }
	    }
	}
	String jsonText = setJSONObject(survey.getSurveyId(), answersFilledMap,survey.getExpertId(), userGroupId);
	
	if(!surveyExpertsMap.containsKey(survey.getSurveyId()+""))
	{
		Set expertIdSet = new HashSet();
		Map finalExpertMap = new HashMap();
		finalExpertMap.put("expertId", survey.getExpertId()+"");
		finalExpertMap.put("jsonText",jsonText);
		expertIdSet.add(finalExpertMap);
	    surveyExpertsMap.put(survey.getSurveyId()+"", expertIdSet);	
	}
	else
	{
		Set currentSet = (Set)surveyExpertsMap.get(survey.getSurveyId()+"");
		surveyExpertsMap.remove(survey.getSurveyId()+"");
		Map finalExpertMap = new HashMap();
		finalExpertMap.put("expertId", survey.getExpertId()+"");
		finalExpertMap.put("jsonText",jsonText);
		currentSet.add(finalExpertMap);
		surveyExpertsMap.put(survey.getSurveyId()+"",currentSet);
	}

//System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");
}	
  
return surveyExpertsMap;
}
return null;
}

private String setJSONObject(long surveyId,Map answersFilledMap,long expertId,long userGroupId)
{


	  //System.out.println("to load"+surveyId);
	  try{
         NewSurvey editSurvey = getSurveyById(surveyId,userGroupId);
           if(editSurvey!=null){
	    	   	Set questionObjects = editSurvey.getQuestions();
	    	   	Iterator questionItr = questionObjects.iterator();
	    	   	List questionObjectsMap = new ArrayList();
	    	   	Comparator comparator =new  Comparator() {
	    	   	public int compare(Object o1, Object o2) {
				NewSurveyQuestion dto1 = (NewSurveyQuestion) o1;
				NewSurveyQuestion dto2 = (NewSurveyQuestion) o2;
				return new Long(dto1.getQuestionNumber()).compareTo(
						new Long(dto2.getQuestionNumber()));
			}
		 };
     SortedSet questionObjectsSet = new TreeSet(comparator);
     questionObjectsSet.addAll(questionObjects);
     Iterator sortedIterator = questionObjectsSet.iterator();
     while(sortedIterator.hasNext())
     {
  	  Map individualQuestion = new HashMap(); 
  	  NewSurveyQuestion surveyQuestion = (NewSurveyQuestion)sortedIterator.next();
  	  String questionText = surveyQuestion.getQuestionText();
        String questionType = surveyQuestion.getQuestionType();
        String questionMandatory = surveyQuestion.getMandatory();
        long questionNumber = surveyQuestion.getQuestionNumber();
        List answerOptions = new ArrayList();
        //System.out.println("At server end"+questionMandatory);
        individualQuestion.put("questionText",questionText);
        individualQuestion.put("mandatory",questionMandatory);
        
        if(questionType.equals(Constants.LIKERT4SCALE)||questionType.equals(Constants.LIKERT5SCALE))
        {
          individualQuestion.put("questionType",questionType);
      	Set subQuestions = surveyQuestion.getSubQuestions();
          Iterator subQuestionsIterator = subQuestions.iterator();
          while(subQuestionsIterator.hasNext())
          {
          	NewSurveySubQuestions subQuestion = (NewSurveySubQuestions)subQuestionsIterator.next();
          	String subQuestionText = subQuestion.getSubQuestionText();
              answerOptions.add(subQuestionText);
              List subQAns = (List)answersFilledMap.get(surveyQuestion.getQuestionNumber()+""); 
              if(subQAns!=null)
              {
            	  
            	  individualQuestion.put("answers", subQAns.toArray());
            	  //System.out.println("Adding this in the map"+subQAns.size());
              }
              else
              {
            	  //System.out.println("Sub Q is null");
              }
          }
          
        }
        if(questionType.equals(Constants.MULTIOPTMULTISEL)||questionType.equals(Constants.MULTIOPTSISEL))
        {
      	individualQuestion.put("questionType",questionType);  
      	Set answerOpts = surveyQuestion.getAnswerOptions();
      	Comparator ansOptComparator =new  Comparator() {
				public int compare(Object o1, Object o2) {
				NewSurveyAnswerOptions dto1 = (NewSurveyAnswerOptions) o1;
			NewSurveyAnswerOptions dto2 = (NewSurveyAnswerOptions) o2;
					return new Long(dto1.getOptionOrder()).compareTo(
							new Long(dto2.getOptionOrder()));
				}
			 };
	       SortedSet answerOptsSet = new TreeSet(ansOptComparator);//Sort the list based on the questionNumbers
	   answerOptsSet.addAll(answerOpts);
      	Iterator answerOptsIterator = answerOptsSet.iterator();
      	while(answerOptsIterator.hasNext())
      	{
      		NewSurveyAnswerOptions surveyAnswerOptions = (NewSurveyAnswerOptions)answerOptsIterator.next();
      	    answerOptions.add(surveyAnswerOptions.getAnswerOptionText());
      	}
      	List ansOpt = (List)answersFilledMap.get(surveyQuestion.getQuestionNumber()+""); 
        if(ansOpt!=null)
        {
      	  individualQuestion.put("answers", ansOpt.toArray());
      	  //System.out.println("Adding this in the map"+ansOpt.size());
        }
        else
        {
      	  //System.out.println("Ans Opt is null");
        }
        }

        if(questionType.equals(Constants.OPENTEXT)||questionType.equals(Constants.NUMTEXT))
        {
      	  individualQuestion.put("questionType",questionType);
      	String ansTxt = (String)answersFilledMap.get(surveyQuestion.getQuestionNumber()+""); 
        if(ansTxt!=null)
        {
      	  individualQuestion.put("answers", ansTxt);
      	  //System.out.println("Adding this in the map"+ansTxt);
        }
        else
        {
      	  //System.out.println("Ans Text is null");
        }
        }
        individualQuestion.put("answerOptions",answerOptions.toArray()); 
        questionObjectsMap.add(individualQuestion);
     }
     Map finalMap = new HashMap();
     finalMap.put("questionObjects",questionObjectsMap.toArray());
     try{
	       JSONObject obj = JSONObject.fromMap(finalMap);
	       //System.out.println("JSON Object created"+obj.toString()+"***\n\n");
            return obj.toString();       
        }
     catch (JSONException e) {
	    	   // TODO: handle exception
		   System.out.println(e.getMessage()); 
     }
     
	      }
	      else
	       {
	    	   //System.out.println("editSurvey was null");
	       }
	  }catch (Exception e) {
		// TODO: handle exception
	  System.out.println(e.getMessage());
    }
  
	  
return "";  
}  
public Date deleteFilledSurvey(long interactionId)
{
	StringBuffer query = new StringBuffer("");
	query.append("from NewSurveyFilled s where s.interactionId="+interactionId+" ");
	//System.out.println("The query called for delete "+query.toString());
	List resultList = getHibernateTemplate().find(query.toString());
    Date startDate = new Date(System.currentTimeMillis());
	if(resultList!=null&&resultList.size()>0)
    {
    	for(int i=0;i<resultList.size();i++)
    	{
    		NewSurveyFilled survey = (NewSurveyFilled)resultList.get(i);
    		startDate =survey.getStartDate();
    		Set newSet = survey.getQuestionsFilled();
    		if(newSet!=null)
    		{
    			//System.out.println("Size of the questionsFilled is"+newSet.size());
    		    Iterator questionFilledIterator = newSet.iterator();
    		    while(questionFilledIterator.hasNext())
    		    {
    		    	NewSurveyQuestionsFilled questionFilled = (NewSurveyQuestionsFilled)questionFilledIterator.next();
    		        if(questionFilled!=null)
    		        {
    		        	//System.out.println("******************");
    		        	Set answersFilled = questionFilled.getSubQuesAnsFilled();
    		        	Iterator answersFilledItr = answersFilled.iterator();
    		        	while(answersFilledItr.hasNext())
    		        	{
    		        		NewSurveySubQuesAnsFilled subQuestionFilled = (NewSurveySubQuesAnsFilled)answersFilledItr.next();
    		        	    if(subQuestionFilled!=null)
    		        		getHibernateTemplate().delete(subQuestionFilled);
    		        	}
    		          getHibernateTemplate().delete(questionFilled);  	
    		       }
    		    }
    		}
    	  getHibernateTemplate().delete(survey);
    	  } 
    }
return startDate;
}
public void editFilledSurveys(String interactionId,String jsonText,long userGroupId,long userId,Date createDate,Date updateDate)
{
  if(jsonText!=null)
  {
	  try
	  {
		  JSONArray jsonSurveysArray = JSONArray.fromString(jsonText);
		  if(jsonSurveysArray!=null&&jsonSurveysArray.length()>0)
		  {
			  for(int i=0;i<jsonSurveysArray.length();i++)
			  {
				  JSONObject surveyObject = jsonSurveysArray.getJSONObject(i);
				  if(surveyObject!=null)
				  {
					 String surveyId = null,expertId=null;
					 if(surveyObject.has("surveyId"))
					 {
						surveyId = surveyObject.getString("surveyId");
					 }	 
				    if(surveyObject.has("experts"))
				    {
				    	JSONArray expertsObject = (JSONArray)surveyObject.get("experts");
				    	String expertsObjectText = expertsObject.toString();
				    	if(expertsObject!=null&&expertsObject.length()>0)
				        {
				        	for(int j=0;j<expertsObject.length();j++)
				        	{
				        		JSONObject expertObject = (JSONObject)expertsObject.get(j);
				        		String jsonexpertObj = (String)expertsObject.getString(j);
				        	    expertId = null;
				        		if(expertObject.has("expertId"))
				        	    {
				        	     expertId = (String)expertObject.getString("expertId");	
				        	    }
				        	    if(expertObject.has("questions"))
				        	    {
				        	      String jsonQuestionsFilled = (String)expertObject.getString("questions");	
				        	      //do nothing
				        	    }
				        	}
				        }
				        //System.out.println("Gonna be called to save\n");
		        	     //System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$\n");
		        	      //System.out.println(expertsObjectText);
		        	      saveFilledSurveys(interactionId, expertsObjectText, userGroupId,userId,createDate,updateDate);
		        	      //System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$\n");
				    } 
				  }	 
				}	 
			 } 
	  }
	  catch(JSONException e)
	  {
		  System.out.println(e.getMessage());
	  }
  }
}
public NewSurvey[] getAllLaunchedSurveys(long userGroupId,long userType)
{
	final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.SURVEY_PERMISSION_ID, userGroupId);
	 List resultList= new ArrayList();  
	 resultList = getHibernateTemplate().find("from NewSurvey s where s.state = '"+Constants.LAUNCHED+"' and s.id "+ PERMISSION_APPEND_QUERY);		 
	 if(resultList!=null&&resultList.size()>0)
	 {
		 ArrayList surveyList= new ArrayList();
		 for(int i=0;i<resultList.size();i++)
		 {
			 NewSurvey survey = (NewSurvey)resultList.get(i);
			 if(checkDates(survey.getSurveyStartDate(),survey.getSurveyEndDate())|| userType==Constants.ADMIN_TYPE)
			 {
				 surveyList.add(survey);
			 }
		 }
		 return (NewSurvey[])(surveyList.toArray(new NewSurvey[surveyList.size()]));
	 }
	 return null;
}

public List getSurveyInfoForExpertProfile(long expertid,long userGroupId)
{
	final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.SURVEY_PERMISSION_ID, userGroupId);
	List result = getHibernateTemplate().find("from NewSurvey s,NewSurveyFilled NS where " +
			"s.id=NS.surveyId and NS.expertId="+expertid+" and s.id" + PERMISSION_APPEND_QUERY);
	
	//if(result != null && result.size()>0)
		return result;
	
}


public String getJSONText(long expertId,long surveyId,long userGroupId){
	
	final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.SURVEY_PERMISSION_ID, userGroupId);
	List resultList = getHibernateTemplate().find("select nsf from NewSurveyFilled nsf,NewSurvey s where nsf.surveyId="+surveyId+" and nsf.expertId="+expertId+" and s.id" + PERMISSION_APPEND_QUERY);
	if(resultList!=null&&resultList.size()>0)
	{
	for(int i=0;i<resultList.size();i++)
	{
		NewSurveyFilled survey = (NewSurveyFilled)resultList.get(i);
		Set newSet = survey.getQuestionsFilled();
		//System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		//System.out.println("\nSurvey number "+i+1+"\n");
		//System.out.println("Survey for expert"+survey.getExpertId()+"\n");
		Map questIdObjsMap = getQuestionIdsMap(survey.getSurveyId());
		Map answersFilledMap = new HashMap();
		if(newSet!=null)
		{
			//System.out.println("Size of the questionsFilled is"+newSet.size());
		    Iterator questionFilledIterator = newSet.iterator();
		    while(questionFilledIterator.hasNext())
		    {
		    	NewSurveyQuestionsFilled questionFilled = (NewSurveyQuestionsFilled)questionFilledIterator.next();
		        if(questionFilled!=null&&questIdObjsMap!=null)
		        {
		        	//System.out.println("******************");
		        	//System.out.println("Question Id:"+questionFilled.getQuestionId());
		        	NewSurveyQuestion surveyQuestion = (NewSurveyQuestion)questIdObjsMap.get(questionFilled.getQuestionId()+"");
		        	//List surveyQuestionList = getHibernateTemplate().find("from NewSurveyQuestion s where s.id="+questionFilled.getQuestionId());
		        	if(surveyQuestion!=null)
		        	{
		        		//surveyQuestion = (NewSurveyQuestion)surveyQuestionList.get(0);
		        	    //System.out.println("Question :"+surveyQuestion.getQuestionNumber()+"  "+surveyQuestion.getQuestionText());
		        	    String questionType = surveyQuestion.getQuestionType();
		        	    //System.out.println("Type is :"+questionType);
		        	    if(questionType.equals(Constants.OPENTEXT)||questionType.equals(Constants.NUMTEXT))
		        	    { 
		        	    	answersFilledMap.put(surveyQuestion.getQuestionNumber()+"", questionFilled.getAnswerText());
		        	    	//System.out.println("\nAnswerText  "+questionFilled.getAnswerText()+"\n");
		        	    }   
		        	    Set subQuestionsFilled = questionFilled.getSubQuesAnsFilled();
			        	if(subQuestionsFilled!=null)
			        	{
			        		Iterator subQuestionsFilledIterator = subQuestionsFilled.iterator();
			        		Map subQuestionAnswerIdsMap = getSubQuesAnswerOptIdsMap(surveyQuestion);
			        		while(subQuestionsFilledIterator.hasNext())
			        		{
			        			NewSurveySubQuesAnsFilled newSurveySubQuesAnsFilled = (NewSurveySubQuesAnsFilled)subQuestionsFilledIterator.next();
			        			if(questionType.equals(Constants.LIKERT4SCALE)||questionType.equals(Constants.LIKERT5SCALE))
			        			{
			        				String subQuestionId = newSurveySubQuesAnsFilled.getSubQuestion();
			        				String answerOptionId = newSurveySubQuesAnsFilled.getAnswerOption();
			        				Map subQuestionIdsMap = (Map)subQuestionAnswerIdsMap.get("subQuestions");
			        				Map answerOptionIdsMap = (Map)subQuestionAnswerIdsMap.get("answerOptions");
			        				if(subQuestionIdsMap!=null&&answerOptionIdsMap!=null)
			        				{
			        					//System.out.println("Printing out the SubQuestions with answer");
			        					NewSurveyAnswerOptions surveyAnswerOptions = (NewSurveyAnswerOptions)answerOptionIdsMap.get(answerOptionId);
				        				NewSurveySubQuestions surveySubQuestions = (NewSurveySubQuestions)subQuestionIdsMap.get(subQuestionId);
				        				if(surveySubQuestions!=null&&surveyAnswerOptions!=null)
				        				{
				        					//System.out.println("SubQuestion  "+surveySubQuestions.getSubQuestionText());
						        			//System.out.println("AnswerOption "+surveyAnswerOptions.getAnswerOptionText());	
				        				    if(answersFilledMap.get(surveyQuestion.getQuestionNumber()+"")!=null)
				        				    {
				        				    	List prevFilled = (List)answersFilledMap.get(surveyQuestion.getQuestionNumber()+"");
				        				    	answersFilledMap.remove(surveyQuestion.getQuestionNumber()+"");
				        				    	Map subQFill = new HashMap();
				        				    	subQFill.put("text",surveySubQuestions.getSubQuestionText());
				        				    	subQFill.put("answer",surveyAnswerOptions.getAnswerOptionText());
				        				    	prevFilled.add(subQFill);
				        				    	answersFilledMap.put(surveyQuestion.getQuestionNumber()+"", prevFilled);
				        				    }
				        				    else
				        				    {   
				        				    	Map subQFill = new HashMap();
				        				    	List prevFill = new ArrayList();
				        				    	subQFill.put("text",surveySubQuestions.getSubQuestionText());
				        				    	subQFill.put("answer",surveyAnswerOptions.getAnswerOptionText());
				        				    	prevFill.add(subQFill);
				        				    	answersFilledMap.put(surveyQuestion.getQuestionNumber()+"", prevFill);		    	
				        				    }
				        				}
				        				else
				        				{
				        					//System.out.println("Getting from map failed"+ subQuestionId+"\n");
				        				}		
			        				}	
			        			}
			        			else if(questionType.equals(Constants.MULTIOPTMULTISEL)||questionType.equals(Constants.MULTIOPTSISEL))
			        			{
			        				String answerOptionId = newSurveySubQuesAnsFilled.getAnswerOption();
			        				Map answerOptionIdsMap = (Map)subQuestionAnswerIdsMap.get("answerOptions");
			        				//System.out.println("AnswerOption "+answerOptionId);				
			        				if(answerOptionIdsMap!=null)
			        				{
			        					//System.out.println("Printing out the answer Opts");
			        					NewSurveyAnswerOptions surveyAnswerOptions = (NewSurveyAnswerOptions)answerOptionIdsMap.get(answerOptionId);
				        				if(surveyAnswerOptions!=null)
				        				{
				        					//System.out.println("AnswerOption "+surveyAnswerOptions.getAnswerOptionText());	
				        					if(answersFilledMap.get(surveyQuestion.getQuestionNumber()+"")!=null)
				        				    {
				        						List prevFilled = (List)answersFilledMap.get(surveyQuestion.getQuestionNumber()+"");
				        						answersFilledMap.remove(surveyQuestion.getQuestionNumber()+"");
				        						prevFilled.add(surveyAnswerOptions.getAnswerOptionText());
				        						answersFilledMap.put(surveyQuestion.getQuestionNumber()+"",prevFilled);
				        				    }
				        					else
				        					{
				        						List prevFilled = new ArrayList();
				        						prevFilled.add(surveyAnswerOptions.getAnswerOptionText());
				        						answersFilledMap.put(surveyQuestion.getQuestionNumber()+"",prevFilled);
				        					}
				        				}
				        				else
				        				{
				        					//System.out.println("Map didnot contain"+answerOptionId);
				        				}		
			        				}
			        			}
			        			
			        			
			        		}
			        	}
			        	//System.out.println("******************");
		        	}
		        	
		        }
		    }
		}
		String jsonText = setJSONObject(survey.getSurveyId(), answersFilledMap,survey.getExpertId(), userGroupId);
	  return jsonText;
	
}
}
	return null;
}
}

