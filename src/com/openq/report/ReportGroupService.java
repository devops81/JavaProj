package com.openq.report;

import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class ReportGroupService extends HibernateDaoSupport implements IReportGroupService {
	
	/* (non-Javadoc)
 * @see com.openq.group.IGroupTreeService#getAllGroups()
 */

//Returns all the rows of the result table

public ReportGroups[] getAllGroups() {
		
	    List result = getHibernateTemplate().find("from ReportGroups order by GROUPID");
		return (ReportGroups[]) result.toArray(new ReportGroups[result.size()]); 
	}

//Saves the row to group table

public void addGroups(ReportGroups group) {
	
	getHibernateTemplate().save(group);
	
}

public ReportGroups getGroup(long groupId){
	ReportGroups grp = (ReportGroups) getHibernateTemplate().find("from ReportGroups where groupId=" + groupId).get(0);
	return grp;
}

public void deleteGroup(long groupId){
	
	ReportGroups group = getGroup(groupId);
	getHibernateTemplate().delete(group);
}

//To get all the child groups corresponding to the parent id
public ReportGroups[] getChildGroups(long parentID){
	
	List result = getHibernateTemplate().find("from ReportGroups g where g.parentGroup=" + parentID);
	return (ReportGroups[]) result.toArray(new ReportGroups[result.size()]);
}

public void updateGroup(ReportGroups group) {
	// TODO Auto-generated method stub
	getHibernateTemplate().saveOrUpdate(group);
}
}