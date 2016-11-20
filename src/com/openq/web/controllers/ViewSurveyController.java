package com.openq.web.controllers;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.survey.ISurveyService;
import com.openq.survey.QuestionAnswer;
import com.openq.survey.QuestionDetails;
import com.openq.survey.QuestionType;
import com.openq.survey.Survey;

public class ViewSurveyController extends AbstractController{

  ISurveyService surveyService;
  private  Survey survey;
  private boolean newInteraction = true;
  private String currentInteractionId = "0";
  public ISurveyService getSurveyService() {
    return surveyService;
  }
  public void setSurveyService(ISurveyService surveyService) {
    this.surveyService = surveyService;
     
  }
  public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception  
  {
   
    System.out.println("ViewSurveyController\n");
    String action = request.getParameter("action");
    String interactionId = request.getParameter("interactionId");
    String surveyIdFromInteraction = request.getParameter("surveyId");
    Map questionsMap=new HashMap();
    questionsMap = surveyService.getSurvey("SampleTemplate");
    if(surveyIdFromInteraction!=null&&!surveyIdFromInteraction.equals(""))
    {
      try
      {
      long surveyId = Long.parseLong(surveyIdFromInteraction);  
        Map newSurveyMap = surveyService.getSurvey(surveyId); 
        if(newSurveyMap!=null)
        {
          System.out.println("Setting the new MAP");
          questionsMap = newSurveyMap;
          request.getSession().setAttribute("NEWSURVEY_ID", surveyIdFromInteraction);
        }
      }
      catch(Exception e)
      {
        System.out.println(e.getMessage());
      }
    }
    
    if(interactionId!=null&&!interactionId.equals("0"))
    {
      newInteraction=false;
      System.out.println("Update interaction\n\n\n");
      currentInteractionId=interactionId;   
     }
    else 
    {
      System.out.println("New Interaction\n");
    }
    System.out.println(action+"the action");
    HttpSession session = request.getSession();
    
    
    if(questionsMap!=null)
      {
        survey= (Survey)questionsMap.get("survey");  
        questionsMap.remove("survey");
        session.setAttribute("questionsMap", questionsMap);
        session.setAttribute("surveyTitle", survey.getName());
        System.out.println("questionMaps length"+questionsMap.size()+"\n");
      }
    
    if(action!=null&&action.equals("submitSurvey"))
    {
      System.out.println("Action equalled submitSurvey");
      System.out.println(request.getParameter("totalQuestions")+"totalQ");
      Map submitSurveyMap = new HashMap();
      submitSurveyMap.put("survey", survey);
      submitSurveyMap.put("userId",(String) session.getAttribute(Constants.USER_ID));
        
      if(request.getParameter("interactionAttendee")!=null)
      {
        String kolId = request.getParameter("interactionAttendee");
        System.out.println(kolId+"THis is kolid\n");
        submitSurveyMap.put("kolId",kolId);
      }
      
      if(request.getParameter("totalQuestions")!=null)
        {
           int totalQuestions = Integer.parseInt(request.getParameter("totalQuestions").trim());
           System.out.println(totalQuestions+"no. of questions");
           for(int i=1;i<=totalQuestions;i++)
           {
               
             System.out.println(request.getParameter("question"+i+"Type")+"Type");
             if(request.getParameter("question"+i+"Type")!=null)
             {
               String questionType= request.getParameter("question"+i+"Type");
               
               if(questionType.trim().equals("4")||questionType.trim().equals("3"))
               {
                 System.out.println(request.getParameter("answer"+i)+"Answer");
                 if(request.getParameter("answer"+i)!=null)
                 {
                    String answerText = request.getParameter("answer"+i);
                    System.out.println(answerText+"Text");
                    System.out.println(request.getParameter("question"+i+"Id")+"questionID");
                    if(request.getParameter("question"+i+"Id")!=null)
                    {
                      
                      String questionId = request.getParameter("question"+i+"Id");
                      System.out.println("Type:"+questionType+" \n");
                      System.out.println("QuestionId:"+questionId+"\n");
                      System.out.println("Answer:"+answerText+"\n");
                      submitSurveyMap.put(questionId, answerText);
                    }
                 }
               }
               else if(questionType.trim().equals("5"))
               {
                 System.out.println("Type 5");
                 System.out.println(request.getParameter("question"+i+"options")+"question"+i+"options");
                 if(request.getParameter("question"+i+"options")!=null)
                 {
                    int options = Integer.parseInt(request.getParameter("question"+i+"options").trim());
                    String[] optionAnswers = new String[options];
                    
                    for(int j=0;j<options;j++)
                    {
                      System.out.println(request.getParameter("answer"+i+"Radio"+j)+"Radion"+j);
                       if(request.getParameter("answer"+i+"Radio"+j)!=null)
                       {
                          optionAnswers[j] =  request.getParameter("answer"+i+"Radio"+j);   
                          
                       }
                    }
                   if(request.getParameter("question"+i+"Id")!=null)
                   {
                      String questionId =  request.getParameter("question"+i+"Id");
                      System.out.println("Agreement question");
                      System.out.println("Question ID:"+questionId+"\n");
                      
                      for(int j=0;j<options;j++)
                      {
                        System.out.println("Answer"+options+":"+optionAnswers[j]);
                        String subQuestionId = request.getParameter("answer"+i+"subQuestion"+j+"Id");
                        System.out.println("AgreementSubquestionId"+ subQuestionId);
                        submitSurveyMap.put(subQuestionId, optionAnswers[j]);
                      }
                    
                   }
                 }
               
               }
             
               else if(questionType.trim().equals("6"))
               {
                 System.out.println("Type 6");
                 System.out.println(request.getParameter("question"+i+"options")+"question"+i+"options");
                 if(request.getParameter("question"+i+"options")!=null)
                 {
                    int options = Integer.parseInt(request.getParameter("question"+i+"options").trim());
                    if(request.getParameter("question"+i+"Id")!=null)
                   {
                      String questionId =  request.getParameter("question"+i+"Id");
                      System.out.println("Rating Numeric question");
                      System.out.println("Question ID:"+questionId+"\n");
                      
                      for(int j=0;j<options;j++)
                      {
                        String subQuestionId = request.getParameter("answer"+i+"subQuestion"+j+"Id");
                        String subQuestionValue = request.getParameter("answer"+i+"Text"+j);
                        System.out.println("RatingSubquestionId"+ subQuestionId);
                        submitSurveyMap.put(subQuestionId, subQuestionValue);
                      }
                    
                   }
                 }
               
               }
               
               
               
               else if( questionType.equals("1")||questionType.equals("7"))
               {
                 if(request.getParameter("question"+i+"Id")!=null)
                 {
                     
                   
                   if(request.getParameter("answerRadio"+i)!=null)
                   {
                   
                       String questionId=request.getParameter("question"+i+"Id");
                       String answerValue = request.getParameter("answerRadio"+i);
                       System.out.println("Question Id is "+ questionId);
                       System.out.println("Multiple Answer selected is"+answerValue);
                       submitSurveyMap.put(questionId, answerValue);
                   }
                     
                }
                 
              } 
               else if(questionType.equals("2"))
               {
                 if(request.getParameter("question"+i+"Id")!=null)
                 {
                     
                   
                   if(request.getParameterValues("answerCheck"+i)!=null)
                   {
                       String questionId=request.getParameter("question"+i+"Id");
                       String[] answerValue = request.getParameterValues("answerCheck"+i);
                       System.out.println("Question Id is "+ questionId);
                       if(answerValue!=null)
                       {
                         String answerValues = "";  
                         for(int j=0;j<answerValue.length;j++)
                           {
                           System.out.println("Multiple Multi Answer selected is"+answerValue[j]);
                           answerValues += answerValue[j]+",";
                           }
                         answerValues = answerValues.substring(0,answerValues.length()-1);
                         System.out.println("Setting"+answerValues);
                         submitSurveyMap.put(questionId, answerValues);
                       }
                    }
                     
                }  
             
               }
             
             
             }
           
           }
        
           if(!newInteraction)
           {
             Survey survey =(Survey) submitSurveyMap.get("survey");
             if(survey!=null)
             {
               if(survey.getName().equals("SampleTemplate"))
               {
                 submitSurveyMap.put("interactionId", currentInteractionId);
                 System.out.println("Going to call save service");
                 surveyService.saveSurvey(submitSurveyMap);
                 System.out.println("Saved");    
               }
               else
               {
                 System.out.println("This not a valid survey to be saved");
               }
             }
            }
           else
           {
             System.out.println("SURVEY FOR INTERACTION\n");
             session.removeAttribute("SURVEY_FOR_INERACTION");
             Survey survey = (Survey)submitSurveyMap.get("survey");
             if(survey!=null)
             {
               if(survey.getName().equals("SampleTemplate"))
               {
                 session.setAttribute("SURVEY_FOR_INERACTION", submitSurveyMap);  
                 System.out.println("SURVEY FOR INTERACTION 2\n"); 
               }
               else
               {
                 System.out.println("Not a valid survey to be saved");
               }
             }
             
           }
        
        }
    
    }
    
    return new ModelAndView("viewSurvey");
    
  }


 
}
