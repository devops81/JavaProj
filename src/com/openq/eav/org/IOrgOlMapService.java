package com.openq.eav.org;

public interface IOrgOlMapService {
   
	public long getOlEntityId(String custId);
	public OlRmlMap[] getAllRmlsForOl();
	public OrgOlMap[] getAllOrgsForOl(long oldid);

	public OrgOlMap[] getAllOlsForOrgs(long orgid);

	public void saveOrgOlMap(OrgOlMap omap);

	public void deleteOrgOlMap(OrgOlMap omap);

	public void updateOrgOlMap(OrgOlMap omap);

	public void saveOrgOlMap(long orgid, long olid);
	
	public OrgOlMap getOrgOlMap(long orgolId);

	
	public OrgOlCma[] getAllOrgOlCma();
	
	public long getOrgId(String orgCma);
	
	public long getOlId(String olCma);

	
	public void deleteOrgOlMap(long olid, long orgid);

}
