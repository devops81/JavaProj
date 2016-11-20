package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authorization.IPrivilegeService;
import com.openq.authorization.NonCompatiblePrivilegeException;
import com.openq.authorization.Privilege;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.EntityType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.group.IGroupService;
import com.openq.utils.PropertyReader;
import com.openq.web.controllers.helpers.AttributeTypeForm;
import com.openq.web.controllers.helpers.UIHelper;

public class AddAttributeController extends AbstractController {

	UIHelper uiHelper;

	IMetadataService metadataService;

	IOptionService optionService;
	IOptionServiceWrapper optionServiceWrapper;
	IPrivilegeService privilegeService;
	
	IGroupService groupService;

	private static Logger logger = Logger.getLogger(AddAttributeController.class);
	
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
	    // TODO Auto-generated method stub
		String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
		ModelAndView mav = new ModelAndView("addAttribute");

		String action = request.getParameter("_action");
		String parentIdString = request.getParameter("parentId");
		mav.addObject("parentId", parentIdString);

		String parentIsList = request.getParameter("parentIsList");
		mav.addObject("parentIsList", parentIsList);

		String attrIdString = request.getParameter("attrId");
		mav.addObject("attrId", attrIdString);

		request.getSession().removeAttribute("deleteMessage");

		if (action != null && !action.equals("")) {
			long parentId = Long.parseLong(parentIdString);
			boolean isParentAnArray = (parentIsList != null && !parentIsList
					.equals("")) ? parentIsList.equals("true") : false;
			
			long attrId = (attrIdString != null && !attrIdString.equals("")) ? Long
					.parseLong(attrIdString)
					: -1;

			if (action.trim().equals("new") || action.trim().equals("edit")) {

				AttributeTypeForm newFormObject = AttributeTypeForm
						.fillFormValues(parentId, isParentAnArray, attrId,
								metadataService, optionService);				
				request.getSession().setAttribute(
						Constants.ATTRIBUTE_FORM_OBJECT, newFormObject);
				mav.addObject("viewGroups", uiHelper.getGroupOptions("viewGroups", "field-blue-15-110x20", "false"));
				mav.addObject("editGroups", uiHelper.getGroupOptions("editGroups", "field-blue-15-110x20", "false"));
				mav.addObject("createGroups", uiHelper.getGroupOptions("createGroups", "field-blue-15-110x20", "false"));
				mav.addObject("deleteGroups", uiHelper.getGroupOptions("deleteGroups", "field-blue-15-110x20", "false"));
				
				// Amit - changes related to privilege service
	
				OptionLookup[] allUserTypes = optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("USER_TYPES"), userGroupId);
				mav.addObject("createUserTypes", uiHelper.getOptionsForOptionLookupList(allUserTypes, "createUserTypes", false, "field-blue-13-260x100", "false"));
				mav.addObject("viewUserTypes", uiHelper.getOptionsForOptionLookupList(allUserTypes, "viewUserTypes", false, "field-blue-13-260x100", "false"));
				mav.addObject("editUserTypes", uiHelper.getOptionsForOptionLookupList(allUserTypes, "editUserTypes", false, "field-blue-13-260x100", "false"));
				mav.addObject("deleteUserTypes", uiHelper.getOptionsForOptionLookupList(allUserTypes, "deleteUserTypes", false, "field-blue-13-260x100", "false"));
				
				List allowedCreators = new ArrayList();
				List allowedReaders = new ArrayList();
				List allowedEditors = new ArrayList();
				List allowedDeletors = new ArrayList();
				
				if(action.trim().equals("edit")) {
					// Get the feature key corresponding to this attribute
					String featureKey = metadataService.getFeatureKeyForAttribute(parentId, attrId);

					allowedCreators = getPrivilegedGroupAndUserType(featureKey, Privilege.CREATE,userGroupId);
					allowedReaders = getPrivilegedGroupAndUserType(featureKey, Privilege.READ,userGroupId);
					allowedEditors = getPrivilegedGroupAndUserType(featureKey, Privilege.UPDATE,userGroupId);
					allowedDeletors = getPrivilegedGroupAndUserType(featureKey, Privilege.DELETE,userGroupId);
				}

				// Set the UI controls to have data about existing groups which have read privilege for this attrib
				mav.addObject("selectedAllowedReadersList", uiHelper.getOptionsFromStringList(allowedReaders, "selectedAllowedReadersList", true, "field-blue-13-260x100", "false"));
				mav.addObject("allowedReaderGroups", uiHelper.getHiddenInputFieldWithSelections(allowedReaders, "allowedReaderGroups"));
				
				mav.addObject("selectedAllowedEditorsList", uiHelper.getOptionsFromStringList(allowedEditors, "selectedAllowedEditorsList", true, "field-blue-13-260x100", "false"));
				mav.addObject("allowedEditorGroups", uiHelper.getHiddenInputFieldWithSelections(allowedEditors, "allowedEditorGroups"));
				
				mav.addObject("selectedAllowedCreatorsList", uiHelper.getOptionsFromStringList(allowedCreators, "selectedAllowedCreatorsList", true, "field-blue-13-260x100", "false")); 
				mav.addObject("allowedCreatorGroups", uiHelper.getHiddenInputFieldWithSelections(allowedCreators, "allowedCreatorGroups"));
				
				mav.addObject("selectedAllowedDeletorsList", uiHelper.getOptionsFromStringList(allowedDeletors, "selectedAllowedDeletorsList", true, "field-blue-13-260x100", "false"));
				mav.addObject("allowedDeletorGroups", uiHelper.getHiddenInputFieldWithSelections(allowedDeletors, "allowedDeletorGroups"));

				
				// End - changes related to privilege service
				
				mav.addObject("action", "save");
				if (action.trim().equals("new"))
				{
					mav.addObject("buttonLabel", "add");
				mav.addObject("buttonLabel2", "Add");
				}
				else{
					mav.addObject("buttonLabel", "edit");
				mav.addObject("buttonLabel2", "Edit");
				}
			} else if (action.trim().equals("save")) {

				EntityType parent = metadataService.getEntityType(parentId);
				if (attrId >= 0) {
					// we are saving an existing attribute
					AttributeType existingAttribute = metadataService
							.getAttributeType(attrId);
					AttributeType editedAttribute = AttributeTypeForm
							.loadAttributeForm(request, existingAttribute);
					metadataService.updateAttributeType(editedAttribute);

					if (editedAttribute.isEntity()) {
						EntityType editedEntity = metadataService
								.getEntityType(editedAttribute.getType());
						editedEntity.setName(editedAttribute.getName());
						editedEntity.setDescription(editedAttribute.getDescription());
						metadataService.updateEntityType(editedEntity);
					}
				} else {
					// create new attribute
					
					AttributeType newAttribute = AttributeTypeForm
							.loadAttributeForm(request, null);
					metadataService.addAttributeType(parent, newAttribute);
					
					attrId = newAttribute.getAttribute_id();
				}
				
				// Amit - changes related to privilege service
				
				String featureKey = metadataService.getFeatureKeyForAttribute(parentId, attrId); //Get the feature key corresponding to this attribute

				// TODO: Convert all the hard-coded String values (keys) to constants
				
				try {
				
				String allowedReaderCombos = request.getParameterValues("allowedReaderGroups")[0];
				setPrivilegeForEAVAttrib(allowedReaderCombos, featureKey, Privilege.READ,userGroupId);
				
				String allowedEditorCombos = request.getParameterValues("allowedEditorGroups")[0];
				setPrivilegeForEAVAttrib(allowedEditorCombos, featureKey, Privilege.UPDATE,userGroupId);
				
				String allowedCreatorCombos = request.getParameterValues("allowedCreatorGroups")[0];
				setPrivilegeForEAVAttrib(allowedCreatorCombos, featureKey, Privilege.CREATE,userGroupId);
				
				String allowedDeletorCombos = request.getParameterValues("allowedDeletorGroups")[0];
				setPrivilegeForEAVAttrib(allowedDeletorCombos, featureKey, Privilege.DELETE,userGroupId);

				} catch(Exception e) {
				    logger.error(e.getMessage());
				    mav.addObject("errorMessage", e.getMessage());
				}
				// End - changes related to privilege service
				
				// TODO: redirect to parent
				mav.addObject("refresh", "true");
			} else if (action.trim().equals("delete")) {
				if (attrId > 0) {
					// Amit - changes related to privilege service	
					
					// Remove the privilege entries when the attribute is deleted
					String featureKey = metadataService.getFeatureKeyForAttribute(parentId, attrId);	
					privilegeService.deletePrivilegesForFeature(featureKey);
					
					// End - changes related to privilege service
					
					try{
					metadataService.deleteAttributeType(attrId);
					}catch(Exception e){
						String deleteMessage = "Can not delete the attribute";
						request.getSession().setAttribute("deleteMessage",deleteMessage);
						e.printStackTrace();
					}
				}
				// TODO: redirect to parent
				mav.addObject("refresh", "true");
			}
		}

		return mav;
	}
	
	/**
	 * This routine is used to get a list of "groupName:userType" entries corresponding to
	 * the group/user type tuple which have privileges to access the specified feature
	 * in the manner specified by privType 
	 * 
	 * @param featureKey
	 * @param privType
	 * @return
	 */
	private List getPrivilegedGroupAndUserType(String featureKey, String privType,long userGroupId) {
		List allOptions = new ArrayList();
		
		Privilege[] definedPrivileges = privilegeService.getDefinedPrivileges(featureKey);
		
		for(int i=0; i<definedPrivileges.length; i++) {
			String groupName = groupService.getGroup(definedPrivileges[i].getGroupId()).getGroupName();
			String userType = optionService.getOptionLookup(definedPrivileges[i].getUserType(),userGroupId).getOptValue();
		
			boolean allowed = false;
			
			if(privType.equals(Privilege.CREATE))
				allowed = definedPrivileges[i].getAllowCreate();
			else if(privType.equals(Privilege.READ))
				allowed = definedPrivileges[i].getAllowRead();
			else if(privType.equals(Privilege.UPDATE))
				allowed = definedPrivileges[i].getAllowUpdate();
			else if(privType.equals(Privilege.DELETE))
				allowed = definedPrivileges[i].getAllowDelete();
			else
				throw new IllegalArgumentException("privType should be one of CREATE/READ/UPDATE/DELETE");
			// Add groups that do not have permissions to the list
			if(!allowed) {
				allOptions.add(groupName + ":" + userType);
			}
		}
		
		return allOptions;
	}
	
	/**
	 * @param allowedCombos Comma separated list of group name/user type combinations which have
	 * 						privilege to access the specified feature
	 * @param featureKey	Unique key for the feature 
	 */
	private void setPrivilegeForEAVAttrib(String allowedCombos, String featureKey, String privType,long userGroupId) 
																throws NonCompatiblePrivilegeException {
		// First identify all the groups which previously had specified privilege for this feature
		List existingCombos = getPrivilegedGroupAndUserType(featureKey, privType,userGroupId);
		
		List l = new ArrayList();
		for(int i=0; i<existingCombos.size(); i++) {
			l.add(existingCombos.get(i));
		}
				
		// Now traverse over all the groups which have been set to have the specified privilege
		StringTokenizer st = new StringTokenizer(allowedCombos, ",");
		while(st.hasMoreTokens()) {
			String combo = st.nextToken().trim();
			
			// Deny privileges for this combo
			setPrivilegeForGroupAndUserType(combo, featureKey, privType, false, userGroupId);
			
			// Remove this combo from the list for book-keeping purposes
			l.remove(combo);
		}
		
		// Now for the remaining combos, disable previously given access
		for(int i=0; i<l.size(); i++) {
			String combo = (String) l.get(i);
			
			// Allow privileges for this combo
			setPrivilegeForGroupAndUserType(combo, featureKey, privType, true, userGroupId);
		}
	}
	
	/**
	 * 
	 * @param groupAndUserType group name and user type separated by a ":"
	 * @param featureKey
	 * @param privType
	 * @param allowed
	 * @throws NonCompatiblePrivilegeException
	 */
	private void setPrivilegeForGroupAndUserType(String groupAndUserType, String featureKey, String privType, 
							boolean allowed, long userGroupId) throws NonCompatiblePrivilegeException {
		int colonIndex = groupAndUserType.indexOf(":");

		if(colonIndex < 1)
			throw new IllegalArgumentException("groupAndUserType must be of the form group_name:user_type");
		
		String groupName = groupAndUserType.substring(0, colonIndex);
		String userTypeName = groupAndUserType.substring(colonIndex + 1);
		
		OptionLookup[] allUserTypes = optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("USER_TYPES"), userGroupId);

		long userType = -1;
		
		for(int i=0; i<allUserTypes.length; i++) {
			if(allUserTypes[i].getOptValue().equals(userTypeName)) {
				userType = allUserTypes[i].getId();
			}	
		}
		
		if(userType == -1)
			throw new IllegalArgumentException("Could not find id for user type : " + userTypeName);
				
		privilegeService.setPrivilege(groupName, userType, featureKey, privType, allowed);
	}
	 

	public UIHelper getUiHelper() {
		return uiHelper;
	}

	public void setUiHelper(UIHelper uiHelper) {
		this.uiHelper = uiHelper;
	}

	public IMetadataService getMetadataService() {
		return metadataService;
	}

	public void setMetadataService(IMetadataService metadataService) {
		this.metadataService = metadataService;
	}

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

	public IPrivilegeService getPrivilegeService() {
		return privilegeService;
	}

	public void setPrivilegeService(IPrivilegeService privilegeService) {
		this.privilegeService = privilegeService;
	}

	public IGroupService getGroupService() {
		return groupService;
	}

	public void setGroupService(IGroupService groupService) {
		this.groupService = groupService;
	}
	public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

}
