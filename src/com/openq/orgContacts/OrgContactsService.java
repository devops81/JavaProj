package com.openq.orgContacts;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.eav.EavConstants;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.org.IOrganizationService;
import com.openq.eav.org.Organization;
import com.openq.kol.DBUtil;
import com.openq.user.IUserService;
import com.openq.user.User;

public class OrgContactsService extends HibernateDaoSupport implements IOrgContactsService{
	IOrganizationService orgService;
	IUserService userService;

	private static final String PROPERTIES_FILE = "resources/ServerConfig.properties";
	
	private static final String ENDDATE = "contact.endDate";

	public static Logger logger = Logger.getLogger(OrgContactsService.class);
	
	
	public boolean addOrgContact(OrgContacts orgContact) throws ParseException, IOException {
		logger.info("Adding Org Contact");
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
		String presentDate= (dateFormat.format(date)).toString();
		orgContact.setBegindate(dateFormat.parse(presentDate));
		Properties p = DBUtil.getInstance().getDataFromPropertiesFile(
				PROPERTIES_FILE);
		orgContact.setEnddate(dateFormat.parse(p.getProperty(ENDDATE)));
		if((getHibernateTemplate().find("from OrgContacts o where o.orgId=" + orgContact.getOrgId() 
				+ " AND o.staffid=" + orgContact.getStaffid()+ "And begindate <= '" + presentDate + "' and enddate >= '"+ presentDate +"'")).size() == 0){
			getHibernateTemplate().save(orgContact);
		logger.info("Saved to the database");
		return true;
		}
		logger.info("OrgContact already present in database");
		return false;
	}
	public boolean getOrgContact(OrgContacts orgContact){
		logger.debug("Getting OrgContact: " + orgContact );
		
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
		String presentDate= (dateFormat.format(date)).toString();
		
		
		if(orgContact != null){
			List result = getHibernateTemplate().find("from OrgContacts where orgId=" + orgContact.getOrgId() + "AND staffid=" + orgContact.getStaffid() + "And begindate <= '" + presentDate + "' and enddate >= '"+ presentDate +"'");
			return(result.size() == 0);
		}
		return false;
	}

	public Organization[] getOrgContactsForStaffId(long staffId) {
		logger.debug("Getting Org Contacts for StaffId:" + staffId);
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
		String presentDate= (dateFormat.format(date)).toString();
		
		List result = getHibernateTemplate().find("from OrgContacts o where staffid=" + staffId + " and begindate <= '" 
				+ presentDate + "' and enddate >= '"+ presentDate +"'");
		if(result != null && result.size() > 0){
			OrgContacts [] orgContacts = (OrgContacts [])result.toArray(new OrgContacts[result.size()]);
			List orgToReturn = new ArrayList();
			logger.debug("eavconst.opr_profile="+EavConstants.ORG_PROFILE_TAB_ATTR);
			for(int i=0;i<result.size();i++){
				EntityAttribute[] children = dataService.getEntityAttributes(orgContacts[i].getOrgId(),
						EavConstants.ORG_PROFILE_TAB_ATTR);
				logger.debug("children.length="+children.length);
				if (children.length > 0) {
					long parent = children[0].getMyEntity().getId();
						orgToReturn.add(orgService.getOrganizationByid(orgContacts[i].getOrgId()));
				}
				
			}
			if(orgToReturn.size()>0)
			   return ((Organization[])orgToReturn.toArray(new Organization[orgToReturn.size()]));

		}
		return null;
	}

	public OrgContacts[]  getOrgContactsForOrgId(long orgId) {
		logger.debug("Getting Contacts for orgId: " + orgId);
		
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
		String presentDate= (dateFormat.format(date)).toString();
		
		List result = getHibernateTemplate().find("from OrgContacts o where orgId=" + orgId + "and begindate <= '" + presentDate + "' and enddate >= '"+ presentDate +"'");
		if(result != null && result.size() > 0){
			OrgContacts[] orgContacts = (OrgContacts [])result.toArray(new OrgContacts[result.size()]);
			if(orgContacts != null){
				for (int i=0; i<orgContacts.length; i++) {
					User [] users = userService.getUserForStaffId("" + orgContacts[i].getStaffid());
					if (users != null && users.length > 0) {
						orgContacts[i].setContactName(users[0].getLastName() + ", " + users[0].getFirstName());
						orgContacts[i].setEmail(users[0].getEmail());
						orgContacts[i].setPhone(users[0].getPhone());
					}
				}
			}
			return orgContacts;
		}
			
		return null;
	}
	
