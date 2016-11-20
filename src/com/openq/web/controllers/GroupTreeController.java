package com.openq.web.controllers;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.group.Groups;
import com.openq.group.IGroupService;


public class GroupTreeController extends AbstractController  {

	IGroupService groupService;
	
	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("grpTree");
		
	
		Groups[] groups=(Groups[]) groupService.getAllGroups();
		
		
		
		long [] GroupID = new long[groups.length];
		long [] ParentID = new long[groups.length];
		String [] GroupsName = new String[groups.length];
		
		for(int i=0;i<groups.length;i++)
		{
			GroupID[i] = groups[i].getGroupId();
		    ParentID[i] = groups[i].getParentGroup();
		    GroupsName[i] = groups[i].getGroupName();
		}
		
		request.getSession().setAttribute("Groups", GroupID);
	    request.getSession().setAttribute("Parents", ParentID);
		request.getSession().setAttribute("GroupsName", GroupsName);
		mav.addObject("groups", GroupID);
		//mav.addObject("parents", ParentID);
		//mav.addObject("groupname", GroupsName);
		
		return mav;
	}
	public IGroupService getGroupService() {
		return groupService;
	}
	public void setGroupService(IGroupService groupService) {
		this.groupService = groupService;
	}
	
	
}
