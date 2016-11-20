package com.openq.web.controllers;

import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.org.IOrganizationService;
import com.openq.eav.org.Organization;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

public class AdvancedOrgSerchController extends AbstractController {

    IOrganizationService orgService;

    public IOrganizationService getOrgService() {
        return orgService;
    }

    public void setOrgService(IOrganizationService orgService) {
        this.orgService = orgService;
    }
    
    private String organizationName = null;
    private String organizationAcroNym = null;
    private String organizationCountry = null;
    private String organizationState = null;
    private String organizationType = null;
    private String organizationMajorSeg = null;
    private String organizationMinorSeg = null;

    public void setOrganizationName(String organizationName) {
        this.organizationName = organizationName;
    }
    
    public void setOrganizationAcroNym(String organizationAcroNym) {
        this.organizationAcroNym = organizationAcroNym;
    }

    public void setOrganizationCountry(String organizationCountry) {
        this.organizationCountry = organizationCountry;
    }

    public void setOrganizationState(String organizationState) {
        this.organizationState = organizationState;
    }

    public void setOrganizationType(String organizationType) {
        this.organizationType = organizationType;
    }

    public void setOrganizationMajorSeg(String organizationMajorSeg) {
        this.organizationMajorSeg = organizationMajorSeg;
    }

    public void setOrganizationMinorSeg(String organizationMinorSeg) {
        this.organizationMinorSeg = organizationMinorSeg;
    }

    private IOptionServiceWrapper optionServiceWrapper;

    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println("st 1");
        HttpSession session = request.getSession();
        String action = (String) request.getParameter("action");
        String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
        
         session.removeAttribute("MESSAGE");
        if (ActionKeys.ADV_SEARCH_ORG.equalsIgnoreCase(action)) {
            session.setAttribute("STATE_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("STATE"), userGroupId));
            session.setAttribute("COUNTRY_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("COUNTRY"), userGroupId));
            session.setAttribute("ORGNIZATION_TYPE", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("ORGANIZATION_TYPE"), userGroupId));
            session.setAttribute("MAJOR_SEGMENT", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("MAJOR_SEGMENT"), userGroupId));
            session.setAttribute("MINOR_SEGMENT", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("MINOR_SEGMENT"), userGroupId));
            session.setAttribute("CURRENT_LINK", "ADVANCED_ORG_SEARCH");
            session.setAttribute("ORG_LINK","YES");
            session.removeAttribute("MESSAGE");

            if(request.getParameter("reset") != null &&
                    "yes".equals(request.getParameter("reset"))) {

                session.removeAttribute("ORGNAME_SELECTED");
                session.removeAttribute("ACRONAME_SELECTED");
                session.removeAttribute("COUNTRY_SELECTED");
                session.removeAttribute("STATE_SELECTED");
                session.removeAttribute("TYPE_SELECTED");
                session.removeAttribute("MAJOR_SELECTED");
                session.removeAttribute("MINOR_SELECTED");
                session.removeAttribute("ORGANIZATION_ADV_SEARCH_RESULT");
            }

        } else if (ActionKeys.ADV_SEARCH_ORG_MAIN.equalsIgnoreCase(action)) {
            System.out.println("st 2");
            session.removeAttribute("ORGNAME_SELECTED");
               session.removeAttribute("ACRONAME_SELECTED");
               session.removeAttribute("COUNTRY_SELECTED");
               session.removeAttribute("STATE_SELECTED");
               session.removeAttribute("TYPE_SELECTED");
               session.removeAttribute("MAJOR_SELECTED");
               session.removeAttribute("MINOR_SELECTED");

            HashMap searchAttrMap = new HashMap();
            if (null != request.getParameter("orgName") &&
                    !"".equals(request.getParameter("orgName"))) {
                searchAttrMap.put(organizationName, request.getParameter("orgName"));
                session.setAttribute("ORGNAME_SELECTED", request.getParameter("orgName"));

            }
            else
            {
            	session.removeAttribute("ORGNAME_SELECTED");
            }
            if (null != request.getParameter("acroNym") &&
                    !"".equals(request.getParameter("acroNym"))) {
                searchAttrMap.put(organizationAcroNym, request.getParameter("acroNym"));
                session.setAttribute("ACRONAME_SELECTED", request.getParameter("acroNym"));

            }
            else
            {
            	session.removeAttribute("ACRONAME_SELECTED");
            }
            if (null != request.getParameter("country") &&
                    !"".equals(request.getParameter("country"))) {
                searchAttrMap.put(organizationCountry, request.getParameter("country"));
                session.setAttribute("COUNTRY_SELECTED", request.getParameter("country"));

            }
            else
            {
            	session.removeAttribute("COUNTRY_SELECTED");
            }
            if (null != request.getParameter("state") &&
                    !"".equals(request.getParameter("state"))) {
                searchAttrMap.put(organizationState, request.getParameter("state"));
                session.setAttribute("STATE_SELECTED", request.getParameter("state"));

            }
            else
            {
            	session.removeAttribute("STATE_SELECTED");
            }
            if (null != request.getParameter("orgnizationType") &&
                    !"".equals(request.getParameter("orgnizationType"))) {
                searchAttrMap.put(organizationType, request.getParameter("orgnizationType"));
                session.setAttribute("TYPE_SELECTED", request.getParameter("orgnizationType"));

            }
            else
            {
            	session.removeAttribute("TYPE_SELECTED");
            }
            if (null != request.getParameter("majorSegment") &&
                    !"".equals(request.getParameter("majorSegment"))) {
                searchAttrMap.put(organizationMajorSeg, request.getParameter("majorSegment"));
                session.setAttribute("MAJOR_SELECTED", request.getParameter("majorSegment"));

            }
            else
            {
            	session.removeAttribute("MAJOR_SELECTED");
            }
            if (null != request.getParameter("minorSegment") &&
                    !"".equals(request.getParameter("minorSegment"))) {
                searchAttrMap.put(organizationMinorSeg, request.getParameter("minorSegment"));
                session.setAttribute("MINOR_SELECTED", request.getParameter("minorSegment"));

            }
            else
            {
            	session.removeAttribute("MINOR_SELECTED");
            }
            Organization[] orgArray = null;

            if ( searchAttrMap.size() > 0 )
            {
                orgArray = orgService.searchOrganizationsAdv(searchAttrMap, userGroupId);
            }
            else
                orgArray = orgService.getAllOrganizations();


            session.setAttribute("ORGANIZATION_ADV_SEARCH_RESULT", orgArray);
            if(orgArray == null || (orgArray != null && orgArray.length == 0)) {
                session.setAttribute("MESSAGE", "For the given search criteria, there is no match found");
            }

        }
        System.out.println("st 3");
        return new ModelAndView("OrgNameSearch");
    }

    public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

}
