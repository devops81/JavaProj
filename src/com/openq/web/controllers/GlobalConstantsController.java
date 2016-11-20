package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.utils.GlobalConstants;
import com.openq.utils.IGlobalConstantsService;

public class GlobalConstantsController extends AbstractController {

	IGlobalConstantsService globalConstantsService;
	
	public IGlobalConstantsService getGlobalConstantsService() {
		return globalConstantsService;
	}

	public void setGlobalConstantsService(
			IGlobalConstantsService globalConstantsService) {
		this.globalConstantsService = globalConstantsService;
	}

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		HttpSession session = request.getSession();
		ModelAndView mav = new ModelAndView("globalConstants");
		String action = (String) request.getParameter("action");
		if("saveGlobalConstants".equals(action)){ // save the changes made to the value(s) of the constant(s)
			String globalConstantName = (String) request.getParameter("globalConstantName");
		    String globalConstantNewValue = (String) request.getParameter("globalConstantValue");
		    int globalConstantId = Integer.parseInt(request.getParameter("globalConstantId"));
			GlobalConstants globalConstant = new GlobalConstants();
			globalConstant.setId(globalConstantId);
			globalConstant.setName(globalConstantName);
			globalConstant.setValue(globalConstantNewValue);
			globalConstantsService.updateGlobalConstantValue(globalConstant);
		}
		GlobalConstants[] allGlobalConstants = globalConstantsService.getAllGlobalConstants();
		mav.addObject("allGlobalConstants",allGlobalConstants);
		session.setAttribute("CURRENT_LINK", "GLOBAL_CONSTANTS");
		return mav;
	}
}
