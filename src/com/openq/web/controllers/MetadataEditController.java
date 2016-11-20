package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

public class MetadataEditController extends AbstractController {

	protected ModelAndView handleRequestInternal(HttpServletRequest req,
			HttpServletResponse res) throws Exception {
	    ModelAndView mav = new ModelAndView("metadataEdit");
		HttpSession session = req.getSession(true);
		session.setAttribute("CURRENT_LINK","METADATA");
		
		String errorMessage=null;
		errorMessage = (String)req.getParameter("errorMessage");
		req.getSession().setAttribute("errorMsg", errorMessage);
		return mav;
	}

}
