package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authorization.FeatureUsergroupMap;
import com.openq.authorization.IFeaturePermissionService;
import com.openq.group.IGroupService;
import com.openq.utils.PropertyReader;

public class SelectGroupsForPermissionController extends AbstractController {

	IFeaturePermissionService featurePermissionService;
	IGroupService groupService;
	/**
	 * @return the groupService
	 */
	public IGroupService getGroupService() {
		return groupService;
	}

	/**
	 * @param groupService
	 *            the groupService to set
	 */
	public void setGroupService(IGroupService groupService) {
		this.groupService = groupService;
	}

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	       
        // Setting all the usergroups in the session to be used while setting Group Level Permissions
		long adminUserGroupId = 0;
		String adminUserTypeIdString = PropertyReader.getEavConstantValueFor("ADMIN_USER_GROUP_ID");
		if(adminUserTypeIdString != null && !"".equals(adminUserTypeIdString)){
			adminUserGroupId = Long.parseLong(adminUserTypeIdString);
		}
        request.setAttribute("ALL_USER_GROUPS",groupService.getAllGroupsExcludingAdminUserGroup(adminUserGroupId));
		long permissionOnFeature = 0;
		long featureId = 0;
		if (request.getParameter("permissionOnFeature") != null && !"".equals(request.getParameter("permissionOnFeature")))
			permissionOnFeature = Long.parseLong(request
					.getParameter("permissionOnFeature"));
		
		if (request.getParameter("featureId") != null && !"".equals(request.getParameter("featureId")))
			featureId = Long.parseLong(request
					.getParameter("featureId"));

		String newUsergroupMapping = (String) request.getParameter("newSelectedGroupIds");
		if(featureId != 0 && permissionOnFeature != 0 && newUsergroupMapping != null){
			FeatureUsergroupMap featureUsergroupMapObj = featurePermissionService.getFeatureUsergroupMapForId(featureId, permissionOnFeature);
			if(featureUsergroupMapObj != null){
				featureUsergroupMapObj.setUsergroupId(newUsergroupMapping);
				try{
					featurePermissionService.updateUsergroupMapping(featureUsergroupMapObj);
				}catch(Exception e){
					logger.error(e.getMessage());
				}
			}else{
				featureUsergroupMapObj = new FeatureUsergroupMap();
				featureUsergroupMapObj.setFeatureId(featureId);
				featureUsergroupMapObj.setPermissionOnFeature(permissionOnFeature);
				featureUsergroupMapObj.setUsergroupId(newUsergroupMapping);
				try{
					featurePermissionService.saveNewUsergroupMapping(featureUsergroupMapObj);
				}catch(Exception e){
					logger.error(e.getMessage());
				}
			}
			return null;
		}
		return new ModelAndView("selectGroupsForPermission");
	}

	/**
	 * @return the featurePermissionService
	 */
	public IFeaturePermissionService getFeaturePermissionService() {
		return featurePermissionService;
	}

	/**
	 * @param featurePermissionService
	 *            the featurePermissionService to set
	 */
	public void setFeaturePermissionService(
			IFeaturePermissionService featurePermissionService) {
		this.featurePermissionService = featurePermissionService;
	}

}
