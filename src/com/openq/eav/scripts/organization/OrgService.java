package com.openq.eav.scripts.organization;

import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class OrgService extends HibernateDaoSupport implements IOrgService {

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.organization.IOrgService#searchOrganizationByName(java.lang.String)
	 */
	public Organization[] searchOrganizationByName(String orgName) {

		StringBuffer query = new StringBuffer("from Organization o where id>0");

		if (orgName != null && orgName.length() > 0) {
			String name = orgName.trim().toUpperCase();
			String keyword = "'%" + name + "%'";

			query.append(" AND (UPPER(o.name) LIKE (" + keyword + "))");
		}
		List result = getHibernateTemplate().find(query.toString());
		return (Organization[]) result.toArray(new Organization[result.size()]);
	}

	public Organization[] getAllOrganizations(int startIndex, int size) {

		List result = getHibernateTemplate().find(
				"from Organization o where o.id >=" + startIndex
						+ " and o.id < " + (startIndex + size));
		return (Organization[]) result.toArray(new Organization[result.size()]);
	}
	
	public OrganizationFromOrion[] getAllOrganizationFromOrionForCmaId(String cmaId) {

		List result = getHibernateTemplate().find(
				"from OrganizationFromOrion o where o.acctCma='" + cmaId
						+ "'");
		return (OrganizationFromOrion[]) result.toArray(new OrganizationFromOrion[result.size()]);
	}

	public Organization[] getAllOrganizationForCmaId(String cmaId) {

		List result = getHibernateTemplate().find(
				"from Organization o where o.acct_cma='" + cmaId
						+ "'");
		return (Organization[]) result.toArray(new Organization[result.size()]);
	}
	
	
}
