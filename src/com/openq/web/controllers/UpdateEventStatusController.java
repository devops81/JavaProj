package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.event.IEventService;

public class UpdateEventStatusController extends AbstractController {

	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav =  new ModelAndView("updateEventStatus");
		
		String attendeeId = request.getParameter("attendeeId");
		String status = request.getParameter("status");

		if (attendeeId != null && status != null) {
			try {
				long aId = (new Long(attendeeId)).longValue();
				eventService.updateEventAttendeeStatus(aId, status);
				mav.addObject("status", "Thanks you. Your acceptance status updated.");
			} catch (Exception e) {
				// Do nothing
				mav.addObject("status", "Acceptance status could not be updated.");
			}
		}
		
		//System.out.print("Attendee ID=" + attendeeId);
		//System.out.print("Status=" + status);

		return mav;
	}
	
	IEventService eventService;

	public IEventService getEventService() {
		return eventService;
	}

	public void setEventService(IEventService eventService) {
		this.eventService = eventService;
	}
}
