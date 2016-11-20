package com.openq.eav.option;

public interface IOptionServiceWrapper extends IOptionService {
	public OptionLookup[] getValuesForOptionAndUser(long OptionId, long userId, long userGroupId);
	public OptionLookup[] getValuesForOptionAndUser(String optionName, long userId, long userGroupId);
	public OptionLookup[] getUndeletedValuesForOptionAndUser(String optionName, long userId, long userGroupId);
	public OptionLookup[] getValuesForOptionName(String optionName, long userGroupId);
	public OptionLookup[] getUndeletedValuesForOptionName(String optionName, long userGroupId);
    public OptionLookup getValuesForId(long id, long userGroupId);
    public boolean isTASphereOfInfluence(String sphereOfInfluence);
    public boolean isBMSInfoAttribute(String attribute);
}
