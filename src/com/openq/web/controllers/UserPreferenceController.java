package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.userPreference.IUserPreferenceService;
import com.openq.userPreference.UserPreference;

public class UserPreferenceController extends AbstractController{
	
	IUserPreferenceService userPreferenceService;
	protected ModelAndView handleRequestInternal(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView("userPreference");
		
		String userString = (String)req.getSession().getAttribute(Constants.USER_ID);
		long userId = Long.parseLong(userString);
		
		UserPreference userPreference = userPreferenceService.getUserPreference(userId);
		if("savePreference".equalsIgnoreCase((String) req.getParameter("action")))
		{
		String prefString = (String)req.getParameter("pref");
		long preference = Long.parseLong(prefString);
		System.out.println(preference);
		
		 userString = (String)req.getSession().getAttribute(Constants.USER_ID);
		 userId = Long.parseLong(userString);
		
		
		if(userPreference!=null)
			{
				userPreference.setFrequency(preference);
				userPreferenceService.updatePreference(userPreference);
			}
		else
		{
			userPreference = new UserPreference();
			userPreference.setUserId(userId);
			userPreference.setFrequency(preference);
			userPreferenceService.savePreference(userPreference);
			
		}
		req.getSession().setAttribute("message","Preference Saved Successfully");
		}
		
		if(userPreference != null)
		req.getSession().setAttribute("userPreference",userPreference.getFrequency()+"");
		
		
		
		return mav;
	}
	public IUserPreferenceService getUserPreferenceService() {
		return userPreferenceService;
	}
	public void setUserPreferenceService(
			IUserPreferenceService userPreferenceService) {
		this.userPreferenceService = userPreferenceService;
	}
	

}
