package com.openq.web.controllers;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import com.openq.attendee.Attendee;
import com.openq.attendee.IAttendeeService;
import com.openq.audit.IDataAuditService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.org.IOrganizationService;
import com.openq.eav.org.Organization;
import com.openq.event.EventEntity;
import com.openq.event.IEventService;
import com.openq.interaction.IInteractionService;
import com.openq.interaction.Interaction;
import com.openq.interactionData.IInteractionDataService;
import com.openq.interactionData.InteractionData;
import com.openq.interactionData.UserRelationship;
import com.openq.kol.KOLManager;
import com.openq.kol.ManagerException;
import com.openq.survey.ISurveyService;
import com.openq.survey.NewSurvey;
import com.openq.user.IUserService;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;
import com.openq.web.forms.InteractionForm;

public class KolInteractionController extends SimpleFormController {
	IOptionServiceWrapper optionServiceWrapper;
	ISurveyService surveyService;
	IEventService eventService;
	OptionLookup[] plannedInteraction = null;
    IDataAuditService dataAuditService;

    public ISurveyService getSurveyService() {
    return surveyService;
  }

  public void setSurveyService(ISurveyService surveyService) {
    this.surveyService = surveyService;
  }

  public IOptionServiceWrapper getOptionServiceWrapper() {
		return optionServiceWrapper;
	}

	public void setOptionServiceWrapper(
			IOptionServiceWrapper optionServiceWrapper) {
		this.optionServiceWrapper = optionServiceWrapper;
	}
	private static final String DELIMITER_TO_SEPARATE_VALUES = Constants.DELIMITER_TO_SEPARATE_VALUES;
	private static final String DELIMITER_TO_SEPARATE_SUBVALUES = Constants.DELIMITER_TO_SEPARATE_SUBVALUES;
	
