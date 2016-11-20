package com.openq.eav.scripts;


import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.ClassPathResource;

import com.openq.contacts.Contacts;
import com.openq.contacts.IContactsService;
import com.openq.eav.EavConstants;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;

import com.openq.eav.metadata.EntityType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.org.IOrgOlMapService;
import com.openq.eav.org.OlRmlMap;
import com.openq.eav.org.OrgOlCma;
import com.openq.eav.org.OrgOlMap;
import com.openq.eav.scripts.organization.CmaIdsToLoad;
import com.openq.eav.scripts.organization.IOrgService;
import com.openq.eav.scripts.organization.Organization;
import com.openq.eav.scripts.organization.OrganizationFromOrion;
import com.openq.user.IUserService;

public class InitEavDataTables implements IInitEavDataTables {

	public static void main(String[] args) {
		ClassPathResource res = new ClassPathResource("beans.xml");
	
		XmlBeanFactory factory = new XmlBeanFactory(res);
		IInitEavDataTables init = (IInitEavDataTables) factory
				.getBean("initEavDataTables");

		/*System.out.println("Max JVM memory = " + Runtime.getRuntime().maxMemory());
		int batchSize = 50;
		
		for (int i=1; i<3446; i+= batchSize) {
			init.organizationDataLoad(i, batchSize);
			System.out.println("Free memory before GC= " + Runtime.getRuntime().freeMemory());
			Runtime.getRuntime().gc(); // garbage collect
			System.out.println("After GC = " + Runtime.getRuntime().freeMemory());
			System.out.println("Loaded " + (i + batchSize - 1) + " records so far.");
		}*/
		//init.organizationDataLoad();
		init.OrgOlMapLoad();
		//init.OlRmlMapLoad();
		  //System.out.println("Congratulations! All Org Ol Maps loaded.");
		System.out.println("Congratulations! All Rml Ol Maps loaded.");
	    //System.out.println("Congratulations! All organizations loaded.");
		// init.start();
	}

	public void organizationDataLoad(int startIndex, int size) {

		Organization[] orgs = orgService.getAllOrganizations(startIndex, size);
		//System.out.println("length" + orgs.length);
		System.out.println(orgs.length + " organizations found.");
		for (int i = 0; i < orgs.length; i++) {

			EntityType et = metadataService
					.getEntityType(EavConstants.INSTITUTION_ENTITY_ID);
			Entity entity = new Entity();
			entity.setType(et);
			dataService.saveEntity(entity); // org entity

			EntityAttribute ea = new EntityAttribute();
			ea.setParent(entity);
			dataService.saveEntityAttribute(ea, metadataService
					.getAttributeType(161l));
			//System.out.println("entityattribute" + ea.getMyEntity());
			//System.out.println("attribute"
			//		+ metadataService.getAttributeType(161));

			//System.out.println("org" + orgs[0].getName());
			dataService
					.saveStringAttribute(metadataService.getAttributeType(162),
							ea.getMyEntity(), orgs[i].getName());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(166), ea.getMyEntity(), orgs[i]
					.getMajor_segment());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(167), ea.getMyEntity(), orgs[i]
					.getMinor_segment());

			dataService.saveStringAttribute(metadataService
					.getAttributeType(169), ea.getMyEntity(), orgs[i]
					.getPhonenumber());

			dataService.saveStringAttribute(metadataService
					.getAttributeType(170), ea.getMyEntity(), orgs[i]
					.getFaxnumber());

			dataService.saveStringAttribute(metadataService
					.getAttributeType(171), ea.getMyEntity(), orgs[i]
					.getEmail());

			dataService.saveStringAttribute(metadataService
					.getAttributeType(173), ea.getMyEntity(), orgs[i].getUrl());

			dataService.saveStringAttribute(metadataService
					.getAttributeType(175), ea.getMyEntity(), orgs[i]
					.getStreet_address());

			dataService
					.saveStringAttribute(metadataService.getAttributeType(178),
							ea.getMyEntity(), orgs[i].getCity());

			dataService.saveStringAttribute(metadataService
					.getAttributeType(179), ea.getMyEntity(), orgs[i]
					.getState());

			dataService.saveStringAttribute(metadataService
					.getAttributeType(181), ea.getMyEntity(), orgs[i]
					.getZipcode());

			dataService.saveStringAttribute(metadataService
					.getAttributeType(182), ea.getMyEntity(), "United States of America");

