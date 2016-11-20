package com.openq.report;

import java.io.Serializable;

import com.openq.user.User;

public class ReportGroups implements Serializable {

	public ReportGroups (){}
	
	private long groupId;
	private String groupName;
	private String groupDescription;
	private long parentGroup;
	/**
	 * @return the groupDescription
	 */
	public String getGroupDescription() {
		return groupDescription;
	}
	/**
	 * @param groupDescription the groupDescription to set
	 */
	public void setGroupDescription(String groupDescription) {
		this.groupDescription = groupDescription;
	}
	/**
	 * @return the groupId
	 */
	public long getGroupId() {
		return groupId;
	}
	/**
	 * @param groupId the groupId to set
	 */
	public void setGroupId(long groupId) {
		this.groupId = groupId;
	}
	/**
	 * @return the groupName
	 */
	public String getGroupName() {
		return groupName;
	}
	/**
	 * @param groupName the groupName to set
	 */
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	/**
	 * @return the parentGroup
	 */
	public long getParentGroup() {
		return parentGroup;
	}
	/**
	 * @param parentGroup the parentGroup to set
	 */
	public void setParentGroup(long parentGroup) {
		this.parentGroup = parentGroup;
	}
	
	
	
}