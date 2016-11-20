package com.openq.web.controllers;

import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.ModelAndView;

import com.openq.event.materials.EventMaterial;
import com.openq.event.materials.IEventMaterialService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


/**
 * 
 */

public class MaterialListController extends AbstractController {
	IEventMaterialService eventMaterialService;
	
    public IEventMaterialService getEventMaterialService() {
		return eventMaterialService;
	}

	public void setEventMaterialService(IEventMaterialService eventMaterialService) {
		this.eventMaterialService = eventMaterialService;
	}

	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	ModelAndView mav = new ModelAndView("materialList");
    	long eventId = 0;
    	if(request.getParameter("eventId") != null)
    		eventId = Long.parseLong(request.getParameter("eventId"));
    	EventMaterial[] material= eventMaterialService.getAllEventMaterialsOfEvent(eventId);
    	request.getSession().setAttribute("MATERIAL", material);
    	return mav;
    }
}
