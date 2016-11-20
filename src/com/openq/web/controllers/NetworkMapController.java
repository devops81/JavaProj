package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionService;
import com.openq.kol.KOLManager;

public class NetworkMapController extends AbstractController {

	protected ModelAndView handleRequestInternal(HttpServletRequest arg0, HttpServletResponse arg1) throws Exception {
		// TODO Auto-generated method stub
		HttpSession session = arg0.getSession(true);
		session.setAttribute("CURRENT_LINK","REPORTS"); 
		ModelAndView mav = new ModelAndView("networkMap");
		return mav;
	}

}
