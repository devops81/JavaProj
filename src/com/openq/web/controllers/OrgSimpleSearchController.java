package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

public class OrgSimpleSearchController extends AbstractController {

	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.getSession().removeAttribute("orgs");
        String action=request.getParameter("action");
        if(null != action && !"".equals(action) &&
                "fromAdvSearch".equals(action)) {
            request.getSession().setAttribute("FROM_ADV_SEARCH",action);
        }
        return new ModelAndView("interaction_org_search");
	}

}
