package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.expert.IExpertListService;
import com.openq.eav.expert.MyExpertList;

public class ExpertDetailsController extends AbstractController {

	IExpertListService expertlistService;

	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("expertdetails");
		/*
		if (request.getParameter("expertId") != null) {
			MyExpertList myexpert = (MyExpertList) expertlistService
			.getMyExpert(request.getParameter("expertId"));
			mav.addObject("myexpert", myexpert);			
		}
		*/
		return mav;
	}

	public IExpertListService getExpertlistService() {
		return expertlistService;
	}

	public void setExpertlistService(IExpertListService expertlistService) {
		this.expertlistService = expertlistService;
	}
}
