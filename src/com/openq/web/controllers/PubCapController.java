package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

public class PubCapController extends AbstractController  {
	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("pubcap");	
		HttpSession session = request.getSession();
		session.setAttribute("CURRENT_LINK","PUBCAP");
		session.setAttribute("CURRENT_SUB_LINK","STATUS");
		
		return mav;
	}

}