	protected ModelAndView processFormSubmission(HttpServletRequest request,
			HttpServletResponse response, Object object, BindException exception)
			throws Exception {

		HttpSession session = request.getSession();
		session.setAttribute("kolIntUserService", userService);

	    String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
		 
		 long userType=-1;
		    OptionLookup userTypeLookup = (OptionLookup)session.getAttribute(Constants.USER_TYPE);
		    if(null!=userTypeLookup){
		    	userType = userTypeLookup.getId();
		    }
		
		String action = (String) request.getParameter("action");
		String resetIntForm = (String)request.getParameter("resetInteractionForm");
		long currentUserId = 0;
		if(session.getAttribute(Constants.USER_ID) != null){
			currentUserId = Long.parseLong((String) session
					.getAttribute(Constants.USER_ID));
		}
		long currentStaffId = 0;
		if (null != session.getAttribute(Constants.CURRENT_STAFF_ID)
				&& session.getAttribute(Constants.CURRENT_STAFF_ID).toString()
						.trim().length() > 0) {
			currentStaffId = Long.parseLong(((String) session
					.getAttribute(Constants.CURRENT_STAFF_ID)).trim());
		}

		String tafaregion = null != request.getSession().getAttribute(
				"TA_Fa_Region") ? (String) request.getSession().getAttribute(
				"TA_Fa_Region") : null;
    
     if(session.getAttribute("ALL_SURVEYS")==null)
     { 
      NewSurvey[] totalSurveys = surveyService.getAllLaunchedSurveysByType(userGroupId, userType,Constants.SURVEY_TYPE_INTERACTIONS);
      session.setAttribute("ALL_SURVEYS", totalSurveys);
     }
     session.removeAttribute("relatedEventEntity");
     session.removeAttribute("SURVEY_EXPERTS");
     session.removeAttribute("ATTENDEES_MAP");
     String resetEvent = request.getParameter("resetEvent")!=null?(String)request.getParameter("resetEvent"):"false";
     if (ActionKeys.SHOW_ADD_INTERACTION.equalsIgnoreCase(action)
				|| ActionKeys.PROFILE_SHOW_ADD_INTERACTION
						.equalsIgnoreCase(action)) {
			plannedInteraction = getPlannedInteractions(Long.toString(currentUserId));
			session.setAttribute("PRODUCTS", getValuesForOptionAndUser("PRODUCT", currentUserId, userGroupId));
			session.setAttribute("PLANNED_INTERACTION", plannedInteraction);
			session.removeAttribute("relatedEventEntity");
			session.removeAttribute("SURVEY_EXPERTS");
			session.removeAttribute("ATTENDEES_MAP");
			request.setAttribute("ACTION", action);
			
	if (ActionKeys.PROFILE_SHOW_ADD_INTERACTION
					.equalsIgnoreCase(action)) {
		if(resetIntForm!=null&&resetIntForm.equalsIgnoreCase("true"))
	    	resetInteractionForm(request);		
		return new ModelAndView("add_interaction_main");
			}

		} else if (ActionKeys.ADD_INTERACTION.equalsIgnoreCase(action)
				|| ActionKeys.PROFILE_ADD_INTERACTION.equalsIgnoreCase(action)) {
			InteractionForm interactionForm = (InteractionForm) object;
			Interaction interaction = setInteractionDTO(currentUserId,
					currentStaffId, interactionForm, tafaregion, userGroupId);
			// Tagging Information to support report development starts
			// userid and therapeautic area id are already set above
			
			UserRelationship currentUserRelationship = (UserRelationship) session.getAttribute(Constants.CURRENT_USER_RELATIONSHIP);
			if(currentUserRelationship != null){
				long supervisorId = 0;
				if (currentUserRelationship.getSupervisorId() != null) {
					supervisorId = Long.parseLong(currentUserRelationship.getSupervisorId());
					interaction.setSupervisorId(supervisorId);
				}
				long groupId = 0;
				if (session.getAttribute(Constants.CURRENT_USER_GROUP) != null) {
					groupId = Long.parseLong((String) session
							.getAttribute(Constants.CURRENT_USER_GROUP));
					interaction.setGroupId(groupId);
				}
				long territoryId = 0;
				if (currentUserRelationship.getTerritory() != null) {
					territoryId = Long.parseLong(currentUserRelationship.getTerritory());
					interaction.setTerritoryId(territoryId);
				}
				long reportLevelId = 0;
				if (currentUserRelationship.getReportLevel() != null) {
					reportLevelId = Long.parseLong(currentUserRelationship.getReportLevel());
					interaction.setReportLevelId(reportLevelId);
				}
			}
			// Tagging Information to support report development ends
			
			interactionService.saveInteraction(interaction);
			// saveOrUpdateInteractionData for new sections
			saveOrUpdateInteractionData(interactionForm, interaction, action);

			// add all attendees (kols + others)
			String[] attendeeList = request.getParameterValues("attendeeList");
			Attendee attendee = new Attendee();
			String userId = "";
			if(attendeeList != null && attendeeList.length>0)
			{
			for (int i = 0; i < attendeeList.length; i++) {

				// OL
				if (attendeeList[i].startsWith("kol_")) {
					attendee = new Attendee();
					attendee.setAttendeeType(Attendee.KOL_ATTENDEE_TYPE);
					userId = attendeeList[i].split("_")[1];
					attendee.setUserId(Long.parseLong(userId));
					attendee.setName(attendeeList[i].split("_")[2]);
				}

				// ORX
				if (attendeeList[i].startsWith("orx_")) {
					attendee = new Attendee();
					attendee.setAttendeeType(Attendee.ORX_ATTENDEE_TYPE);
					userId = attendeeList[i].split("_")[1];
					attendee.setName(attendeeList[i].split("_")[2]);
				}

				// Employee
				if (attendeeList[i].startsWith("emp_")) {
					attendee = new Attendee();
					attendee.setAttendeeType(Attendee.EMPLOYEE_ATTENDEE_TYPE);
					userId = attendeeList[i].split("_")[1];
					attendee.setUserId(Long.parseLong(userId));
					attendee.setName(attendeeList[i].split("_")[2]);
				}

				// Other input format to this if condition is
				// otr_firstName_lastName(type)(ta)(title)(state)(city)(zip)
				if (attendeeList[i].startsWith("otr_")) {
					attendee = new Attendee();
					attendee.setAttendeeType(Attendee.OTHER_ATTENDEE_TYPE);
					int firstbraceIndex = attendeeList[i].indexOf("(", 4);
					attendee.setName(attendeeList[i].substring(4,
							firstbraceIndex));
				}

				// Org
				if (attendeeList[i].startsWith("org_")) {
					attendee = new Attendee();
					attendee.setAttendeeType(Attendee.ORG_ATTENDEE_TYPE);
					userId = attendeeList[i].split("_")[1];
					attendee.setUserId(Long.parseLong(userId));
					attendee.setName(attendeeList[i].split("_")[2]);
				}

				attendee.setInteraction(interaction);
				attendeeService.saveAttendee(attendee);
			}
			}
			Attendee[] attendeeList1 = attendeeService
					.getAllAttendees(interaction.getId());
			Set attendees = new HashSet();
			if (attendeeList1 != null && attendeeList1.length > 0) {
				for (int i = 0; i < attendeeList1.length; i++) {
					attendees.add(attendeeList1[i]);
				}
			}

			interaction.setAttendees(attendees);
			Set interactionSet = new HashSet();

//			add Attendee Type Informarion
			createInteractionDataObjectsSetFromTextBoxForAttendeeInformation(request,"attendeeInfo", Constants.INTERACTION_ATTENDEE_TYPE, interaction,interactionSet, userGroupId);
//			add Event Information
			createInteractionDataObjectsSetFromTextBoxForEventInformation(request,"eventId","eventVenue", Constants.INTERACTION_RELATED_EVENTS, interaction,interactionSet, userGroupId);

			// Add data of new sections
			addDataForSections(interaction, interactionSet);

      if(session.getAttribute("SURVEY_FOR_INERACTION")!=null)
      {
         Map surveyDetails = (Map)session.getAttribute("SURVEY_FOR_INERACTION");   
        if(surveyDetails!=null)
        {
          surveyDetails.put("interactionId",interaction.getId()+"");
        }
       surveyService.saveSurvey(surveyDetails);  
       session.removeAttribute("SURVEY_FOR_INERACTION");
      }
      session.setAttribute("INTERACTION_DETAILS", interaction);
      
      //for related events added recently
      
      InteractionData[] interactionDataListForType = interactionDataService.getAllDataOnType(interaction.getId(), Constants.INTERACTION_RELATED_EVENTS);
      if (null != interactionDataListForType && interactionDataListForType.length > 0){
	        for (int i = 0; i < interactionDataListForType.length; i++) {
		       interactionSet.add(interactionDataListForType[i]);
	        }
	        interaction.setInteractionData(interactionSet);
	        String eventId = interactionDataListForType[0].getData();
      if(eventId!=null&&!eventId.trim().equals("")&&resetEvent.equalsIgnoreCase("false"))
      {
	        EventEntity e = eventService.getEventbyId(Long.parseLong(eventId));
	        session.setAttribute("relatedEventEntity", e);	
      }
      else
    	  session.removeAttribute("relatedEventEntity");
      }
      //The above block is added for the related Events
      
		if(interactionForm!=null)
		{
			if(interactionForm.getSurveyAnswersFilled()!=null)
			{
				String keyVal = interactionForm.getSurveyAnswersFilled();
				surveyService.saveFilledSurveys(interaction.getId()+"",keyVal, userGroupId,interaction.getUserId(),interaction.getInteractionDate(),interaction.getUpdateTime());
			}
			String editSurveyAnswers = interactionForm.getSurveyEditAnswersFilled();
			if(editSurveyAnswers!=null&&!editSurveyAnswers.trim().equals(""))
            {
            	java.util.Date surveyCreateDate = surveyService.deleteFilledSurvey(interaction.getId());
            	java.util.Date surveyUpdateDate = new Date(System.currentTimeMillis());
            	surveyService.editFilledSurveys(interaction.getId()+"", editSurveyAnswers,userGroupId,interaction.getUserId(),surveyCreateDate,surveyUpdateDate);
            }
		}	
      //Set the survey data which has been added for save and continue interaction
		Map surveyExpertIds = surveyService.surveyIdsAndExpertIds(interaction.getId(), userGroupId);
		if(surveyExpertIds!=null)
		{
			session.setAttribute("SURVEY_EXPERTS", surveyExpertIds);
			   Map attendeesMap = new HashMap();  
		for(int j=0;j<attendeeList.length;j++)
		   {
			if (attendeeList[j].startsWith("kol_")) {
				attendee = new Attendee();
				attendee.setAttendeeType(Attendee.KOL_ATTENDEE_TYPE);
				userId = attendeeList[j].split("_")[1];
				attendee.setUserId(Long.parseLong(userId));
				attendee.setName(attendeeList[j].split("_")[2]);
				   if(attendee.getAttendeeType()==Attendee.KOL_ATTENDEE_TYPE)
				   {
					   attendeesMap.put(attendee.getUserId()+"", attendee.getName());
				     logger.debug("Adding in attendee Map"+attendee.getUserId()+":"+
				    		  attendee.getName());
				   }  
			 }   
		  }
	    session.setAttribute("ATTENDEES_MAP", attendeesMap);
		}
      		session.setAttribute("MESSAGE",
					"Interaction details saved successfully");

			if (ActionKeys.PROFILE_ADD_INTERACTION.equalsIgnoreCase(action)) {
				if(resetIntForm!=null&&resetIntForm.equalsIgnoreCase("true"))
			    	resetInteractionForm(request);
				return new ModelAndView("add_interaction_main");
			}

			
			
		} else if (ActionKeys.EDIT_INTERACTION.equalsIgnoreCase(action)
		        || ActionKeys.PROFILE_SHOW_EDIT_INTERACTION
		        .equalsIgnoreCase(action)) {

		    long interactionId = Long.parseLong(request
		            .getParameter("interactionId"));
		    Interaction interaction = interactionService
		    .getInteraction(interactionId);

		    Attendee[] attendeeList = attendeeService
		    .getAllAttendees(interactionId);
		    Set attendees = new HashSet();
		    List attendeeIdList = new ArrayList();
		    for (int i = 0; i < attendeeList.length; i++) {
		        attendees.add(attendeeList[i]);
		        attendeeIdList.add(attendeeList[i].getId() + "");
		    }
		    interaction.setAttendees(attendees);
		    Set interactionSet = new HashSet();
		    addObjectsToInteractionDataSet(interaction,
		            Constants.INTERACTION_ATTENDEE_TYPE, interactionSet);

		    // Add data of new sections
		    addDataForSections(interaction, interactionSet);
		    InteractionData[] interactionDataListForType = interactionDataService
		    .getAllDataOnType(interaction.getId(),
		            Constants.INTERACTION_RELATED_EVENTS);
		    if (null != interactionDataListForType
		            && interactionDataListForType.length > 0) {
		        for (int i = 0; i < interactionDataListForType.length; i++) {
		            interactionSet.add(interactionDataListForType[i]);
		        }
		        interaction.setInteractionData(interactionSet);
		        String eventId = interactionDataListForType[0].getData();
		        if (eventId != null && !eventId.trim().equals("")
		                && resetEvent.equalsIgnoreCase("false")) {
		            EventEntity e = eventService.getEventbyId(Long
		                    .parseLong(eventId));
		            session.setAttribute("relatedEventEntity", e);

		        } else{
		            session.removeAttribute("relatedEventEntity");
		        }
		    }

		    session.setAttribute("INTERACTION_DETAILS", interaction);

		    String mode = request.getParameter("mode");
		    session.setAttribute("MODE", mode);
		    Map surveyExpertIds = surveyService.surveyIdsAndExpertIds(
		            interactionId, userGroupId);
		    if (surveyExpertIds != null) {
		        session.setAttribute("SURVEY_EXPERTS", surveyExpertIds);
		        Map attendeesMap = new HashMap();
		        for (int j = 0; j < attendeeList.length; j++) {
		            Attendee individualAttendee = attendeeList[j];

		            if (individualAttendee.getAttendeeType() == Attendee.KOL_ATTENDEE_TYPE) {
		                attendeesMap.put(individualAttendee.getUserId() + "",
		                        individualAttendee.getName());
		                logger.debug("Adding in attendee Map"
		                        + individualAttendee.getUserId() + ":"
		                        + individualAttendee.getName());
		            }
		        }
		        session.setAttribute("ATTENDEES_MAP", attendeesMap);
		    }
		    if (ActionKeys.PROFILE_SHOW_EDIT_INTERACTION
		            .equalsIgnoreCase(action)) {
		        if (resetIntForm != null
		                && resetIntForm.equalsIgnoreCase("true"))
		            resetInteractionForm(request);
		        return new ModelAndView("add_interaction_main");
		    }

		} else if (ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
				|| ActionKeys.PROFILE_UPDATE_INTERACTION
						.equalsIgnoreCase(action)) {
			// update interaction
			InteractionForm interactionForm = (InteractionForm) object;
			Interaction interaction = setInteractionDTO(currentUserId,
					currentStaffId, interactionForm, tafaregion, userGroupId);
			if(session.getAttribute("CREATE_TIME")!=null){					        
				interaction.setCreateTime((Date)session.getAttribute("CREATE_TIME"));
				session.removeAttribute("CREATE_TIME");
			}
		
			interactionService.updateInteraction(interaction);
	        // saveOrUpdateInteractionData for new sections 
	        saveOrUpdateInteractionData(interactionForm, interaction, action);
			String editSurveyAnswers = interactionForm.getSurveyEditAnswersFilled();

			Map surveyAttendeesMap = new HashMap();
			// update all attendees (kols + others)
			String[] attendeeList = request.getParameterValues("attendeeList");
			if(attendeeList != null && attendeeList.length > 0)
			{
			Attendee[] attendeeSet = new Attendee[attendeeList.length];
			Attendee attendee = new Attendee();
			String userId = "";

			for (int i = 0; i < attendeeList.length; i++) {

				// OL
				if (attendeeList[i].startsWith("kol_")) {
					attendee = new Attendee();
					attendee.setAttendeeType(Attendee.KOL_ATTENDEE_TYPE);
					userId = attendeeList[i].split("_")[1];
					attendee.setUserId(Long.parseLong(userId));
					attendee.setName(attendeeList[i].split("_")[2]);
					// set attendee map for the surveys
					surveyAttendeesMap.put(userId, attendee.getName());
				}

				// ORX
				if (attendeeList[i].startsWith("orx_")) {
					attendee = new Attendee();
					attendee.setAttendeeType(Attendee.ORX_ATTENDEE_TYPE);
					userId = attendeeList[i].split("_")[1];
					attendee.setName(attendeeList[i].split("_")[2]);
				}

				// Employee
				if (attendeeList[i].startsWith("emp_")) {
					attendee = new Attendee();
					attendee.setAttendeeType(Attendee.EMPLOYEE_ATTENDEE_TYPE);
					userId = attendeeList[i].split("_")[1];
					attendee.setUserId(Long.parseLong(userId));
					attendee.setName(attendeeList[i].split("_")[2]);
				}

				// Other input format to this if condition is
				// otr_firstName_lastName(type)(ta)(title)(state)(city)(zip)
				if (attendeeList[i].startsWith("otr_")) {
					attendee = new Attendee();
					attendee.setAttendeeType(Attendee.OTHER_ATTENDEE_TYPE);
					int firstbraceIndex = attendeeList[i].indexOf("(", 4);
					attendee.setName(attendeeList[i].substring(4,
							firstbraceIndex));
				}

				// Org
				if (attendeeList[i].startsWith("org_")) {
					attendee = new Attendee();
					attendee.setAttendeeType(Attendee.ORG_ATTENDEE_TYPE);
					userId = attendeeList[i].split("_")[1];
					attendee.setUserId(Long.parseLong(userId));
					attendee.setName(attendeeList[i].split("_")[2]);
				}

				attendee.setInteraction(interaction);
				attendeeSet[i] = attendee;

			}
			attendeeService.updateAttendees(interaction.getId(), attendeeSet);
			// set attendee map for surveys ion session
			session.setAttribute("ATTENDEES_MAP", surveyAttendeesMap);
			}
			else
			{
				attendeeService.deleteAttendees(interaction.getId());
			}
			
			
			interaction = interactionService
					.getInteraction(interaction.getId());

			Attendee[] attendeeSet = attendeeService.getAllAttendees(interaction.getId());
			Set attendees = new HashSet();
			for (int i = 0; i < attendeeSet.length; i++) {
				attendees.add(attendeeSet[i]);
			}

			interaction.setAttendees(attendees);
			
			Set interactionSet = new HashSet();
		
			updateInteractionDataObjectsSetFromTextBoxForAttendee(request, "attendeeInfo", Constants.INTERACTION_ATTENDEE_TYPE, interaction, interactionSet, userGroupId);
			updateInteractionDataObjectsSetFromTextBoxForEvents(request, "eventId","eventVenue",Constants.INTERACTION_RELATED_EVENTS, interaction, interactionSet);

			// Add data of new sections
			addDataForSections(interaction, interactionSet);

			//This is added for the Related Events: Recently added
			
			InteractionData[] interactionDataListForType = interactionDataService.getAllDataOnType(interaction.getId(), Constants.INTERACTION_RELATED_EVENTS);
	        if (null != interactionDataListForType && interactionDataListForType.length > 0){
		        for (int i = 0; i < interactionDataListForType.length; i++) {
			       interactionSet.add(interactionDataListForType[i]);
		        }
		        interaction.setInteractionData(interactionSet);
		        String eventId = interactionDataListForType[0].getData();
            if(eventId!=null&&!eventId.trim().equals("")&&resetEvent.equalsIgnoreCase("false"))
            {
		        EventEntity e = eventService.getEventbyId(Long.parseLong(eventId));
		        session.setAttribute("relatedEventEntity", e);	
            }
            else
            	session.removeAttribute("relatedEventEntity");
	       }
			session.setAttribute("MESSAGE","Interaction details updated successfully");
			session.setAttribute("INTERACTION_DETAILS", interaction);
	        if(interactionForm!=null)
			{
				if(interactionForm.getSurveyAnswersFilled()!=null)
				{
					String keyVal = interactionForm.getSurveyAnswersFilled();
					surveyService.saveFilledSurveys(interaction.getId()+"",keyVal, userGroupId,interaction.getUserId(),interaction.getInteractionDate(),interaction.getUpdateTime());
				}
			}
	        if(editSurveyAnswers!=null&&!editSurveyAnswers.trim().equals(""))
            {
	        	java.util.Date surveyCreateDate = surveyService.deleteFilledSurvey(interaction.getId());
            	java.util.Date surveyUpdateDate = new Date(System.currentTimeMillis());
	        	surveyService.editFilledSurveys(interaction.getId()+"", editSurveyAnswers,userGroupId,interaction.getUserId(),surveyCreateDate,surveyUpdateDate);
            }
			
			// setting survey related data in the session 
			Map surveyExpertIds = surveyService.surveyIdsAndExpertIds(
					interaction.getId(), userGroupId);

			session.setAttribute("SURVEY_EXPERTS", surveyExpertIds);
			
			if (ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action)) {
				if(resetIntForm!=null&&resetIntForm.equalsIgnoreCase("true"))
		        	resetInteractionForm(request);
				return new ModelAndView("add_interaction_main");
			}
		} else if (ActionKeys.DELETE_INTERACTION.equalsIgnoreCase(action)) {

			long interactionId = 0;
			if (request.getParameter("interactionId") != null) {
				interactionId = Long.parseLong((String) request
						.getParameter("interactionId"));
			}
			Interaction interaction = interactionService
					.getInteraction(interactionId);
			interaction.setDeleteFlag("Y");
			interaction.setUpdateTime(new Date(System.currentTimeMillis()));
            surveyService.deleteFilledSurvey(interaction.getId());
			interactionService.deleteInteraction(interaction);

			String from = "";
			if (request.getParameter("from") != null) {
				from = request.getParameter("from");
			}

			if ("olProfile".equalsIgnoreCase(from)) {

				String kolId = (String) session
						.getAttribute(Constants.CURRENT_KOL_ID);
				if (null != kolId && !"".equals(kolId)) {
				    List interactionSearchResults = interactionService.getAllInteractionsByExpertId(Long.parseLong(kolId));
				    request.setAttribute("KOL_INTERACTIONS", interactionSearchResults);
				}
				return new ModelAndView("kol_interactions");
			} else {
				
				// Handle Deletion of an Interaction
				ModelAndView mav = new ModelAndView("search_interaction_main");
				SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
		        Map interactionSearchParameters =  (Map) session.getAttribute("INTERACTION_SEARCH_PARAMETER_MAP");
		        if( interactionSearchParameters != null ){
		            Date fromDate = null;
		            if( !"".equals(interactionSearchParameters.get("fromDate"))){
		                fromDate = sdf.parse( (String) interactionSearchParameters.get("fromDate") );
		            }
		            Date toDate = null; 
                    if( !"".equals(interactionSearchParameters.get("toDate"))){
                        toDate = sdf.parse( (String) interactionSearchParameters.get("toDate") );
                    }
		            String kolName = (String) interactionSearchParameters.get("kolName");
	                String searchUserId = (String) interactionSearchParameters.get("searchUserId");
	                String productSelectedId = (String) interactionSearchParameters.get("productSelectedId");
	                boolean isSAXAJVUser = ((Boolean) interactionSearchParameters.get("isSAXAJVUser")).booleanValue();
	                long selectedUserID = searchUserId != null ? Long.parseLong(searchUserId) : 0;
	                long selectedProductId = productSelectedId != null ? Long.parseLong(productSelectedId) : 0;
	                List interactionSearchResultsList = interactionService
	                        .getInteractionResultsList(fromDate, toDate,
	                                selectedUserID, kolName, selectedProductId, isSAXAJVUser, 0);
	                
	                session.setAttribute("INTERACTION_SEARCH_RESULT", interactionSearchResultsList);
		        }
	            return mav;
			} // end of if ("olProfile".equalsIgnoreCase(from))

		} else if (ActionKeys.SEARCH_ORG.equalsIgnoreCase(action)
				|| ActionKeys.SEARCH_ORG_ON_PROFILE.equals(action)) {

			String searchText = request.getParameter("searchText");

			Organization[] orgs = orgService.searchOrganizations(searchText);
			request.setAttribute("orgs", orgs);
		//	session.setAttribute("orgas", orgs);
			session.setAttribute("SEARCH_TEXT", searchText);
			if (action.equals(ActionKeys.SEARCH_ORG_ON_PROFILE))
				return new ModelAndView("profile_org_search");

			return new ModelAndView("interaction_org_search");

		} // end of ActionKeys

