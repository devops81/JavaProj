package com.openq.group;



public interface IUserGroupMapService {

	public UserGroupMap[] getAllGroupsForUser(long userid);

	public UserGroupMap[] getAllUsersForGroup(long groupid);

	public void saveUserGroupMap(UserGroupMap ugmap);

	public void deleteUserGroupMap(UserGroupMap ugmap);

	public void updateUserGroupMap(UserGroupMap ugmap);

	public void saveUserGroupMap(long userid, long groupid);

	public void deleteUserGroupMap(long userid, long groupid);

	public void updateUserGroupMap(long userid, long groupid);

	public long getGroupIdForUser(long userId);

	public String[] getAllTAsForUser(long userId);

}