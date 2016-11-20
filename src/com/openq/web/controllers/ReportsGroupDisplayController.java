package com.openq.web.controllers;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authorization.IFeaturePermissionService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.report.IReportGroupMapService;
import com.openq.report.IReportGroupService;
import com.openq.report.ReportGroups;
import com.openq.web.ActionKeys;

public class ReportsGroupDisplayController extends AbstractController {

	IReportGroupService reportGroupService;
	IOptionService optionService;
	IReportGroupMapService reportGroupMapService;
	IOptionServiceWrapper optionServiceWrapper;
	IFeaturePermissionService featurePermissionService;

	/**
	 * @return the featurePermissionService
	 */
	public IFeaturePermissionService getFeaturePermissionService() {
		return featurePermissionService;
	}



	/**
	 * @param featurePermissionService the featurePermissionService to set
	 */
	public void setFeaturePermissionService(
			IFeaturePermissionService featurePermissionService) {
		this.featurePermissionService = featurePermissionService;
	}



	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub

		request.getSession().removeAttribute("isDeleted");
		HttpSession session = request.getSession();
		ModelAndView mav = new ModelAndView("reportsGroupDisplay");
		request.setAttribute("REPORT_PERMISSION_MAP", featurePermissionService.getEntityGroupMapping(Constants.REPORT_PERMISSION_ID));
		String action = (String) request.getParameter("action");
	    String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
		 
		String groupIdString = "";
		if(request.getParameter("groupId")!=null){
			groupIdString = request.getParameter("groupId");
		}
		if (ActionKeys.REPORT_GROUP.equalsIgnoreCase(action)) {
			mav = new ModelAndView("reportsGroupDisplay");
			
			/*
			 * values coming from list of values
			 */
			if(request.getParameter("groupId") != null && request.getParameter("groupname") != null && request.getParameter("groupdesc") != null){
				long ParentID = Long.parseLong(request.getParameter("groupId"));
				String GroupName = request.getParameter("groupname");
				String GroupDescription = request.getParameter("groupdesc");
				ReportGroups AddGroup = new ReportGroups();
				if (GroupName != null && GroupDescription != null && !GroupName.equals("") && !GroupDescription.equals("")) {
					AddGroup.setGroupName(GroupName);
					AddGroup.setGroupDescription(GroupDescription);
					AddGroup.setParentGroup(ParentID);
					reportGroupService.addGroups(AddGroup);
					//mav.addObject("refresh", "true");
					mav.addObject("groupId",request.getParameter("groupId"));
				}
			}
		}
		/*
		 * for edit group
		 */
		if(request.getParameter("editgroupId") != null && session.getAttribute("isEdited")==null){
			long editgroupId = Long.parseLong((String) request.getParameter("editgroupId"));
			mav.addObject("editGroup", reportGroupService.getGroup(editgroupId));
			request.getSession().setAttribute("editGrp", reportGroupService.getGroup(editgroupId));
			ReportGroups gr = reportGroupService.getGroup(editgroupId);
		}
		/*
		 * Edit group
		 */
		if(request.getParameter("editgroupname")!= null && request.getParameter("editgroupdesc") != null ){
			ReportGroups group = reportGroupService.getGroup(Long.parseLong(request.getParameter("editgroupid")));	
			group.setGroupDescription((String)request.getParameter("editgroupdesc"));
			group.setGroupName((String) request.getParameter("editgroupname"));
			reportGroupService.updateGroup(group);
			//session.setAttribute("isEdited", true);
        }
		String groupIds[] =  request.getParameterValues("checkedGroupList");
		if (groupIds != null && groupIds.length>0) {
			for(int i=0;i<groupIds.length;i++) {
				if(reportGroupMapService.getAllReportForGroup(Long.parseLong(groupIds[i]), userGroupId) != null && 
						reportGroupMapService.getAllReportForGroup(Long.parseLong(groupIds[i]), userGroupId).length == 0){
					reportGroupService.deleteGroup(Long.parseLong(groupIds[i]));
					//mav.addObject("refresh", "true");
				}else{
					request.getSession().setAttribute("isDeleted", "false");
				}
			}
		}
		else{
			
			mav.addObject("Status", "Group Cannot be deleted, there are users associated with It");
		}
		mav.addObject("groupId", groupIdString);
		session.setAttribute("CURRENT_LINK", "reportGroup");
		return mav;
	}
	

	
	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

	

    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }


	/**
	 * @return the reportGroupMapService
	 */
	public IReportGroupMapService getReportGroupMapService() {
		return reportGroupMapService;
	}


	/**
	 * @param reportGroupMapService the reportGroupMapService to set
	 */
	public void setReportGroupMapService(
			IReportGroupMapService reportGroupMapService) {
		this.reportGroupMapService = reportGroupMapService;
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


	/**
	 * @return the optionServiceWrapper
	 */
	public IOptionServiceWrapper getOptionServiceWrapper() {
		return optionServiceWrapper;
	}

	
}
