package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionService;
import com.openq.report.ReportGroups;
import com.openq.report.IReportGroupService;

public class ReportListController extends AbstractController{

	IReportGroupService reportGroupService;
	IOptionService optionService;
	
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView("reportList");
		
		if(request.getParameter("parentID") != null && !((String)request.getParameter("parentID")).equalsIgnoreCase("null")){
				
			long ParentID = Long.parseLong(request.getParameter("parentID"));
			
			ReportGroups[] groups = reportGroupService.getChildGroups(ParentID);
			long [] GroupID = new long[groups.length];
			String [] GroupName = new String[groups.length];
			String [] GroupDescription = new String[groups.length];
			
			for(int i=0;i < groups.length; i++){
				GroupID[i] = groups[i].getGroupId();
				GroupName[i] = groups[i].getGroupName();
				GroupDescription[i] = groups[i].getGroupDescription();
				
			}
			
			request.getSession().setAttribute("groupid", GroupID);
			request.getSession().setAttribute("groupname", GroupName);
			request.getSession().setAttribute("groupdesc", GroupDescription);
			request.getSession().setAttribute("parentId", request.getParameter("parentID"));
			
		}
		
		return mav;
	}
	
	

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}



	/**
	 * @return the reportGroupService
	 */
	public IReportGroupService getReportGroupService() {
		return reportGroupService;
	}



	/**
	 * @param reportGroupService the reportGroupService to set
	 */
	public void setReportGroupService(IReportGroupService reportGroupService) {
		this.reportGroupService = reportGroupService;
	}
}
