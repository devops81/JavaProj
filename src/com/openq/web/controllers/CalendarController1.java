package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.event.EventEntity;
import com.openq.event.EventService;
import com.openq.event.IEventService;

public class CalendarController1 extends AbstractController{

	
	IEventService eventService;

	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
		
		ModelAndView mav = new ModelAndView("calendar/calendar1");
		request.getSession().removeAttribute("eventEntity");
		
		EventEntity [] eventEntity = eventService.getAllEvents();
		request.getSession().setAttribute("eventEntity", eventEntity);
		
		
		return mav;
	}
	
	public IEventService getEventService() {
		return eventService;
	}

	public void setEventService(IEventService eventService) {
		this.eventService = eventService;
	}

}

