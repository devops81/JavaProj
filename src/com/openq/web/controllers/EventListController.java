package com.openq.web.controllers;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.event.EventAttendee;
import com.openq.event.EventEntity;
import com.openq.event.IEventService;
import com.openq.interactionData.IInteractionDataService;
import com.openq.user.IUserService;
import com.openq.user.User;

public class EventListController extends AbstractController {

    IEventService eventService;
    IUserService userService;
    IInteractionDataService interactionDataService;
    // IOptionServiceWrapper optionServiceWrapper;

    public final static DateFormat format = new SimpleDateFormat("mm/dd/yyyy");

    public IUserService getUserService() {
        return userService;
    }

    public void setUserService(IUserService userService) {
        this.userService = userService;
    }

    protected ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        // TODO Auto-generated method stub
        ModelAndView mav = new ModelAndView("eventsList");
        request.getSession().removeAttribute("EVENT_LIST_RESULTS");
        String eventdate = request.getParameter("eventdate");
        String middledate = request.getParameter("eventmiddate");
        String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
        long userGroupId = -1;
        if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString)){
         userGroupId = Long.parseLong(userGroupIdString);
        }

        // HttpSession session = request.getSession();
        TreeMap attrMap = new TreeMap();
        EventEntity[] result1 = null;
        if (null != eventdate && !"".equals(eventdate)) {
            String d = eventdate.split("-")[1] + "/" + eventdate.split("-")[2]
                                                                            + "/" + eventdate.split("-")[0];
            // Added one condition for fromSearchEvent
            if ((request.getParameter("fromSearch")) == "true") {

                String d1 = "03/01/2008";
                String d2 = "03/30/2008";
                attrMap.put("toDate1", d1);
                attrMap.put("toDate2", d2);

            } else {
                attrMap.put("toDate1", d);
                attrMap.put("toDate2", d);
            }

        } else if (null != middledate && !"".equals(middledate)) {
            String selectedDate = middledate.split("-")[1] + "/"
            + middledate.split("-")[2] + "/" + middledate.split("-")[0];

            result1 = eventService.searchEvent(selectedDate, userGroupId);
        } else {
            if ((request.getParameter("fromSearch")).equalsIgnoreCase("true")) {
                // String date = request.getParameter("searchFromDate");
                String dateString = request.getParameter("interactionDate");
                // String dateString = dateString1.replaceAll("/", "//");
                if (dateString != null) {
                    DateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
                    Date date1 = formatter.parse(dateString);

                    Calendar cal1 = Calendar.getInstance();
                    Calendar cal2 = Calendar.getInstance();
                    cal1.setTime(date1);
                    cal2.setTime(date1);
                    cal1.add(Calendar.DATE, -7);
                    cal2.add(Calendar.DATE, +7);
                    // Date previousDate = cal1.getTime();

                    int year1 = cal1.get(Calendar.YEAR);
                    int month1 = cal1.get(Calendar.MONTH);
                    month1++;
                    int day1 = cal1.get(Calendar.DAY_OF_MONTH);

                    String monthString1 = "";
                    if (month1 < 10) {
                        monthString1 = "0" + month1;
                    } else {
                        monthString1 = month1 + "";
                    }
                    String dayString1 = "";
                    if (day1 < 10) {
                        dayString1 = "0" + day1;
                    } else {
                        dayString1 = day1 + "";
                    }
                    String fromDate = monthString1 + "/" + dayString1 + "/"
                    + year1;

                    int year2 = cal2.get(Calendar.YEAR);
                    int month2 = cal2.get(Calendar.MONTH);
                    month2++;
                    int day2 = cal2.get(Calendar.DAY_OF_MONTH);

                    String monthString2 = "";
                    if (month2 < 10) {
                        monthString2 = "0" + month2;
                    } else {
                        monthString2 = month2 + "";
                    }
                    String dayString2 = "";
                    if (day2 < 10) {
                        dayString2 = "0" + day2;
                    } else {
                        dayString2 = day2 + "";
                    }
                    String toDate = monthString2 + "/" + dayString2 + "/"
                    + year2;
                    String d1 = "03/01/2008";
                    String d2 = "03/30/2008";
                    attrMap.put("toDate1", fromDate);
                    attrMap.put("toDate2", toDate);
                }

            }

        }

        EventEntity[] result = eventService.searchEvent(attrMap, userGroupId);
        if (null != middledate && !"".equals(middledate)) {
            result = result1;
        }
        if (result != null && result.length != 0) {
            Map eventAttendeeMap = new HashMap();
            Map interactionsCountMap = new HashMap();
            for (int i = 0; i < result.length; i++) {
                EventEntity eventEntity = result[i];

                EventAttendee[] eventAttendee = eventService
                .getAllAttendees(eventEntity.getId());
                int interactionsCount = interactionDataService
                .getInteractionsCountForEvent(eventEntity.getId());
                interactionsCountMap.put(eventEntity.getId() + "",
                        interactionsCount + "");
                if (eventAttendee != null && eventAttendee.length > 0) {
                    String eventAttendess = "";
                    for (int j = 0; j < eventAttendee.length; j++) {

                        User user = userService.getUser(eventAttendee[j]
                                                                      .getExpertId().getId());
                        eventAttendess += user.getFirstName() + " "
                        + user.getLastName() + ",";
                    }
                    eventAttendeeMap.put(eventEntity.getId() + "",
                            eventAttendess.substring(0,
                                    eventAttendess.length() - 1));
                }
                request.getSession().setAttribute("eventAttendees",
                        eventAttendeeMap);
                request.getSession().setAttribute("eventInteractionsCount",
                        interactionsCountMap);
            }
            request.getSession().setAttribute("EVENT_LIST_RESULTS", result);

        }
        mav.addObject("fromSearch", request.getParameter("fromSearch"));
        return mav;
    }

    public IEventService getEventService() {
        return eventService;
    }

    public void setEventService(IEventService eventService) {
        this.eventService = eventService;
    }

    public IInteractionDataService getInteractionDataService() {
        return interactionDataService;
    }

    public void setInteractionDataService(
            IInteractionDataService interactionDataService) {
        this.interactionDataService = interactionDataService;
    }

}