	public void update(OrgContacts orgContact) {
		logger.debug("Updating OrgContact: " + orgContact);
		// TODO Auto-generated method stub
		getHibernateTemplate().saveOrUpdate(orgContact);
	}
	public void add(OrgContacts orgContact) {
		logger.debug("Updating OrgContact: " + orgContact);
		// TODO Auto-generated method stub
		getHibernateTemplate().save(orgContact);
	}
	public void delete(long orgContactId) {
		logger.debug("Deleting a OrgContact with contactId: " + orgContactId + "from Contact Table");
		getHibernateTemplate().delete(getOrgContact(orgContactId));
	}
	/*
	 * Getting contact detail for given contactId (only one result expected) Searching on primary key
	 */ 
	public OrgContacts getOrgContact(long orgContactId){
			logger.debug("Getting OrgContact details for contactId: " + orgContactId + " Searching on primary key");
			
			Date date = new Date(System.currentTimeMillis());
			SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
			String presentDate= (dateFormat.format(date)).toString();
			
			
			List result = getHibernateTemplate().find("from OrgContacts where ContactId=" + orgContactId + "and begindate <= '" + presentDate + "' and enddate >= '"+ presentDate +"'");
			if(result == null)
				logger.debug("result is null");
			if(result.size() == 1) {
				OrgContacts c = (OrgContacts) result.get(0);
				
				User [] users = userService.getUserForStaffId("" + c.getStaffid());
				if (users != null && users.length > 0) {
					c.setContactName(users[0].getLastName() + ", " + users[0].getFirstName());
					c.setEmail(users[0].getEmail());
					c.setPhone(users[0].getPhone());
				}
				return c;
			}
			return null;
		}
	
	
	public Map getOrgContactsMapForStaffId(long staffId, String filterFlag) {
		
		logger.debug("Getting Org Contacts for StaffId:" + staffId + "and Filter Flag:"+filterFlag);
		
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
		String presentDate= (dateFormat.format(date)).toString();
		
		
		List result = null;
		Map contactsOrgMap = new LinkedHashMap();
    	
		if(filterFlag.equalsIgnoreCase("Current Only")){
		    logger.debug("from OrgContacts o where o.staffid=" + staffId + " and o.begindate <= '" + presentDate + "' and o.enddate >= '"+ presentDate +"'");
		    result = getHibernateTemplate().find("from OrgContacts o where o.staffid=" + staffId + " and o.begindate <= '" + presentDate + "' and o.enddate >= '"+ presentDate +"'");
		}else if(filterFlag.equalsIgnoreCase("All")){
			logger.debug("from OrgContacts o where o.staffid=" + staffId);
		    result = getHibernateTemplate().find("from OrgContacts o where o.staffid=" + staffId);
		}
		if(result != null && result.size() > 0){
			OrgContacts [] orgContacts = (OrgContacts [])result.toArray(new OrgContacts[result.size()]);
			List orgToReturn = new ArrayList();
			for(int i=0;i<result.size();i++){
				logger.debug("Query DataService For:"+orgContacts[i].getOrgId());
			    EntityAttribute[] children = dataService.getEntityAttributes(orgContacts[i].getOrgId(),
						EavConstants.ORG_PROFILE_TAB_ATTR);
			    logger.debug("childeren.len="+children.length);
				if (children.length > 0) {
					long parent = children[0].getMyEntity().getId();
					logger.debug("parent="+parent);
						orgToReturn.add(orgService.getOrganizationByid(orgContacts[i].getOrgId()));
				}
				
			}
			if(orgToReturn.size()>0){
				logger.debug("Undeleted Orgs Found:"+orgToReturn.size());
			    	Organization[] undeletedOrgs = (Organization[])orgToReturn.toArray(new Organization[orgToReturn.size()]); 
				Arrays.sort(undeletedOrgs);
				for(int i=0;i<undeletedOrgs.length;i++){
					for(int j=0;j<orgContacts.length;j++){
						if(undeletedOrgs[i].getEntityId() == orgContacts[j].getOrgId()){
						    logger.debug("Map Key Id"+j+":"+orgContacts[j].getOrgContactsId()+" Map Value"+i+":"+undeletedOrgs[i].getName());
						    contactsOrgMap.put(orgContacts[j],undeletedOrgs[i]);
						}   
						    
						    
					}
				}
				return contactsOrgMap;
		    }else{
		    	logger.debug("No Undeleted Orgs were Found for StaffId:"+staffId+" Returning Null");
		    	return null;
		    }

		}
		logger.debug("NO rows were found in Orgs Contacts Table For StaffId"+staffId+".Returning Null");
		return null;
	}
	
