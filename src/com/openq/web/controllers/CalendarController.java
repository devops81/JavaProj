package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.event.*;
import com.openq.interaction.*;
import com.openq.utils.PropertyReader;
import com.openq.utils.DateUtils;

import java.util.*;

public class CalendarController extends AbstractController{


    IEventService eventService;
    IInteractionService interactionService;

    public IKolCalendarService getKolCalendarService() {
        return kolCalendarService;
    }

    public void setKolCalendarService(IKolCalendarService kolCalendarService) {
        this.kolCalendarService = kolCalendarService;
    }

    IKolCalendarService kolCalendarService;

    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // TODO Auto-generated method stub

        HttpSession session = request.getSession();
        ModelAndView mav = new ModelAndView("calendar/calendar1");
        String action = (String)request.getParameter("abc");
        String source = (String)request.getParameter("source");
        String kolId = (String)request.getParameter("kolid");
        String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString)){
		 userGroupId = Long.parseLong(userGroupIdString);
		}

        session.setAttribute("EVENT_TYPES", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("EVENT_TYPES"), userGroupId));
        session.setAttribute("EVENT_THERAPY", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("THERAPY"), userGroupId));
        removeExpertRelatedSessionAttributes(session);
        if(action != null ){
            if ( source == null )
            {   
                if(action.equals("calendar")){
                    ModelAndView agendaMAV = new ModelAndView("calendar/calendar");
                    return agendaMAV;
                }
                if(action.equals("calendar1")){
                    ModelAndView agendaMAV = new ModelAndView("calendar/calendar1");
                    return agendaMAV;
                }
                if(action.equals("calendar2")){
                    ModelAndView agendaMAV = new ModelAndView("calendar/calendar2");
                    return agendaMAV;
                }
            }
            else if (source.equals("1expert"))
            {
                long kol = 0;
                try {
                    kol = Long.parseLong(kolId);
                }
                catch (NumberFormatException n)
                {
                    return  mav;
                }

                return getKolCalendar(session, kol);
            }
        }
        return mav;
    }

    private ModelAndView getKolCalendar(HttpSession session, long userID)
    {
        Object[] eventObject = (Object[]) eventService.getEventsByExpert(userID);
        Interaction[] interactions = interactionService.getAllInteractionByExpert(userID);
        Collection invitited = new HashSet();
        Collection accepted = new HashSet();
        Collection rejected    = new HashSet();
        Collection attended    = new HashSet();
        Collection interaction = new HashSet();
        
        if (null != interactions)
        {
            for (int i = 0; i < interactions.length; i++)
            {
                Interaction inter = interactions[i];
                interaction.add(inter);
            }
        }
        if (null != eventObject)
        {
            for (int i = 0; i < eventObject.length; i++)
            {
                Object[] eventRow = (Object[]) eventObject[i];
                EventEntity eventEntity = (EventEntity) eventRow[0];
                EventAttendee attendee = (EventAttendee) eventRow[1];
                if (EventAttendee.ACCEPTED_STATUS.equals(attendee.getAcceptanceStatus()))
                {
                    accepted.add(eventEntity);
                }
                else if (EventAttendee.DECLIEND_STATUS.equals(attendee.getAcceptanceStatus()))
                {
                    rejected.add(eventEntity);
                }
                else  if(attendee.getAttended().equals("Y"))
                {
                    attended.add(eventEntity);
                }
                else
                {
                    invitited.add(eventEntity);
                }
            }
        }
        session.setAttribute("accepted", accepted);
        session.setAttribute("rejected", rejected);
        session.setAttribute("invited", invitited);
        session.setAttribute("attended", attended);
        session.setAttribute("preference", kolCalendarService.getAllPreferenceForExpertId(userID));
        session.setAttribute("INTERACTIONS", interaction);
        return new ModelAndView("calendar/calendar");
    }
    private void removeExpertRelatedSessionAttributes(HttpSession session){
        session.removeAttribute("accepted");
        session.removeAttribute("rejected");
        session.removeAttribute("invited");
        session.removeAttribute("attended");
        session.removeAttribute("preference");
        session.removeAttribute("INTERACTIONS");
    }
    public IEventService getEventService() {
        return eventService;
    }

    public void setEventService(IEventService eventService) {
        this.eventService = eventService;
    }
    IOptionServiceWrapper optionServiceWrapper;


    public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }
    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

    public IInteractionService getInteractionService() {
        return interactionService;
    }
    
    public void setInteractionService(IInteractionService interactionService) {
        this.interactionService = interactionService;
    }
}

