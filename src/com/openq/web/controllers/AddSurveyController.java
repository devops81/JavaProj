package com.openq.web.controllers;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authorization.IFeaturePermissionService;
import com.openq.eav.option.OptionLookup;
import com.openq.survey.ISurveyService;
import com.openq.survey.NewSurvey;
import com.openq.survey.NewSurveyAnswerOptions;
import com.openq.survey.NewSurveyQuestion;
import com.openq.survey.NewSurveySubQuestions;
import com.openq.web.ActionKeys;

public class AddSurveyController extends AbstractController{

  ISurveyService surveyService;
  public ISurveyService getSurveyService() {
    return surveyService;
  }
  public void setSurveyService(ISurveyService surveyService) {
    this.surveyService = surveyService;
  }
  IFeaturePermissionService  featurePermissionService;

  /**
 * @return the featurePermissionService
 */
public IFeaturePermissionService getFeaturePermissionService() {
	return featurePermissionService;
}

/**
 * @param featurePermissionService the featurePermissionService to set
 */
public void setFeaturePermissionService(
		IFeaturePermissionService featurePermissionService) {
	this.featurePermissionService = featurePermissionService;
}

  public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception  
  {
    ModelAndView mav = new ModelAndView("surveyHome");
    String action = request.getParameter("action");
    HttpSession session = request.getSession();//Remove the session variable to avoid confusion
    session.setAttribute("SURVEY_PERMISSION_MAP", featurePermissionService.getEntityGroupMapping(Constants.SURVEY_PERMISSION_ID));
    String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
    long userType=-1;
    OptionLookup userTypeLookup = (OptionLookup)session.getAttribute(Constants.USER_TYPE);
    //null check added to prevent crash when userType is null
    if (userTypeLookup != null){
       userType = userTypeLookup.getId();
    }
	long userGroupId = -1;
	if(userGroupIdString != null && !("".equalsIgnoreCase(userGroupIdString))){
	 userGroupId = Long.parseLong(userGroupIdString);
	}
    session.removeAttribute("surveyTitle");
    session.removeAttribute("currentSurvey");
    session.removeAttribute("surveyMessage");//Message to hold values like survey saved/launched
    session.removeAttribute("jsonQuestions");
    session.removeAttribute("savedMessage");
    session.removeAttribute("allNewSurveys");//List of all surveys
    session.removeAttribute("page");
    NewSurvey[] allNewSurveys = surveyService.getAllNewSurveys(userGroupId,userType);
    if(allNewSurveys!=null&&allNewSurveys.length>0)
    	session.setAttribute("allNewSurveys",allNewSurveys);//All the surveys are set in the session for the tree generation        
    if(action!=null&&!action.equals(""))
    {
     /* Action = create New title
      * */ 
     if(action.equals("createTitle"))//Creation of survey 1st step.
      {
    	  String surveyTitle = request.getParameter("surveyTitle"),surveyType =request.getParameter("surveyType");
    	  
    	  if(surveyTitle!=null)
    	  {
    		  if(surveyType!=null)
    	      {  
    	    	 //System.out.println("Survey type is"+surveyType);
    			  
    	          //Survey currentSurvey = surveyService.saveSurvey(surveyTitle, surveyType);//Save survey title,type and state.
    	          NewSurvey currentSurvey = surveyService.createNewSurvey(surveyTitle, surveyType,userGroupId);
    			  if(currentSurvey!=null)
    			  {
    	          session.setAttribute("surveyTitle", surveyTitle);
    	          session.setAttribute("currentSurvey", currentSurvey); 
    	          } 
    			  else
    				  session.setAttribute("surveyMessage","Survey Title already exists please add a new Title");
    	      }
    	  }    
    	  else
    		  logger.error("SurveyTitleUnknwon");
      }	
     /* Action = delete a survey
      * */ 
     else if (action.equals("deleteSurvey"))//Delete a saved survey
      {
    	  String surveyId = request.getParameter("surveyId");
    	  if(surveyId!=null&&!(surveyId.equals("")))
    	  {
    		  try{
    			  surveyService.deleteSurvey(Long.parseLong(surveyId),userGroupId);
    		  }catch (Exception e) 
    		  {
			    logger.error(e.getMessage());
    		  }
    	  }
    	    session.removeAttribute("surveyTitle");
    	    session.removeAttribute("currentSurvey");
    	    session.removeAttribute("surveyMessage");
    	    session.removeAttribute("allSurveys");
      	    session.removeAttribute("allNewSurveys");
      	    session.setAttribute("allNewSurveys", surveyService.getAllNewSurveys(userGroupId,userType));
      return mav;
      }
     /* Action = edit a survey -load from tree
      * */ 
      else if(action.equals("editSurvey"))//edit a survey (save a survey)
      {
    	  if(request.getParameter("surveyId")!=null)
    	  {
    		  String surveyId = request.getParameter("surveyId");
    		  session.removeAttribute("surveyTitle");
      	      session.removeAttribute("currentSurvey");
      	      session.removeAttribute("jsonQuestions");
      	      //System.out.println("to load"+surveyId);
    		  try
    		  {
    			  String jsonText = getJSONTextForSurvey(Long.parseLong(surveyId.trim()),session);
    			  session.setAttribute("jsonQuestions", jsonText);
    		  }
    		  catch (Exception e) {
				// TODO: handle exception
			  logger.error(e.getMessage());
    	      }
    	  }
    	  return mav;
      }
     // called from survey.htm 
      else if(action.equals("showLaunchedSurveys"))
      {	
    	  HashMap launchedSurveys = surveyService.getLaunchedSurveyMap(userGroupId, userType,true);
    	  if(launchedSurveys!=null && launchedSurveys.size()!=0)
    	  {
    		  //System.out.println("in side AddSurveyController, launchedSurveys is not null");
    		  session.setAttribute("LaunchedSurveys", launchedSurveys);
    		   session.setAttribute("ACTIONSTRING", action);
    	  }
    	  request.setAttribute("SURVEY_PERMISSION_MAP", featurePermissionService.getEntityGroupMapping(Constants.SURVEY_PERMISSION_ID));
    	  return mav;
      }
     
     /* Action = save/launch
      * */ 
      else if (action.equals("saveSurvey"))
      {
    	  session.removeAttribute("allNewSurveys");
    	  if(request.getParameter("questionObj")!=null)
    	  {
    		  //System.out.println("date is to be recievedtoo");
    	      //System.out.println(request.getParameter("questionObj")+"\n\n\n");
    	      String keyVal = request.getParameter("questionObj");
    	      try{
    	      //JSONObject jsObject = JSONObject.fromString(keyVal);
    	      JSONArray jsArray = JSONArray.fromString(keyVal);
    	      if(request.getParameter("survey")!=null)
    	      {
    	        String survey = request.getParameter("survey");
    	        JSONObject jsObject = JSONObject.fromString(survey);
    	        String surveyState="Saved",surveyTitle="",surveyId="",surveyActive="false";
    	        if(jsObject!=null)
    	        {
	    	        if(jsObject.has("state"))
	    	        {
	    	        	surveyState = (String)jsObject.get("state");
	    	        }
	    	        if(jsObject.has("id"))
	    	        {
	    	        	surveyId = (String)jsObject.get("id");
	    	        }
	    	        if(jsObject.has("title"))
	    	        {
	    	        	surveyTitle = (String)jsObject.get("title");
	    	        }
	    	        if(jsObject.has("active"))
	    	        {
	    	        	surveyActive = (String)jsObject.get("active");
	    	        }
    	        }
    	        String dateFlag=(String) request.getParameter("dateFlag");
    	        if(dateFlag!=null)
    	        {
    	        	String surveyStartDate="-999", surveyEndDate="-111";
    	        	if(dateFlag.equals("true"))
    	        	{
    	        		surveyStartDate=(String)request.getParameter("surveyStartDate");
    		        	surveyEndDate=(String)request.getParameter("surveyEndDate");
    		        	surveyService.editNewSurvey(surveyTitle, surveyId, surveyState,surveyActive, jsArray, surveyStartDate, surveyEndDate,userGroupId, userType);
    		        }
    	        	else
    	        	{
    	        		int test=0;
//    	              	surveyId=(String) request.getParameter("surveyId");
    	              	surveyStartDate=(String)request.getParameter("surveyModifyStartDate");
    	              	surveyEndDate=(String)request.getParameter("surveyModifyEndDate");
    	              	//System.out.println(surveyStartDate+" , "+ surveyEndDate);
    	              	test= surveyService.modifySurveyDates(surveyId, surveyStartDate, surveyEndDate, userGroupId, userType);
    	              	
    	        	}
    	        		
    	        }
    	        if(surveyId!=null&&!(surveyId.equals("")))
    	      	{

        		  //System.out.println("to load"+surveyId);
        		  session.removeAttribute("surveyTitle");
          	      session.removeAttribute("currentSurvey");
          	      session.removeAttribute("jsonQuestions");
          	      //System.out.println("to load"+surveyId);
        		  try
        		  {
        			  String jsonText = getJSONTextForSurvey(Long.parseLong(surveyId.trim()),session);
        			  session.setAttribute("jsonQuestions", jsonText);
        			  allNewSurveys = surveyService.getAllNewSurveys(userGroupId,userType);
               	      if(allNewSurveys!=null&&allNewSurveys.length>0)
               	    	 session.setAttribute("allNewSurveys",allNewSurveys);//All the surveys are set in the session for the tree generation        
                       String savedMessage = "The survey has been "+surveyState+" successfully";
                       session.setAttribute("savedMessage", savedMessage);
        		  }
        		  catch (Exception e) {
    				// TODO: handle exception
    			  logger.error(e.getMessage());
        	      }
        		}
    	      }
    	     }
    	    catch(JSONException e)
    	    {
    	    	  logger.error(e.getMessage());
    	     }
    	 return mav;
   	      }
    	  
      }
      else if(action.equals("viewSurvey")||action.equals("EditInteractionSurvey")||action.equals("viewProfileSurvey")||action.equals(ActionKeys.VIEW_SURVEY_SPECIALTY_FORM))
      {
    	  session.removeAttribute("surveyTitle");
  	      session.removeAttribute("currentSurvey");
    	  String interactionId = request.getParameter("interactionId");
    	  String surveyIdFromInteraction = request.getParameter("surveyId");
    	  session.removeAttribute("answersFilled");
    	  session.removeAttribute("expertId");
    	  session.removeAttribute("page");
    	  if(interactionId!=null&&surveyIdFromInteraction!=null)
          {
        	  //System.out.println("InteractionId is"+interactionId);
        	  //System.out.println("surveyIdFromInteraction is"+surveyIdFromInteraction);
        	  //System.out.println("Answer is"+request.getParameter("answersJsonText")+"\n");
        	  NewSurvey editSurvey = surveyService.getSurveyById(Long.parseLong(surveyIdFromInteraction),userGroupId,userType);              
              if(editSurvey!=null)
              {
               session.setAttribute("surveyTitle", editSurvey.getName());
               session.setAttribute("currentSurvey", editSurvey);
               setJSONObject(editSurvey.getId(),session);
               if(action.equals("EditInteractionSurvey"))
               {
            	   session.setAttribute("answersFilled",request.getParameter("answersJsonText") );
            	   session.setAttribute("expertId",request.getParameter("expertId") );
               }
               
              }
          }
    	  else if(ActionKeys.VIEW_SURVEY_FROM_PROFILE.equals(action)){
    		  long expertId =request.getParameter("expertId")!=null?Long.parseLong(request.getParameter("expertId")):-1;
      		   long surveyId  =  request.getParameter("surveyId")!=null?Long.parseLong(request.getParameter("surveyId")):-1;
    		  NewSurvey editSurvey = surveyService.getSurveyById(surveyId,userGroupId,userType);              
              if(editSurvey!=null)
              {
               session.setAttribute("surveyTitle", editSurvey.getName());
               session.setAttribute("currentSurvey", editSurvey);
               setJSONObject(editSurvey.getId(),session);
              }
   		   //request.setAttribute("page", request.getAttribute("page"));
   		   session.setAttribute("answersFilled",surveyService.getJSONText(expertId, surveyId, userGroupId));
       	   session.setAttribute("expertId",request.getParameter("expertId") );
       	   session.setAttribute("page", "profile");
         }
    	  else if(ActionKeys.VIEW_SURVEY_SPECIALTY_FORM.equals(action)){
    		  logger.debug("Inside the action for specialty");
    		  long surveyId  =  request.getParameter("surveyId")!=null?Long.parseLong(request.getParameter("surveyId")):-1;
    		  NewSurvey editSurvey = surveyService.getSurveyById(surveyId,userGroupId,userType);              
              if(editSurvey!=null)
              {
               session.setAttribute("surveyTitle", editSurvey.getName());
               session.setAttribute("currentSurvey", editSurvey);
               setJSONObject(editSurvey.getId(),session);
              }
   		   //request.setAttribute("page", request.getAttribute("page"));
   		   session.setAttribute("answersFilled",surveyService.getJSONText(0, surveyId, userGroupId));
       	   session.setAttribute("expertId",0+"");
       	   request.setAttribute("specialitySurvey", "specialitySurvey");
          }
    	   
  	       
       return new ModelAndView("viewSurveyNew");
       
      }
      else if(action.equals("specialitySurvey"))
      {
          
    	  NewSurvey[] medicalIntSurveys = surveyService.getAllLaunchedSurveysByType(userGroupId, userType, Constants.MEDICAL_INTELLIGENCE);
    	  NewSurvey[] dciSurveys = surveyService.getAllLaunchedSurveysByType(userGroupId, userType, Constants.DCI);
    	  logger.debug("dci"+dciSurveys);
    	  session.setAttribute("ALL_MEDICAL_SURVEYS", medicalIntSurveys);
    	  session.setAttribute("ALL_DCI_SURVEYS", dciSurveys);
    	  session.setAttribute("CURRENT_LINK", "SPECIALTY_FORMS");
    	  return new ModelAndView("specialtyFormSurveys");
      }
      else if(ActionKeys.SAVE_SPECIALTY_SURVEY.equalsIgnoreCase(action))
	  {
		  String filledSurveyString = (String)request.getParameter("filledSurveyValue");
	      if(filledSurveyString!=null&&!filledSurveyString.equals(""))
	      {
	    	  SimpleDateFormat sdf = new SimpleDateFormat(
						ActionKeys.CALENDAR_DATE_FORMAT);
				java.util.Date createDate = null;
				createDate = new java.util.Date(System.currentTimeMillis());
				String userIdString =(String)request.getSession().getAttribute(Constants.USER_ID);
				if(userIdString!=null)
				{
				 long userId = Long.parseLong(userIdString);
				surveyService.saveFilledSurveys("111", filledSurveyString, userGroupId, userId,createDate,createDate);
				}
				
				return new ModelAndView("specialtyFormSurveys"); 
	      }
	  } 
    }
        return mav;
  }


