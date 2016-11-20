package com.openq.web.controllers;

import java.util.Collection;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.report.IReportGroupMapService;
import com.openq.report.IReportGroupService;
import com.openq.report.IReportService;
import com.openq.report.ReportGroupMap;
import com.openq.report.ReportGroups;

public class ReportstreeController extends AbstractController {
	IReportGroupService reportGroupService;
	IReportGroupMapService reportGroupMapService;
	IReportService reportService;

	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("reportsTree");

		ReportGroups[] groups = (ReportGroups[]) reportGroupService
		.getAllGroups();
		String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
		Collection reports = reportService.getAllReports(userGroupId);
		if (groups != null) {
			long[] GroupID = new long[groups.length];
			long[] ParentID = new long[groups.length];
			String[] GroupsName = new String[groups.length];
			HashMap reportsHashedOnGrp = new HashMap();
			for (int i = 0; i < groups.length; i++) {
				GroupID[i] = groups[i].getGroupId();
				ParentID[i] = groups[i].getParentGroup();
				GroupsName[i] = groups[i].getGroupName();
				ReportGroupMap[] rg = reportGroupMapService
				.getAllReportForGroup(GroupID[i], userGroupId);
				reportsHashedOnGrp.put(groups[i], rg);
			}
			request.getSession().setAttribute("reports", reports);
			request.getSession().setAttribute("reportsHashedOnGrp",
					reportsHashedOnGrp);
			request.getSession().setAttribute("Groups", GroupID);
			request.getSession().setAttribute("Parents", ParentID);
			request.getSession().setAttribute("GroupsName", GroupsName);

			mav.addObject("groups", GroupID);
			// mav.addObject("parents", ParentID);
			// mav.addObject("groupname", GroupsName);
		}
		return mav;
	}

	/**
	 * @return the reportGroupService
	 */
	public IReportGroupService getReportGroupService() {
		return reportGroupService;
	}

	/**
	 * @param reportGroupService
	 *            the reportGroupService to set
	 */
	public void setReportGroupService(IReportGroupService reportGroupService) {
		this.reportGroupService = reportGroupService;
	}

	/**
	 * @return the reportGroupMapService
	 */
	public IReportGroupMapService getReportGroupMapService() {
		return reportGroupMapService;
	}

	/**
	 * @param reportGroupMapService
	 *            the reportGroupMapService to set
	 */
	public void setReportGroupMapService(
			IReportGroupMapService reportGroupMapService) {
		this.reportGroupMapService = reportGroupMapService;
	}

	/**
	 * @return the reportService
	 */
	public IReportService getReportService() {
		return reportService;
	}

	/**
	 * @param reportService
	 *            the reportService to set
	 */
	public void setReportService(IReportService reportService) {
		this.reportService = reportService;
	}

}
