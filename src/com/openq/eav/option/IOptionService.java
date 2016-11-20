package com.openq.eav.option;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

public interface IOptionService {

	public OptionNames[] getAllOptionNames();

	public OptionNames getOptionNames(long id);

	public OptionLookup getOptionLookup(long id,long userGroupId);

	public OptionLookup getOptionLookup(long id);

	public OptionLookup[] getValuesForOption(long OptionId,long userGroupId);
	
	public OptionLookup[] getValuesForOptionWithExcludedValues(long id,long userGroupId, String[] excludedValues);

	public OptionLookup[] getValuesForOption(String optionName,long userGroupId);

	public void saveUpdateOptionLookup(long id, String value,long userGroupId);

	public void deleteOptionLookup(long id,long userGroupId);

	public void deleteOptionLookup(OptionLookup opid,long userGroupId);

	public long getIdForOptionName(String optionName);

	public void createOptionName(OptionNames OptionName);

    public OptionNames createOrUpdateOptionName(String name);

    public void addValueToOptionLookup(OptionNames optionNames, String value , long parentId);

	public void addValueToOptionLookup(OptionLookup ol,OptionNames on);

	public void addValuesToOptionLookUp(OptionNames optionNames, LinkedHashSet ValuesSet);

    public void addOrUpdateValuesToOptionLookUp(OptionNames optionNames, LinkedHashSet ValuesSet,long userGroupId);

    public void saveUpdateOptionName(long id, String value);
    
	public OptionLookup[] getUndeletedValuesForOption(long OptionId,long userGroupId) ;
	public OptionLookup[] getRelatedChild(long optionId, long parentId,long userGroupId);

	public OptionLookup[] getAllChild(long parentId,long userGroupId);

	/**
	 * This method sets the default value for option lookup LOV
	 * @param existingOptionLookupId
	 * @param newOptionLookupId
	 * @return boolean true for success and false for failure
	 */

	public boolean setDefaultDisplayValue(long existingOptionLookupId, long newOptionLookupId,long userGroupId);

	/**
	 * This method deletes the default value for option lookup LOV
	 * @param existingOptionLookupId
	 * @return boolean true for success and false for failure
	 */
	public boolean deleteDefaultDisplayValue(long existingOptionLookupId,long userGroupId);

	/**
	 * This method updates the display order for option lookup LOV
	 * @param optionLookup
	 */

	public void updateOptionLookupDisplayOrder(OptionLookup optionLookup);

	public List getRelatedChild(String optionName, long parentId,long userGroupId);
	/**
	 * This method will delete all the child records recursively
	 * @param parentId
	 */
	public void deleteChildRecordsCascade(long parentId);

	/**
	 *
	 * @param optionName
	 * @param commaSeparatedParentIds
	 * @param userGroupId
	 * @param lovValuesToBeExcluded
	 * @param allowDeletedValuesFlag
	 * @return
	 */
	public List getRelatedChildForParents(String optionName, String commaSeparatedParentIds, long userGroupId, String lovValuesToBeExcluded, boolean allowDeletedValuesFlag);

	public OptionLookup getOptionValueForOptValueAndRegion(String optValue, String region);

	public long getIdForOptionValue(String optValue);

	public OptionLookup getOptionForOptionValue(String optValue);

	public OptionLookup[] getAllOptions(String optionList,long userGroupId);

	public long getIdForOptionValueAndParentName(String optValue,String parentName);

	public List getLookupForOptionId(long optionId, long userGroupId);

	public List getOptionLookupByName(String optionName);
	public void saveUpdateOptionLookup(long id, String value,long parentId,long userGroupId);

	public OptionLookup[] getValuesForOptionByDeleteStatus(String optionName, long userGroupId, boolean allowDeletedValues);

	/**
	 * @see Use this function only if all the option Values for the Option Name are unique.
	 * @param parentOptionName
	 * @param parentOptionValue
	 * @return parent Option Lookup Object
	 */
	public OptionLookup getParentOptionLookupId(String parentOptionName, String parentOptionValue);

	/**
	 * @see Use this API to check if an OptionValue already exist in the option Lookup table, avoid duplicates
	 * @param childOptionValue
	 * @param parentOptionValue
	 * @return true if exists, false, if not exists
	 */
	public boolean doesOptionLookupExist(String childValue, long parentOptionValueId);
	
	public Map getValueParentMap(String optionName);

	public OptionLookup getParentLookupObject(String childOptionName);
}