  public String getJSONTextForSurvey(long surveyId,HttpSession session)
  {
	  String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
	  long userType=-1;
	    OptionLookup userTypeLookup = (OptionLookup)session.getAttribute(Constants.USER_TYPE);
	    userType = userTypeLookup.getId();
	  long userGroupId = -1;
	  if(userGroupIdString != null && !("".equalsIgnoreCase(userGroupIdString))){
	      userGroupId = Long.parseLong(userGroupIdString);
	  }
  	if(true)
  	{

         try{
  	       NewSurvey editSurvey = surveyService.getSurveyById(surveyId,userGroupId,userType);//The survey will already be present in the db
  	       if(editSurvey!=null){
  	       session.setAttribute("currentSurvey", editSurvey);
  	       session.setAttribute("surveyTitle", editSurvey.getName());
  	       Set questionObjects = editSurvey.getQuestions();
  	       Iterator questionItr = questionObjects.iterator();
  	       List questionObjectsMap = new ArrayList();//List to send back the question Objects
  	       Comparator comparator =new  Comparator() {
  				public int compare(Object o1, Object o2) {
  					NewSurveyQuestion dto1 = (NewSurveyQuestion) o1;
  					NewSurveyQuestion dto2 = (NewSurveyQuestion) o2;
  					return new Long(dto1.getQuestionNumber()).compareTo(
  							new Long(dto2.getQuestionNumber()));
  				}
  			 };
  	       SortedSet questionObjectsSet = new TreeSet(comparator);//Sort the list based on the questionNumbers
  	       questionObjectsSet.addAll(questionObjects);
           Iterator sortedIterator = questionObjectsSet.iterator();
           while(sortedIterator.hasNext())
  	       {
  	    	  Map questionObj = new HashMap(); 
  	    	  NewSurveyQuestion surveyQuestion = (NewSurveyQuestion)sortedIterator.next();
  	    	  String questionText = surveyQuestion.getQuestionText();
  	          String questionType = surveyQuestion.getQuestionType();
  	          String questionMandatory = surveyQuestion.getMandatory();
  	          long questionNumber = surveyQuestion.getQuestionNumber();
  	          List answerOptions = new ArrayList();
  	          questionObj.put("questionText",questionText);
  	          questionObj.put("mandatory",questionMandatory);
  	          questionObj.put("questionType",questionType);
  	          //If question type is likert scale add the sub questions only
  	          if(questionType.equals(Constants.LIKERT4SCALE)||questionType.equals(Constants.LIKERT5SCALE))
  	          {
  	            Set subQuestions = surveyQuestion.getSubQuestions();
  	            Iterator subQuestionsIterator = subQuestions.iterator();
  	            while(subQuestionsIterator.hasNext())
  	            {
  	            	NewSurveySubQuestions subQuestion = (NewSurveySubQuestions)subQuestionsIterator.next();
  	            	String subQuestionText = subQuestion.getSubQuestionText();
  	                answerOptions.add(subQuestionText);
  	            }
  	            
  	          }//If the question type is multiopt then add just the answerOptions
  	          if(questionType.equals(Constants.MULTIOPTMULTISEL)||questionType.equals(Constants.MULTIOPTSISEL))
  	          {
  	        	  
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

  	          }
  	          questionObj.put("answerOptions",answerOptions.toArray()); 
  	          questionObjectsMap.add(questionObj);
  	       }
  	       Map finalMap = new HashMap();
  	       finalMap.put("questionObjects",questionObjectsMap.toArray());
  	       try{
    	       JSONObject obj = JSONObject.fromMap(finalMap);
    	       //System.out.println("JSON Object created"+obj.toString()+"\n\n");
               //session.setAttribute("jsonQuestions", obj.toString());
              return obj.toString();
  	     }
  	       catch (JSONException e) {
    	    	   // TODO: handle exception
  			   logger.error(e.getMessage()); 
           }
  	       
   	      }
   	      
  		}catch (Exception e) {
  			// TODO: handle exception
  		  logger.error(e.getMessage());
  	     }
  	  
  	}

  return null;	
  }

