package com.openq.web.controllers;

import java.io.InputStream;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.event.EventAttendee;
import com.openq.event.EventEntity;
import com.openq.event.IEventService;
import com.openq.event.materials.EventMaterial;
import com.openq.event.materials.IEventMaterialService;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.EventNotificationEMailForContact;
import com.openq.utils.EventNotificationEmail;
import com.openq.utils.EventNotificationMailSender;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;

/**
 * Created by IntelliJ IDEA.
 * User: radhikav
 * Date: Nov 29, 2006
 * Time: 6:16:45 PM
 * To change this template use File | Settings | File Templates.
 */
public class EventsController extends AbstractController {

    protected ModelAndView handleRequestInternal(HttpServletRequest request,
                                                 HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        session.removeAttribute("FromHome");
        session.setAttribute("CURRENT_LINK", "EVENTS");
        String fromEvents = null;
        String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
        if (null != request.getParameter("fromEvents"))
        {
          fromEvents = request.getParameter("fromEvents");
          session.setAttribute("fromEvents",fromEvents);
        }

        if(request.getParameter("kolId")!=null){
            User user[]=new User[1];
            user[0]=userService.getUser(Long.parseLong(request.getParameter("kolId")));
            session.setAttribute("INVITED_USERS",user);
        }

        OptionLookup userType = (OptionLookup) session.getAttribute(Constants.USER_TYPE);
        String userTypeText = userType.getOptValue();
        if (userTypeText != null && userTypeText.equalsIgnoreCase("Viewer")) response.sendRedirect("event_search.htm");

        session.setAttribute("EVENT_THERAPY", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("THERAPY"), userGroupId));
        session.setAttribute("EVENT_THERAPAEUTIC_AREA", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
        session.setAttribute("EVENT_TYPES", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("EVENT_TYPES"), userGroupId));
        session.setAttribute("EVENT_STATE", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("STATE"), userGroupId));
        session.setAttribute("EVENT_COUNTRY", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("COUNTRY"), userGroupId));
        session.setAttribute("EVENT_STATUS", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("EVENT_STATUS"), userGroupId));
        long currentUserId = Long.parseLong((String) session.getAttribute(Constants.USER_ID));
        EventAttendee eventAttendee = new EventAttendee();

        session.removeAttribute("MESSAGE");

        if (ActionKeys.SAVE_EVENT.equals(action))
        {   // is it an update or new save
            EventEntity event = getEventDTO(request, currentUserId,userGroupId);
            String[] attendeeList = request.getParameterValues("invitedOl");
            String[] approverList=request.getParameterValues("approvers");
            if (request.getParameter("hiddeneventid") != null && !"".equals(request.getParameter("hiddeneventid"))
                && !"0".equals(request.getParameter("hiddeneventid")))
           {
                event.setId(Long.parseLong(request.getParameter("hiddeneventid")));
                eventService.updateEvent(event);
                if (attendeeList != null && attendeeList.length > 0)
                {
                    EventAttendee[] attendeeSet = new EventAttendee[attendeeList.length];
                    User user = new User();
                    for (int i = 0; i < attendeeList.length; i++)
                    {
                        String expertId = attendeeList[i];
                        EventAttendee[] attendedObj = eventService.isAttended(event.getId(), Long.parseLong(expertId));
                        eventAttendee = new EventAttendee();
                        eventAttendee.setUserId(currentUserId);
                        user.setId(Long.parseLong(expertId));
                        eventAttendee.setExpertId(user);
                        if (null != attendedObj && attendedObj.length > 0)
                        {
                            if (attendedObj[0].getAttended().equalsIgnoreCase("Y"))
                                eventAttendee.setAttended("Y");
                            else
                                eventAttendee.setAttended("N");
                        } else
                            eventAttendee.setAttended("N");
                        eventAttendee.setEventId(event);
                        attendeeSet[i] = eventAttendee;
                    }
                    eventService.updateAttendeeList(event.getId(), attendeeSet);
                }
                else
                {
                    EventAttendee[] eventAttendees = eventService.getAllAttendees(event.getId());
                    if (null != eventAttendees)
                        for (int i = 0; i < eventAttendees.length; i++)
                        {   eventService.deleteAttendee(eventAttendees[i]); }
                }
                sendMail(event, attendeeList,currentUserId, "edit");

            } else {
                eventService.saveEvent(event);
                if (attendeeList != null && attendeeList.length > 0)
                {   User user = new User();
                    for (int i = 0; i < attendeeList.length; i++)
                    {
                        String expertId = attendeeList[i];
                        eventAttendee = new EventAttendee();
                        eventAttendee.setUserId(currentUserId);
                        user.setId(Long.parseLong(expertId));
                        eventAttendee.setExpertId(user);
                        eventAttendee.setAttended("N");
                        eventAttendee.setEventId(event);
                        eventService.saveAttendee(eventAttendee);

                     }
                }
                sendMail(event, attendeeList,currentUserId, "save");
            }
            //saving material
            ArrayList description=(ArrayList)session.getAttribute("description");
            ArrayList filePath=(ArrayList)session.getAttribute("filePath");
            ArrayList inputStream=(ArrayList)session.getAttribute("inputStream");
            if(filePath!=null){
            for(int i=0;i<filePath.size();i++){
                logger.debug("Filegoing in DB is "+filePath.get(i));
                EventMaterial eventMaterial=new EventMaterial();
                eventMaterial.setDescription(description.get(i).toString());
                eventMaterial.setEventId(event.getId());
                eventMaterial.setMaterialContentStream((InputStream)inputStream.get(i));
                eventMaterial.setName(filePath.get(i).toString());
                eventMaterialService.saveEventMaterial(eventMaterial);

              }
            }
            //code for deleting material
            if(session.getAttribute("deletedMaterials")!=null){
                ArrayList deletedMaterials=(ArrayList)session.getAttribute("deletedMaterials");
                EventMaterial[] deletedMatArr=(EventMaterial[])deletedMaterials.toArray(new EventMaterial[deletedMaterials.size()]);
                for(int i=0;i<deletedMatArr.length;i++){
                 eventMaterialService.deleteEventMaterial(deletedMatArr[i].getMaterialID());
                }
            }
            //session.removeAttribute("materials");
            //session.removeAttribute("eventId");
            //session.removeAttribute("deletedMaterials");
            //session.removeAttribute("INVITED_USERS");
            EventEntity e1 = (EventEntity)session.getAttribute("EVENT_DETAILS");
            User[] users = null;
            String approvers=event.getApprovers();

            users = userService.getUsers(event
                    .getInvitedol());
            session.setAttribute("INVITED_USERS", users);
            session.setAttribute("approversList", approvers);
            session.setAttribute("EVENT_DETAILS",event);
            session.setAttribute("MESSAGE", Constants.MEDICAL_MEETING_SAVE_MSG);
        } else if (ActionKeys.EDIT_EVENT.equals(action)) {
            long eventId = 0;
            if (request.getParameter("eventid") != null
                    && !"".equals(request.getParameter("eventid"))) {
                eventId = Long.parseLong(request.getParameter("eventid"));

                //we are setting as an attribute coz we will need it for retriving all the materials if required
                session.setAttribute("eventId", Long.toString(eventId));
            }
            if (eventId != 0) {
                EventEntity eventEntity = eventService.getEventbyId(eventId);
                User[] user = null;
                if (eventEntity != null && eventEntity.getInvitedol() != null
                        && !"".equals(eventEntity.getInvitedol())
                        && eventEntity.getInvitedol().length() > 0) {

                    user = userService.getUsers(eventEntity
                            .getInvitedol());
                    session.setAttribute("INVITED_USERS", user);
                }
                if(eventEntity.getApprovers()!=null){
                    String approvers=eventEntity.getApprovers();
                    session.setAttribute("approversList", approvers);
                }
                session.setAttribute("EVENT_DETAILS", eventEntity);

            }

        } else if(ActionKeys.KOL_ADD_EXPERTS.equalsIgnoreCase(action)){
            session.removeAttribute("fromPage");
            session.removeAttribute("flagCheck");
            //System.out.println("length of attendee list" + attendeeList.length);

             if (null != request.getParameter("fromEvents")){
              fromEvents = request.getParameter("fromEvents");
              session.setAttribute("fromEvents",fromEvents);
            }

             String[] ids = null;
             if (null != request.getParameterValues("checkIds")){
                 ids = request.getParameterValues("checkIds");
             }
             Set finalList = new HashSet();
             if(session.getAttribute("INVITED_USERS")!=null){

                 User user[] = (User [])session.getAttribute("INVITED_USERS");
                 for(int i=0;i<user.length;i++){
                     finalList.add(user[i]);
                 }

             }
             if(session.getAttribute("attendees") != null)
             {
            	 String[] attendeeList = (String[])session.getAttribute("attendees");
            	 if (attendeeList != null && attendeeList.length > 0) {
	                    for (int i = 0; i < attendeeList.length; i++) {
	                        String expertId = attendeeList[i];
	                        User user = userService.getUser(Long.parseLong(expertId));
	                        finalList.add(user);
	                    }
	             }
            	 session.removeAttribute("attendees");
             }
             if (null != ids) {
                   User user[] = new User[ids.length];
                   for (int i = 0; i < ids.length; i++) {
                       if (null != ids[i]) {
                           user[i] = userService.getUser(Long.parseLong(ids[i]));
                           finalList.add(user[i]);

                       }
                   }

             }
             if(finalList.size()>0){
                 User user[]=new User[finalList.size()];
                 Iterator itr = finalList.iterator();
                 int i=0;
                 while(itr.hasNext()){
                     user[i] = (User)itr.next();
                     i++;
                 }
                 session.setAttribute("INVITED_USERS",user);
                 session.removeAttribute("fromEvents");
               }


           }else if (ActionKeys.DELETE_EVENT.equals(action)) {
            long eventId = 0;
            if (request.getParameter("eventid") != null
                    && !"".equals(request.getParameter("eventid"))) {
                eventId = Long.parseLong(request.getParameter("eventid"));
            }
            if (eventId != 0) {
                eventService.deleteAttendeeByEventId(eventId);
                eventService.deleteEventByEventId(eventId);
            }
            String lastSearchedEvents[];
            StringBuffer searchedEventIds = new StringBuffer("-1");
            if (request.getParameterValues("eventIds") != null) {
                lastSearchedEvents = request.getParameterValues("eventIds");
                if (lastSearchedEvents != null && lastSearchedEvents.length > 0) {
                    for (int i = 0; i < lastSearchedEvents.length; i++) {
                        if (lastSearchedEvents[i] != null && !"".equals(lastSearchedEvents[i])
                                && Long.parseLong(lastSearchedEvents[i]) != eventId) {
                                searchedEventIds.append(", ").append(lastSearchedEvents[i]);
                        }
                    }
                }
            }
            session.setAttribute("EVENT_SEARCH_RESULTS", eventService
                        .getEvents(searchedEventIds.toString()));

            StringBuffer eventsListBuffer = new StringBuffer("-1");
            if (session.getAttribute("EVENT_LIST_RESULTS") != null) {
                EventEntity [] eventList = (EventEntity []) session.getAttribute("EVENT_LIST_RESULTS");
                if (eventList != null && eventList.length > 0) {
                    for (int i = 0; i < eventList.length; i++) {
                        if (eventList[i] != null && !"".equals(eventList[i])
                                && eventList[i].getId() != eventId) {
                            eventsListBuffer.append(", ").append(eventList[i].getId());
                        }
                    }
                }
            }
            session.setAttribute("EVENT_LIST_RESULTS", eventService
                    .getEvents(eventsListBuffer.toString()));
           
            return new ModelAndView("event_search");
        }
        ModelAndView mav = new ModelAndView("event_add");
        return mav;

    }

    IOptionServiceWrapper optionServiceWrapper;

    IEventService eventService;

    IUserService userService;

    public IEventMaterialService eventMaterialService;

    public IEventMaterialService getEventMaterialService() {
        return eventMaterialService;
    }

    public void setEventMaterialService(IEventMaterialService eventMaterialService) {
        this.eventMaterialService = eventMaterialService;
    }

    public IUserService getUserService() {
        return userService;
    }

    public void setUserService(IUserService userService) {
        this.userService = userService;
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

    private EventEntity getEventDTO(HttpServletRequest request,
                                    long currentUserId,long userGroupId) throws Exception {
    	EventEntity event = new EventEntity();
        event.setUserid(currentUserId);
        if (request.getParameter("eventTitle") != null
                && !"".equals(request.getParameter("eventTitle"))) {
            String title = request.getParameter("eventTitle");
            if (title != null && title.length() > 0) {
                title = title.trim();
                event.setTitle(title.replaceAll("\"", "''"));
            }
        }

        if (request.getParameter("eventDate") != null
                && !"".equals(request.getParameter("eventDate"))) {
            SimpleDateFormat sdf = new SimpleDateFormat(
                    ActionKeys.CALENDAR_DATE_FORMAT);
            event.setEventdate(sdf.parse(request.getParameter("eventDate")));
        }
        if (request.getParameter("eventCity") != null
                && !"".equals(request.getParameter("eventCity"))) {
            event.setCity(request.getParameter("eventCity"));

        }
        if (request.getParameter("eventState") != null
                && !"".equals(request.getParameter("eventState"))) {
            
            long lookupId = Long.parseLong(request.getParameter("eventState"));
            OptionLookup stateLookup = optionServiceWrapper.getValuesForId(lookupId, userGroupId);
            event.setState(stateLookup);
       }

        if (request.getParameter("eventCountry") != null
                && !"".equals(request.getParameter("eventCountry"))) {
            
            long lookupId = Long.parseLong(request.getParameter("eventCountry"));
            OptionLookup countryLookup = optionServiceWrapper.getValuesForId(lookupId, userGroupId);
            event.setCountry(countryLookup);
       }
        if (request.getParameter("startHrs") != null
                && !"".equals(request.getParameter("startHrs"))) {
            event.setStartTime(request.getParameter("startHrs"));
        }

        if (request.getParameter("endHrs") != null
                && !"".equals(request.getParameter("endHrs"))) {
            event.setEndTime(request.getParameter("endHrs"));
        }

        if (request.getParameter("eventType") != null
                && !"".equals(request.getParameter("eventType"))) {

            long lookupId = Long.parseLong(request.getParameter("eventType"));
            OptionLookup typeLookup = optionServiceWrapper.getValuesForId(lookupId, userGroupId);
            event.setEvent_type(typeLookup);

        }
        if (request.getParameter("eventOwner") != null
                && !"".equals(request.getParameter("eventOwner"))) {
            event.setOwner(request.getParameter("eventOwner"));
        }
        if (request.getParameter("eventTa") != null
                && !"".equals(request.getParameter("eventTa"))) {

            long lookupId = Long.parseLong(request.getParameter("eventTa"));
            OptionLookup TALookup = optionServiceWrapper.getValuesForId(lookupId, userGroupId);
            event.setTa(TALookup);

        }
        if (request.getParameter("eventTherapyId") != null
                && !"".equals(request.getParameter("eventTherapyId"))) {

            long lookupId = Long.parseLong(request.getParameter("eventTherapyId"));
            OptionLookup therapyLookup = optionServiceWrapper.getValuesForId(lookupId, userGroupId);
            event.setTherapy(therapyLookup);
       }
        if(request.getParameter("approvalDate") != null &&
                !"".equals(request.getParameter("approvalDate"))) {
            SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
            event.setApprovaldate(sdf.parse(request.getParameter("approvalDate")));

        }

        if(request.getParameter("endDate") != null &&
                !"".equals(request.getParameter("endDate"))) {
            SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
            event.setEndDate(sdf.parse(request.getParameter("endDate")));

        }

        if(request.getParameter("fundingAmount") != null &&
                !"".equals(request.getParameter("fundingAmount"))) {
            event.setFundingAmount(request.getParameter("fundingAmount"));

        }

        if(request.getParameter("status") != null &&
                !"".equals(request.getParameter("status"))) {
            event.setStatus(request.getParameter("status"));

        }
        if(request.getParameter("reviewDate") != null &&
                !"".equals(request.getParameter("reviewDate"))) {
            SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
            event.setReviewdate(sdf.parse(request.getParameter("reviewDate")));

        }
        if (request.getParameter("eventDescription") != null
                && !"".equals(request.getParameter("eventDescription"))) {
            event.setDescription((request.getParameter("eventDescription")).trim().replaceAll("\"", "''"));

        }
        if (request.getParameterValues("invitedOl") != null
                && !"".equals(request.getParameterValues("invitedOl"))) {
            String invitedOls[] = request.getParameterValues("invitedOl");
            StringBuffer invitedOlBuff = new StringBuffer();
            if (invitedOls != null && invitedOls.length > 0) {
                for (int i = 0; i < invitedOls.length; i++) {
                    if (i == 0) {
                        invitedOlBuff.append(invitedOls[i]);
                    } else {
                        invitedOlBuff.append(", ").append(invitedOls[i]);
                    }
                }
            }
            event.setInvitedol(invitedOlBuff.toString());
        }
        if(request.getParameterValues("approvers") != null &&
                !"".equals(request.getParameterValues("approvers"))) {
            String approvers[] = request.getParameterValues("approvers");
            StringBuffer approversBuff = new StringBuffer();
            if(approvers != null && approvers.length>0) {
                for(int i=0;i<approvers.length;i++) {
                    if(i==0) {
                        approversBuff.append(approvers[i]);
                    } else {
                        approversBuff.append("@").append(approvers[i]);
                    }
                }
            }
            event.setApprovers(approversBuff.toString());
        }
        if (null != request.getParameter("staffId")
                && !"".equals(request.getParameter("staffId"))) {
            event.setStaffids(request.getParameter("staffId"));
        }
        event.setCreatetime(new Date(System.currentTimeMillis()));
        event.setUpdatetime(new Date(System.currentTimeMillis()));
        event.setDeleteflag("N");

        return event;
}

    private void sendMail(EventEntity event, String[] attendeeList, long currentUserId, String mode)
    {
        EventNotificationEmail email = new EventNotificationEmail();
        EventNotificationEMailForContact emailForContact = new EventNotificationEMailForContact();
        String therapy = "";
        if( event.getTherapy() != null ){
            therapy = event.getTherapy().getOptValue();
        }
        emailForContact.event = event;
        email.event = event;
        emailForContact.eventOwner = event.getOwner();
        emailForContact.eventType = event.getEvent_type().getOptValue();
        emailForContact.eventName = event.getTitle();
        email.eventName = event.getTitle();
        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
        email.eventDate = sdf.format(event.getEventdate());
        emailForContact.eventDate = sdf.format(event.getEventdate());
        email.description = (event.getDescription() == null ? "N.A." : event.getDescription());
        email.activity = "Speaker";
        email.therapy = therapy;
        emailForContact.therapy = therapy;
        emailForContact.therapeuticArea = therapy;
        emailForContact.city = event.getCity();
        emailForContact.state = event.getState().getOptValue();
        email.status = "Pending";
        for (int i = 0; attendeeList != null && i < attendeeList.length; i++)
        {
            String expertId = attendeeList[i];

            String contactName = sendMailToContact(Long.parseLong(expertId), emailForContact, event.getId(), mode);
           /* if ( contactName == null ) contactName = event.getOwner();
            System.out.println(" kol contact name is " + contactName);
            sendMailToAttendee(Long.parseLong(expertId), email, event.getId(), mode, contactName);
            */
        }
    }

    public void sendMailToAttendee(long kolIds, EventNotificationEmail email,long eventId, String mode, String contactName) {
        if (kolIds != 0)
        {
            EventNotificationMailSender eventNotificationMailSender = EventNotificationMailSender.getInstance();
            User u = userService.getUser(kolIds);
            email.kolName = u.getFirstName() + " " + u.getLastName();
            email.attendeeId = eventService.getAttendee(eventId, kolIds).getId();
            email.contactName = contactName;
            String htmlString = email.returnCompleteHTMLString();
            if ( mode.equals("save"))
                eventNotificationMailSender.setSubject(eventNotificationMailSender.getSubject() + ": New Event");
            else
                eventNotificationMailSender.setSubject(eventNotificationMailSender.getSubject() + ": Update Event");

            eventNotificationMailSender.send(htmlString);
        }
    }

    public String sendMailToContact(long kolIds, EventNotificationEMailForContact emailForContact, long eventId, String mode)
    {
        String contactName = null;
        if (kolIds != 0 )
        {
            User u = userService.getUser(kolIds);
            emailForContact.kolName = u.getFirstName() + " " + u.getLastName();
            emailForContact.kolPhotoName = "Photo_" + u.getFirstName() + "_" + u.getLastName() + ".jpg";
            User[] contacts = userService.getContactForKol(kolIds);

            for(int j = 0; contacts != null && j < contacts.length; j++)
            {

                EventNotificationMailSender eventNotificationMailSender = EventNotificationMailSender.getInstance();
                if ( mode.equals("save"))
                    eventNotificationMailSender.setSubject(eventNotificationMailSender.getSubject() + ": New Event");
                else
                    eventNotificationMailSender.setSubject(eventNotificationMailSender.getSubject() + ": Update Event");

                User contact = contacts[j];

                emailForContact.contactName =  contact.getLastName() + ", " + contact.getFirstName();
                eventNotificationMailSender.setTo(contact.getEmail());
                String htmlString = emailForContact.returnCompleteHTMLString();
                eventNotificationMailSender.send(htmlString);
                contactName =  emailForContact.contactName;
            }
        }
        return contactName;
    }


}