			dataService.saveStringAttribute(metadataService
					.getAttributeType(163), ea.getMyEntity(), "");
			dataService.saveStringAttribute(metadataService
					.getAttributeType(165), ea.getMyEntity(), orgs[i]
					.getAcct_type());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(177), ea.getMyEntity(), "");
			dataService.saveStringAttribute(metadataService
					.getAttributeType(174), ea.getMyEntity(), "");
			
			dataService.saveStringAttribute(metadataService
					.getAttributeType(223), ea.getMyEntity(), orgs[i]
					                           					.getAcct_cma());

		}

	}
	
	public void OrgOlMapLoad()
	{
		
		OrgOlCma [] olOrgCma = orgOlMapService.getAllOrgOlCma();
		
		System.out.println(olOrgCma.length+"orgs found");
		for(int i=0;i<olOrgCma.length;i++)
		{
			long olid=orgOlMapService.getOlId(olOrgCma[i].getOlcma());
			long orgid=orgOlMapService.getOrgId(olOrgCma[i].getOrgcma());
			System.out.println(olid);
			System.out.println(orgid);
			if(orgid != -1 && olid != -1)
			{
			OrgOlMap omap=new OrgOlMap();
			omap.setOlId(olid);
			omap.setOrgId(orgid);
			orgOlMapService.saveOrgOlMap(omap);
			}
		}
	}
	
	
	public void OlRmlMapLoad()
	{
		OlRmlMap [] olRmlMap = orgOlMapService.getAllRmlsForOl();
		for(int i=0;i<olRmlMap.length;i++)
		{
			long olid=orgOlMapService.getOlId(olRmlMap[i].getCustnum());
			System.out.println(olid);
			if(olid != -1)
			{
			Contacts contact=new Contacts();
			contact.setKolId(olid);
			contact.setStaffid(Long.parseLong(olRmlMap[i].getStaffid()));
			contactsService.addContact(contact);
			}
		}
	}
	public void organizationDataLoad() {

		for (int i=0;i<CmaIdsToLoad.cmaIds.length;i++)
		{
			Organization[] orgs = orgService.getAllOrganizationForCmaId(CmaIdsToLoad.cmaIds[i].trim());
			//OrganizationFromOrion[] orgs = orgService.getAllOrganizationFromOrionForCmaId(CmaIdsToLoad.cmaIds[i].trim());
			System.out.println(orgs.length + " organizations found.");
			if(orgs.length>0)
			{
			EntityType et = metadataService
					.getEntityType(EavConstants.INSTITUTION_ENTITY_ID);
			Entity entity = new Entity();
			entity.setType(et);
			dataService.saveEntity(entity); // org entity

			EntityAttribute ea = new EntityAttribute();
			ea.setParent(entity);
			dataService.saveEntityAttribute(ea, metadataService
					.getAttributeType(161l));
			dataService
					.saveStringAttribute(metadataService.getAttributeType(162),
							ea.getMyEntity(), orgs[0].getName());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(166), ea.getMyEntity(), orgs[0]
					.getMajor_segment());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(167), ea.getMyEntity(), orgs[0]
					.getMinor_segment());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(169), ea.getMyEntity(), orgs[0]
					.getPhonenumber());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(170), ea.getMyEntity(), orgs[0]
					.getFaxnumber());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(171), ea.getMyEntity(), orgs[0]
					.getEmail());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(173), ea.getMyEntity(), orgs[0].getUrl());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(175), ea.getMyEntity(), orgs[0]
					.getStreet_address());
			dataService
					.saveStringAttribute(metadataService.getAttributeType(178),
							ea.getMyEntity(), orgs[0].getCity());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(179), ea.getMyEntity(), orgs[0]
					.getState());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(181), ea.getMyEntity(), orgs[0]
					.getZipcode());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(182), ea.getMyEntity(), "United States of America");

			dataService.saveStringAttribute(metadataService
					.getAttributeType(163), ea.getMyEntity(), "");
			dataService.saveStringAttribute(metadataService
					.getAttributeType(165), ea.getMyEntity(), orgs[0]
					.getAcct_type());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(177), ea.getMyEntity(), "");
			dataService.saveStringAttribute(metadataService
					.getAttributeType(174), ea.getMyEntity(), "");
			
			dataService.saveStringAttribute(metadataService
					.getAttributeType(223), ea.getMyEntity(), CmaIdsToLoad.cmaIds[i].trim());
			}

		}
	}

	/*public void organizationDataLoad() {

		for (int i=0;i<CmaIdsToLoad.cmaIds.length;i++)
		{
			OrganizationFromOrion[] orgs = orgService.getAllOrganizationFromOrionForCmaId(CmaIdsToLoad.cmaIds[i]);
			System.out.println(orgs.length + " organizations found.");
			if(orgs.length>0)
			{
			EntityType et = metadataService
					.getEntityType(EavConstants.INSTITUTION_ENTITY_ID);
			Entity entity = new Entity();
			entity.setType(et);
			dataService.saveEntity(entity); // org entity

			EntityAttribute ea = new EntityAttribute();
			ea.setParent(entity);
			dataService.saveEntityAttribute(ea, metadataService
					.getAttributeType(161l));
			dataService
					.saveStringAttribute(metadataService.getAttributeType(162),
							ea.getMyEntity(), orgs[0].getName());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(166), ea.getMyEntity(), orgs[0]
					.getMajor_segment());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(167), ea.getMyEntity(), orgs[0]
					.getMinor_segment());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(169), ea.getMyEntity(), orgs[0]
					.getPhonenumber());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(170), ea.getMyEntity(), orgs[0]
					.getFaxnumber());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(171), ea.getMyEntity(), orgs[0]
					.getEmail());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(173), ea.getMyEntity(), orgs[0].getUrl());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(175), ea.getMyEntity(), orgs[0]
					.getStreet_address());
			dataService
					.saveStringAttribute(metadataService.getAttributeType(178),
							ea.getMyEntity(), orgs[0].getCity());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(179), ea.getMyEntity(), orgs[0]
					.getState());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(181), ea.getMyEntity(), orgs[0]
					.getZipcode());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(182), ea.getMyEntity(), "United States of America");

			dataService.saveStringAttribute(metadataService
					.getAttributeType(163), ea.getMyEntity(), "");
			dataService.saveStringAttribute(metadataService
					.getAttributeType(165), ea.getMyEntity(), orgs[0]
					.getAcct_type());
			dataService.saveStringAttribute(metadataService
					.getAttributeType(177), ea.getMyEntity(), "");
			dataService.saveStringAttribute(metadataService
					.getAttributeType(174), ea.getMyEntity(), "");
			
			dataService.saveStringAttribute(metadataService
					.getAttributeType(223), ea.getMyEntity(), CmaIdsToLoad.cmaIds[i]);
			}

		}
	}*/
	private void start() {

		Entity entity = new Entity();
		entity.setType(metadataService
				.getEntityType(EavConstants.INSTITUTION_ENTITY_ID));
		dataService.saveEntity(entity);
		System.out.println("Entity Id: " + entity.getId());
		//dataService.saveOLProfile(entity);

		/*
		 * OptionLookup optLookup = new OptionLookup(); optLookup.setId(4);
		 * 
		 * String [] users = userService.searchUser("", optLookup, -1); // Get
		 * all KOLs Entity [] entities = new Entity[users.length]; for (int i=0;
		 * i<users.length; i++) { // create an entity for each user
		 * System.out.println("creating user " + users[i]);
		 * 
		 * Entity entity = new Entity();
		 * entity.setType(metadataService.getEntityType(EavConstants.KOL_ENTITY_ID));
		 * dataService.saveEntity(entity); entities[i] = entity; }
		 * 
		 * for (int k=0; k<entities.length; k++) {
		 * dataService.saveEmptyProfileForEntity(entities[k], 1); }
		 * 
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(1), 1);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(2), 2);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(3), 3);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(4), 4);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(5), 5);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(6), 6);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(7), 7);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(8), 8);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(9), 9);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(10), 10);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(11), 11);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(12), 12);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(13), 13);
		 * dataService.saveEmptyProfileForEntity(dataService.getEntity(14), 14);
		 */
		System.out.println("Init of OL profile completed.");
	}

	IMetadataService metadataService;

	IUserService userService;

	IDataService dataService;

	IOrgService orgService;
	
	IOrgOlMapService orgOlMapService;
	
	IContactsService contactsService;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.IInitEavDataTables#getUserService()
	 */
	public IUserService getUserService() {
		return userService;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.IInitEavDataTables#setUserService(com.openq.user.IUserService)
	 */
	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.IInitEavDataTables#getMetadataService()
	 */
	public IMetadataService getMetadataService() {
		return metadataService;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.IInitEavDataTables#setMetadataService(com.openq.eav.metadata.IMetadataService)
	 */
	public void setMetadataService(IMetadataService metadataService) {
		this.metadataService = metadataService;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.IInitEavDataTables#getDataService()
	 */
	public IDataService getDataService() {
		return dataService;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.IInitEavDataTables#setDataService(com.openq.eav.data.IDataService)
	 */
	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.IInitEavDataTables#getOrgService()
	 */
	public IOrgService getOrgService() {
		return orgService;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.IInitEavDataTables#setOrgService(com.openq.organization.IOrgService)
	 */
	public void setOrgService(IOrgService orgService) {
		this.orgService = orgService;
	}

	public IOrgOlMapService getOrgOlMapService() {
		return orgOlMapService;
	}

	public void setOrgOlMapService(IOrgOlMapService orgOlMapService) {
		this.orgOlMapService = orgOlMapService;
	}

	public IContactsService getContactsService() {
		return contactsService;
	}

	public void setContactsService(IContactsService contactsService) {
		this.contactsService = contactsService;
	}
}
