package com.openq.eav.org;

import java.util.List;


import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class OrgOlMapService extends HibernateDaoSupport implements IOrgOlMapService {

	public OrgOlMap[] getAllOrgsForOl(long olid) {
	    List result = getHibernateTemplate().find("from OrgOlMap o where o.olId="+olid);
        return (OrgOlMap[]) result.toArray(new OrgOlMap[result.size()]);
	}
	
	public OlRmlMap[] getAllRmlsForOl() {
	    List result = getHibernateTemplate().find("from OlRmlMap o");
        return (OlRmlMap[]) result.toArray(new OlRmlMap[result.size()]);
	}

	public OrgOlMap[] getAllOlsForOrgs(long orgid) {
	    List result = getHibernateTemplate().find("from OrgOlMap o where o.orgId="+orgid);
        return (OrgOlMap[]) result.toArray(new OrgOlMap[result.size()]);
	}

	public OrgOlCma[] getAllOrgOlCma()
	{
		List result =getHibernateTemplate().find("from OrgOlCma o where o.id>0");
	    return (OrgOlCma[]) result.toArray(new OrgOlCma[result.size()]);
	}
	
	public void saveOrgOlMap(OrgOlMap omap) {
		//List result = getHibernateTemplate().find("from OrgOlMap o where o.orgId="+omap.getOrgId()+ "and o.olId="+omap.getOlId());
		//if(result.size()==0)
		getHibernateTemplate().save(omap);
	}
	
	public OrgOlMap getOrgOlMap(long orgolId){
		return (OrgOlMap) getHibernateTemplate().find("from OrgOlMap o where o.id=" + orgolId).get(0);
	}

	public void deleteOrgOlMap(OrgOlMap omap) {
		getHibernateTemplate().delete(omap);
	}

	public void deleteOrgOlMap(long olid, long orgid) {
		List result = getHibernateTemplate().find("from OrgOlMap o where o.orgId="+orgid+"AND o.olId="+olid);
		if(result.size()!=0)
			getHibernateTemplate().delete((OrgOlMap)result.get(0));
	}

	
	public void updateOrgOlMap(OrgOlMap omap) {
		getHibernateTemplate().update(omap);
	}
	
	public void saveOrgOlMap(long orgid, long olid) {
		OrgOlMap oMap = new OrgOlMap();
		oMap.setOlId(olid);
		oMap.setOrgId(orgid);
		getHibernateTemplate().save(oMap);
	}
	
	
	
	public long getOlId(String olCma)
	{
		List result=getHibernateTemplate().find("select A.id from User A, StringAttribute B,EntityAttribute C,EntityAttribute D"
				+" where D.parent=A.kolid and B.attribute=222 and B.parent=C.myEntity and C.parent=D.myEntity and B.value='"+olCma+"'");
		
		if (result.size() >0)
		{
			return ((Long) result.get(0)).longValue();
		}
		
		return -1;
	}
	
	public long getOlEntityId(String custId)
	{
		List result=getHibernateTemplate().find("select A.id from Entity A, StringAttribute B,EntityAttribute C,EntityAttribute D"
				+" where D.parent=A.id and B.attribute=222 and B.parent=C.myEntity and C.parent=D.myEntity and B.value='"+custId+"'");
		
		if (result.size() >0)
		{
			return ((Long) result.get(0)).longValue();
		}
		
		return -1;
	}
	public long getOrgId(String orgCma)
	{
		
		
		List result=getHibernateTemplate().find("SELECT A.id FROM Entity A,StringAttribute B,EntityAttribute C "
        +" where C.parent=A.id and B.attribute=223 and B.parent=C.myEntity and B.value='"+orgCma+"'");

		if (result.size() >0)
		{
			return ((Long) result.get(0)).longValue();
		}
		
		return -1;
	}
}