     if(resetIntForm!=null&&resetIntForm.equalsIgnoreCase("true"))
     	resetInteractionForm(request);	
     return new ModelAndView("add_interaction_main");

	} // end of processFormSubmission()

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

	public Interaction setInteractionDTO(long currentUserId,
			long currentStaffId, InteractionForm interactionForm,
			String tafaregion, long userGroupId) throws Exception {
		Interaction interaction = null;
		try {

			interaction = new Interaction();

			if (interactionForm.getInteractionId() != 0) {
				interaction.setId(interactionForm.getInteractionId());
			}
			interaction.setUserId(currentUserId); 	
			interaction.setStaffId(currentStaffId);
			
			// tagging of TA
			final String productMultiselectIds = interactionForm.getProductMultiselectIds();
			OptionLookup primaryProductLookup = null;
			if(productMultiselectIds != null){
				final String [] productIdsList = productMultiselectIds.split(Constants.DELIMITER_TO_SEPARATE_VALUES);
				if(productIdsList.length>0){
					primaryProductLookup = optionService.getOptionLookup(Long.parseLong(productIdsList[0]));
				}
				if(primaryProductLookup != null){
					interaction.setTa(primaryProductLookup.getParentId());
				}
			}							
			

			// set interaction type
			if(interactionForm.getInteractionTypeId() != 0){
				OptionLookup interactionTypeOption = new OptionLookup();
				interactionTypeOption.setId(interactionForm.getInteractionTypeId());
				interaction.setType(interactionTypeOption);
			}
			// set interaction date
			String interactionDate = interactionForm.getInteractionDate();
			SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
			interaction.setInteractionDate(sdf.parse(interactionDate));

			// set attendee list
			String[] attendeeList = interactionForm.getAttendeeList();
 			String[] kolIdList = null;
			if (attendeeList != null && attendeeList.length > 0) {
				kolIdList = new String[attendeeList.length];
				String attendee = null;
				String[] attendees = null;
				for (int l = 0; l < attendeeList.length; l++) {
					attendee = attendeeList[l];
					if (attendeeList[l].startsWith("kol_")) {
						attendees = attendee.split("_");
						kolIdList[l] = attendees[1];
					}
				}
			}
			interaction.setKolIdArr(kolIdList);

			interaction.setCreateTime(new Date(System.currentTimeMillis()));
			interaction.setUpdateTime(new Date(System.currentTimeMillis()));
			interaction.setDeleteFlag("N");
		} catch (Exception e) {
			logger.error("Error while creating interaction object", e);
		}
		return interaction;
	}

	IOptionService optionService;

	IInteractionService interactionService;

	IAttendeeService attendeeService;

	IUserService userService;

	IOrganizationService orgService;

	IInteractionDataService interactionDataService;

	public IInteractionDataService getInteractionDataService() {
		return interactionDataService;
	}

	public void setInteractionDataService(
			IInteractionDataService interactionDataService) {
		this.interactionDataService = interactionDataService;
	}

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	public IInteractionService getInteractionService() {
		return interactionService;
	}

	public void setInteractionService(IInteractionService interactionService) {
		this.interactionService = interactionService;
	}

	public void setAttendeeService(IAttendeeService attendeeService) {
		this.attendeeService = attendeeService;
	}

	public IOrganizationService getOrgService() {
		return orgService;
	}

	public void setOrgService(IOrganizationService orgService) {
		this.orgService = orgService;
	}

	private OptionLookup[] getPlannedInteractions(String userId)
			throws ManagerException {
		OptionLookup lookup[] = null;
		if (userId != null && !"".equals(userId)) {
			KOLManager kolManager = new KOLManager();
			HashMap tacticMap = kolManager.getMatchedTaFaRegion(Long
					.parseLong(userId));
			if (!tacticMap.isEmpty()) {
				lookup = new OptionLookup[tacticMap.size()];
				OptionLookup option = null;
				Set keys = tacticMap.keySet();
				Iterator itr = keys.iterator();
				String key = null;
				String val = null;
				int counter = 0;
				while (itr.hasNext()) {
					key = (String) itr.next();
					val = (String) tacticMap.get(key);
					option = new OptionLookup();
					if (null != key && !"".equals(key)) {
						option.setId(Long.parseLong(key));
					}
					option.setOptValue(val);
					lookup[counter] = option;
					counter++;
				}
			}
		}
		return lookup;
	}
	private void addObjectsToInteractionDataSet(Interaction interaction,String type, Set interactionSet){
		InteractionData[] interactionDataListForType = interactionDataService.getAllDataOnType(interaction.getId(), type);
        if (null != interactionDataListForType && interactionDataListForType.length > 0)
	        for (int i = 0; i < interactionDataListForType.length; i++)
		       interactionSet.add(interactionDataListForType[i]);
        interaction.setInteractionData(interactionSet);
 	}	
	void createInteractionDataObjectsSetFromTextBox(HttpServletRequest request, String formFieldName, String type, Interaction interaction, Set interactionSet, long userGroupId)
	{
		String[] valuesFromTextBox = request.getParameterValues(formFieldName);
		InteractionData interactionData;
		if (valuesFromTextBox != null && valuesFromTextBox.length > 0) {
			for (int i = 0; i < valuesFromTextBox.length; i++) {
				
				interactionData= new InteractionData();
				interactionData.setType(type);
				interactionData.setData(valuesFromTextBox[i]);
				interactionData.setInteraction(interaction);
				interactionDataService.saveInteractionData(interactionData);
			}
		}
		addObjectsToInteractionDataSet(interaction,type,interactionSet);
	}
	//added for adding attendee Information
	void createInteractionDataObjectsSetFromTextBoxForAttendeeInformation(HttpServletRequest request, String formFieldName, String type, Interaction interaction, Set interactionSet, long userGroupId)
	{
		String[] valuesFromTextBox = request.getParameterValues(formFieldName);
		InteractionData interactionData;
		if (valuesFromTextBox != null && valuesFromTextBox.length > 0) {
			for (int i = 0; i < valuesFromTextBox.length; i++) {
				interactionData= new InteractionData();
				StringTokenizer st = new StringTokenizer(valuesFromTextBox[i],"-");
				String lovIdString = "";
				String dataId = "";
				OptionLookup lovId = new OptionLookup();
				
				while(st.hasMoreTokens())
				{
					lovIdString = st.nextToken();
					dataId = st.nextToken();
				}
				if( !"".equals(dataId) ){
    				lovId = optionServiceWrapper.getValuesForId(Long
    						.parseLong(lovIdString), userGroupId);
    				
    				interactionData.setLovId(lovId);
    				interactionData.setData(dataId);
    				interactionData.setType(type);
    				interactionData.setInteraction(interaction);
    				interactionDataService.saveInteractionData(interactionData);
				}
			}
		}
		addObjectsToInteractionDataSet(interaction,type,interactionSet);
	}
	void createInteractionDataObjectsSetFromTextBoxForEventInformation(HttpServletRequest request, String formFieldName, String formFieldName2,String type, Interaction interaction, Set interactionSet, long userGroupId)
	{
		String[] valuesFromTextBox = request.getParameterValues(formFieldName);
		InteractionData interactionData;
		if (valuesFromTextBox != null && valuesFromTextBox.length > 0 ) {
			for (int i = 0; i < valuesFromTextBox.length; i++) {
			    if (valuesFromTextBox[i] != null
			            && !"".equals(valuesFromTextBox[i])) {
			        interactionData = new InteractionData();
			        String dataId = valuesFromTextBox[i];
			        interactionData.setData(dataId);
			        interactionData.setType(type);
			        interactionData.setInteraction(interaction);
			        interactionDataService.saveInteractionData(interactionData);
			    }
			}
			addObjectsToInteractionDataSet(interaction,type,interactionSet);
		}
		
	}
	
	void createInteractionDataObjectsSetFromLovs(HttpServletRequest request, String formFieldName, String type, Interaction interaction, Set interactionSet, long userGroupId) {
		String[] valuesFromDropdown = request.getParameterValues(formFieldName);
		InteractionData interactionData ;
		OptionLookup lookup = new OptionLookup();
		if (null != valuesFromDropdown && valuesFromDropdown.length > 0) {
			for (int i = 0; i < valuesFromDropdown.length; i++) {
				interactionData = new InteractionData();
				lookup = optionServiceWrapper.getValuesForId(Long
						.parseLong(valuesFromDropdown[i]), userGroupId);
				interactionData.setLovId(lookup);
				interactionData.setType(type);
				interactionData.setInteraction(interaction);
				interactionDataService.saveInteractionData(interactionData);
			}
				//TODO before or after }}??????????
				addObjectsToInteractionDataSet(interaction, type, interactionSet);
		}
	}
	
	void updateInteractionDataObjectsSetFromLovs(HttpServletRequest request, String formFieldName, String type, Interaction interaction, Set interactionSet, long userGroupId) {
		String[] valuesFromDropdown = request.getParameterValues(formFieldName);
		InteractionData interactionData ;
		InteractionData[] interactionDataSet=null;
		
		//TODO ask from gyan ?????
		//interaction = interactionService.getInteraction(interaction.getId());
		OptionLookup lookup = new OptionLookup();
		if (null != valuesFromDropdown && valuesFromDropdown.length > 0) {
			interactionDataSet = new InteractionData[valuesFromDropdown.length];
			for (int i = 0; i < valuesFromDropdown.length; i++) {
				interactionData = new InteractionData();
				lookup = optionServiceWrapper.getValuesForId(Long
						.parseLong(valuesFromDropdown[i]), userGroupId);
				interactionData.setLovId(lookup);
				interactionData.setType(type);
				interactionData.setInteraction(interaction);
				interactionDataSet[i] = interactionData;
			}
		}else{
      interactionDataSet = new InteractionData[0];      
    }
		interactionDataService.updateInteractionData(interaction.getId(),interactionDataSet, type);
		
		interactionDataSet= interactionDataService.getAllDataOnType(interaction.getId(),type);
		if(interactionDataSet != null && interactionDataSet.length>0)
		    for (int i = 0; i < interactionDataSet.length; i++)
			     interactionSet.add(interactionDataSet[i]);
		interaction.setInteractionData(interactionSet);
	}
	
	void updateInteractionDataObjectsSetFromTextBox(HttpServletRequest request, String formFieldName, String type, Interaction interaction, Set interactionSet)
	{
		String[] valuesFromTextBox = request.getParameterValues(formFieldName);
		InteractionData interactionData ;
		InteractionData[] interactionDataSet=null;
		
		//TODO ask from gyan ?????
		//interaction = interactionService.getInteraction(interaction.getId());
		if (null != valuesFromTextBox && valuesFromTextBox.length > 0) {
			interactionDataSet = new InteractionData[valuesFromTextBox.length];
			for (int i = 0; i < valuesFromTextBox.length; i++) {
				interactionData = new InteractionData();
				interactionData.setData(valuesFromTextBox[i]);
				interactionData.setType(type);
				interactionData.setInteraction(interaction);
				interactionDataSet[i] = interactionData;
			}
		}
		interactionDataService.updateInteractionData(interaction.getId(),interactionDataSet, type);
		interactionDataSet= interactionDataService.getAllDataOnType(interaction.getId(),type);
		if(interactionDataSet != null && interactionDataSet.length>0)
		    for (int i = 0; i < interactionDataSet.length; i++)
			    interactionSet.add(interactionDataSet[i]);
		interaction.setInteractionData(interactionSet);
		}
	void updateInteractionDataObjectsSetFromTextBoxForEvents(HttpServletRequest request, String formFieldName, String formFieldName2,String type, Interaction interaction, Set interactionSet)
	{
		String[] valuesFromTextBox = request.getParameterValues(formFieldName);
		InteractionData interactionData ;
		InteractionData[] interactionDataSet=null;
		
		//TODO ask from gyan ?????
		//interaction = interactionService.getInteraction(interaction.getId());
		if (null != valuesFromTextBox && valuesFromTextBox.length > 0) {
			interactionDataSet = new InteractionData[valuesFromTextBox.length];
			for (int i = 0; i < valuesFromTextBox.length; i++) {
				interactionData = new InteractionData();
				String dataId = valuesFromTextBox[i];
				int dataIdLength = dataId.length();
				if(dataId != null && dataId != "" &&dataIdLength > 0) {
					interactionData.setData(dataId);
					interactionData.setType(type);
					interactionData.setInteraction(interaction);
					interactionDataSet[i] = interactionData;
				}
			}
		}
		interactionDataService.updateInteractionData(interaction.getId(),interactionDataSet, type);
		interactionDataSet= interactionDataService.getAllDataOnType(interaction.getId(),type);
		if(interactionDataSet != null && interactionDataSet.length>0)
		    for (int i = 0; i < interactionDataSet.length; i++)
			    interactionSet.add(interactionDataSet[i]);
		interaction.setInteractionData(interactionSet);
	}
	void updateInteractionDataObjectsSetFromTextBoxForAttendee(HttpServletRequest request, String formFieldName, String type, Interaction interaction, Set interactionSet, long userGroupId)
	{
		String[] valuesFromTextBox = request.getParameterValues(formFieldName);
		InteractionData interactionData ;
		InteractionData[] interactionDataSet=null;
		
		//TODO ask from gyan ?????
		//interaction = interactionService.getInteraction(interaction.getId());
		if (null != valuesFromTextBox && valuesFromTextBox.length > 0) {
			interactionDataSet = new InteractionData[valuesFromTextBox.length];
			for (int i = 0; i < valuesFromTextBox.length; i++) {
				interactionData = new InteractionData();
				
				StringTokenizer st = new StringTokenizer(valuesFromTextBox[i],"-");
				String lovIdString = "";
				String dataId = "";
				OptionLookup lovId = new OptionLookup();
				
				while(st.hasMoreTokens())
				{
					lovIdString = st.nextToken();
					dataId = st.nextToken();
				}
				
				lovId = optionServiceWrapper.getValuesForId(Long
						.parseLong(lovIdString), userGroupId);
				interactionData.setLovId(lovId);
				interactionData.setData(dataId);
				interactionData.setType(type);
				interactionData.setInteraction(interaction);
				interactionDataSet[i] = interactionData;
			}
		}
		interactionDataService.updateInteractionData(interaction.getId(),interactionDataSet, type);
		interactionDataSet= interactionDataService.getAllDataOnType(interaction.getId(),type);
		if(interactionDataSet != null && interactionDataSet.length>0)
		    for (int i = 0; i < interactionDataSet.length; i++)
			    interactionSet.add(interactionDataSet[i]);
		interaction.setInteractionData(interactionSet);
	}
	
	OptionLookup[] getValuesForOptionName(String optionNameInLovConstantsFile, long userGroupId)
	{
		return(optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor(optionNameInLovConstantsFile), userGroupId));
	}
	
	OptionLookup[] getValuesForOptionAndUser(String optionNameInLovConstantsFile, long userId, long userGroupId)
	{
		return(optionServiceWrapper.getValuesForOptionAndUser(PropertyReader.getLOVConstantValueFor(optionNameInLovConstantsFile),userId, userGroupId));
	}

	public IEventService getEventService() {
		return eventService;
	}

	public void setEventService(IEventService eventService) {
		this.eventService = eventService;
	}
   private void resetInteractionForm(HttpServletRequest request)
   {
	   request.getSession().removeAttribute("relatedEventEntity");
	   request.getSession().removeAttribute("INTERACTION_DETAILS") ;
       request.getSession().removeAttribute("SURVEY_EXPERTS");
       request.getSession().removeAttribute("ATTENDEES_MAP");
       
   }
   private void saveOrUpdateInteractionData(InteractionForm interactionForm, Interaction interaction, String action){
	      // 11-October-2008 : Code starts for storing the data for the new sections for BMS
	   
	      if(interactionForm != null && interaction != null ){
		      // saveOrUpdate Interaction Triplet Data
	    	  if(interactionForm.getInteractionTypeLOVTripletIds() != null &&
		    		  !"".equals(interactionForm.getInteractionTypeLOVTripletIds())){
		    	  	String commaSeparatedIds = interactionForm.getInteractionTypeLOVTripletIds();
		    	  	saveOrUpdateLOVIdTriplet(interaction, action, Constants.INTERACTION_TYPE_LOV_TRIPLET_IDS, commaSeparatedIds);
	    	  }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
							|| ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
		    		  	// action is update data but new values are null, therefore, delete the existing records for the type.
		    	  		interactionDataService.deleteInteractionDataByType(interaction.getId(), Constants.INTERACTION_TYPE_LOV_TRIPLET_IDS);
			  }
		      // saveOrUpdate Product lovs
	    	  // In UI Products is in multiple rows, but, instead of storing it in multiple rows
	    	  // we will store products in LOVID, SECONDARY_LOVID, TERTIARY_LOVID to ease
	    	  // report development. Also, the maximum product number is 3
		      if(interactionForm.getProductMultiselectIds() != null &&
		    		  !"".equals(interactionForm.getProductMultiselectIds())){
			    	  String [] products = interactionForm.getProductMultiselectIds().split(DELIMITER_TO_SEPARATE_VALUES);
			    	  if(products != null){
    				      InteractionData interactionSaveOrUpdateObj = new InteractionData();
    				      interactionSaveOrUpdateObj.setInteraction(interaction);
    				      interactionSaveOrUpdateObj.setType(Constants.PRODUCT_MULTISELECT_IDS);
    					  if(products.length >= 1 && products[0] != null){
    						  OptionLookup lookup = new OptionLookup();
    						  lookup.setId(Long.parseLong(products[0]));
    						  interactionSaveOrUpdateObj.setLovId(lookup);
    					  }
    					  if(products.length >= 2 && products[1] != null){
    						  OptionLookup lookup = new OptionLookup();
    						  lookup.setId(Long.parseLong(products[1]));
    						  interactionSaveOrUpdateObj.setSecondaryLovId(lookup);
    					  }
    					  if(products.length >= 3 && products[2] != null){
    						  OptionLookup lookup = new OptionLookup();
    						  lookup.setId(Long.parseLong(products[2]));
    						  interactionSaveOrUpdateObj.setTertiaryLovId(lookup);
    					  }
    					  InteractionData[] interactionSaveOrUpdateArray = new InteractionData[1];
    					  interactionSaveOrUpdateArray[0] = interactionSaveOrUpdateObj;
					      saveOrUpdateInteractionData(interaction.getId(), interactionSaveOrUpdateArray, action, Constants.PRODUCT_MULTISELECT_IDS);
			    	  }
		      }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
						|| ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
		    	  	// action is update data but new values are null, therefore, delete the existing records for the type.
	    	  		interactionDataService.deleteInteractionDataByType(interaction.getId(), Constants.PRODUCT_MULTISELECT_IDS);
		      }
		      // saveOrUpdate intentOfVisit : Constants.PROACTIVE_INTENT_OF_VISIT or Constants.REACTIVE_INTENT_OF_VISIT
		      if(interactionForm.getIntentOfVisit() != null &&
		    		  !"".equals(interactionForm.getIntentOfVisit())){
		    	  saveOrUpdateData(interaction, action, Constants.INTENT_OF_VISIT, interactionForm.getIntentOfVisit());
		      }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
						|| ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
		    	  	// action is update data but new values are null, therefore, delete the existing records for the type.
	    	  		interactionDataService.deleteInteractionDataByType(interaction.getId(), Constants.INTENT_OF_VISIT);
		      }
		      // saveOrUpdate whether unsolicitedOffLabel required or not
		      if(interactionForm.getUnsolicitedOffLabelCheckbox() != null &&
		    		  !"".equals(interactionForm.getUnsolicitedOffLabelCheckbox())){
		    	  saveOrUpdateData(interaction, action, Constants.UNSOLICTED_OFF_LABEL_CHECKBOX, interactionForm.getUnsolicitedOffLabelCheckbox());
		      }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
						|| ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
		    	  	// action is update data but new values are null, therefore, delete the existing records for the type.
	    	  		interactionDataService.deleteInteractionDataByType(interaction.getId(), Constants.UNSOLICTED_OFF_LABEL_CHECKBOX);
		      }
		      // saveOrUpdate speaker decks
		      if(interactionForm.getSpeakerDecksMultiselectIds() != null &&
		    		  !"".equals(interactionForm.getSpeakerDecksMultiselectIds())){
		    	  String commaSeparatedIds = interactionForm.getSpeakerDecksMultiselectIds();
		    	  saveOrUpdateLOVId(interaction, action, Constants.SPEAKER_DECKS_MULTISELECT_IDS, commaSeparatedIds);
		      }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
						|| ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
		    	  	// action is update data but new values are null, therefore, delete the existing records for the type.
	    	  		interactionDataService.deleteInteractionDataByType(interaction.getId(), Constants.SPEAKER_DECKS_MULTISELECT_IDS);
		      }
		      // saveOrUpdate Disease State
		      if(interactionForm.getDiseaseStateMultiselectIds() != null &&
		    		  !"".equals(interactionForm.getDiseaseStateMultiselectIds())){
		    	  String commaSeparatedIds = interactionForm.getDiseaseStateMultiselectIds();
		    	  saveOrUpdateLOVId(interaction, action, Constants.DISEASE_STATE_MULTISELECT_IDS, commaSeparatedIds);
		      }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
						|| ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
		    	  	// action is update data but new values are null, therefore, delete the existing records for the type.
	    	  		interactionDataService.deleteInteractionDataByType(interaction.getId(), Constants.DISEASE_STATE_MULTISELECT_IDS);
		      }
		      // saveOrUpdate Product Presentation
		      if(interactionForm.getProductPresentationMultiselectIds() != null &&
		    		  !"".equals(interactionForm.getProductPresentationMultiselectIds())){
		    	  String commaSeparatedIds = interactionForm.getProductPresentationMultiselectIds();
		    	  saveOrUpdateLOVId(interaction, action, Constants.PRODUCT_PRESENTATION_MULTISELECT_IDS, commaSeparatedIds);
		      }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
						|| ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
		    	  	// action is update data but new values are null, therefore, delete the existing records for the type.
	    	  		interactionDataService.deleteInteractionDataByType(interaction.getId(), Constants.PRODUCT_PRESENTATION_MULTISELECT_IDS);
		      }
		      // saveOrUpdate Unsolicted-off label triplet ids
		      if(interactionForm.getUnsolictedOffLabelTripletIds() != null &&
		    		  !"".equals(interactionForm.getUnsolictedOffLabelTripletIds())){
		    	  	String commaSeparatedIds = interactionForm.getUnsolictedOffLabelTripletIds();
		    	  	saveOrUpdateLOVIdQuartetText(interaction, action, Constants.UNSOLICTED_OFF_LABEL_TRIPLET_IDS, commaSeparatedIds);
		    	  }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
							|| ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
		    		  	// action is update data but new values are null, therefore, delete the existing records for the type.
		    	  		interactionDataService.deleteInteractionDataByType(interaction.getId(), Constants.UNSOLICTED_OFF_LABEL_TRIPLET_IDS);
			      }
		      // saveOrUpdate Educational Objectives multi select
		      if(interactionForm.getEducationalObjectivesMultiselectIds() != null &&
		    		  !"".equals(interactionForm.getEducationalObjectivesMultiselectIds())){
		    	  	String commaSeparatedIds = interactionForm.getEducationalObjectivesMultiselectIds();
		    	  	saveOrUpdateLOVIdPair(interaction, action, Constants.EDUCATIONAL_OBJECTIVES_MULTISELECT_IDS, commaSeparatedIds);
	    	  }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
						|| ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
	    		  	// action is update data but new values are null, therefore, delete the existing records for the type.
	    	  		interactionDataService.deleteInteractionDataByType(interaction.getId(), Constants.EDUCATIONAL_OBJECTIVES_MULTISELECT_IDS);
		      }
		      //saveOrUpdate Medical Plan Activity multi select
		      if(interactionForm.getMedicalPlanActivitiesMultiselectIds() != null &&
		    		  !"".equals(interactionForm.getMedicalPlanActivitiesMultiselectIds())){
		    	  	String commaSeparatedIds = interactionForm.getMedicalPlanActivitiesMultiselectIds();
		    	  	saveOrUpdateLOVIdTriplet(interaction, action, Constants.MEDICAL_PLAN_ACTIVITY, commaSeparatedIds);
	    	  }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
						|| ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
	    		  	// action is update data but new values are null, therefore, delete the existing records for the type.
	    	  		interactionDataService.deleteInteractionDataByType(interaction.getId(), Constants.MEDICAL_PLAN_ACTIVITY);
		      }
		      		      
		      // saveOrUpdate Clinical Trials multi select
		      if(interactionForm.getSelectStudyMultiselectIds() != null &&
		    		  !"".equals(interactionForm.getSelectStudyMultiselectIds())){
		    	  	String commaSeparatedIds = interactionForm.getSelectStudyMultiselectIds();
		    	  	saveOrUpdateLOVIdText(interaction, action, Constants.SELECT_STUDY_MULTISELECT_IDS, commaSeparatedIds);
	    	  }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
						|| ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
	    		  	// action is update data but new values are null, therefore, delete the existing records for the type.
	    	  		interactionDataService.deleteInteractionDataByType(interaction.getId(), Constants.SELECT_STUDY_MULTISELECT_IDS);
		      }
		      // saveOrUpdate speaker decks
              if(interactionForm.getMIRFMultiselectIds() != null &&
                      !"".equals(interactionForm.getMIRFMultiselectIds())){
                  String commaSeparatedIds = interactionForm.getMIRFMultiselectIds();
                  saveOrUpdateNonLOVId(interaction, action, Constants.MIRF_MULTISELECT_IDS,interactionForm.getMIRFMultiselectIds());
              }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
                        || ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
                    // action is update data but new values are null, therefore, delete the existing records for the type.
                    interactionDataService.deleteInteractionDataByType(interaction.getId(), Constants.MIRF_MULTISELECT_IDS);
              }
	      }
	      // Code ends for storing the data for the new sections for BMS
   }
   
   private void saveOrUpdateNonLOVId(Interaction interaction, String action, String type, String commaSeparatedIds){
       if(interaction != null && action != null && type != null && commaSeparatedIds != null && !"".equals(commaSeparatedIds)){
          String [] data = commaSeparatedIds.split(DELIMITER_TO_SEPARATE_VALUES);
          if(data != null){
              InteractionData[] interactionSaveOrUpdateArray = new InteractionData[data.length];
              for(int i=0; i<data.length; i++){
                  if(data[i] != null){
                      InteractionData interactionSaveOrUpdateObj = new InteractionData();
                      interactionSaveOrUpdateObj.setInteraction(interaction);
                      interactionSaveOrUpdateObj.setType(type);
                      interactionSaveOrUpdateObj.setData(data[i]);
                      interactionSaveOrUpdateArray[i] = interactionSaveOrUpdateObj;
                  }
              }
              saveOrUpdateInteractionData(interaction.getId(), interactionSaveOrUpdateArray, action, type);
          }
       }
       
       
   }
   private void saveOrUpdateData(Interaction interaction, String action, String type, String data){
	   if(interaction != null && action != null && type != null && data != null && !"".equals(data)){
	      InteractionData interactionSaveOrUpdateObj = new InteractionData();
	      interactionSaveOrUpdateObj.setInteraction(interaction);
	      interactionSaveOrUpdateObj.setType(type);
	      interactionSaveOrUpdateObj.setData(data);
		  InteractionData[] interactionSaveOrUpdateArray = new InteractionData[1];
		  interactionSaveOrUpdateArray[0] = interactionSaveOrUpdateObj;
	      saveOrUpdateInteractionData(interaction.getId(), interactionSaveOrUpdateArray, action, type);
	   }
   }
   private void saveOrUpdateLOVId(Interaction interaction, String action, String type, String commaSeparatedIds){
	   if(interaction != null && action != null && type != null && commaSeparatedIds != null && !"".equals(commaSeparatedIds)){
	 	  String [] lovIdsArray = commaSeparatedIds.split(DELIMITER_TO_SEPARATE_VALUES);
		  if(lovIdsArray != null){
		      InteractionData[] interactionSaveOrUpdateArray = new InteractionData[lovIdsArray.length];
			  for(int i=0; i<lovIdsArray.length; i++){
				  if(lovIdsArray[i] != null){
				      InteractionData interactionSaveOrUpdateObj = new InteractionData();
				      interactionSaveOrUpdateObj.setInteraction(interaction);
				      interactionSaveOrUpdateObj.setType(type);
					  OptionLookup lookup = new OptionLookup();
					  lookup.setId(Long.parseLong(lovIdsArray[i]));
	    			  interactionSaveOrUpdateObj.setLovId(lookup);
	    			  interactionSaveOrUpdateArray[i] = interactionSaveOrUpdateObj;
				  }
			  }
			  saveOrUpdateInteractionData(interaction.getId(), interactionSaveOrUpdateArray, action, type);
		  }
	   }
	   
   }
   private void saveOrUpdateLOVIdPair(Interaction interaction, String action, String type, String commaSeparatedIds){
	   if(interaction != null && action != null && type != null && commaSeparatedIds != null && !"".equals(commaSeparatedIds)){
	 	  String [] pairs = commaSeparatedIds.split(DELIMITER_TO_SEPARATE_VALUES);
		  if(pairs != null){
			  InteractionData[] interactionSaveOrUpdateArray = new InteractionData[pairs.length];
			  for(int i=0; i<pairs.length; i++){
					  String [] lovIds = pairs[i].split(DELIMITER_TO_SEPARATE_SUBVALUES);
					  if(lovIds != null){
					      InteractionData interactionSaveOrUpdateObj = new InteractionData();
					      interactionSaveOrUpdateObj.setInteraction(interaction);
					      interactionSaveOrUpdateObj.setType(type);
						  if(lovIds.length >= 1 && lovIds[0] != null){
							  OptionLookup lookup = new OptionLookup();
							  lookup.setId(Long.parseLong(lovIds[0]));
							  interactionSaveOrUpdateObj.setLovId(lookup);
						  }
						  if(lovIds.length >= 2 && lovIds[1] != null){
							  OptionLookup lookup = new OptionLookup();
							  lookup.setId(Long.parseLong(lovIds[1]));
							  interactionSaveOrUpdateObj.setSecondaryLovId(lookup);
						  }
						  interactionSaveOrUpdateArray[i] = interactionSaveOrUpdateObj;
					  }
				  }
			      saveOrUpdateInteractionData(interaction.getId(), interactionSaveOrUpdateArray, action, type);
			  }
	   }
   }
   private void saveOrUpdateLOVIdTriplet(Interaction interaction, String action, String type, String commaSeparatedIds){
	   if(interaction != null && action != null && type != null && commaSeparatedIds != null && !"".equals(commaSeparatedIds)){
	 	  String [] triplets = commaSeparatedIds.split(DELIMITER_TO_SEPARATE_VALUES);
		  if(triplets != null){
			  InteractionData[] interactionSaveOrUpdateArray = new InteractionData[triplets.length];
			  for(int i=0; i<triplets.length; i++){
					  String [] lovIds = triplets[i].split(DELIMITER_TO_SEPARATE_SUBVALUES);
					  if(lovIds != null){
					      InteractionData interactionSaveOrUpdateObj = new InteractionData();
					      interactionSaveOrUpdateObj.setInteraction(interaction);
					      interactionSaveOrUpdateObj.setType(type);
						  if(lovIds.length <=3 && lovIds[0] != null && lovIds[1] != null && lovIds[2] != null){
							  OptionLookup LovIdLookup = new OptionLookup();
							  LovIdLookup.setId(Long.parseLong(lovIds[0]));
							  interactionSaveOrUpdateObj.setLovId(LovIdLookup);
							 
							  OptionLookup secondaryLovIdLookup = new OptionLookup();
							  secondaryLovIdLookup.setId(Long.parseLong(lovIds[1]));
							  interactionSaveOrUpdateObj.setSecondaryLovId(secondaryLovIdLookup);
							  
							  OptionLookup tertiaryLovIdLookup = new OptionLookup();
							  tertiaryLovIdLookup.setId(Long.parseLong(lovIds[2]));
							  interactionSaveOrUpdateObj.setTertiaryLovId(tertiaryLovIdLookup);
							  
							  if( Constants.INTERACTION_TYPE_LOV_TRIPLET_IDS.equals(type)){
							      interactionSaveOrUpdateObj.setData(String.valueOf(i+1));
							  }
							  interactionSaveOrUpdateArray[i] = interactionSaveOrUpdateObj;
						 }
					  }
	    		  }
			  	  saveOrUpdateInteractionData(interaction.getId(), interactionSaveOrUpdateArray, action, type);
		  }
	   }
   }
   private void saveOrUpdateInteractionData(long interactionId, InteractionData[] interactionSaveOrUpdateArray, String action, String type){
	   if(interactionId != 0 && interactionSaveOrUpdateArray != null && action != null){
	      if ((ActionKeys.ADD_INTERACTION.equalsIgnoreCase(action)
					|| ActionKeys.PROFILE_ADD_INTERACTION.equalsIgnoreCase(action))) {
	    	   		interactionDataService.saveInteractionData(interactionSaveOrUpdateArray);
	      }else if ((ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
					|| ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action))) {
	    	  		interactionDataService.updateInteractionData(interactionId, interactionSaveOrUpdateArray, type);
	      }
	   }
   }
   private void addDataForSections(Interaction interaction, Set interactionSet){
		addObjectsToInteractionDataSet(interaction, Constants.INTENT_OF_VISIT, interactionSet);
		addObjectsToInteractionDataSet(interaction, Constants.UNSOLICTED_OFF_LABEL_CHECKBOX, interactionSet);
		addObjectsToInteractionDataSet(interaction, Constants.INTERACTION_TYPE_LOV_TRIPLET_IDS, interactionSet);
		addObjectsToInteractionDataSet(interaction, Constants.PRODUCT_MULTISELECT_IDS, interactionSet);
		addObjectsToInteractionDataSet(interaction, Constants.SPEAKER_DECKS_MULTISELECT_IDS, interactionSet);
		addObjectsToInteractionDataSet(interaction, Constants.UNSOLICTED_OFF_LABEL_TRIPLET_IDS, interactionSet);
		addObjectsToInteractionDataSet(interaction, Constants.EDUCATIONAL_OBJECTIVES_MULTISELECT_IDS, interactionSet);
		addObjectsToInteractionDataSet(interaction, Constants.SELECT_STUDY_MULTISELECT_IDS, interactionSet);
		addObjectsToInteractionDataSet(interaction, Constants.DISEASE_STATE_MULTISELECT_IDS, interactionSet);
		addObjectsToInteractionDataSet(interaction, Constants.PRODUCT_PRESENTATION_MULTISELECT_IDS, interactionSet);
        addObjectsToInteractionDataSet(interaction, Constants.MIRF_MULTISELECT_IDS, interactionSet);
        addObjectsToInteractionDataSet(interaction, Constants.MEDICAL_PLAN_ACTIVITY, interactionSet);
        
   }
   private void saveOrUpdateLOVIdText(Interaction interaction, String action, String type, String commaSeparatedIds){
	   if(interaction != null && action != null && type != null && commaSeparatedIds != null && !"".equals(commaSeparatedIds)){
	 	  String [] pairs = commaSeparatedIds.split(DELIMITER_TO_SEPARATE_VALUES);
		  if(pairs != null){
			  InteractionData[] interactionSaveOrUpdateArray = new InteractionData[pairs.length];
			  for(int i=0; i<pairs.length; i++){
					  String [] idsToSave = pairs[i].split(DELIMITER_TO_SEPARATE_SUBVALUES);
					  if(idsToSave != null){
					      InteractionData interactionSaveOrUpdateObj = new InteractionData();
					      interactionSaveOrUpdateObj.setInteraction(interaction);
					      interactionSaveOrUpdateObj.setType(type);
						  if(idsToSave.length >= 1 && idsToSave[0] != null){
							  OptionLookup lookup = new OptionLookup();
							  lookup.setId(Long.parseLong(idsToSave[0]));
							  interactionSaveOrUpdateObj.setLovId(lookup);
						  }
						  if(idsToSave.length >= 2 && idsToSave[1] != null){
							  OptionLookup lookup = new OptionLookup();
							  lookup.setId(Long.parseLong(idsToSave[1]));
							  interactionSaveOrUpdateObj.setSecondaryLovId(lookup);
						  }
						  if(idsToSave.length >= 3 && idsToSave[2] != null){
							  interactionSaveOrUpdateObj.setData(idsToSave[2]);
						  }
						  interactionSaveOrUpdateArray[i] = interactionSaveOrUpdateObj;
					  }
				  }
			      saveOrUpdateInteractionData(interaction.getId(), interactionSaveOrUpdateArray, action, type);
			  }
	   }
   }
   
   private void saveOrUpdateLOVIdQuartetText(Interaction interaction, String action, String type, String commaSeparatedIds){
	   if(interaction != null && action != null && type != null && commaSeparatedIds != null && !"".equals(commaSeparatedIds)){
	 	  String [] pairs = commaSeparatedIds.split(DELIMITER_TO_SEPARATE_VALUES);
		  if(pairs != null){
			  InteractionData[] interactionSaveOrUpdateArray = new InteractionData[pairs.length];
			  for(int i=0; i<pairs.length; i++){
					  String [] idsToSave = pairs[i].split(DELIMITER_TO_SEPARATE_SUBVALUES);
					  if(idsToSave != null){
					      InteractionData interactionSaveOrUpdateObj = new InteractionData();
					      interactionSaveOrUpdateObj.setInteraction(interaction);
					      interactionSaveOrUpdateObj.setType(type);
						  if(idsToSave.length >= 1 && idsToSave[0] != null){
							  OptionLookup lookup = new OptionLookup();
							  lookup.setId(Long.parseLong(idsToSave[0]));
							  interactionSaveOrUpdateObj.setLovId(lookup);
						  }
						  if(idsToSave.length >= 2 && idsToSave[1] != null){
							  OptionLookup lookup = new OptionLookup();
							  lookup.setId(Long.parseLong(idsToSave[1]));
							  interactionSaveOrUpdateObj.setSecondaryLovId(lookup);
						  }
						  if(idsToSave.length >= 3 && idsToSave[2] != null){
							  OptionLookup lookup = new OptionLookup();
							  lookup.setId(Long.parseLong(idsToSave[2]));
							  interactionSaveOrUpdateObj.setTertiaryLovId(lookup);
						  }
						  if(idsToSave.length >= 4 && idsToSave[3] != null){
							  interactionSaveOrUpdateObj.setData(idsToSave[3]);
						  }
						  interactionSaveOrUpdateArray[i] = interactionSaveOrUpdateObj;
					  }
				  }
			      saveOrUpdateInteractionData(interaction.getId(), interactionSaveOrUpdateArray, action, type);
			  }
	   }
   }
   
    /**
     * @return the dataAuditService
     */
    public IDataAuditService getDataAuditService() {
        return dataAuditService;
    }

    /**
     * @param dataAuditService
     *            the dataAuditService to set
     */
    public void setDataAuditService(IDataAuditService dataAuditService) {
        this.dataAuditService = dataAuditService;
    }
} // end of class
