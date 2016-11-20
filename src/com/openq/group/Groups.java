package com.openq.group;

import java.io.Serializable;

import com.openq.user.User;

public class Groups implements Serializable {

	public Groups (){}
	
	private long groupId;
	private String groupName;
	private String groupDescription;
	private String groupType;
	private String therupticArea;
	private String functionalArea;
	private String Region;
	private long parentGroup;
	private User user;
	
	public String getGroupDescription() {
		return groupDescription;
	}
	public void setGroupDescription(String groupDescription) {
		this.groupDescription = groupDescription;
	}
	public long getGroupId() {
		return groupId;
	}
	public void setGroupId(long groupId) {
		this.groupId = groupId;
	}
	public String getGroupName() {
		return groupName;
	}
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	public String getGroupType() {
		return groupType;
	}
	public void setGroupType(String groupType) {
		this.groupType = groupType;
	}
	public long getParentGroup() {
		return parentGroup;
	}
	public void setParentGroup(long parentGroup) {
		this.parentGroup = parentGroup;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public String getFunctionalArea() {
		return functionalArea;
	}
	public void setFunctionalArea(String functionalArea) {
		this.functionalArea = functionalArea;
	}
	public String getTherupticArea() {
		return therupticArea;
	}
	public void setTherupticArea(String therupticArea) {
		this.therupticArea = therupticArea;
	}
	public String getRegion()
	{
	return Region;
	}
	public void setRegion(String region)
	{
	this.Region=region;
	}
	
	
}