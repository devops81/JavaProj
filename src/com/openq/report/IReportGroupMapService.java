package com.openq.report;

import java.util.List;



public interface IReportGroupMapService {

	public ReportGroupMap[] getAllGroupsForReport(long reportId, long userGroupId);
	
	public ReportGroupMap[] getGroupsReportMap(long reportId,long groupId, long userGroupId);
	
	public List getAllGroupsListForReport(long reportId, long userGroupId);
	
	public List getAllReportsListForGroup(long groupId, long userGroupId);

	public ReportGroupMap[] getAllReportForGroup(long groupid, long userGroupId);

	public void saveReportGroupMap(ReportGroupMap rgmap);

	public void deleteReportGroupMap(ReportGroupMap rgmap);

	public void updateReportGroupMap(ReportGroupMap rgmap);

	public void saveReportGroupMap(long reportId, long groupid);

	public void deleteReportGroupMap(long reportId, long groupid, long userGroupId);

	public void updateReportGroupMap(long reportId, long groupid);
	
	public long getGroupIdForReport(long reportId, long userGroupId);

}