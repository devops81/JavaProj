package com.openq.group;

import java.util.Map;

public interface IGroupService {

	public Groups[] getAllGroups();
	public void addGroups(Groups group);
	public Groups[] getChildGroups(long parentID);
	public void deleteGroup(long groupId);
	public Groups getGroup(long groupId);
	public void updateGroup(Groups group);
	public Map getGroupidGroupnameMap();
	public Groups[] getAllGroupsExcludingAdminUserGroup(long adminGroupId);
	public Groups getGroupByName(String groupName);

}