	public void updateOrgContactList(long staffId, OrgContacts[] newContacts)
	throws IOException, ParseException {
        logger.debug("Update Org Contact List For StaffID:"+staffId);
        OrgContacts[] existingContacts = getAllOrgContactsList(staffId);
        getHibernateTemplate().flush();
		if(newContacts!=null && newContacts.length!=0){
	        if(existingContacts==null || existingContacts.length==0){
				for (int j = 0; j < newContacts.length; j++){
					logger.info("New Contact Submitted:"+newContacts[j].getOrgContactsId());
					add(newContacts[j]);
				}
			}
			else{
				for(int i=0;i< existingContacts.length;i++){
						for (int j = 0; j < newContacts.length; j++){
							if(newContacts[j].getOrgContactsId()==existingContacts[i].getOrgContactsId()){
								logger.info("Old Contact Submitted:"+newContacts[j].getOrgContactsId());
								copyObject(newContacts[j],existingContacts[i]);
								update(existingContacts[i]);
							}
							else if(newContacts[j].getOrgContactsId()==1){
								logger.info("New Contact Submitted:"+newContacts[j].getOrgContactsId());
								add(newContacts[j]);
							}
						}
				}
				for (int k = 0; k < existingContacts.length; k++) {
					OrgContacts contact = existingContacts[k];
					boolean found = false;
					for (int j = 0; j < newContacts.length; j++) {
						if (newContacts[j].getOrgContactsId() == contact.getOrgContactsId()) {
							found = true;
							break;
						}
					}
					if (!found){
						logger.debug("This Contact Not Found.Deleting it"+contact.getOrgContactsId());
						deleteOrgContact(contact);
					}
				}
			}
		}
	}
	
	public OrgContacts[] getOrgContactsList(long staffId) {
		logger.info("Getting OrgContact list for StaffId:"+staffId);
		
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
		String presentDate= (dateFormat.format(date)).toString();
		
		List result = getHibernateTemplate().find(
				"from OrgContacts c where c.staffid = " + staffId
				+ " and c.begindate <= '" + presentDate
				+ "' and c.enddate >= '" + presentDate + "'");
		if(result ==null || result.size()==0){
			logger.debug("Query Returned No Results.Returning Null");
			return null;
		}
		logger.debug("Query Returned results of size:"+result.size());
		return (OrgContacts[]) result.toArray(new OrgContacts[result.size()]);
	}

	public OrgContacts[] getAllOrgContactsList(long staffId) {
		logger.info("Getting OrgContact list for StaffId:"+staffId);
		List result = getHibernateTemplate().find(
				"from OrgContacts c where c.staffid = " + staffId);
		if(result ==null || result.size()==0){
			logger.debug("Query Returned No Results.Returning Null");
			return null;
		}
		logger.debug("Query Returned results of size:"+result.size());
		return (OrgContacts[]) result.toArray(new OrgContacts[result.size()]);
	}
	
	public void deleteOrgContact(OrgContacts contact) {
		Date beforeDate = new Date(System.currentTimeMillis() - 24*60*60*1000);
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
		String previousDate = dateFormat.format(beforeDate);

		try{
			contact.setEnddate(dateFormat.parse(previousDate));
			logger.debug("deleting contact"+contact.getOrgContactsId());
			getHibernateTemplate().update(contact);
		}catch(Exception e){
			logger.debug(e.getLocalizedMessage(),e);
		}
	}
	private void copyObject(OrgContacts fromContactObj, OrgContacts toContactObj){
		toContactObj.setBegindate(fromContactObj.getBegindate());
		toContactObj.setEnddate(fromContactObj.getEnddate());
		toContactObj.setContactName(fromContactObj.getContactName());
		toContactObj.setStaffid(fromContactObj.getStaffid());
		toContactObj.setIsPrimaryContact(fromContactObj.getIsPrimaryContact());
		toContactObj.setEmail(fromContactObj.getEmail());
		toContactObj.setPhone(fromContactObj.getPhone());
		toContactObj.setOrgId(fromContactObj.getOrgId());
	}
	
	public IDataService dataService;
		
	public IDataService getDataService()
	{
		return dataService;
	}
	public void setDataService(IDataService dataService)
	{
		this.dataService = dataService;
	}
	public IOrganizationService getOrgService() {
		return orgService;
	}

	public void setOrgService(IOrganizationService orgService) {
		this.orgService = orgService;
	}
	
	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}
	
}
