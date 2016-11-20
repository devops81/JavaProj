package com.openq.web.controllers;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.option.OptionNames;
import com.openq.siteSearch.ISiteSearchService;
import com.openq.siteSearch.SiteEntity;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;

/**
 *
 * @author Tapan
 * @date 16th Sept 2009
 *
 */

public class SiteSearchController extends AbstractController {

    ISiteSearchService siteSearchService;
    IOptionService optionService;

    /**
     * @return the optionService
     */
    public IOptionService getOptionService() {
        return optionService;
    }


    /**
     * @param optionService the optionService to set
     */
    public void setOptionService(IOptionService optionService) {
        this.optionService = optionService;
    }


    /**
     * @return the siteSearchService
     */
    public ISiteSearchService getSiteSearchService() {
        return siteSearchService;
    }


    /**
     * @param siteSearchService the siteSearchService to set
     */
    public void setSiteSearchService(ISiteSearchService siteSearchService) {
        this.siteSearchService = siteSearchService;
    }


    protected ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        ModelAndView mav = new ModelAndView("site_search");
        HttpSession session = request.getSession();
        //removing the siteSearchResults if any in session

        String studyOptValueFromInteraction = request.getParameter("selectedStudy");
        request.getSession().setAttribute("studyOptValueFromInteraction", studyOptValueFromInteraction);

        if (session.getAttribute("siteSearchResult") != null)
            session.removeAttribute("siteSearchResult");

        if (session.getAttribute("isSiteSaved")!= null)
            session.removeAttribute("isSiteSaved");

        //Current UserGroupId
        String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
        long userGroupId = -1;
        if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString)){
         userGroupId = Long.parseLong(userGroupIdString);
        }
        if(session.getAttribute("SITE_SEARCH_STATE") == null){
            session.setAttribute("SITE_SEARCH_STATE", optionService
                    .getValuesForOption(PropertyReader
                            .getLOVConstantValueFor("SITE_SEARCH_STATE"), userGroupId));
        }
        // Current User TA
        String currentUserTA = (String) session.getAttribute(Constants.CURRENT_USER_TA);

        // Creating a hashmap of parameters and corresponding values passed from the siteSearch Screen
        HashMap siteParamMap = new HashMap();

        if (null != request.getParameter("centerName") &&
                !("".equals(request.getParameter("centerName"))))
            siteParamMap.put("centerName", request.getParameter("centerName"));
        if (null != request.getParameter("address") &&
                !("".equals(request.getParameter("address"))))
            siteParamMap.put("address", request.getParameter("address"));
        if (null != request.getParameter("firstName") &&
                !("".equals(request.getParameter("firstName"))))
            siteParamMap.put("firstName", request.getParameter("firstName"));
        if (null != request.getParameter("city") &&
                !("".equals(request.getParameter("city"))))
            siteParamMap.put("city", request.getParameter("city"));
        if (null != request.getParameter("lastName") &&
                !("".equals(request.getParameter("lastName"))))
            siteParamMap.put("lastName", request.getParameter("lastName"));
        if (null != request.getParameter("state") &&
                !("".equals(request.getParameter("state"))))
            siteParamMap.put("state", request.getParameter("state"));
        if (null != request.getParameter("zipCode") &&
                !("".equals(request.getParameter("zipCode"))))
            siteParamMap.put("zipCode", request.getParameter("zipCode"));
        if (null != request.getParameter("country") &&
                !("".equals(request.getParameter("country")))){
            siteParamMap.put("country", request.getParameter("country"));
        }

        List siteSearchResult = null;
        if (siteParamMap != null && siteParamMap.size() > 0){
            siteSearchResult = siteSearchService.getAllSites(siteParamMap, userGroupId, currentUserTA);
        }

        request.setAttribute("SITE_SEARCH_PARAMETER_MAP", siteParamMap);

        if (siteSearchResult != null && siteSearchResult.size() > 0) {
            session.setAttribute("siteSearchResult",
                    (SiteEntity[])siteSearchResult.toArray(new SiteEntity[siteSearchResult.size()]));
        }
        else if (siteParamMap!=null && siteParamMap.size() > 0 &&
                (siteSearchResult == null || siteSearchResult.size() == 0) ){
            request.setAttribute("SITE_SEARCH_MESSAGE",
                    "For the given search criteria, there are no Sites found");
        }

        //Now saving the new Site LOV to the option lookup table as a child to study lov.
        if (null != request.getParameter("do") && !("".equals(request.getParameter("do"))) &&
                ActionKeys.ASSOCIATE_SITE.equals(request.getParameter("do"))) {

            String selectStudyIMPACTNumberLOVName = PropertyReader.getLOVConstantValueFor("SELECT_STUDY_IMPACT_NUMBER");
            String selectStudySiteLOVName = PropertyReader.getLOVConstantValueFor("SELECT_STUDY_SITE");

            String studySiteSelectedValue = request.getParameter("siteSelectedValue");
            String []studySite = studySiteSelectedValue.split("~");

            if (studySite.length == 2) {
                String selectedStudyValue = studySite[0].trim();
                String selectSiteValue = studySite[1].trim();

                OptionLookup selectedStudyId = optionService.
                getParentOptionLookupId(selectStudyIMPACTNumberLOVName, selectedStudyValue);

                if (selectedStudyId != null) {
                    //To check if the site lov already exisiting
                    boolean doesSiteExist = optionService.doesOptionLookupExist(selectSiteValue, selectedStudyId.getId());
                    if (!doesSiteExist) {
                        OptionNames siteOptionNameObj = optionService.getOptionNames(optionService.getIdForOptionName(selectStudySiteLOVName));
                        optionService.addValueToOptionLookup(siteOptionNameObj, selectSiteValue, selectedStudyId.getId());
                    }
                    request.setAttribute("isSiteSaved", "true");
                    request.setAttribute("siteValue", selectSiteValue);
                    request.setAttribute("studyValue", selectedStudyValue);
                }
            }

            request.getSession().removeAttribute("studyOptValueFromInteraction");
        }




        return mav;

    }


}