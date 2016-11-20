package com.openq.web.controllers;

import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.trials.ClinicalTrials;
import com.openq.eav.trials.ITrialService;
import com.openq.eav.trials.TrialsConstants;
import com.openq.web.ActionKeys;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

public class AdvancedTrialSearchController extends AbstractController {

	ITrialService trialService;

    public ITrialService getTrialService() {
        return trialService;
    }

    public void setTrialService(ITrialService trialService) {
        this.trialService = trialService;
    }
    

    private IOptionServiceWrapper optionServiceWrapper;

    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println("Inside Advanced search handler");
        HttpSession session = request.getSession();
        
        session.setAttribute("CURRENT_LINK", "ADVANCED_TRIAL_SEARCH");
        
        String action = (String) request.getParameter("action");
         session.removeAttribute("MESSAGE");
        if (ActionKeys.ADV_SEARCH_TRIAL.equalsIgnoreCase(action)) {
            session.removeAttribute("MESSAGE");

            if(request.getParameter("reset") != null &&
                    "yes".equals(request.getParameter("reset"))) {

            	session.removeAttribute("TRIALNAME_SELECTED");
            	session.removeAttribute("INVESTIGATORNAME_SELECTED");
                session.removeAttribute("TUMOURTYPE_SELECTED");
                session.removeAttribute("GENENTECHINVESTIGATORID_SELECTED");
                session.removeAttribute("LICENSENUMBER_SELECTED");
                session.removeAttribute("ISGENENTECHCOMPOUND_SELECTED");
                session.removeAttribute("MOLECULE1_SELECTED");
                session.removeAttribute("MOLECULE2_SELECTED");
                session.removeAttribute("INSTITUTION_SELECTED");
                session.removeAttribute("TRIALS_ADV_SEARCH_RESULT");
            }

        } else if (ActionKeys.ADV_SEARCH_TRIAL_MAIN.equalsIgnoreCase(action)) {
               System.out.println("Inside trial search");
               session.removeAttribute("TRIALNAME_SELECTED");
               session.removeAttribute("INVESTIGATORNAME_SELECTED");
               session.removeAttribute("TUMOURTYPE_SELECTED");
               session.removeAttribute("GENENTECHINVESTIGATORID_SELECTED");
               session.removeAttribute("LICENSENUMBER_SELECTED");
               session.removeAttribute("ISGENENTECHCOMPOUND_SELECTED");
               session.removeAttribute("MOLECULE1_SELECTED");
               session.removeAttribute("MOLECULE2_SELECTED");
               session.removeAttribute("INSTITUTION_SELECTED");
               session.removeAttribute("TRIALS_ADV_SEARCH_RESULT");

            HashMap searchAttrMap = new HashMap();
            
            if (null != request.getParameter("trialName") &&
                    !"".equals(request.getParameter("trialName"))) {
                searchAttrMap.put(new Long(TrialsConstants.TRIAL_OFFICIAL_TITLE_ATTRIB_ID), request.getParameter("trialName"));
                session.setAttribute("TRIALNAME_SELECTED", request.getParameter("trialName"));

            }
            else
            {
            	session.removeAttribute("TRIALNAME_SELECTED");
            }
            
            if (null != request.getParameter("investigatorName") &&
                    !"".equals(request.getParameter("investigatorName"))) {
                searchAttrMap.put(new Long(TrialsConstants.TRIAL_INVESTIGATION_INVESTIGATOR_ATTRIB_ID), request.getParameter("investigatorName"));
                session.setAttribute("INVESTIGATORNAME_SELECTED", request.getParameter("investigatorName"));

            }
            else
            {
            	session.removeAttribute("INVESTIGATORNAME_SELECTED");
            }
            
            if (null != request.getParameter("tumourType") &&
                    !"".equals(request.getParameter("tumourType"))) {
                searchAttrMap.put(new Long(TrialsConstants.TRIAL_TUMOUR_TYPE_ATTRIB_ID), request.getParameter("tumourType"));
                session.setAttribute("TUMOURTYPE_SELECTED", request.getParameter("tumourType"));

            }
            else
            {
            	session.removeAttribute("TUMOURTYPE_SELECTED");
            }

            if (null != request.getParameter("genentechInvestigatorId") &&
                    !"".equals(request.getParameter("genentechInvestigatorId"))) {
                searchAttrMap.put(new Long(TrialsConstants.TRIAL_GENENTECH_INVESTIGATOR_ID_ATTRIB_ID), request.getParameter("genentechInvestigatorId"));
                session.setAttribute("GENENTECHINVESTIGATORID_SELECTED", request.getParameter("genentechInvestigatorId"));

            }
            else
            {
            	session.removeAttribute("GENENTECHINVESTIGATORID_SELECTED");
            }
            
            if (null != request.getParameter("licenseNumber") &&
                    !"".equals(request.getParameter("licenseNumber"))) {
                searchAttrMap.put(new Long(TrialsConstants.TRIAL_LICENSE_NUMBER_ATTRIB_ID), request.getParameter("licenseNumber"));
                session.setAttribute("LICENSENUMBER_SELECTED", request.getParameter("licenseNumber"));

            }
            else
            {
            	session.removeAttribute("LICENSENUMBER_SELECTED");
            }

            if (null != request.getParameter("isGenentechCompound") &&
                    !"".equals(request.getParameter("isGenentechCompound"))) {
                searchAttrMap.put(new Long(TrialsConstants.TRIAL_IS_GENENTECH_COMPOUND_ATTRIB_ID), 
                		(request.getParameter("isGenentechCompound").equalsIgnoreCase("Yes")?"1":"0"));
                session.setAttribute("ISGENENTECHCOMPOUND_SELECTED", request.getParameter("isGenentechCompound"));
                System.out.println("Using isGenentechCompound : " + request.getParameter("isGenentechCompound"));
            }
            else
            {
            	session.removeAttribute("ISGENENTECHCOMPOUND_SELECTED");
            }
            
            if (null != request.getParameter("molecule1") &&
                    !"".equals(request.getParameter("molecule1"))) {
                searchAttrMap.put(new Long(TrialsConstants.TRIAL_MOLECULE_ATTRIB_ID), request.getParameter("molecule1"));
                session.setAttribute("MOLECULE1_SELECTED", request.getParameter("molecule1"));

            }
            else
            {
            	session.removeAttribute("MOLECULE1_SELECTED");
            }
            
            if (null != request.getParameter("molecule2") &&
                    !"".equals(request.getParameter("molecule2"))) {
            	
            	// Check if molecule 1 criteria is already specified
            	String criteria = (String) searchAttrMap.get(new Long(TrialsConstants.TRIAL_MOLECULE_ATTRIB_ID));
            	if(criteria == null) {
            		criteria = request.getParameter("molecule2");
            	}
            	else {
            		criteria += "," + request.getParameter("molecule2");
            	}
            	
                searchAttrMap.put(new Long(TrialsConstants.TRIAL_MOLECULE_ATTRIB_ID), criteria);
                session.setAttribute("MOLECULE2_SELECTED", request.getParameter("molecule2"));
            }
            else
            {
            	session.removeAttribute("MOLECULE2_SELECTED");
            }
            
            if (null != request.getParameter("institution") &&
                    !"".equals(request.getParameter("institution"))) {
                searchAttrMap.put(new Long(TrialsConstants.TRIAL_OL_INSTITUTE_ATTRIB), request.getParameter("institution"));
                session.setAttribute("INSTITUTION_SELECTED", request.getParameter("institution"));

            }
            else
            {
            	session.removeAttribute("INSTITUTION_SELECTED");
            }
            
            ClinicalTrials[] trialArray = trialService.searchTrialAdv(searchAttrMap);
            session.setAttribute("TRIALS_ADV_SEARCH_RESULT", trialArray);
            if(trialArray == null || (trialArray != null && trialArray.length == 0)) {
                session.setAttribute("MESSAGE", "For the given search criteria, there is no match found");
            }

        }
        System.out.println("Returning from trial search controller");
        return new ModelAndView("TrialNameSearch");
    }

    public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

}
