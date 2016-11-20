package com.openq.web.controllers.helpers;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.openq.authorization.FeatureUsergroupMap;
import com.openq.eav.metadata.MetadataUtil;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.option.OptionNames;
import com.openq.group.Groups;
import com.openq.group.IGroupService;

public class UIHelper {

	public IGroupService groupService;

	public IOptionService optionService;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.web.controllers.helpers.IUiHelper#getDataTypeOptions(java.lang.String,
	 *      java.lang.String, java.lang.String, java.lang.String)
	 */
	public String getDataTypeOptions(String selectName, String style,
			String selected, String disabled) {
		String options = "<select name='" + selectName + "' onchange=javascript:on" + selectName + "() class='" + style
				+ "' " + disabled + ">";

		for (int i = 0; i < MetadataUtil.supportedTypes.length; i++) {
			options += " <option value='"
					+ i
					+ "' "
					+ (selected.equals(MetadataUtil.supportedTypes[i]) ? "selected"
							: "") + ">" + MetadataUtil.supportedTypes[i]
					+ "</option>";
		}
		options += "</select>";

		return options;
	}

	public String getBasicDataTypeOptions(String selectName, String style,
			String selected, String disabled) {
		String options = "<select name='" + selectName + "' onchange=javascript:on" + selectName + "() class='" + style
				+ "' " + disabled + ">";

		for (int i = 0; i < MetadataUtil.supportedTypes.length - 2; i++) {
			options += " <option value='"
					+ i
					+ "' "
					+ (selected.equals(MetadataUtil.supportedTypes[i]) ? "selected"
							: "") + ">" + MetadataUtil.supportedTypes[i]
					+ "</option>";
		}
		options += "</select>";

		return options;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.web.controllers.helpers.IUiHelper#getGroupOptions(java.lang.String,
	 *      java.lang.String, java.lang.String)
	 */
	public String getGroupOptions(String selectName, String style,
			String disabled) {
		
		Groups[] groups = groupService.getAllGroups();
		
		return getOptionsForGroupList(groups, selectName, false, style, disabled);
	}

	
	/**
	 * This routine is used to create an HTML options tag with entries for all specified group names 
	 * 
	 * @param groups
	 * @param selectName
	 * @param isMultipe if it should be a multi-select option list
	 * @param style
	 * @param disabled
	 * @return
	 */
	public String getOptionsForGroupList(Groups[] groups, String selectName, boolean isMultiple, String style, String disabled) {
		String options = "<select name='" + selectName + "' " + (isMultiple?"multiple":"") + " class='" + style
								+ "' " + disabled + ">";

		if (groups != null) {
			for (int i = 0; i < groups.length; i++) {
				options += " <option id='"+groups[i].getGroupId()+"' value='" + groups[i].getGroupName()
						+ "' >" + groups[i].getGroupName() + "</option>";
			}
		}
		
		options += "</select>";
		
		return options;
	}
	
	/**
	 * This routine is used to create an HTML options tag with entries for all specified entries in the list of option lookup 
	 * 
	 * @param list
	 * @param selectName
	 * @param isMultipe if it should be a multi-select option list
	 * @param style
	 * @param disabled
	 * @return
	 */
	public String getOptionsForOptionLookupList(OptionLookup[] list, String selectName, boolean isMultiple, String style, String disabled) {
		String options = "<select name='" + selectName + "' " + (isMultiple?"multiple":"") + " class='" + style
								+ "' " + disabled + ">";

		if (list != null) {
			for (int i = 0; i < list.length; i++) {
				options += " <option value='" + list[i].getOptValue()
						+ "' >" + list[i].getOptValue() + "</option>";
			}
		}
		
		options += "</select>";
		
		return options;
	}
	
	/**
	 * This routine is used to create an HTML options tag with entries for all specified entries in the list
	 * 
	 * @param optionNames
	 * @param selectName
	 * @param isMultiple
	 * @param style
	 * @param disabled
	 * 
	 * @return
	 */
	public String getOptionsFromStringList(List optionNames, String selectName, boolean isMultiple, String style, String disabled) {
		String options = "<select name='" + selectName + "' " + (isMultiple?"multiple":"") + " class='" + style
		+ "' " + disabled + ">";
		
		if((optionNames != null) && (optionNames.size() != 0)) {
			for (int i=0; i<optionNames.size(); i++) {
				options += " <option value='" + optionNames.get(i)
						+ "' >" + optionNames.get(i) + "</option>";
			}
		}
		
		return options;
	}
	
	/**
	 * This routine is used to get a input hidden field with comma-separated names of all specified groups
	 * 
	 * @param groups
	 * @return
	 */
	public String getHiddenInputFieldWithSelections(List optionNames, String selectName) {
		String inputField = "<input type='hidden' name='" + selectName + "' value='";
		for(int i=0; i<optionNames.size(); i++) {
			inputField += optionNames.get(i);
			if(optionNames.size() - i > 1)
				inputField += ",";
		}
		inputField += "'/>";
		
		return inputField;
	}
	
	public String getListOfValues(String selectName, String style, String selected, String disabled) {
		String options = "<select name='" + selectName + "'  class='" + style
				+ "' " + disabled + ">";

		OptionNames[] optionNames = optionService.getAllOptionNames();
		if (optionNames != null) {
			for (int i = 0; i < optionNames.length; i++) {
				options += " <option value='" + optionNames[i].getId()
						+ "' >" + optionNames[i].getName() + "</option>";
			}
		}

		options += "</select>";

		return options;
	}

	/**
	 * This routine is used to create an HTML options tag with entries for all specified feature entity names for which security
	 * is required
	 * 
	 * @param featurePermissionIdName
	 * @param selectName
	 * @param isMultipe if it should be a multi-select option list
	 * @param style
	 * @param disabled
	 * @return
	 */
	public String getOptionsForFeaturePermissionIdName(Map featurePermissionIdNamePair, 
			String selectName, boolean isMultiple, String style, String disabled) {
		String options = "<select name='" + selectName + "' " + (isMultiple?"multiple":"") + " class='" + style
								+ "' " + disabled + ">";
		if(featurePermissionIdNamePair != null){
			for (Iterator iter = featurePermissionIdNamePair.keySet().iterator(); iter.hasNext();) {
	            Long key = (Long) iter.next();
	            String value = (String) featurePermissionIdNamePair.get(key);
					options += " <option id='"+key+"' value='" + value
							+ "' >" + value + "</option>";
			}
		}
		options += "</select>";
		return options;
	}
	
	/**
	 * This routine is used to create an HTML options tag with entries for all permissible features entities
	 * and the user groups.
	 * 
	 * @param featureUsergroupMap
	 * @param selectName
	 * @param isMultipe if it should be a multi-select option list
	 * @param style
	 * @param disabled
	 * @return
	 */
	public String getOptionsForFeatureUsergroupMap(
			FeatureUsergroupMap[] featureUsergroupMap, 
			Map featurePermissionIdNamePair,
			Map allUserGroupsMap,
			String selectName,
			boolean isMultiple, String style, String disabled) {
		String options = "<select name='" + selectName + "' "
		+ (isMultiple ? "multiple" : "") + " class='" + style + "' "
		+ disabled + ">";

		if (featureUsergroupMap != null && featurePermissionIdNamePair != null && allUserGroupsMap != null) {
			for (int i = 0; i < featureUsergroupMap.length; i++) {
				String entityIdUsergroupId = featureUsergroupMap[i].getFeatureId()
				+ ":" + featureUsergroupMap[i].getUsergroupId();
				Long featureEntityId = new Long(featureUsergroupMap[i].getFeatureId());
				Long usergroupId = new Long(featureUsergroupMap[i].getUsergroupId());
				String featureEntityName = "";
				String usergroupName = "";
				if(featurePermissionIdNamePair.containsKey(featureEntityId))
					featureEntityName = (String) featurePermissionIdNamePair.get(featureEntityId);
				
				if(allUserGroupsMap.containsKey(usergroupId))
					usergroupName = (String) allUserGroupsMap.get(usergroupId);
				
				String displayValue = featureEntityName	+ ":" + usergroupName;
				options += " <option id='" + featureUsergroupMap[i].getId()
				+ "' value='" + entityIdUsergroupId + "' >"
				+ displayValue + "</option>";
			}
		}

		options += "</select>";

		return options;
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
