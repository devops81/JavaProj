package com.openq.eav.scripts;

import com.openq.contacts.IContactsService;
import com.openq.eav.data.IDataService;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.org.IOrgOlMapService;
import com.openq.eav.scripts.organization.IOrgService;
import com.openq.user.IUserService;

public interface IInitEavDataTables {

	public IUserService getUserService();

	public void setUserService(IUserService userService);

	
	public IOrgOlMapService getOrgOlMapService();

	public void setOrgOlMapService(IOrgOlMapService orgOlMapService); 
	public IMetadataService getMetadataService();

	public void setMetadataService(IMetadataService metadataService);

	public IDataService getDataService();

	public void setDataService(IDataService dataService);

	public IOrgService getOrgService();

	public void setOrgService(IOrgService orgService);

	public void organizationDataLoad(int startIndex, int size);
	
	public void organizationDataLoad();
	
	public void OrgOlMapLoad();
	public void OlRmlMapLoad();
	
	public IContactsService getContactsService();

	public void setContactsService(IContactsService contactsService);

}