  private void setJSONObject(long surveyId,HttpSession session)
  {
	  String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
	  long userType=-1;
	    OptionLookup userTypeLookup = (OptionLookup)session.getAttribute(Constants.USER_TYPE);
	    userType = userTypeLookup.getId();
	  long userGroupId = -1;
	  if(userGroupIdString != null && !("".equalsIgnoreCase(userGroupIdString))){
	      userGroupId = Long.parseLong(userGroupIdString);
	  }


	  //System.out.println("to load"+surveyId);
	  try{
           NewSurvey editSurvey = surveyService.getSurveyById(surveyId,userGroupId,userType);
           session.removeAttribute("surveyTitle");
	       session.removeAttribute("currentSurvey");
	       session.removeAttribute("jsonQuestions");
	       if(editSurvey!=null){
	    	   	session.setAttribute("currentSurvey", editSurvey);
	    	   	session.setAttribute("surveyTitle", editSurvey.getName());
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

          }

          if(questionType.equals(Constants.OPENTEXT)||questionType.equals(Constants.NUMTEXT))
          {
        	  individualQuestion.put("questionType",questionType);
          }
          individualQuestion.put("answerOptions",answerOptions.toArray()); 
          questionObjectsMap.add(individualQuestion);
       }
       Map finalMap = new HashMap();
       finalMap.put("questionObjects",questionObjectsMap.toArray());
       try{
	       JSONObject obj = JSONObject.fromMap(finalMap);
	       //System.out.println("JSON Object created"+obj.toString()+"***\n\n");
           session.setAttribute("jsonQuestions", obj.toString());
           session.setAttribute("surveyTitle",editSurvey.getName());
           session.setAttribute("currSurvey",editSurvey );
          }
       catch (JSONException e) {
	    	   // TODO: handle exception
		   logger.error(e.getMessage()); 
       }
       
	      }
	      else
	       {
	    	   logger.error("editSurvey was null");
	       }
	  }catch (Exception e) {
		// TODO: handle exception
	  logger.error(e.getMessage());
      }
    
	  
    
  }  
}
