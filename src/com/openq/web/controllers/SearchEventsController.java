package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.audit.IDataAuditService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.event.EventAttendee;
import com.openq.event.EventEntity;
import com.openq.event.IEventService;
import com.openq.group.Groups;
import com.openq.group.IGroupService;
import com.openq.group.IUserGroupMapService;
import com.openq.user.User;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;

/**
 * Created by IntelliJ IDEA.
 * User: radhikav
 * Date: Nov 29, 2006
 * Time: 7:14:57 PM
 * To change this template use File | Settings | File Templates.
 */
public class SearchEventsController extends AbstractController {

    IDataAuditService dataAuditService;

    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString)){
		 userGroupId = Long.parseLong(userGroupIdString);
		}

        String groupFunctionalArea = (String)session.getAttribute(Constants.GROUP_FUNCTIONAL_AREA);
        String action = (String) request.getParameter("action");
        request.setAttribute("go", request.getParameter("go"));
        request.setAttribute("kol_id", request.getParameter("kolId"));
        request.setAttribute("kol_name", request.getParameter("kolName"));
        session.setAttribute("CURRENT_LINK","EVENTS");
        session.setAttribute("EVENT_THERAPY", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("THERAPY"), userGroupId));
        session.setAttribute("EVENT_THERAPAEUTIC_AREA", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
        session.setAttribute("EVENT_TYPES", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("EVENT_TYPES"), userGroupId));
        session.removeAttribute("MESSAGE");
        session.removeAttribute("EVENT_SEARCH_RESULTS");
        session.removeAttribute("SEARCH_MAP");

        // Get the audit data for all events
        Map auditMap = new HashMap();

        if(ActionKeys.SEARCH_EVENT.equals(action)) {
        	TreeMap attrMap = new TreeMap();
            if(null != request.getParameter("title") &&
                    !"".equals(request.getParameter("title"))) {
                attrMap.put("title",request.getParameter("title"));

            }
            if(null != request.getParameter("city") &&
                    !"".equals(request.getParameter("city"))) {
                attrMap.put("city",request.getParameter("city"));

            }
            if(null != request.getParameter("state") &&
                    !"".equals(request.getParameter("state"))) {
                attrMap.put("",request.getParameter("state"));

            }
            if(null != request.getParameter("type") &&
                    !"".equals(request.getParameter("type")) &&
                    !"-1".equals(request.getParameter("type"))) {
                attrMap.put("type",request.getParameter("type"));

            }
            if(null != request.getParameter("owner") &&
                    !"".equals(request.getParameter("owner"))) {
                attrMap.put("owner",request.getParameter("owner"));

            }
            if(null != request.getParameter("ta") &&
                    !"".equals(request.getParameter("ta")) &&
                    !"-1".equals(request.getParameter("ta"))) {
                attrMap.put("ta",request.getParameter("ta"));

            }
            if(null != request.getParameter("therapy") &&
                    !"".equals(request.getParameter("therapy")) &&
                    !"-1".equals(request.getParameter("therapy"))) {
                attrMap.put("therapy",request.getParameter("therapy"));
            }
            if(null != request.getParameter("fromDate") &&
                    !"".equals(request.getParameter("fromDate"))) {
                attrMap.put("toDate1",request.getParameter("fromDate"));

            }
            if(null != request.getParameter("toDate") &&
                    !"".equals(request.getParameter("toDate"))) {
                attrMap.put("toDate2",request.getParameter("toDate"));

            }
            if(null != request.getParameter("staffId") &&
                    !"".equals(request.getParameter("staffId"))) {
                attrMap.put("staffId",request.getParameter("staffId"));

            }
            EventEntity[] result = eventService.searchEvent(attrMap, userGroupId);
            session.setAttribute("SEARCH_MAP",attrMap);
            if(groupFunctionalArea !=null && groupFunctionalArea.equalsIgnoreCase("commercial")){
            	List resultList = new ArrayList();
            	for(int i=0;i<result.length;i++){
            		EventEntity eventEntity = result[i];
            		long eventCreatedById = eventEntity.getUserid();
            		String eventFunctionalArea = getGroupFunctionlArea(eventCreatedById);
            		if(eventFunctionalArea !=null && eventFunctionalArea.equalsIgnoreCase("commercial")){
            			resultList.add(eventEntity);
            		}
            	}
            	result = (EventEntity[]) resultList.toArray(new EventEntity[resultList.size()]);
            	if(result != null && result.length !=0)
                	Arrays.sort(result);
            	session.setAttribute("EVENT_SEARCH_RESULTS",result);
            }else{
                if(result != null && result.length !=0)
                //	Arrays.sort(result);
            	session.setAttribute("EVENT_SEARCH_RESULTS",result);
            }
            if(result == null || (result != null && result.length == 0)) {
            	session.setAttribute("MESSAGE", "For the given search criteria, there is no match found");
            }
        }else if (ActionKeys.VIEW_EVENT.equalsIgnoreCase(action)){

            String fromHome = (String) session.getAttribute("FromHome");
            if (null != fromHome && "yes".equalsIgnoreCase(fromHome)){
              session.setAttribute("CURRENT_LINK", "HOME");
            }
            long eventId = 0;
            if(request.getParameter("eventid") != null &&
                    !"".equals(request.getParameter("eventid"))) {
                eventId = Long.parseLong(request.getParameter("eventid"));
            }
            EventEntity event = null;
            if( eventId > 0 ){
                event = eventService.getEventbyId(eventId);
            }
 
            session.setAttribute("EVENT_OBJECT", event);
            return new ModelAndView("veiwEventAttendee");
        } else if (ActionKeys.EDIT_ATTENDEE.equalsIgnoreCase(action)){
             long eventId = 0;
               if (null != request.getParameter("eventId")){
                eventId = Long.parseLong(request.getParameter("eventId"));
             }
             long userId = Long.parseLong((String) session.getAttribute(Constants.USER_ID));
             String[] attendeeList = request.getParameterValues("invitedOL");
             String[] expertIds = request.getParameterValues("expertId");
               EventEntity event = new EventEntity();

                event.setId(eventId);
       if(attendeeList.length>0){
                EventAttendee[] attendeeSet = new EventAttendee[attendeeList.length];

                EventAttendee eAttendee = null;
                User user = new User();
            for (int i = 0; i < attendeeList.length; i++) {
                String exptId = attendeeList[i];
                eAttendee = new EventAttendee();
                user.setId(Long.parseLong(exptId));
                eAttendee.setExpertId(user);
                if (null != expertIds && expertIds.length > 0) {
                    for (int j = 0; j < expertIds.length; j++) {
                        if (exptId.equalsIgnoreCase(expertIds[j])) {
                            eAttendee.setAttended("Y");
                            break;
                        }else
                            eAttendee.setAttended("N");
                    }
                }else
                    eAttendee.setAttended("N");
                    eAttendee.setEventId(event);
                    eAttendee.setUserId(userId);
                    attendeeSet[i] = eAttendee;

            }
            eventService.updateAttendeeList(event.getId(), attendeeSet);
       }
           return new ModelAndView("event_search");
        } else if (ActionKeys.SHOW_EVENTS_BY_EXPERT.equalsIgnoreCase(action)){
            session.setAttribute("FromHome","yes");
            session.setAttribute("CURRENT_LINK", "HOME");
            session.setAttribute("FromProfile",ActionKeys.SHOW_EVENTS_BY_EXPERT);
            long expertId = 0;
            if (null != request.getParameter("kolId")){
                expertId = Long.parseLong(request.getParameter("kolId"));
            }else if(null != session.getAttribute("KOLID")){
                expertId = Long.parseLong((String)session.getAttribute("KOLID"));
            }
            Object[] eventsObject = null;
            if (expertId != 0){
                eventsObject = eventService.getEventsByExpert(expertId);
            }
            session.setAttribute("EXP_EVENTS",eventsObject);
            if(request.getParameter("fromProfSummary")!=null)
            {
              request.setAttribute("fromProfSummary", "true");
            }
            // Fill in the audit map
            if (eventsObject != null) {
                List attributeList = Arrays.asList(new String[] { "title", "event_type", "eventdate", "ta", "therapy" });
                for (int i = 0; i < eventsObject.length; i++) {
                    EventEntity eventEntity = (EventEntity) ((Object[]) eventsObject[i])[0];
                    String id = eventEntity.getId() + "";
                    auditMap.putAll(dataAuditService.getLatest(id, attributeList));

                }
            }

            // Set the audit info in the session
            session.setAttribute("auditLastUpdated", auditMap);

            return new ModelAndView("eventsByExpert");
        }
        ModelAndView mav = new ModelAndView("event_search");
        return mav;

    }

    IOptionServiceWrapper optionServiceWrapper;
    IOptionService optionService ;
	IGroupService groupService;
	IUserGroupMapService userGroupMapService;

	public IUserGroupMapService getUserGroupMapService() {
		return userGroupMapService;
	}

	public void setUserGroupMapService(IUserGroupMapService userGroupMapService) {
		this.userGroupMapService = userGroupMapService;
	}

	public IGroupService getGroupService() {
		return groupService;
	}

	public void setGroupService(IGroupService groupService) {
		this.groupService = groupService;
	}

    public String getGroupFunctionlArea(long luserId){

    		long groupId      = userGroupMapService.getGroupIdForUser(luserId);
    		if(groupId != -1){
    		Groups groupDetail = groupService.getGroup(groupId);
    		if(groupDetail != null){
    		String functionalAreaId = groupDetail.getFunctionalArea();
    		if(functionalAreaId != null && functionalAreaId.length() > 0){
    			long faID = Long.parseLong(functionalAreaId);
    			OptionLookup optionLookup = optionService.getOptionLookup(faID, groupId);
    			String functionalAreaValue = optionLookup.getOptValue();
    			return functionalAreaValue;
    		  }
    		}
    	  }

    	return "";
    }




    public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }
    IEventService eventService;

    public IEventService getEventService() {
        return eventService;
    }

    public void setEventService(IEventService eventService) {
        this.eventService = eventService;
    }

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

    /**
     * @return the dataAuditService
     */
    public IDataAuditService getDataAuditService() {
        return dataAuditService;
    }

    /**
     * @param dataAuditService the dataAuditService to set
     */
    public void setDataAuditService(IDataAuditService dataAuditService) {
        this.dataAuditService = dataAuditService;
    }
}
