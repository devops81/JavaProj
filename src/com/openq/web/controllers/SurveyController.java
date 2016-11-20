package com.openq.web.controllers;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.survey.ISurveyService;
import com.openq.survey.Survey;

public class SurveyController extends AbstractController{

  ISurveyService surveyService;
  public ISurveyService getSurveyService() {
    return surveyService;
  }
  public void setSurveyService(ISurveyService surveyService) {
    this.surveyService = surveyService;
  }
  public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception  
  {
    ModelAndView mav = new ModelAndView("addSurvey");
    Map simpleTextMap = new HashMap();
    Map agreementQuestionsMap = new HashMap();
    Map multipleQuestionsMap = new HashMap();
    Map ratingNumQuestionsMap = new HashMap();
    HttpSession session = request.getSession();
    session.setAttribute("CURRENT_LINK", "SURVEY");
    String surveyTitle = "";
     if(request.getParameter("surveysTitle")!=null)
    {
      surveyTitle = request.getParameter("surveysTitle");
    }
    if(request.getParameter("simpleTextQ")!=null)
    {
      
      String simpleQuestions = request.getParameter("simpleTextQ");
      System.out.println("Simple Questions Count"+simpleQuestions);
      int simpleQuestionsLength = Integer.parseInt(simpleQuestions.trim());
      System.out.println(request.getParameter("simpleTQs"));
      
      for(int i=0;i<simpleQuestionsLength;i++)
      {
         
        if(request.getParameter("simpleText"+i)!=null)
        {
         String wholeQ = request.getParameter("simpleText"+i);
         System.out.println(wholeQ+"\n"); 
         int index = wholeQ.indexOf('.');
         char[] questionNumber=new char[index];   
         wholeQ.getChars(0,index, questionNumber, 0);
         String questionNumberString="";
         String type = "";
         for(int m=0;m<questionNumber.length;m++)
         {
           questionNumberString +=questionNumber[m]+"";
         }
         System.out.println(questionNumberString+"supposedly Question Number");
         if(request.getParameter("simpleText"+i+"Type")!=null)
         {
           type = request.getParameter("simpleText"+i+"Type");
           if(type.equals("3"))
           {
             System.out.println("Now this is numeric open end");
           }
           else
           System.out.println("This is open text man");
         }
         Object[] textObject = new Object[3];
         
         if(wholeQ!=null&&!questionNumberString.equals("")&&!type.equals(""))
         { 
           textObject[0]=wholeQ;
           textObject[1]=questionNumberString;
           textObject[2]=type;
           simpleTextMap.put(questionNumberString, textObject);
         }
      }
    }
   } 
    if(request.getParameter("agreementQ")!=null)
    {
      System.out.println("Agreement Questions"+request.getParameter("agreementQ"));
      int agreementQlength = Integer.parseInt(request.getParameter("agreementQ").trim());
      String wholeQ="";
      String[] agreeOptions=null;
      

      for(int i=0;i<agreementQlength;i++)
      {
        System.out.println(request.getParameter("agreementQuestion"+i));  
        wholeQ = request.getParameter("agreementQuestion"+i);
        int index = wholeQ.indexOf('.');
        char[] questionNumber=new char[index];   
        wholeQ.getChars(0,index, questionNumber, 0);
        String questionNumberString="";
        for(int m=0;m<questionNumber.length;m++)
        {
          questionNumberString +=questionNumber[m]+"";
        }
        System.out.println(questionNumberString+"supposedly Question Number");
        if(request.getParameter("agreementQuestion"+i+"optionCount")!=null)
        {
          int options = Integer.parseInt(request.getParameter("agreementQuestion"+i+"optionCount").trim());
          agreeOptions = new String[options];
          for(int j=0;j<options;j++)
          {
            agreeOptions[j] = request.getParameter("agreementQuestion"+i+"option"+j);  
            System.out.println(agreeOptions[j]+"\n");
          }
        }
        Object[] agreementQ = new Object[2];
        
        if(!wholeQ.equals("")&&agreeOptions!=null&&agreeOptions.length>0&&!questionNumberString.equals(""))
        {
          agreementQ[0] = wholeQ;
          agreementQ[1] = agreeOptions;     
          agreementQuestionsMap.put(questionNumberString, agreementQ);
        }

      }
      
    }
    
    if(request.getParameter("mussQ")!=null)
    {
      System.out.println("Multiple Questions"+request.getParameter("mussQ"));
      int mussQlength = Integer.parseInt(request.getParameter("mussQ").trim());
      String wholeQ="";
      String[] mulOptions=null;
      
      for(int i=0;i<mussQlength;i++)
      {
        System.out.println(request.getParameter("MUSS"+i));  
        wholeQ = request.getParameter("MUSS"+i);
        int index = wholeQ.indexOf('.');
        char[] questionNumber=new char[index];   
        wholeQ.getChars(0,index, questionNumber, 0);
        String questionNumberString="";
        for(int m=0;m<questionNumber.length;m++)
        {
          questionNumberString +=questionNumber[m]+"";
        }
        System.out.println(questionNumberString+"supposedly Question Number");
        if(request.getParameter("MUSS"+i+"optionCount")!=null)
        {
          int options = Integer.parseInt(request.getParameter("MUSS"+i+"optionCount").trim());
          mulOptions = new String[options];
          for(int j=0;j<options;j++)
          {
              mulOptions[j]= request.getParameter("MUSS"+i+"option"+j);
              System.out.println(mulOptions[j]+"\n");
          }
        }
        String questionType="";
        if(request.getParameter("MUSS"+i+"Type")!=null)
        {
          questionType = request.getParameter("MUSS"+i+"Type");
          if(questionType!=null&&!questionType.equals(""))
          {
             if(questionType.equals("7"))
             {
               System.out.println("The type is Rating select");
             }
             else if(questionType.equals("1"))
             {
              System.out.println("The type is of multi choice single select");    
             }
             else
             {
              System.out.println("The type is MultiOptionMultiselect2"); 
             }
          }
        }
        
        Object[] multipleQ = new Object[3];
      
      if(!wholeQ.equals("")&&mulOptions!=null&&mulOptions.length>0&&!questionNumberString.equals(""))
      {
        multipleQ[0] = wholeQ;
        multipleQ[1] = mulOptions;
        multipleQ[2]=questionType;
        multipleQuestionsMap.put(questionNumberString, multipleQ);
      }
       
    }
      
    }
    
    if(request.getParameter("rnumQ")!=null)
    {
      System.out.println("Rating Numeric Questions"+request.getParameter("rnumQ"));
      int rnumQlength = Integer.parseInt(request.getParameter("rnumQ").trim());
      String wholeQ="";
      String[] ratingNumOptions=null;
      
      for(int i=0;i<rnumQlength;i++)
      {
        System.out.println(request.getParameter("RNUM"+i));  
        wholeQ = request.getParameter("RNUM"+i);
        int index = wholeQ.indexOf('.');
        char[] questionNumber=new char[index];   
        wholeQ.getChars(0,index, questionNumber, 0);
        String questionNumberString="";
        for(int m=0;m<questionNumber.length;m++)
        {
          questionNumberString +=questionNumber[m]+"";
        }
        System.out.println(questionNumberString+"supposedly Question Number");
        if(request.getParameter("RNUM"+i+"optionCount")!=null)
        {
          int options = Integer.parseInt(request.getParameter("RNUM"+i+"optionCount").trim());
          ratingNumOptions = new String[options];
          for(int j=0;j<options;j++)
          {
              System.out.println("RNUM"+i+"option"+j);            
              ratingNumOptions[j]= request.getParameter("RNUM"+i+"option"+j);
              System.out.println(ratingNumOptions[j]+"\n");
          }
        }
      Object[] ratingNumQ = new Object[3];
      
      if(!wholeQ.equals("")&&ratingNumOptions!=null&&ratingNumOptions.length>0&&!questionNumberString.equals(""))
      {
        ratingNumQ[0] = wholeQ;
        ratingNumQ[1] = ratingNumOptions;
        ratingNumQuestionsMap.put(questionNumberString,ratingNumQ);
      }
       
    }
      
    }
    
    System.out.println("Inside survey controller\n");
   if(simpleTextMap.size()>0)
   {
     Set keys = simpleTextMap.keySet(); 
     Iterator itr = keys.iterator();
     while(itr.hasNext())
     {
       System.out.println(itr.next()+"simple\n");
     }
   }
  if(agreementQuestionsMap.size()>0)
   {
    Set keys = agreementQuestionsMap.keySet(); 
    Iterator itr = keys.iterator();
    while(itr.hasNext())
    {
      System.out.println(itr.next()+"agree\n");
    }
   }
  if(multipleQuestionsMap.size()>0)
  {
    Set keys = multipleQuestionsMap.keySet(); 
    Iterator itr = keys.iterator();
    while(itr.hasNext())
    {
      System.out.println(itr.next()+"multi\n");
    }
  }
  if(ratingNumQuestionsMap.size()>0)
  {
    Set keys = ratingNumQuestionsMap.keySet(); 
    Iterator itr = keys.iterator();
    while(itr.hasNext())
    {
      System.out.println(itr.next()+"rating Numerical\n");
    }
  }
  if(surveyTitle!=null&&!surveyTitle.equals(""))
  {
     System.out.println("Supposed to set survey");
   Survey survey= surveyService.setSurvey(surveyTitle,simpleTextMap , agreementQuestionsMap, multipleQuestionsMap,ratingNumQuestionsMap);  
   Survey[] totalSurveys = surveyService.getAllSurveys();
   session.setAttribute("ALL_SURVEYS", totalSurveys);  
  }
  return mav;
  }
}
