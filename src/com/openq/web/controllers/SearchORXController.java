package com.openq.web.controllers;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.user.IUserService;
import com.openq.utils.PropertyReader;

public class SearchORXController extends AbstractController {

    IOptionService optionService;
    IOptionServiceWrapper optionServiceWrapper;
    IUserService userService;

    protected ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        // TODO Auto-generated method stub

        ModelAndView mav = new ModelAndView("search_hcp");
        String action = request.getParameter("action");
        String lastName = (String) request.getParameter("lastnamesearch");
        String firstName = (String) request.getParameter("firstnamesearch");
        String stateSearch = (String) request.getParameter("searchstate");
        String citySearch = (String) request.getParameter("citysearch");
        String userGroupIdString = (String) request.getSession().getAttribute(
                Constants.CURRENT_USER_GROUP);
        long userGroupId = -1;
        if (userGroupIdString != null
                && !"".equalsIgnoreCase(userGroupIdString)) {
            userGroupId = Long.parseLong(userGroupIdString);
        }

        request.getSession().removeAttribute("noresult");
        request.getSession().removeAttribute("orxResult");
        request.getSession().removeAttribute("myExperts");
        request.getSession().setAttribute(
                "state",
                optionServiceWrapper.getValuesForOptionName(PropertyReader
                        .getLOVConstantValueFor("STATE"), userGroupId));
        request.getSession().setAttribute(
                "therapeuticArea",
                optionService.getValuesForOption(PropertyReader
                        .getLOVConstantValueFor("THERAPEUTIC_AREA"),
                        userGroupId));
        request.getSession().setAttribute(
                "attendeeType",
                optionService.getValuesForOption(PropertyReader
                        .getLOVConstantValueFor("ATTENDEE_TYPE"), userGroupId));
        request.getSession().setAttribute(
                "stateAbbriviation",
                optionService.getValuesForOption(PropertyReader
                        .getLOVConstantValueFor("STATE_ABBREVIATION"),
                        userGroupId));
        request.getSession().setAttribute(
                "title",
                optionService.getValuesForOption(PropertyReader
                        .getLOVConstantValueFor("TITLE"), userGroupId));

        if (null != action && Constants.SEARCH_HCP.equals(action)) {
			List searchHcpResults = userService.searchExpert(firstName,
					lastName, stateSearch, citySearch);
			request.setAttribute("SEARCH_HCP_RESULTS", searchHcpResults);
		}

        if (null != action && !"".equals(action) && "olSearch".equals(action)) {
            mav = new ModelAndView("event_ol_search");
            request.getSession().setAttribute("SEARCH_TEXT", lastName);
            return mav;
        }
        return mav;
    }

    public IOptionService getOptionService() {
        return optionService;
    }

    public void setOptionService(IOptionService optionService) {
        this.optionService = optionService;
    }

    public IUserService getUserService() {
        return userService;
    }

    public void setUserService(IUserService userService) {
        this.userService = userService;
    }

    public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(
            IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

}
