package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.expert.IExpertListService;
import com.openq.authentication.UserDetails;

public class AddExpertController extends AbstractController{


	IExpertListService expertlistService;
		
		public ModelAndView handleRequestInternal(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			ModelAndView mav = new ModelAndView("searchKOL");

			UserDetails user = (UserDetails) request.getSession().getAttribute(Constants.CURRENT_USER);
			String expert=request.getParameter("expert");

			if(expert!=null)
			{

			}



			return mav;
		}

		public IExpertListService getExpertlistService() {
			return expertlistService;
		}

		public void setExpertlistService(IExpertListService expertlistService) {
			this.expertlistService = expertlistService;
		}


	}
