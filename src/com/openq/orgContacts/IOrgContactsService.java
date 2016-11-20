package com.openq.orgContacts;

import java.io.IOException;
import java.text.ParseException;
import java.util.Map;

import com.openq.eav.org.Organization;

public interface IOrgContactsService {
	public boolean addOrgContact(OrgContacts orgContact) throws ParseException, IOException;
	public boolean getOrgContact(OrgContacts orgContact);
	public void update(OrgContacts orgContact);
	public Organization[] getOrgContactsForStaffId(long staffid);
	public OrgContacts [] getOrgContactsForOrgId(long orgId);
	public void delete(long orgContactId);
	public OrgContacts getOrgContact(long orgContactId);
	public Map getOrgContactsMapForStaffId(long staffId, String filterFlag);
	public void updateOrgContactList(long staffId, OrgContacts[] newContacts)throws IOException, ParseException;
	public OrgContacts[] getOrgContactsList(long staffId);
	public void deleteOrgContact(OrgContacts contact);
	
}
