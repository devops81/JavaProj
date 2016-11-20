package com.openq.web.controllers;

import com.openq.eav.data.IDataService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.org.IOrgOlMapService;
import com.openq.eav.org.OrgOlMap;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;
import com.openq.web.forms.AdvancedSearchForm;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * User: abhrap
 * Date: Nov 8, 2006
 * Time: 11:44:36 AM
 */
public class AdvanceSearchController extends SimpleFormController {
	
    private static Logger logger = Logger.getLogger(AdvanceSearchController.class);
	private IOrgOlMapService orgOlMapService;
	private IUserService userService;
	
    protected ModelAndView showForm(HttpServletRequest httpServletRequest,
                                    HttpServletResponse httpServletResponse,
                                    BindException bindException) throws Exception {
        return null;
    }

    protected ModelAndView processFormSubmission(HttpServletRequest request,
                                                 HttpServletResponse response,
                                                 Object object, BindException exception) throws Exception {
        HttpSession session = request.getSession();

        AdvancedSearchForm advancedSearchForm = (AdvancedSearchForm) object;
        String action = (String) request.getParameter("action");
        ModelAndView mav = new ModelAndView("advsearch");
        String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
        if(session.getAttribute("INVITED_USERS")!=null){
    		session.setAttribute("INVITED_USERS", session.getAttribute("INVITED_USERS"));
    		System.out.println("in adv search controller invited users size : " +((User [])session.getAttribute("INVITED_USERS")).length);
    	}
        if(session.getAttribute("invitedOl")!=null){
    		session.setAttribute("invitedOl", session.getAttribute("invitedOl"));
    		System.out.println("In advanced search controller invited users is not null value : " +  session.getAttribute("invitedOl"));
    	}
        session.setAttribute("THERAPAUTIC_AREA",  optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
        session.setAttribute("TIER", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("TIER"), userGroupId));
        session.setAttribute("TOPIC_EXPERTIS", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("TOPIC_EXPERTISE"), userGroupId));
        session.setAttribute("SPECIALTY", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("SPECIALTY"), userGroupId));
        session.setAttribute("PLATFORM", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("PLATFORM"), userGroupId));
        session.setAttribute("PUBLICATION", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("PUBLICATION"), userGroupId));
        session.setAttribute("RESEARCH", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("RESEARCH"), userGroupId));
        session.setAttribute("POS_AMGEN_SCIENCE", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("THERAPY"), userGroupId));
        session.setAttribute("COUNTRY_LIST",optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("COUNTRY"), userGroupId));
        session.setAttribute("STATE_LIST",optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("STATE_ABBREVIATION"), userGroupId));

        if (ActionKeys.ADV_SEARCH_USER.equals(action)) {
            session.removeAttribute("FROM_ADV_SEARCH");
            HashMap attrIDMap = new HashMap();
            System.out.println(" Organization-->"+advancedSearchForm.getOrganisation());
            if (null != advancedSearchForm.getOrganisation() && !"".equals(advancedSearchForm.getOrganisation())
                    && !"-1".equals(advancedSearchForm.getOrganisation())) {
                List orgOlList = getOLsBelongToAffilitedOrg(advancedSearchForm.getOrgEntityId());
                attrIDMap.put("ORG_OL_LIST", orgOlList);
            }
            if (null != advancedSearchForm.getAddress() && !"".equals(advancedSearchForm.getAddress())
                     && !"-1".equals(advancedSearchForm.getAddress())) {
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_LINE_1")).getAttribute_id()+"", advancedSearchForm.getAddress().trim());
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_LINE_1")).getAttribute_id()+"", advancedSearchForm.getAddress().trim());
            }
            if (null != advancedSearchForm.getCountry() && !"".equals(advancedSearchForm.getCountry())
                    && !"-1".equals(advancedSearchForm.getCountry())) {
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_COUNTRY")).getAttribute_id()+"", advancedSearchForm.getCountry());
            }
            if (null != advancedSearchForm.getState() && !"".equals(advancedSearchForm.getState())
                    && !"-1".equals(advancedSearchForm.getState())) {
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_STATE")).getAttribute_id()+"", advancedSearchForm.getState());
            }
            if (null != advancedSearchForm.getZip() && !"".equals(advancedSearchForm.getZip())
                    && !"-1".equals(advancedSearchForm.getZip())) {
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_ZIP")).getAttribute_id()+"", advancedSearchForm.getZip().trim());
            }
            if (null != advancedSearchForm.getAmgenContact() && !"".equals(advancedSearchForm.getAmgenContact())
                    && !"-1".equals(advancedSearchForm.getAmgenContact())) {
                attrIDMap.put(PropertyReader.getEavConstantValueFor("CUSTOMER_CONTACTS"), request.getParameter("staffId"));
            }
            if (null != advancedSearchForm.getTa() && !"".equals(advancedSearchForm.getTa()) &&
                    !"-1".equals(advancedSearchForm.getTa())) {
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("THERAPEUTIC_AREA")).getAttribute_id()+"", advancedSearchForm.getTa());
            }
            // TODO THERE CAN BE 2 
            if (null != advancedSearchForm.getTier() && !"".equals(advancedSearchForm.getTier()) &&
                    !"-1".equals(advancedSearchForm.getTier())) {
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("TIER")).getAttribute_id()+"", advancedSearchForm.getTier());
            }
            if (null != advancedSearchForm.getTopicExpertis() && !"".equals(advancedSearchForm.getTopicExpertis()) &&
                    !"-1".equals(advancedSearchForm.getTopicExpertis())) {
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("TOPIC_EXPERTISE")).getAttribute_id()+"", advancedSearchForm.getTopicExpertis());
            }
            if (null != advancedSearchForm.getSpecialty() && !"".equals(advancedSearchForm.getSpecialty()) &&
                    !"-1".equals(advancedSearchForm.getSpecialty())) {
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_1")).getAttribute_id()+"", advancedSearchForm.getSpecialty());
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_2")).getAttribute_id()+"", advancedSearchForm.getSpecialty());
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_3")).getAttribute_id()+"", advancedSearchForm.getSpecialty());
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_4")).getAttribute_id()+"", advancedSearchForm.getSpecialty());
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_5")).getAttribute_id()+"", advancedSearchForm.getSpecialty());
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_6")).getAttribute_id()+"", advancedSearchForm.getSpecialty());
            }
            if (null != advancedSearchForm.getPosAmgenScience() && !"".equals(advancedSearchForm.getPosAmgenScience()) &&
                    !"-1".equals(advancedSearchForm.getPosAmgenScience())) {
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("POSITION_TO_CUSTOMER_SCIENCE")).getAttribute_id()+"", advancedSearchForm.getPosAmgenScience());
            }
            if (null != advancedSearchForm.getPlatform() && !"".equals(advancedSearchForm.getPlatform()) &&
                    !"-1".equals(advancedSearchForm.getPlatform())) {
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("PLATFORM")).getAttribute_id()+"", advancedSearchForm.getPlatform());
            }
            if (null != advancedSearchForm.getPublication() && !"".equals(advancedSearchForm.getPublication()) &&
                    !"-1".equals(advancedSearchForm.getPublication())) {
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("PUBLICATION")).getAttribute_id()+"", advancedSearchForm.getPublication());
            }
            if (null != advancedSearchForm.getResearch() && !"".equals(advancedSearchForm.getResearch()) &&
                    !"-1".equals(advancedSearchForm.getResearch())) {
                attrIDMap.put(dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("RESEARCH")).getAttribute_id()+"", advancedSearchForm.getResearch());
            }
            if (null != advancedSearchForm.getLastName() && !"".equals(advancedSearchForm.getLastName())) {
                attrIDMap.put(PropertyReader.getEavConstantValueFor("LAST_NAME"), advancedSearchForm.getLastName().trim());
            }
            if (null != advancedSearchForm.getFirstName() && !"".equals(advancedSearchForm.getFirstName())) {
                attrIDMap.put(PropertyReader.getEavConstantValueFor("FIRST_NAME"), advancedSearchForm.getFirstName().trim());
            }
           
            logger.debug("Starting search query : " + System.currentTimeMillis());
            User searchResults[] = dataService.getSearchUser(attrIDMap);
            User searchResults1[]=null;
            if(advancedSearchForm.getKeyWord().trim()!=null && !advancedSearchForm.getKeyWord().trim().equals("")){
            	searchResults1 =  dataService.getEntityforAttributeValue(advancedSearchForm.getKeyWord().trim());
            }
            logger.debug("Finished search query : " + System.currentTimeMillis());
            session.removeAttribute("MESSAGE");
            if(searchResults1!=null) {
            	OlSearchDataController.getCustomDataForOl(searchResults1, dataService);
            	session.setAttribute("ADV_SEARCH_RESULT", searchResults1);
            }
            else {
            	OlSearchDataController.getCustomDataForOl(searchResults, dataService);
            	session.setAttribute("ADV_SEARCH_RESULT", searchResults);
            }
            session.setAttribute("ADV_SEARCH_FROM", advancedSearchForm);
            if(searchResults == null || (searchResults != null && searchResults.length == 0)) {
                session.setAttribute("MESSAGE", "For the given search criteria, there is no match found");
            }

        }
        return mav;
    }
    private List getOLsBelongToAffilitedOrg(String orgEntityID) {
		OrgOlMap [] orgOlMap = orgOlMapService.getAllOlsForOrgs(Long.parseLong(orgEntityID));
		List userList = new ArrayList();
		User [] user = new User[orgOlMap.length];
		
		for(int i=0;i<orgOlMap.length;i++){
			user[i] = userService.getUser(orgOlMap[i].getOlId());
			userList.add(user[i]);
		}
		return userList;
	}	

    protected IDataService dataService;


    public IDataService getDataService() {
        return dataService;
    }

    public void setDataService(IDataService dataService) {
        this.dataService = dataService;
    }
    IOptionServiceWrapper optionServiceWrapper;

    public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

	public IOrgOlMapService getOrgOlMapService() {
		return orgOlMapService;
	}

	public void setOrgOlMapService(IOrgOlMapService orgOlMapService) {
		this.orgOlMapService = orgOlMapService;
	}

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}
}
