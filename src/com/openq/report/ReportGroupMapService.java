package com.openq.report;

import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.authorization.IFeaturePermissionService;
import com.openq.web.controllers.Constants;

public class ReportGroupMapService extends HibernateDaoSupport implements
IReportGroupMapService {

	IFeaturePermissionService  featurePermissionService;
	
	/**
	 * @return the featurePermissionService
	 */
	public IFeaturePermissionService getFeaturePermissionService() {
		return featurePermissionService;
	}

	/**
	 * @param featurePermissionService the featurePermissionService to set
	 */
	public void setFeaturePermissionService(
			IFeaturePermissionService featurePermissionService) {
		this.featurePermissionService = featurePermissionService;
	}

	public ReportGroupMap[] getAllGroupsForReport(long reportId, long userGroupId) {
		final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.REPORT_PERMISSION_ID, userGroupId);
		List result = getHibernateTemplate().find(
				"select rg from ReportGroupMap rg where rg.report_id "
				+ PERMISSION_APPEND_QUERY + " and rg.report_id="
				+ reportId);
		return (ReportGroupMap[]) result.toArray(new ReportGroupMap[result.size()]);
	}

	public ReportGroupMap[] getGroupsReportMap(long reportId, long groupId, long userGroupId) {
		final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.REPORT_PERMISSION_ID, userGroupId);
		List result = getHibernateTemplate().find(
				"select rg from ReportGroupMap rg where rg.report_id "
				+ PERMISSION_APPEND_QUERY + " and rg.report_id="
				+ reportId + " and rg.report_group_id=" + groupId);
		return (ReportGroupMap[]) result.toArray(new ReportGroupMap[result
		                                                            .size()]);
	}

	public List getAllGroupsListForReport(long reportId, long userGroupId) {
		final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.REPORT_PERMISSION_ID, userGroupId);
		List result = getHibernateTemplate().find(
				"select rg from ReportGroupMap rg where rg.report_id "
				+ PERMISSION_APPEND_QUERY + " and rg.report_id="
				+ reportId);
		return result;
	}

	public List getAllReportsListForGroup(long groupId, long userGroupId) {
		final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.REPORT_PERMISSION_ID, userGroupId);
		List result = getHibernateTemplate()
		.find("select rg from ReportGroupMap rg where rg.report_id "
				+ PERMISSION_APPEND_QUERY
				+ " and rg.report_group_id=" + groupId);
		return result;
	}

	public long getGroupIdForReport(long reportId, long userGroupId) {
		ReportGroupMap[] userGroupMap = getAllGroupsForReport(reportId, userGroupId);

		if (userGroupMap != null && userGroupMap.length > 0) {
			return userGroupMap[0].getReport_group_id();
		}

		return -1;
	}

	public ReportGroupMap[] getAllReportForGroup(long groupid, long userGroupId) {

		// 09-July-2008 : Modified the query and joined with reports table to
		// get the reports sorted by reportname
		// TODO : have many-one reference in ReportGroupMap.hbm.xml to
		// Report.hbm.xml
		// so that we can easily get the report name
		final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.REPORT_PERMISSION_ID, userGroupId);
		String query = "Select rg from ReportGroupMap rg, Report r where "
			+ "r.reportID=rg.report_id and r.reportID "
			+ PERMISSION_APPEND_QUERY
			+ " and rg.report_group_id="
			+ groupid + " order by r.name";
		List result = getHibernateTemplate().find(query);
		return (ReportGroupMap[]) result.toArray(new ReportGroupMap[result.size()]);
	}

	public void saveReportGroupMap(ReportGroupMap rgmap) {

		getHibernateTemplate().save(rgmap);

	}

	public void deleteReportGroupMap(ReportGroupMap rgmap) {

		getHibernateTemplate().delete(rgmap);

	}

	public void updateReportGroupMap(ReportGroupMap rgmap) {

		getHibernateTemplate().update(rgmap);

	}

	public void saveReportGroupMap(long reportid, long groupid) {

		ReportGroupMap rgmap = new ReportGroupMap();
		rgmap.setReport_group_id(groupid);
		rgmap.setReport_id(reportid);
		getHibernateTemplate().save(rgmap);

	}

	public void deleteReportGroupMap(long reportid, long groupid, long userGroupId) {

		ReportGroupMap[] rgmap = getGroupsReportMap(reportid, groupid, userGroupId);

		/*
		 * rgmap.setReport_group_id(groupid); // changed to setId
		 * rgmap.setReport_id(reportid);
		 */
		getHibernateTemplate().delete(rgmap[0]);

	}

	public void updateReportGroupMap(long reportid, long groupid) {

		ReportGroupMap rgmap = new ReportGroupMap();
		rgmap.setReport_group_id(groupid);
		rgmap.setReport_id(reportid);
		getHibernateTemplate().update(rgmap);

	}
}
