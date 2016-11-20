package com.openq.eav.option;

import java.util.ArrayList;
import java.util.List;

import com.openq.group.Groups;
import com.openq.group.IGroupService;
import com.openq.group.IUserGroupMapService;
import com.openq.group.UserGroupMap;
import com.openq.utils.PropertyReader;
import com.openq.web.controllers.Constants;

public class OptionServiceWrapper extends OptionService implements IOptionServiceWrapper {
	
	public OptionLookup[] getValuesForOptionAndUser(long optionId, long userId,long userGroupId) {
		if(optionId > 0){
			OptionLookup [] lookups = getValuesForOption(optionId, userGroupId);
			if(lookups != null && lookups.length > 0){
				return lookups;
			}
		}
		return new OptionLookup[0];
	}
	public OptionLookup[] getUndeletedValuesForOptionAndUser(long optionId, long userId,long userGroupId) {
		logger.debug("Option Lookup getUndeletedValuesForOptionAndUser optionId" + optionId);
		if (optionId < 0)
			return new OptionLookup[0];
		
		UserGroupMap[] groups = groupMapService.getAllGroupsForUser(userId);
		// if the group does not exist, use default value
		if (groups.length == 0)
			return getUndeletedValuesForOption(optionId, userGroupId);
		
		
		ArrayList optionValues = new ArrayList();
		
		for (int i=0; i<groups.length; i++) {
			long grpId = groups[i].getGroup_id();
			Groups g = groupService.getGroup(grpId);
			OptionNames optName = getOptionNames(optionId);
			String optionName = optName.getName() + " - " + g.getGroupName();
			
			// get all option values and return
			OptionLookup [] lookups = getUndeletedValuesForOption(optionName, userGroupId);
			
			for (int j=0; j<lookups.length; j++) {
				optionValues.add(lookups[j]);
			}
		}
		
		if (optionValues.size() == 0)
			return getUndeletedValuesForOption(optionId, userGroupId);
		
		return (OptionLookup []) optionValues.toArray(new OptionLookup[optionValues.size()]);
	}
	public OptionLookup[] getValuesForOptionAndUser(String optionName, long userId,long userGroupId) {		
		return getValuesForOptionAndUser(getIdForOptionName(optionName), userId, userGroupId);
	}
	
	public OptionLookup[] getUndeletedValuesForOptionAndUser(String optionName, long userId,long userGroupId) {
		logger.debug("Option Lookup getUndeletedValuesForOptionAndUser optionName "+optionName);
		return getUndeletedValuesForOptionAndUser(getIdForOptionName(optionName), userId, userGroupId);
	}
	public OptionLookup[] getValuesForOptionName(String optionName,long userGroupId){
		long optionId = getIdForOptionName(optionName);
		logger.debug(" optionID Found for OptionName|"+optionName+"|"+optionId);
		if (optionId < 0)
			return new OptionLookup[0];
		return getValuesForOption(optionId, userGroupId);
	}
	public OptionLookup[] getUndeletedValuesForOptionName(String optionName,long userGroupId){
		logger.debug("Option Lookup getUndeletedValuesForOptionName optionName "+optionName);
		long optionId = getIdForOptionName(optionName);
		//System.out.println(" optionID Found for OptionName|"+optionName+"|"+optionId);
		if (optionId < 0)
			return new OptionLookup[0];
		return getUndeletedValuesForOption(optionId, userGroupId);
	}

    public OptionLookup getValuesForId(long id, long userGroupId) {
        return getOptionLookup(id, userGroupId);
    }
	public boolean isTASphereOfInfluence(String sphereOfInfluence) {
		boolean taSphereOfInfluence = false;
		String TAOptionName = PropertyReader
		.getLOVConstantValueFor("THERAPEUTIC_AREA");
		List TAList = getOptionLookupByName(TAOptionName);
		String TASphereOfInfluence = null;
		OptionLookup TALookup = new OptionLookup();
			for(int i=0; i<TAList.size(); i++){
				TALookup = (OptionLookup) TAList.get(i);
				TASphereOfInfluence =  TALookup.getOptValue()+ " " + Constants.SPHERE_OF_INFLUENCE_SUFFIX;
				if(TASphereOfInfluence.equals(sphereOfInfluence)){
					taSphereOfInfluence = true;
					break;
				}
			}
		return taSphereOfInfluence;
	}
	public boolean isBMSInfoAttribute(String attribute) {
		boolean BMSInfoAttribute = false;
		if(attribute != null && attribute.startsWith("BMS")){
			BMSInfoAttribute = true;
		}
		
		return BMSInfoAttribute;
	}
    private IGroupService groupService;
	private IUserGroupMapService groupMapService;
	
	public IGroupService getGroupService() {
		return groupService;
	}

	public void setGroupService(IGroupService groupService) {
		this.groupService = groupService;
	}

	public IUserGroupMapService getGroupMapService() {
		return groupMapService;
	}

	public void setGroupMapService(IUserGroupMapService groupMapService) {
		this.groupMapService = groupMapService;
	}
}

