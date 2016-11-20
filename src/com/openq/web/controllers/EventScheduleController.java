package com.openq.web.controllers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.event.EventEntity;
import com.openq.event.IEventService;
import com.openq.group.IUserGroupMapService;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;

public class EventScheduleController extends AbstractController {

    protected ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        
        ModelAndView mav = new ModelAndView("event_schedule");
        
        session.setAttribute("CURRENT_LINK", "EVENTS");
        
        String reset = (String) request.getParameter("reset");
        if("yes".equals(reset)){
            removeSessionAttributes(session);
        }
        String userGroupIdString = (String) request.getSession().getAttribute(
                Constants.CURRENT_USER_GROUP);
        long userGroupId = -1;
        if (userGroupIdString != null
                && !"".equalsIgnoreCase(userGroupIdString)) {
            userGroupId = Long.parseLong(userGroupIdString);
        }        
        String action = request.getParameter("action");
        if(ActionKeys.ALL_MEDICAL_MEETINGS.equals(action)){
            
            Map lookupId2ColorMap = new HashMap();
            OptionLookup taLookup[] = optionServiceWrapper
            .getValuesForOptionName(PropertyReader
                    .getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId);
            
            createLookupId2ColorMap(lookupId2ColorMap, taLookup, 0);
            
            OptionLookup therapyLookup[] = optionServiceWrapper
            .getValuesForOptionName(PropertyReader
                    .getLOVConstantValueFor("THERAPY"), userGroupId);
            
            createLookupId2ColorMap(lookupId2ColorMap, therapyLookup, taLookup.length);
            EventEntity[] eventEntity = eventService.getAllAllowedEvents(userGroupId);
            
            session.setAttribute("eventEntity", eventEntity);
            session.setAttribute("LOOKUPID_COLORMAP", lookupId2ColorMap);
            session.setAttribute("EVENT_THERAPAEUTIC_AREA", taLookup);
            session.setAttribute("EVENT_TYPES", therapyLookup);
            session.setAttribute("EVENT_THERAPY", therapyLookup);
        }else {
            String parametersJSONString = request.getParameter("parametersJSONString");
            if( parametersJSONString != null &&
                    !"".equals(parametersJSONString)){
                JSONObject parametersJSONObject = JSONObject.fromString(parametersJSONString);
                if(ActionKeys.FILTERED_MEDICAL_MEETINGS.equals(action)){
                    long selectedTA = -1;
                    if( request.getParameter("ta") != null){
                        selectedTA = Long.parseLong((String) request.getParameter("ta"));
                    }
                    JSONArray therapyIdsJSONArray = parametersJSONObject.getJSONArray("therapyIdsArray");
                    // TODO : Find an elegant way to convert JSONArray to String Array
                    List therapyIdsJSONList = JSONArray.toList(therapyIdsJSONArray);
                    String selectedTherapys [] = ( String [] ) therapyIdsJSONList.toArray(new String[therapyIdsJSONList.size()]);
        
                    EventEntity[] eventEntity = eventService.getFilteredEvents(selectedTA, selectedTherapys);
                    session.setAttribute("eventEntity", eventEntity);
                    session.setAttribute("taSelected", (String) request.getParameter("ta") );
                    session.setAttribute("therapySelected", (String [] ) request.getParameterValues("therapy"));
                }
            }
        }
        return mav;
    }
    private void removeSessionAttributes(HttpSession session){
        session.removeAttribute("therapySelected");
        session.removeAttribute("taSelected");
        session.removeAttribute("eventEntity");
    }
    private void createLookupId2ColorMap(Map lookupId2ColorMap, OptionLookup[] lookup, int usedColorIndex){
        int colorArraySize = ColorCodeConstants.colorCodes.length;
        if( lookup != null ) {
              int colorIdx = 0;
              for (int j = 0; j < lookup.length; j++) {
                  colorIdx = usedColorIndex % colorArraySize;
                  usedColorIndex++;
                  lookupId2ColorMap.put(lookup[j].getId()+"", ColorCodeConstants.colorCodes[colorIdx]);
              }
          }
    }
    IOptionServiceWrapper optionServiceWrapper;
    IEventService eventService;
    IUserGroupMapService userGroupMapService;

    /**
     * @return the userGroupMapService
     */
    public IUserGroupMapService getUserGroupMapService() {
        return userGroupMapService;
    }

    /**
     * @param userGroupMapService
     *            the userGroupMapService to set
     */
    public void setUserGroupMapService(IUserGroupMapService userGroupMapService) {
        this.userGroupMapService = userGroupMapService;
    }

    public IEventService getEventService() {
        return eventService;
    }

    public void setEventService(IEventService eventService) {
        this.eventService = eventService;
    }

    public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(
            IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

}
