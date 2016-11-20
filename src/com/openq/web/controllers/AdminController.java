package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

public class AdminController extends AbstractController {
	
	public AdminController(){}

	protected ModelAndView handleRequestInternal(HttpServletRequest arg0, HttpServletResponse arg1) throws Exception {
		// TODO Auto-generated method stub
		HttpSession session = arg0.getSession(true);
		session.setAttribute("CURRENT_LINK","USERS");
		return new ModelAndView("admin");
	}
	
}
