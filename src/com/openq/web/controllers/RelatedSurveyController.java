package com.openq.web.controllers;


import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.survey.ISurveyService;
import com.openq.survey.NewSurvey;
import com.openq.survey.NewSurveyFilled;
import com.openq.survey.SurveyProfileDetails;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.user.UserService;
public class RelatedSurveyController extends AbstractController{
	
	ISurveyService surveyService;
	IUserService userService;

	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		ModelAndView mav = new ModelAndView("relatedSurvey");
		long expertId = -1;
		if(request.getParameter("kolId")!= null)
			expertId = Long.parseLong(request.getParameter("kolId"));
		String userGroupIdString = (String) request.getSession().getAttribute(
				Constants.CURRENT_USER_GROUP);
		
		long userGroupId = -1;
		
		if (userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
			userGroupId = Long.parseLong(userGroupIdString);
		List surveyDetails = surveyService.getSurveyInfoForExpertProfile(expertId,userGroupId);
		
		List surveyProfileDetailsList  = new ArrayList();
		if(surveyDetails != null){
			
			for(int i=0;i<surveyDetails.size();i++){
				
			    SurveyProfileDetails surveyProfileDetails = new SurveyProfileDetails();	
				Object[] objArr = (Object[])surveyDetails.get(i);
				NewSurvey newSurvey = (NewSurvey) objArr[0];
				NewSurveyFilled newSurveyFilled = (NewSurveyFilled) objArr[1];
				surveyProfileDetails.setId(i);
				surveyProfileDetails.setSurveyId(newSurveyFilled.getSurveyId());
				surveyProfileDetails.setDate(newSurveyFilled.getStartDate());
				surveyProfileDetails.setSurveyName(newSurvey.getName());
				User user = userService.getUser(newSurveyFilled.getUserId()); 
				surveyProfileDetails.setUserName(user.getLastName()+", "+user.getFirstName());
				surveyProfileDetailsList.add(surveyProfileDetails);
				
			}
		}
		request.getSession().setAttribute("surveyProfileInfo", surveyProfileDetailsList);
		return mav;

		
		
		
	}

	public ISurveyService getSurveyService() {
		return surveyService;
	}

	public void setSurveyService(ISurveyService surveyService) {
		this.surveyService = surveyService;
	}

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

}

		