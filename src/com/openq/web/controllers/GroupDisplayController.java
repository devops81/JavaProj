package com.openq.web.controllers;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.group.Groups;
import com.openq.group.IGroupService;
import com.openq.group.IUserGroupMapService;
import com.openq.utils.PropertyReader;

public class GroupDisplayController extends AbstractController {

	IGroupService groupService;
	IOptionService optionService;
	IUserGroupMapService userGroupMapService;
	IOptionServiceWrapper optionServiceWrapper;

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub

		ModelAndView mav = new ModelAndView("grpDisplay");
		String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
		request.getSession().removeAttribute("isDeleted");
		String groupIds[] =  request.getParameterValues("checkedGroupList");
		if (groupIds != null) {
			for(int i=0;i<groupIds.length;i++) {
				if(userGroupMapService.getAllUsersForGroup(Long.parseLong(groupIds[i])) != null && userGroupMapService.getAllUsersForGroup(Long.parseLong(groupIds[i])).length == 0){
					groupService.deleteGroup(Long.parseLong(groupIds[i]));
					mav.addObject("refresh", "true");
				}else{
					request.getSession().setAttribute("isDeleted", "false");
				}
			}
		}
		else{
			
			mav.addObject("Status", "Group Cannot be deleted, there are users associated with It");
		}
/*
 * values coming from list of values
 */
		OptionLookup [] groupType = optionService.getValuesForOption(1, userGroupId);
		request.getSession().setAttribute("groupType", groupType);
		
		OptionLookup [] functionalArea = optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("FUNCTIONAL_AREA"), userGroupId);
		request.getSession().setAttribute("functionalArea", functionalArea);
		
		OptionLookup [] TherapeuticArea= optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId);
		request.getSession().setAttribute("TherapeuticArea",TherapeuticArea);
		OptionLookup [] Region=optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("REGION"), userGroupId);
		request.getSession().setAttribute("region",Region);
		
		
		if(request.getParameter("groupId") != null && request.getParameter("groupname") != null && request.getParameter("groupdesc") != null && request.getParameter("grouptype")!= null){
		
		long ParentID = Long.parseLong(request.getParameter("groupId"));
		String GroupName = request.getParameter("groupname");
		String GroupDescription = request.getParameter("groupdesc");
		String GroupType = request.getParameter("grouptype");
		// TODO: Get TA/FA from request
		String TherupticArea  =request.getParameter("groupTA");
		String FunctionalArea =request.getParameter("groupFA");
		String region=request.getParameter("regions");
		
		
		Groups AddGroup = new Groups();
		if (GroupName != null && GroupDescription != null && !GroupName.equals("") && !GroupDescription.equals("")) {
			AddGroup.setGroupName(GroupName);
			AddGroup.setGroupDescription(GroupDescription);
			AddGroup.setGroupType(GroupType);
			AddGroup.setParentGroup(ParentID);
			AddGroup.setTherupticArea(TherupticArea);
			AddGroup.setFunctionalArea(FunctionalArea);
			AddGroup.setRegion(region);
			
			// TODO: Code to set TA/FA
			groupService.addGroups(AddGroup);
			mav.addObject("refresh", "true");
		}
		}

/*
 * for edit group
 */
			
		if(request.getParameter("editgroupId") != null ){
			long editgroupId = Long.parseLong((String) request.getParameter("editgroupId"));
			mav.addObject("editGroup", groupService.getGroup(editgroupId));
			request.getSession().setAttribute("editGrp", groupService.getGroup(editgroupId));
			Groups gr = groupService.getGroup(editgroupId);
		}

/*
 * Edit group
 */
		if(request.getParameter("editgroupname")!= null && request.getParameter("editgroupdesc") != null && request.getParameter("editgrouptype")!= null){
			Groups group = groupService.getGroup(Long.parseLong(request.getParameter("editgroupid")));	
			group.setGroupDescription((String)request.getParameter("editgroupdesc"));
			group.setGroupName((String) request.getParameter("editgroupname"));
			group.setGroupType((String) request.getParameter("editgrouptype"));
			group.setTherupticArea((String) request.getParameter("editgroupTA"));
			group.setFunctionalArea((String) request.getParameter("editgroupFA"));
			group.setRegion((String) request.getParameter("editregions"));


			groupService.updateGroup(group);
            mav.addObject("refresh", "true");
        }
		
		return mav.addObject("groupType", groupType);
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

	public IUserGroupMapService getUserGroupMapService() {
		return userGroupMapService;
	}

	public void setUserGroupMapService(IUserGroupMapService userGroupMapService) {
		this.userGroupMapService = userGroupMapService;
	}
	public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

	
}
