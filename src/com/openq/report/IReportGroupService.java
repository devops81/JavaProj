package com.openq.report;

public interface IReportGroupService {

	public ReportGroups[] getAllGroups();
	public void addGroups(ReportGroups group);
	public ReportGroups[] getChildGroups(long parentID);
	public void deleteGroup(long groupId);
	public ReportGroups getGroup(long groupId);
	public void updateGroup(ReportGroups group);

}