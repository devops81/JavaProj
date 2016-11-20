package com.openq.eav.audit;

import java.util.Calendar;
import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class AuditService extends HibernateDaoSupport implements IAuditService {

	public void saveAuditInfo(AuditInfo auditInfo) {
		auditInfo.setUpdateTime(Calendar.getInstance().getTime());
		getHibernateTemplate().save(auditInfo);
	}
	
	private List getAuditInfo(long entityId){
		return(getHibernateTemplate().find("from AuditInfo a where a.editedEntityId="
						+ entityId + " order by a.updateTime asc"));
	
	}

	public AuditInfo getLatestAuditInfo(long entityId) {
		List auditInfoList = getAuditInfo(entityId);
		if (auditInfoList.size() > 0) {
			return ((AuditInfo) auditInfoList.get(auditInfoList.size() - 1));
		}
		return null;
	}

	public AuditInfo getOldestAuditInfo(long entityId) {
		List auditInfoList = getAuditInfo(entityId);
		if (auditInfoList.size() > 0)
			return ((AuditInfo) auditInfoList.get(0));
		return null;
	}
}
