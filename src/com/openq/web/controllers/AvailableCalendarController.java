package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.event.IEventService;
import com.openq.user.User;

public class AvailableCalendarController extends AbstractController {
	 IEventService eventService;
	public AvailableCalendarController(){}

	protected ModelAndView handleRequestInternal(HttpServletRequest arg0, HttpServletResponse arg1) throws Exception {
		// TODO Auto-generated method stub
		HttpSession session = arg0.getSession(true);
		User[] users=null;
		session.removeAttribute("unavailableDates");
		List unavailableDates=new ArrayList();
		String[] attendeeIds;
		String attendeeList = arg0.getParameter("invitedOl");
        if(attendeeList!=null&&attendeeList.trim().length()>0){
        	attendeeIds=attendeeList.split(",");
        	System.out.println("no of attendees "+attendeeIds.length);
        	ArrayList userIds=new ArrayList();
        	for(int i=0;i<attendeeIds.length;i++){//we are using length -1 because we have one extra coma in attendeelist string
        		System.out.println("attendee id are "+attendeeIds[i]);
        		userIds.add(attendeeIds[i].toString());
        	}
        	unavailableDates=eventService.getUnAvailableDates(userIds);	
        	session.setAttribute("unavailableDates", unavailableDates);
        }
		
        
//		if(session.getAttribute("INVITED_USERS")!=null){
//			users=(User[])session.getAttribute("INVITED_USERS");
//			System.out.println("users length "+users.length);
//			ArrayList userIds=new ArrayList();
//			for(int i=0;i<users.length;i++){
//				System.out.println("in the loop");
//				System.out.println("user id is "+users[i].getId());
//				userIds.add(""+users[i].getId());
//			}
//			unavailableDates=eventService.getUnAvailableDates(userIds);	
//			session.setAttribute("unavailableDates", unavailableDates);
//			System.out.println("exiting");
//		}
		
		Iterator itr=unavailableDates.iterator();
		String unavailDate=new String();
		System.out.println("st4");
		
		while(itr.hasNext()){
			System.out.println("st5");
			unavailDate=itr.next().toString();
			System.out.println("date is "+unavailDate);
		}
		
		return new ModelAndView("available_calendar");
	}
	
	 public IEventService getEventService() {
	        return eventService;
	    }

	    public void setEventService(IEventService eventService) {
	        this.eventService = eventService;
	    }
}