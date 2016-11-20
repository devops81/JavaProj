package com.openq.web.controllers;

import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import sun.rmi.transport.proxy.HttpReceiveSocket;

import com.openq.attendee.Attendee;
import com.openq.attendee.IAttendeeService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.option.OptionNames;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.org.IOrganizationService;
import com.openq.eav.org.Organization;
import com.openq.interaction.IInteractionService;
import com.openq.interaction.Interaction;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;
import com.openq.web.forms.InteractionForm;
import com.openq.kol.KOLManager;
import com.openq.kol.ManagerException;
import com.openq.kol.InteractionsManager;
import com.openq.interactionData.InteractionData;
import com.openq.interactionData.IInteractionDataService;
import com.openq.interactionData.InteractionDataService;
import com.openq.group.IGroupService;
import com.openq.group.IUserGroupMapService;
import com.openq.group.Groups;

public class KolInteractionController extends SimpleFormController {
	IOptionServiceWrapper optionServiceWrapper;

	OptionLookup[] plannedInteraction = null;

	public IOptionServiceWrapper getOptionServiceWrapper() {
		return optionServiceWrapper;
	}

	public void setOptionServiceWrapper(
			IOptionServiceWrapper optionServiceWrapper) {
		this.optionServiceWrapper = optionServiceWrapper;
	}

