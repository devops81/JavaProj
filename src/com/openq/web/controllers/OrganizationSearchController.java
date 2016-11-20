package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.org.IOrganizationService;
import com.openq.eav.org.Organization;
import com.openq.web.ActionKeys;

public class OrganizationSearchController extends AbstractController{

	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
		
		String searchText = (String) request.getParameter("searchText");
		request.getSession().removeAttribute("organization");
		
		if(searchText != null && !searchText.equals("")){
            Organization [] organization = orgService.searchOrganizations(searchText);
            request.getSession().setAttribute("organization", organization);
            request.getSession().setAttribute("SEARCH_TEXT",searchText);
		}
		return new ModelAndView("organization_search");
	}
	
	IOrganizationService orgService;

	public IOrganizationService getOrgService() {
		return orgService;
	}

	public void setOrgService(IOrganizationService orgService) {
		this.orgService = orgService;
	}

}
