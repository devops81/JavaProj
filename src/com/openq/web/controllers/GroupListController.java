package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionService;
import com.openq.group.Groups;
import com.openq.group.IGroupService;

public class GroupListController extends AbstractController{

	IGroupService groupService;
	IOptionService optionService;
	
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView("grpList");
		String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
		
		if(request.getParameter("parentID") != null){
				
			long ParentID = Long.parseLong(request.getParameter("parentID"));
			
			Groups[] groups = groupService.getChildGroups(ParentID);
			long [] GroupID = new long[groups.length];
			String [] GroupName = new String[groups.length];
			String [] GroupDescription = new String[groups.length];
			String [] GroupType = new String[groups.length];
			String [] GroupTA = new String[groups.length];
			String [] GroupFA = new String [groups.length];
			String [] GroupRegion = new String [groups.length];
			
			for(int i=0;i < groups.length; i++){
				GroupID[i] = groups[i].getGroupId();
				GroupName[i] = groups[i].getGroupName();
				GroupDescription[i] = groups[i].getGroupDescription();
				GroupType[i] = groups[i].getGroupType();
				if (groups[i].getTherupticArea() != null) {
					long taId = Long.parseLong(groups[i].getTherupticArea());
					if(taId != -1)
						GroupTA[i] = optionService.getOptionLookup(taId, userGroupId).getOptValue();
					else
						GroupTA[i] = "None";
				}
				if (groups[i].getFunctionalArea() != null) {
					long faId = Long.parseLong(groups[i].getFunctionalArea());
					if(faId != -1)
						GroupFA[i] = optionService.getOptionLookup(faId, userGroupId).getOptValue();
					else
						GroupFA[i] = "None";
					
				}
				if(groups[i].getRegion() != null){
					long RegionId=Long.parseLong(groups[i].getRegion());
					if(RegionId!=-1)
						GroupRegion[i]=optionService.getOptionLookup(RegionId, userGroupId).getOptValue();
					else
						GroupRegion[i]="None";
				}
			}
			
			request.getSession().setAttribute("groupid", GroupID);
			request.getSession().setAttribute("groupname", GroupName);
			request.getSession().setAttribute("groupdesc", GroupDescription);
			request.getSession().setAttribute("grouptype", GroupType);
			request.getSession().setAttribute("groupta",GroupTA);
			request.getSession().setAttribute("groupfa",GroupFA);
			request.getSession().setAttribute("region", GroupRegion);
			request.getSession().setAttribute("parentId", request.getParameter("parentID"));
			
		}
		
		return mav;
	}
	
	public IGroupService getGroupService() {
		return groupService;
	}

	public void setGroupService(IGroupService groupService) {
		this.groupService = groupService;
	}

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}
}
