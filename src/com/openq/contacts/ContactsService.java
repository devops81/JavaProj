package com.openq.contacts;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.user.IUserService;
import com.openq.user.User;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class ContactsService extends HibernateDaoSupport implements IContactsService {

/*
 * Adding a new contact in contacts table
 */
	public void addContact(Contacts contact) {
		getHibernateTemplate().save(contact);
	}

	public boolean getContact(Contacts contact){
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
		String presentDate= (dateFormat.format(date)).toString();
		
		
		if(contact != null){
			List result = getHibernateTemplate().find("from Contacts where kolId=" + contact.getKolId()
					+ "AND staffid=" + contact.getStaffid()+ "and begindate <= '" + presentDate
					 							+ "' and enddate >= '"+ presentDate +"'");
			logger.debug("result in getcontacts="+result);
			if(result.size() == 0)
				return true;
			else 
				return false;
		}
		return false;
	}
/*
 * To delete a contact from the contacts table
 */
	public void delete(long contactId) {
		getHibernateTemplate().delete(getContact(contactId));
	}
	
/*
 * Get all contacts for a kolId
 */
	
	public Contacts[] getContactsForKol(long kolId) {
		
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
		String presentDate= (dateFormat.format(date)).toString();
		
		List result = getHibernateTemplate().find("from Contacts where kolId=" + kolId+ "and begindate <= '" + presentDate
					+ "' and enddate >= '"+ presentDate +"'");
		logger.debug("result in getcontactsforkol="+result);
		Contacts [] c = (Contacts []) result.toArray(new Contacts[result.size()]);
		for (int i=0; i<c.length; i++) {
			User [] users = userService.getUserForStaffId("" + c[i].getStaffid());
			if (users != null && users.length > 0) {
				c[i].setContactName(users[0].getLastName() + ", " + users[0].getFirstName());
				c[i].setEmail(users[0].getEmail());
				c[i].setPhone(users[0].getPhone());
				c[i].setRole(users[0].getTitle());
			}
		}
		return c;
	}

/*
 * Getting contact detail for given contactId (only one result exected) Searching on primary key
 */ 
	public Contacts getContact(long contactId){
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
		String presentDate= (dateFormat.format(date)).toString();
		
		List result = getHibernateTemplate().find("from Contacts where contactId=" + contactId+ "and begindate <= '" + presentDate
				+ "' and enddate >= '"+ presentDate +"'");
		logger.debug("result in getcontact="+result);
		if(result.size() == 1)
			return (Contacts) result.get(0); 

		return null;
	}
	
/*
 * Updating the contact details for the given contact
 */
	public void update(Contacts contact) {
		// TODO Auto-generated method stub
		getHibernateTemplate().saveOrUpdate(contact);
	}
	
	IUserService userService;

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}
}