	protected ModelAndView processFormSubmission(HttpServletRequest request,
			HttpServletResponse response, Object object, BindException exception)
			throws Exception {

		HttpSession session = request.getSession(true);
		session.setAttribute("kolIntUserService", userService);

		String action = (String) request.getParameter("action");
		long currentUserId = Long.parseLong((String) session
				.getAttribute(Constants.USER_ID));
		long currentStaffId = 0;
		if (null != session.getAttribute(Constants.CURRENT_STAFF_ID)
				&& session.getAttribute(Constants.CURRENT_STAFF_ID).toString()
						.trim().length() > 0) {
			currentStaffId = Long.parseLong((String) session
					.getAttribute(Constants.CURRENT_STAFF_ID));
		}

		String tafaregion = null != request.getSession().getAttribute(
				"TA_Fa_Region") ? (String) request.getSession().getAttribute(
				"TA_Fa_Region") : null;

		if (ActionKeys.SHOW_ADD_INTERACTION.equalsIgnoreCase(action)
				|| ActionKeys.PROFILE_SHOW_ADD_INTERACTION
						.equalsIgnoreCase(action)) {
			plannedInteraction = getPlannedInteractions(Long
					.toString(currentUserId));
			session.setAttribute("INTERACTION_TYPE", getValuesForOptionName("INTERACTION_TYPE"));
			session.setAttribute("EXPENSE_TYPE", getValuesForOptionName("EXPENSE_TYPE"));
			session.setAttribute("EXPENSE_VENUE", getValuesForOptionName("EXPENSE_VENUE"));
			session.setAttribute("SCIENTIFIC_TOPICS", getValuesForOptionAndUser("SCIENTIFIC_TOPICS",currentUserId));
			session.setAttribute("INTERACTION_ACTIVITY", getValuesForOptionAndUser("INTERACTION_ACTIVITY",currentUserId));
			session.setAttribute("SIM", getValuesForOptionAndUser("SIM",currentUserId));
			session.setAttribute("SITE_FOLLOW_UP", getValuesForOptionAndUser("SITE_FOLLOW_UP",currentUserId));
			session.setAttribute("MATERIALS", getValuesForOptionAndUser("LEAVE_BEHIND_MATERIALS",currentUserId));
			session.setAttribute("PRODUCTS", getValuesForOptionAndUser("PRODUCT", currentUserId));
			session.setAttribute("PLANNED_INTERACTION", plannedInteraction);
			session.setAttribute("STATUS", getValuesForOptionName("STATUS"));
			session.setAttribute("TOOL", getValuesForOptionAndUser("TOOL",currentUserId));
			session.setAttribute("RATING", getValuesForOptionAndUser("RATING", currentUserId));

			if (ActionKeys.PROFILE_SHOW_ADD_INTERACTION
					.equalsIgnoreCase(action)) {
				return new ModelAndView("show_profile_interaction");
			}

		} else if (ActionKeys.ADD_INTERACTION.equalsIgnoreCase(action)
				|| ActionKeys.PROFILE_ADD_INTERACTION.equalsIgnoreCase(action)) {

			// add interaction
			InteractionForm interactionForm = (InteractionForm) object;
			Interaction interaction = setInteractionDTO(currentUserId,
					currentStaffId, interactionForm, tafaregion);
			interactionService.saveInteraction(interaction);
			

			// add development plans
			String userName = (String) session
					.getAttribute(Constants.COMPLETE_USER_NAME);
			InteractionsManager manager = new InteractionsManager();
			String staffId = null;
			if (session.getAttribute(Constants.CURRENT_STAFF_ID) != null) {
				staffId = (String) session
						.getAttribute(Constants.CURRENT_STAFF_ID);
			}

			manager.saveDevPaln(interactionForm.getAssessment(), currentUserId,
					interaction.getKolIdArr(), userName, staffId, interaction
							.getInteractionDate());
			manager.saveInteractionTactics(interaction.getId(), interactionForm
					.getAssessment());

			// add all attendees (kols + others)
			String[] attendeeList = request.getParameterValues("attendeeList");
			Attendee attendee = new Attendee();
			int otherIdLen = 0;
			String userId = "";

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
					attendee.setSsoid(userId);
					attendee.setName(attendeeList[i].split("_")[2]);
					attendee.setSsname(attendeeList[i].split("_")[3]);
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
					otherIdLen = attendeeList[i].length();
					int firstbraceIndex = attendeeList[i].indexOf("(", 4);
					attendee.setName(attendeeList[i].substring(4,
							firstbraceIndex));

					attendee.setFirstName(attendeeList[i].split("_")[1]);
					attendee.setLastName(attendeeList[i].substring(
							4 + 1 + attendeeList[i].split("_")[1].length(),
							firstbraceIndex));
					String othDetails = attendeeList[i].substring(
							firstbraceIndex, otherIdLen);
					StringTokenizer st = new StringTokenizer(othDetails, "()");
					while (st.hasMoreTokens()) {
						attendee.setType(st.nextToken());
						attendee.setTa(st.nextToken());
						attendee.setTitle(st.nextToken());
						attendee.setState(st.nextToken());
						attendee.setCity(st.nextToken());
						attendee.setZip(st.nextToken());
					}

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
//			 add Scientific topics to interaction data
			createInteractionDataObjectsSetFromLovs(request,"scientificTopics","Scientific Topics",interaction, interactionSet);
//          add other Scientific Topics
			createInteractionDataObjectsSetFromTextBox(request,"otherTopics","Other Scientific Topics",interaction,interactionSet);
			createInteractionDataObjectsSetFromTextBox(request, "Description", "Description", interaction, interactionSet);
//          add InteractionActivity to interactiondata
			createInteractionDataObjectsSetFromLovs(request, "interactionActivityList","Interaction Activity",interaction,interactionSet);
//			add other Interaction Activity
			createInteractionDataObjectsSetFromTextBox(request,"otherInteractionActivities","Other Interaction Activities",interaction,interactionSet);
			createInteractionDataObjectsetFromCheckBox(request, "preCallCkBox", "Pre Call Plan", interaction, interactionSet);
			//          add Leave behind materials
			createInteractionDataObjectsSetFromLovs(request,"materialsList","Materials",interaction,interactionSet);
//			add Product
			createInteractionDataObjectsSetFromLovs(request,"productsList","Products",interaction,interactionSet);
			//for medical request policy
			createInteractionDataObjectSetForMedicalRequestPolicy(request, interaction, interactionSet);
			
//			add Tool Effectiveness
						
			String[] toolEffectiveness = request.getParameterValues("toolAssessment");
			InteractionData toolEffData = new InteractionData();
			OptionLookup tool = new OptionLookup();
			OptionLookup eff = new OptionLookup();
			if (null != toolEffectiveness)
				for (int cnt = 0; cnt < toolEffectiveness.length; cnt++) {
					String[] toolEff = toolEffectiveness[cnt].split("_");

					tool = optionServiceWrapper.getValuesForId(Long
							.parseLong(toolEff[0]));
					eff = optionServiceWrapper.getValuesForId(Long
							.parseLong(toolEff[1]));
					toolEffData.setLovId(tool);
					toolEffData.setStatusId(eff);
					toolEffData.setType("ToolEffectiveness");
					toolEffData.setInteraction(interaction);
					interactionDataService.saveInteractionData(toolEffData);
				}
			InteractionData[] toolEffList = interactionDataService
					.getAllDataOnType(interaction.getId(), "ToolEffectiveness");

			if (null != toolEffList && toolEffList.length > 0)
				for (int i = 0; i < toolEffList.length; i++)
					interactionSet.add(toolEffList[i]);

			 String[] medicalRequest = request.getParameterValues("medicalRequest");
			 
			OptionLookup prod = new OptionLookup();
			String data=new String();
			
			if (null != medicalRequest)
				for (int cnt = 0; cnt < medicalRequest.length; cnt++) {
          InteractionData medicalReqData = new InteractionData();
					String[] medicalReq = medicalRequest[cnt].split("@");
                    //System.out.println("medical request is "+medicalReq[0]+" now "+medicalReq[1]);
					prod = optionServiceWrapper.getValuesForId(Long
							.parseLong(medicalReq[0]));
					data=(medicalReq.length < 2? "":medicalReq[1]) +"@"+ (medicalReq.length < 3? "":medicalReq[2]);
					medicalReqData.setLovId(prod);
					medicalReqData.setData(data);
					medicalReqData.setType("MedicalRequest");
					medicalReqData.setInteraction(interaction);
					interactionDataService.saveInteractionData(medicalReqData);
				}
			InteractionData[] medicalReqList = interactionDataService
					.getAllDataOnType(interaction.getId(), "MedicalRequest");

			if (null != medicalReqList && medicalReqList.length > 0)
				for (int i = 0; i < medicalReqList.length; i++)
					interactionSet.add(medicalReqList[i]);
            
			interaction.setInteractionData(interactionSet);

			String[] assessment = interaction.getIntAssessList();

			String[] plaText = new String[assessment.length];
			for (int i = 0; i < assessment.length; i++) {
				String finalAssessText = getAssessmentText(assessment[i], Long
						.toString(currentUserId));

				plaText[i] = assessment[i] + "1122" + finalAssessText;

			}
			interaction.setIntAssessList(plaText);
			session.setAttribute("INTERACTION_DETAILS", interaction);

			session.setAttribute("MESSAGE",
					"Interaction details saved successfully");

			if (ActionKeys.PROFILE_ADD_INTERACTION.equalsIgnoreCase(action)) {
				return new ModelAndView("show_profile_interaction");
			}

		} else if (ActionKeys.EDIT_INTERACTION.equalsIgnoreCase(action)
				|| ActionKeys.PROFILE_SHOW_EDIT_INTERACTION
						.equalsIgnoreCase(action)) {
			plannedInteraction = getPlannedInteractions(Long
					.toString(currentUserId));
			session.setAttribute("INTERACTION_TYPE", getValuesForOptionName("INTERACTION_TYPE"));
			session.setAttribute("EXPENSE_TYPE", getValuesForOptionName("EXPENSE_TYPE"));
			session.setAttribute("EXPENSE_VENUE", getValuesForOptionName("EXPENSE_VENUE"));
			session.setAttribute("SCIENTIFIC_TOPICS", getValuesForOptionAndUser("SCIENTIFIC_TOPICS",currentUserId));
			session.setAttribute("INTERACTION_ACTIVITY", getValuesForOptionAndUser("INTERACTION_ACTIVITY",currentUserId));
			session.setAttribute("SIM", getValuesForOptionAndUser("SIM",currentUserId));
			session.setAttribute("SITE_FOLLOW_UP", getValuesForOptionAndUser("SITE_FOLLOW_UP",currentUserId));
			session.setAttribute("MATERIALS", getValuesForOptionAndUser("LEAVE_BEHIND_MATERIALS",currentUserId));
			session.setAttribute("PRODUCTS", getValuesForOptionAndUser("PRODUCT", currentUserId));
			session.setAttribute("PLANNED_INTERACTION", plannedInteraction);
			session.setAttribute("STATUS", getValuesForOptionName("STATUS"));
			session.setAttribute("TOOL", getValuesForOptionAndUser("TOOL",currentUserId));
			session.setAttribute("RATING", getValuesForOptionAndUser("RATING", currentUserId));

			
			long interactionId = Long.parseLong(request
					.getParameter("interactionId"));
			Interaction interaction = interactionService
					.getInteraction(interactionId);

			Attendee[] attendeeList = attendeeService
					.getAllAttendees(interactionId);
			Set attendees = new HashSet();
			for (int i = 0; i < attendeeList.length; i++) {
				attendees.add(attendeeList[i]);
			}

			interaction.setAttendees(attendees);
			
			Set interactionSet = new HashSet();
			
			addObjectsToInteractionDataSet(interaction,"Scientific Topics",interactionSet);
			addObjectsToInteractionDataSet(interaction,"Interaction Activity",interactionSet);
			addObjectsToInteractionDataSet(interaction,"Products",interactionSet);
			addObjectsToInteractionDataSet(interaction,"Materials",interactionSet);
			addObjectsToInteractionDataSet(interaction,"Other Scientific Topics",interactionSet);
			addObjectsToInteractionDataSet(interaction,"Other Interaction Activities",interactionSet);
			addObjectsToInteractionDataSet(interaction,"ToolEffectiveness",interactionSet);
			addObjectsToInteractionDataSet(interaction,"Description", interactionSet);
			addObjectsToInteractionDataSet(interaction,"MedicalRequest",interactionSet);
			addObjectsToInteractionDataSet(interaction,"Pre Call Plan", interactionSet);
			addObjectsToInteractionDataSet(interaction, "Unsolicited Medical Request", interactionSet);
			
			
			String[] assessment = interaction.getIntAssessList();

			String[] plaText = new String[assessment.length];
			for (int i = 0; i < assessment.length; i++) {
				String finalAssessText = getAssessmentText(assessment[i], Long
						.toString(currentUserId));

				plaText[i] = assessment[i] + "1122" + finalAssessText;

			}
			interaction.setIntAssessList(plaText);
			session.setAttribute("INTERACTION_DETAILS", interaction);

			String mode = request.getParameter("mode");
			session.setAttribute("MODE", mode);
			Object createdBy[] = interactionService.getCreatedBy(interaction
					.getId(), interaction.getUserId());
			session.setAttribute("CREATED_BY", createdBy);
			if (ActionKeys.PROFILE_SHOW_EDIT_INTERACTION
					.equalsIgnoreCase(action)) {
				return new ModelAndView("show_profile_interaction");
			}

		} else if (ActionKeys.UPDATE_INTERACTION.equalsIgnoreCase(action)
				|| ActionKeys.PROFILE_UPDATE_INTERACTION
						.equalsIgnoreCase(action)) {

			System.out.println("In Update Interaction");
			
			// update interaction
			InteractionForm interactionForm = (InteractionForm) object;
			Interaction interaction = setInteractionDTO(currentUserId,
					currentStaffId, interactionForm, tafaregion);
			interactionService.updateInteraction(interaction);

			String userName = (String) session
					.getAttribute(Constants.COMPLETE_USER_NAME);
			InteractionsManager manager = new InteractionsManager();
			String staffId = null;
			if (session.getAttribute(Constants.CURRENT_STAFF_ID) != null) {
				staffId = (String) session
						.getAttribute(Constants.CURRENT_STAFF_ID);
			}
			// saves into Kol_development_plan
			manager.saveDevPaln(interactionForm.getAssessment(), currentUserId,
					interaction.getKolIdArr(), userName, staffId, interaction
							.getInteractionDate());

			// saves into Interaction_tactics
			manager.saveInteractionTactics(interaction.getId(), interactionForm
					.getAssessment());
			// update all attendees (kols + others)
			String[] attendeeList = request.getParameterValues("attendeeList");
			Attendee[] attendeeSet = new Attendee[attendeeList.length];
			Attendee attendee = new Attendee();
			int otherIdLen = 0;
			String userId = "";

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
					attendee.setSsoid(userId);
					attendee.setName(attendeeList[i].split("_")[2]);
					attendee.setSsname(attendeeList[i].split("_")[3]);
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
					otherIdLen = attendeeList[i].length();
					int firstbraceIndex = attendeeList[i].indexOf("(", 4);
					attendee.setName(attendeeList[i].substring(4,
							firstbraceIndex));

					attendee.setFirstName(attendeeList[i].split("_")[1]);
					attendee.setLastName(attendeeList[i].substring(
							4 + 1 + attendeeList[i].split("_")[1].length(),
							firstbraceIndex));

					String othDetails = attendeeList[i].substring(
							firstbraceIndex, otherIdLen);
					StringTokenizer st = new StringTokenizer(othDetails, "()");
					while (st.hasMoreTokens()) {
						attendee.setType(st.nextToken());
						attendee.setTa(st.nextToken());
						attendee.setTitle(st.nextToken());
						attendee.setState(st.nextToken());
						attendee.setCity(st.nextToken());
						attendee.setZip(st.nextToken());
					}

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


			interaction = interactionService
					.getInteraction(interaction.getId());

			attendeeSet = attendeeService.getAllAttendees(interaction.getId());
			Set attendees = new HashSet();
			for (int i = 0; i < attendeeSet.length; i++) {
				attendees.add(attendeeSet[i]);
			}

			interaction.setAttendees(attendees);
			
			Set interactionSet = new HashSet();
			System.out.println("Update Scienti Topics");
			updateInteractionDataObjectsSetFromLovs(request,"scientificTopics","Scientific Topics",interaction,interactionSet);
			System.out.println("update Interaction Activity");
			updateInteractionDataObjectsSetFromLovs(request,"interactionActivityList","Interaction Activity",interaction,interactionSet);
			System.out.println("update product");
            updateInteractionDataObjectsSetFromLovs(request,"productsList","Products",interaction,interactionSet);
			System.out.println("Update Other Scientific Topics");
			updateInteractionDataObjectsSetFromTextBox(request,"otherTopics","Other Scientific Topics",interaction,interactionSet);
			updateInteractionDataObjectsSetFromTextBox(request, "Description", "Description", interaction, interactionSet);
			System.out.println("Update other interaction activities");
			updateInteractionDataObjectsSetFromTextBox(request,"otherInteractionActivities","Other Interaction Activities",interaction,interactionSet);
			System.out.println("update leave behind materials");
            updateInteractionDataObjectsSetFromLovs(request,"materialsList","Materials",interaction,interactionSet);
			updateInteractionDataObjectFromCheckBox(request, "preCallCkBox", "Pre Call Plan", interaction, interactionSet);
			updateInteractionDataObjectForMedicalRequestPolicy(request, interaction, interactionSet);
            
			System.out.println("update tooleffectiveness");
			String[] toolEffectiveness = request
					.getParameterValues("toolAssessment");
			InteractionData[] toolEffectivenessDataSet = null;

			InteractionData toolEffData = null;
			OptionLookup tool = new OptionLookup();
			OptionLookup eff = new OptionLookup();
			String[] medicalRequest=request.getParameterValues("medicalRequest");
			InteractionData[] medicalRequestDataSet=null;
			System.out.println("medical request is "+medicalRequest);
			InteractionData medicalReqData=null;
			
			String Data=new String();
			OptionLookup prod=new OptionLookup();

			if (null != medicalRequest && medicalRequest.length > 0) {
				medicalRequestDataSet = new InteractionData[medicalRequest.length];
				for (int i = 0; i < medicalRequest.length; i++) {
					String[] medicalReq = medicalRequest[i].split("@");
                    medicalReqData = new InteractionData();
					prod = optionServiceWrapper.getValuesForId(Long
							.parseLong(medicalReq[0]));
					
			        Data= (medicalReq.length < 2? "":medicalReq[1]) +"@"+ (medicalReq.length < 3? "":medicalReq[2]);
			        System.out.println("data is "+Data);
					medicalReqData.setLovId(prod);
					medicalReqData.setData(Data);
					medicalReqData.setType("MedicalRequest");
					medicalReqData.setInteraction(interaction);
					medicalRequestDataSet[i] = medicalReqData;
				}
			}else{
        medicalRequestDataSet = new InteractionData[0];        
      }
			interactionDataService.updateInteractionData(interaction.getId(),
					medicalRequestDataSet, "MedicalRequest");
			medicalRequestDataSet = interactionDataService.getAllDataOnType(
					interaction.getId(), "MedicalRequest");
			for (int i = 0; i < medicalRequestDataSet.length; i++)
				interactionSet.add(medicalRequestDataSet[i]);
			interaction.setInteractionData(interactionSet);

			
			if (null != toolEffectiveness && toolEffectiveness.length > 0) {
				toolEffectivenessDataSet = new InteractionData[toolEffectiveness.length];
				for (int i = 0; i < toolEffectiveness.length; i++) {
					String[] toolEff = toolEffectiveness[i].split("_");
					toolEffData = new InteractionData();
					tool = optionServiceWrapper.getValuesForId(Long
							.parseLong(toolEff[0]));
					eff = optionServiceWrapper.getValuesForId(Long
							.parseLong(toolEff[1]));
					toolEffData.setLovId(tool);
					toolEffData.setStatusId(eff);
					toolEffData.setType("ToolEffectiveness");
					toolEffData.setInteraction(interaction);
					toolEffectivenessDataSet[i] = toolEffData;
				}
			}
			interactionDataService.updateInteractionData(interaction.getId(),
					toolEffectivenessDataSet, "ToolEffectiveness");
			toolEffectivenessDataSet = interactionDataService.getAllDataOnType(
					interaction.getId(), "ToolEffectiveness");
			for (int i = 0; i < toolEffectivenessDataSet.length; i++)
				interactionSet.add(toolEffectivenessDataSet[i]);
			interaction.setInteractionData(interactionSet);

			
			String[] assessment = interaction.getIntAssessList();

			String[] plaText = new String[assessment.length];
			for (int i = 0; i < assessment.length; i++) {
				String finalAssessText = getAssessmentText(assessment[i], Long
						.toString(currentUserId));

				plaText[i] = assessment[i] + "1122" + finalAssessText;

			}
			interaction.setIntAssessList(plaText);
			session.setAttribute("MESSAGE","Interaction details updated successfully");
			session.setAttribute("INTERACTION_DETAILS", interaction);

			if (ActionKeys.PROFILE_UPDATE_INTERACTION.equalsIgnoreCase(action)) {
				return new ModelAndView("show_profile_interaction");
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

			interactionService.deleteInteraction(interaction);

			String from = "";
			if (request.getParameter("from") != null) {
				from = request.getParameter("from");
			}

			if ("olProfile".equalsIgnoreCase(from)) {

				String kolId = (String) session
						.getAttribute(Constants.CURRENT_KOL_ID);
				if (null != kolId && !"".equals(kolId)) {
					Interaction[] interactions = interactionService
							.getAllInteractionByExpert(Long.parseLong(kolId));
					Interaction[] finalInteractions = null;
					Set set = null;
					long userId = 0;
					if (interactions != null && interactions.length > 0) {
						Interaction tempInteraction = null;
						finalInteractions = new Interaction[interactions.length];
						Attendee[] attendees = null;
						User[] users = new User[interactions.length];
						for (int i = 0; i < interactions.length; i++) {
							tempInteraction = interactions[i];
							attendees = attendeeService
									.getAllAttendees(tempInteraction.getId());
							set = new HashSet();
							set.add(attendees);
							tempInteraction.setAttendees(set);
							finalInteractions[i] = tempInteraction;
							userId = tempInteraction.getUserId();
							users[i] = userService.getUser(userId);
						}
						session.setAttribute("USER_OBJECT", users);
					}

					session.setAttribute("KOL_INTERACTIONS", finalInteractions);
				}
				return new ModelAndView("kol_interactions");
			} else {

				String[] interactionIds = null;
				SimpleDateFormat sdf = new SimpleDateFormat(
						ActionKeys.CALENDAR_DATE_FORMAT);
				java.util.Date fromDate = null;
				if (null != request.getParameter("fromDate")
						&& !"".equals(request.getParameter("fromDate"))) {
					fromDate = sdf.parse(request.getParameter("fromDate"));
					request.setAttribute("FROM_DATE", request
							.getParameter("fromDate"));
				}
				java.util.Date toDate = null;
				if (null != request.getParameter("toDate")
						&& !"".equals(request.getParameter("toDate"))) {
					toDate = sdf.parse(request.getParameter("toDate"));
					request.setAttribute("TO_DATE", request
							.getParameter("toDate"));
				}
				String kolName = null;
				if (null != request.getParameter("kolName")
						&& !"".equals(request.getParameter("kolName"))) {
					kolName = request.getParameter("kolName");
					request.setAttribute("KOL_NAME", kolName);
				}

				String userName = null;
				if (null != request.getParameter("userName")
						&& !"".equals(request.getParameter("userName"))) {
					userName = request.getParameter("userName");
					request.setAttribute("USER_NAME", userName);
				}
				String staffId = "0";
				if (null != request.getParameter("staffId")
						&& request.getParameter("staffId").length() > 0) {
					staffId = request.getParameter("staffId");
					request.setAttribute("CURRENT_STAFF_ID", staffId);
				}
				/* if (fromDate != null && toDate != null) { */
				if (null == fromDate && null == toDate && null == userName
						&& null == kolName) {
					interactionIds = interactionService.getAllInteractions();
				} else {
					interactionIds = interactionService
							.getInteractionByDateAndUser(fromDate, toDate,
									staffId, userName, kolName);
				}
				Interaction[] interactions = null;
				long userId = 0;
				if (null != interactionIds && !"".equals(interactionIds)
						&& interactionIds.length > 0) {
					interaction = null;
					String intId = null;
					interactions = new Interaction[interactionIds.length];
					Set set = null;
					User[] users = new User[interactions.length];
					for (int i = 0; i < interactionIds.length; i++) {
						intId = interactionIds[i];
						if (null != intId) {
							interaction = interactionService
									.getInteraction(Long.parseLong(intId));
							Attendee[] attendees = attendeeService
									.getAllAttendees(interaction.getId());
							set = new HashSet();
							set.add(attendees);
							interaction.setAttendees(set);
							interactions[i] = interaction;
							userId = interaction.getUserId();
							users[i] = userService.getUser(userId);
						}
					}
					session.setAttribute("USER_OBJECT", users);
					// }
					session.setAttribute("INTERACTION_SEARCH_RESULT",
							interactions);
				}
				return new ModelAndView("search_interaction_main");

			} // end of if ("olProfile".equalsIgnoreCase(from))

		} else if (ActionKeys.SEARCH_ORG.equalsIgnoreCase(action)
				|| ActionKeys.SEARCH_ORG_ON_PROFILE.equals(action)) {

			String searchText = request.getParameter("searchText");

			Organization[] orgs = orgService.searchOrganizations(searchText);
			session.setAttribute("orgs", orgs);
			session.setAttribute("SEARCH_TEXT", searchText);
			if (action.equals(ActionKeys.SEARCH_ORG_ON_PROFILE))
				return new ModelAndView("profile_org_search");

			return new ModelAndView("interaction_org_search");

		} // end of ActionKeys

		return new ModelAndView("add_interaction_main");

	} // end of processFormSubmission()

	public String getAssessmentText(String plannedInteractionVal, String userId) {
		String[] ids = plannedInteractionVal.split("_");
		if (ids != null && ids.length > 0) {

			String PIText = getPlannedInteractionText(Long.parseLong(ids[0]),
					userId);
			String status = getAssessmentStatus(Long.parseLong(ids[1]));

			return PIText + " (" + status + ")";
		}
		return "";
	}

	public String getAssessmentStatus(long tacticId) {
		OptionLookup[] plaInt;
		String plaIntText = null;
		plaInt = optionServiceWrapper.getValuesForOptionName(PropertyReader
				.getLOVConstantValueFor("STATUS"));
		for (int i = 0; i < plaInt.length; i++) {
			OptionLookup planInt = plaInt[i];
			long plaIntId = planInt.getId();
			if (tacticId == plaIntId) {
				plaIntText = planInt.getOptValue();
				break;
			}
		}
		return plaIntText;
	}

	public String getPlannedInteractionText(long optionId, String userId) {
		OptionLookup[] plaInt;
		String plaIntText = null;
		try {
			plaInt = getPlannedInteractions(userId);
			for (int i = 0; plaInt != null && i < plaInt.length; i++) {
				OptionLookup planInt = plaInt[i];
				long plaIntId = planInt.getId();
				if (optionId == plaIntId) {
					plaIntText = planInt.getOptValue();
					break;
				}
			}
			return plaIntText;
		} catch (ManagerException e) {
			e.printStackTrace();
		}
		return "";
	}

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

	public Interaction setInteractionDTO(long currentUserId,
			long currentStaffId, InteractionForm interactionForm,
			String tafaregion) throws Exception {

		System.out.println("Station 3: In set InteractionDTO");
		Interaction interaction = null;
		try {

			interaction = new Interaction();
			
			// set interaction id
			System.out.println("1");
			if (interactionForm.getInteractionId() != 0) {
				interaction.setId(interactionForm.getInteractionId());
			}

			// set user id
			System.out.println("2");
			interaction.setUserId(currentUserId);
			interaction.setStaffId(currentStaffId);

			// set Group details
			System.out.println("3");
			if(tafaregion != null)
			{
				String[] tafaregionIds = tafaregion.split("_");
				if(tafaregionIds.length>0)
				{
					interaction.setTa(Long.parseLong(tafaregionIds[0]));
					interaction.setFa(Long.parseLong(tafaregionIds[1]));
					interaction.setRegion(Long.parseLong(tafaregionIds[2]));
				}
			}

			// set interaction type
			System.out.println("4");
			OptionLookup interactionTypeOption = new OptionLookup();
			OptionLookup interactionTypeOptionArr[] = optionServiceWrapper
					.getValuesForOptionName(PropertyReader
							.getLOVConstantValueFor("INTERACTION_TYPE"));// 4 is
			// for
			// InteractionTypeId
			if (interactionTypeOptionArr != null
					&& interactionTypeOptionArr.length > 0) {
				interactionTypeOption.setOptionId(interactionTypeOptionArr[0]
						.getOptionId());
				interactionTypeOption.setId(Long.parseLong(interactionForm
						.getInteractionType()));
				if (null != interactionTypeOptionArr
						&& interactionTypeOptionArr.length > 0) {
					OptionLookup lookup = null;
					for (int i = 0; i < interactionTypeOptionArr.length; i++) {
						lookup = interactionTypeOptionArr[i];
						if (lookup.getId() == Long.parseLong(interactionForm
								.getInteractionType())) {
							interactionTypeOption.setOptValue(lookup
									.getOptValue());
						}
					}
				}
			}
			interaction.setType(interactionTypeOption);

			// set interaction date
			String interactionDate = interactionForm.getInteractionDate();
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
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
			System.out.println("st 1");
			interaction.setKolIdArr(kolIdList);
			// set expense type
            OptionLookup expenseTypeOption = new OptionLookup();
            OptionLookup expenseTypeOptionArr[] = optionServiceWrapper.getValuesForOptionName("Expense Type");
            if (expenseTypeOptionArr != null && expenseTypeOptionArr.length > 0) {
                expenseTypeOption.setOptionId(expenseTypeOptionArr[0].getOptionId());
               if(interactionForm.getExpenseType()!=null){
                expenseTypeOption.setId(Long.parseLong(interactionForm.getExpenseType()));

                if (null != expenseTypeOptionArr && expenseTypeOptionArr.length > 0) {
                    OptionLookup lookup = null;
                    for (int i = 0; i < expenseTypeOptionArr.length; i++) {
                        lookup = expenseTypeOptionArr[i];
                        if (lookup.getId() == Long.parseLong(interactionForm.getExpenseType())) {
                            expenseTypeOption.setOptValue(lookup.getOptValue());
                        }
                    }
                  
              }
                interaction.setExpenseType(expenseTypeOption);
             }
            }   
            System.out.println("st 1.1");
           //set expense ammount
            interaction.setAmount(interactionForm.getAmount());
          // set expense venue
            OptionLookup expenseVenueOption = new OptionLookup();
            OptionLookup expenseVenueOptions[] = optionServiceWrapper.getValuesForOptionName("Expense Venue");
            if (expenseVenueOptions != null && expenseVenueOptions.length > 0) {
            	System.out.println("st 1.1.05");
            	System.out.println("option id="+expenseVenueOptions[0].getOptionId());
                expenseVenueOption.setOptionId(expenseVenueOptions[0].getOptionId());
              if(interactionForm.getExpenseVenue()!=null){
                expenseVenueOption.setId(Long.parseLong(interactionForm.getExpenseVenue()));
              
                System.out.println("st 1.1.1");
                if (null != expenseVenueOptions && expenseVenueOptions.length > 0) {
                    OptionLookup lookup = null;
                    for (int i = 0; i < expenseVenueOptions.length; i++) {
                        lookup = expenseVenueOptions[i];
                        if (lookup.getId() == Long.parseLong(interactionForm.getExpenseVenue()!=null?interactionForm.getExpenseVenue():"0")) {
                            expenseVenueOption.setOptValue(lookup.getOptValue());
                        }
                     }
                 
                }
                interaction.setExpenseVenue(expenseVenueOption);
              }
            }  
            System.out.println("st 1.2");
            //set sim
            OptionLookup simTypeOption = new OptionLookup();
            OptionLookup simTypeOptionArr[] = optionServiceWrapper.getValuesForOptionAndUser("SIM", currentUserId);// 8 is for SimId
            if (simTypeOptionArr != null && simTypeOptionArr.length > 0) {
            	System.out.println("st 1.2.0");
                simTypeOption.setOptionId(simTypeOptionArr[0].getOptionId());
                if(interactionForm.getSim()!=null){
                	System.out.println("st 1.4"+interactionForm.getSim());
                simTypeOption.setId(Long.parseLong(interactionForm.getSim()));
                System.out.println("st 1.5");
                if (null != simTypeOptionArr && simTypeOptionArr.length > 0) {
                    OptionLookup lookup = null;
                    for (int i = 0; i < simTypeOptionArr.length; i++) {
                        lookup = simTypeOptionArr[i];
                        if (lookup.getId() == Long.parseLong(interactionForm.getSim())) {
                            simTypeOption.setOptValue(lookup.getOptValue());
                        }
                    }
                  }
                  
               interaction.setSim(simTypeOption);
              }
            }   
            System.out.println("st 1.3");
            OptionLookup productTypeOption = new OptionLookup();
            OptionLookup productTypeOptionArr[] = optionServiceWrapper.getValuesForOptionAndUser(PropertyReader.getLOVConstantValueFor("PRODUCT"), currentUserId);// 8 is for SimId
            if (productTypeOptionArr != null && productTypeOptionArr.length > 0) {
                productTypeOption.setOptionId(productTypeOptionArr[0].getOptionId());
                if(interactionForm.getProduct()!=null){
                productTypeOption.setId(Long.parseLong(interactionForm.getProduct()));
                if (null != productTypeOptionArr && productTypeOptionArr.length > 0) {
                    OptionLookup lookup = null;
                    for (int i = 0; i < productTypeOptionArr.length; i++) {
                        lookup = productTypeOptionArr[i];
                        if (lookup.getId() == Long.parseLong(interactionForm.getProduct())) {
                            productTypeOption.setOptValue(lookup.getOptValue());
                        }
                    }
                  }
                  
               interaction.setProduct(productTypeOption);
              }
            } 
            System.out.println("st 1.3");
            //set site followup
            OptionLookup siteFollowUpTypeOption = new OptionLookup();
            OptionLookup siteFollowUpTypeOptionArr[] = optionServiceWrapper.getValuesForOptionAndUser("Site Follow Up", currentUserId);// 9 is for SiteFollowUpId
            if (siteFollowUpTypeOptionArr != null && siteFollowUpTypeOptionArr.length > 0) {
                siteFollowUpTypeOption.setOptionId(siteFollowUpTypeOptionArr[0].getOptionId());
                if(interactionForm.getSiteFollowUp()!=null){
                siteFollowUpTypeOption.setId(Long.parseLong(interactionForm.getSiteFollowUp()));
                if (null != siteFollowUpTypeOptionArr && siteFollowUpTypeOptionArr.length > 0) {
                    OptionLookup lookup = null;
                    for (int i = 0; i < siteFollowUpTypeOptionArr.length; i++) {
                        lookup = siteFollowUpTypeOptionArr[i];
                        if (lookup.getId() == Long.parseLong(interactionForm.getSiteFollowUp())) {
                            siteFollowUpTypeOption.setOptValue(lookup.getOptValue());
                        }
                    }
               //   }
                }
                interaction.setSiteFollow(siteFollowUpTypeOption);
               }
            }
            System.out.println("st 1.4");
            
            //set assessment
            System.out.println("st 2");
            
            String[] assessment = interactionForm.getAssessment();

            if(assessment != null && assessment.length>0) {

                interaction.setIntAssessList(assessment);

            }
           System.out.println("st 3");
            //get leterature
            if(interactionForm.getLiterature()!=null){
            interaction.setLiterature(interactionForm.getLiterature());
            }
            if(interactionForm.getPhysician()!=null){
            	interaction.setPhysician(interactionForm.getPhysician());
            }
            if(interactionForm.getRequest()!=null){
            	interaction.setRequest(interactionForm.getRequest());
            }
            System.out.println("st 4");

			interaction.setCreateTime(new Date(System.currentTimeMillis()));
			interaction.setUpdateTime(new Date(System.currentTimeMillis()));
			interaction.setDeleteFlag("N");

            System.out.println("st 5");
			

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
	
	void addObjectsToInteractionDataSet(Interaction interaction,String type, Set interactionSet)
	{
		InteractionData[] interactionDataListForType = interactionDataService.getAllDataOnType(interaction.getId(), type);
        if (null != interactionDataListForType && interactionDataListForType.length > 0)
	        for (int i = 0; i < interactionDataListForType.length; i++)
		       interactionSet.add(interactionDataListForType[i]);
        interaction.setInteractionData(interactionSet);
 	}
	
	void createInteractionDataObjectsSetFromTextBox(HttpServletRequest request, String formFieldName, String type, Interaction interaction, Set interactionSet)
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
	
	/**
	 * This method is specialy written fo BI Demo.It will be used only if medical reqest block has policies ans yes/no dropdowns
	 * @param request
	 * @param interaction
	 * @param interactionSet
	 */
	void createInteractionDataObjectSetForMedicalRequestPolicy(HttpServletRequest request,Interaction interaction,Set interactionSet){
		String valueFromYesNoDropDown=request.getParameter("yes_no");
		String valueFromFirstDropDown=request.getParameter("yes_no1");
		String valueFromSecDropDown=request.getParameter("yes_no2");
		if(valueFromFirstDropDown!=null && valueFromSecDropDown!=null){
			String data=valueFromYesNoDropDown+"@"+valueFromFirstDropDown+"@"+valueFromSecDropDown;
			InteractionData interactionData=new InteractionData();
			interactionData.setType("Unsolicited Medical Request");
			interactionData.setInteraction(interaction);
			interactionData.setData(data);
			interactionDataService.saveInteractionData(interactionData);
			addObjectsToInteractionDataSet(interaction,"Unsolicited Medical Request",interactionSet);
		}	
	}
	/**
	 * This method is used to create an interaction data object for check boxes in interaction form page.
	 * @param request
	 * @param ckBoxFieldName
	 * @param type 
	 * @param interaction
	 * @param interactionSet
	 */
	void createInteractionDataObjectsetFromCheckBox(HttpServletRequest request, String ckBoxFieldName, String type, Interaction interaction,Set interactionSet){
		String valueFromCheckBox=request.getParameter(ckBoxFieldName);
		System.out.println("value for checkbox is "+valueFromCheckBox);
		InteractionData interactionData=new InteractionData();
		interactionData.setType(type);
		interactionData.setInteraction(interaction);
		//Set true in data field if checkbox is selected else set false
		interactionData.setData(valueFromCheckBox);
		interactionDataService.saveInteractionData(interactionData);
		addObjectsToInteractionDataSet(interaction,type,interactionSet);
				
	}
	
	void createInteractionDataObjectsSetFromLovs(HttpServletRequest request, String formFieldName, String type, Interaction interaction, Set interactionSet) {
		String[] valuesFromDropdown = request.getParameterValues(formFieldName);
		InteractionData interactionData ;
		OptionLookup lookup = new OptionLookup();
		if (null != valuesFromDropdown && valuesFromDropdown.length > 0) {
			for (int i = 0; i < valuesFromDropdown.length; i++) {
				interactionData = new InteractionData();
				lookup = optionServiceWrapper.getValuesForId(Long
						.parseLong(valuesFromDropdown[i]));
				interactionData.setLovId(lookup);
				interactionData.setType(type);
				interactionData.setInteraction(interaction);
				interactionDataService.saveInteractionData(interactionData);
			}
				//TODO before or after }}??????????
				addObjectsToInteractionDataSet(interaction, type, interactionSet);
		}
	}
	
	void updateInteractionDataObjectsSetFromLovs(HttpServletRequest request, String formFieldName, String type, Interaction interaction, Set interactionSet) {
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
						.parseLong(valuesFromDropdown[i]));
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
		OptionLookup lookup = new OptionLookup();
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
	
	/**
	 * A method used to update the value of check bos in interactino page form.
	 * @param request
	 * @param ckBoxFieldName
	 * @param type
	 * @param interaction
	 * @param interactionSet
	 */
	void updateInteractionDataObjectFromCheckBox(HttpServletRequest request,String ckBoxFieldName,String type,Interaction interaction, Set interactionSet){
		String valueFromCheakBox=request.getParameter(ckBoxFieldName);
		System.out.println("in update");
		InteractionData[] interactionDataSet=null;
		InteractionData interactionData=new InteractionData();
		interactionDataSet=new InteractionData[1];
		interactionData = new InteractionData();
		interactionData.setType(type);
		interactionData.setInteraction(interaction);
		interactionData.setData(valueFromCheakBox);
		System.out.println("value fromcheck box is "+valueFromCheakBox);
		interactionDataSet[0]=interactionData;
		System.out.println("data now is "+interactionDataSet[0].getData());
		interactionDataService.updateInteractionData(interaction.getId(),interactionDataSet,type);
		interactionDataSet= interactionDataService.getAllDataOnType(interaction.getId(),type);
		if(interactionDataSet != null && interactionDataSet.length>0)
		    for (int i = 0; i < interactionDataSet.length; i++)
			    interactionSet.add(interactionDataSet[i]);
		interaction.setInteractionData(interactionSet);
	}
	
	/**
	 * This method is used for updating madical request policy.Right this is only used for BI Demo
	 * @param request
	 * @param interaction
	 * @param interactionSet
	 */
	void updateInteractionDataObjectForMedicalRequestPolicy(HttpServletRequest request,Interaction interaction,Set interactionSet){
		String valueFromFirstDropDown=request.getParameter("yes_no1");
		String valueFromYesNoDropDown=request.getParameter("yes_no");
		String valueFromSecDropDown=request.getParameter("yes_no2");
		if(valueFromYesNoDropDown.equalsIgnoreCase("no")){
			 valueFromFirstDropDown="no";
			 valueFromSecDropDown="no";
		}
			String data=valueFromYesNoDropDown+"@"+valueFromFirstDropDown +"@" +valueFromSecDropDown;
			InteractionData[] interactionDataSet=null;
			InteractionData interactionData=new InteractionData();
			interactionDataSet=new InteractionData[1];
			interactionData = new InteractionData();
			interactionData.setType("Unsolicited Medical Request");
			interactionData.setInteraction(interaction);
			interactionData.setData(data);
			interactionDataSet[0]=interactionData;
			interactionDataService.updateInteractionData(interaction.getId(),interactionDataSet,"Unsolicited Medical Request");
			interactionDataSet= interactionDataService.getAllDataOnType(interaction.getId(),"Unsolicited Medical Request");
			if(interactionDataSet != null && interactionDataSet.length>0)
			    for (int i = 0; i < interactionDataSet.length; i++)
				    interactionSet.add(interactionDataSet[i]);
			interaction.setInteractionData(interactionSet);
		
		
		
	}
	
	OptionLookup[] getValuesForOptionName(String optionNameInLovConstantsFile)
	{
		return(optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor(optionNameInLovConstantsFile)));
	}
	
	OptionLookup[] getValuesForOptionAndUser(String optionNameInLovConstantsFile, long userId)
	{
		return(optionServiceWrapper.getValuesForOptionAndUser(PropertyReader.getLOVConstantValueFor(optionNameInLovConstantsFile),userId));
	}
} // end of class
