package com.openq.web.controllers;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.interaction.IInteractionService;
import com.openq.interaction.InteractionTripletSectionMap;
import com.openq.kol.KOLManager;
import com.openq.survey.ISurveyService;
import com.openq.survey.NewSurvey;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;

public class InteractionsController extends AbstractController {

	IOptionService optionService;

	IOptionServiceWrapper optionServiceWrapper;

	ISurveyService surveyService;
	IInteractionService interactionService;
	/**
	 * @return the interactionService
	 */
	public IInteractionService getInteractionService() {
		return interactionService;
	}
	/**
	 * @param interactionService the interactionService to set
	 */
	public void setInteractionService(IInteractionService interactionService) {
		this.interactionService = interactionService;
	}
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

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		if(session.getAttribute("INTERACTION_LOVTRIPLET_SECTION") == null){
			InteractionTripletSectionMap []  interactionTripletSectionArray = interactionService.getInteractionTripletSectionMap();
			if(interactionTripletSectionArray != null && interactionTripletSectionArray.length > 0){
				Map interactionTripletSectionMap = new HashMap();
				for (int i = 0; i < interactionTripletSectionArray.length; i++) {
					if(interactionTripletSectionArray[i] != null && 
							interactionTripletSectionArray[i].getPrimaryLOVId() != 0 &&
							interactionTripletSectionArray[i].getSecondaryLOVId() != 0 &&
							interactionTripletSectionArray[i].getTertiaryLOVId() != 0){
							String tripletKey = interactionTripletSectionArray[i].getPrimaryLOVId() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES +
											    interactionTripletSectionArray[i].getSecondaryLOVId() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES +
											    interactionTripletSectionArray[i].getTertiaryLOVId();
							String sectionValue = interactionTripletSectionArray[i].getSection();
							if (!interactionTripletSectionMap.containsKey(tripletKey))
								interactionTripletSectionMap.put(tripletKey, sectionValue);
					}
				}
				session.setAttribute("INTERACTION_LOVTRIPLET_SECTION_MAP", interactionTripletSectionMap);
			}
		}
		long userType=-1;
		OptionLookup userTypeLookup = (OptionLookup) session
		.getAttribute(Constants.USER_TYPE);
		if(null !=userTypeLookup){
			userType = userTypeLookup.getId();
		}
		String userTypeText = userTypeLookup.getOptValue();
		session.removeAttribute("relatedEventEntity");
		session.setAttribute("CURRENT_LINK", "INTERACTIONS");
		String userGroupIdString = (String) request.getSession().getAttribute(
				Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		
		if (userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString)){
			userGroupId = Long.parseLong(userGroupIdString);
		}
		
		if (userTypeText != null && userTypeText.equalsIgnoreCase("Viewer")) {
			return new ModelAndView("search_interaction_main");
		}

		String action = (String) request.getParameter("action");
		String userId = "";
		if (request.getSession().getAttribute(Constants.CURRENT_USER) != null) {
			userId = (String) session.getAttribute(Constants.USER_ID);

		}
		if(!ActionKeys.BACK_TO_SEARCH_RESULTS.equalsIgnoreCase(action)){
		    session.removeAttribute("INTERACTION_SEARCH_RESULT");
		    session.removeAttribute("INTERACTION_SEARCH_PARAMETER_MAP");
		}
		session.removeAttribute("SURVEY_EXPERTS");
		session.removeAttribute("ATTENDEES_MAP");
		if (session.getAttribute("ALL_SURVEYS") == null) {
			NewSurvey[] totalSurveys = surveyService.getAllLaunchedSurveysByType(userGroupId, userType, Constants.SURVEY_TYPE_INTERACTIONS);
			session.setAttribute("ALL_SURVEYS", totalSurveys);
		}

		if (ActionKeys.SHOW_ADD_INTERACTION.equalsIgnoreCase(action)
				|| ActionKeys.PROFILE_SHOW_ADD_INTERACTION
				.equalsIgnoreCase(action)) {
			
			session.setAttribute(Constants.INTERACTION_PROFILE_KOLID, request.getParameter("kolId"));
			session.setAttribute(Constants.INTERACTION_PROFILE_EXPERTID, request.getParameter("expertId"));
			
			session.setAttribute("INTERACTION_TYPE", optionServiceWrapper
					.getValuesForOptionName(PropertyReader
							.getLOVConstantValueFor("INTERACTION_TYPE"),
							userGroupId));
			session.setAttribute("PRODUCTS", optionServiceWrapper
					.getValuesForOptionAndUser(PropertyReader
							.getLOVConstantValueFor("PRODUCT"), Long
							.parseLong(userId), userGroupId));
			session.setAttribute("OFF_LABEL_PRODUCTS", optionServiceWrapper
					.getValuesForOptionAndUser(PropertyReader
							.getLOVConstantValueFor("OFF_LABEL_PRODUCT"), Long
							.parseLong(userId), userGroupId));
			session.setAttribute("ATTENDEE_TYPE", optionServiceWrapper
					.getValuesForOptionName(PropertyReader
							.getLOVConstantValueFor("ATTENDEE_TYPE"),
							userGroupId));

			session.setAttribute("EDUCATIONAL_OBJECTIVE_ASSESSMENT", optionServiceWrapper
					.getValuesForOptionName(PropertyReader
							.getLOVConstantValueFor("EDUCATIONAL_OBJECTIVE_ASSESSMENT"),
							userGroupId));
			
			if (userId != null && !"".equals(userId)) {
				KOLManager kolManager = new KOLManager();
				HashMap tacticMap = kolManager.getMatchedTaFaRegion(Long
						.parseLong(userId));
				if (!tacticMap.isEmpty()) {
					OptionLookup lookup[] = new OptionLookup[tacticMap.size()];
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
					session.setAttribute("PLANNED_INTERACTION", lookup);
				}
			}
			String orgId = null;
			if (null != request.getParameter("entityId")) {
				orgId = request.getParameter("entityId");
			} else if (null != session.getAttribute("ORGID")) {
				orgId = (String) session.getAttribute("ORGID");
			}
			if (null != orgId) {
				session.setAttribute("ORG_LINK", "YES");
			} else {
				session.setAttribute("ORG_LINK", "NO");
			}
			session.setAttribute("CURRENT_LINK", "INTERACTIONS");
			/*
			 * <selcting path> 
			 * the following code is for directing on one of the two pages
			 * namely : add_interaction_profile_main
			 * 		   add_interaction_main
			 * */
			request.setAttribute("ACTION", action);
			//return new ModelAndView("show_profile_interaction");

			
				return new ModelAndView("add_interaction_main");// in either action open this page..as iframe is not in use now.
			

			/*
			 * </selecting path>
			 * */

		}

		return new ModelAndView("search_interaction_main");

	}

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

}
