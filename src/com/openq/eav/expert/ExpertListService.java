package com.openq.eav.expert;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.contacts.Contacts;
import com.openq.eav.data.IDataService;
import com.openq.kol.DBUtil;
import com.openq.user.HomeUserAddressView;
import com.openq.user.HomeUserPhoneView;
import com.openq.user.HomeUserView;
import com.openq.user.LocationView;
import com.openq.user.User;



public class ExpertListService extends HibernateDaoSupport implements
        IExpertListService {

	private static final String PROPERTIES_FILE = "resources/ServerConfig.properties";

	private static final String ENDDATE = "contact.endDate";


	 public User[] getOLFromContacts(String staffid){

		    Date date = new Date(System.currentTimeMillis());
			SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
			String presentDate= (dateFormat.format(date)).toString();

	        if(staffid != null){
	            List result = getHibernateTemplate().find("select c.kolId from Contacts c where c.staffid = "
	            		+ staffid+ "and c.begindate <= '" + presentDate
	    				+ "' and c.enddate >= '"+ presentDate +"'");
	            logger.debug("result in getolfromcontacts="+result);
	            Object[] kolIds = result.toArray();
	            ArrayList experts = new ArrayList();
	    //		 since we do not expect more than one entry with the KOLID
	            if(result.size() > 0)
	            for(int i = 0; i<result.size();i++){
	            	List l = getHibernateTemplate().find("from User u where id = " + kolIds[i].toString());
	            	if(l != null && l.size() > 0){
	            		experts.add(l.get(0));
	            	}
	            }
//	          set location from EAV
	            User [] user = (User []) experts.toArray(new User[experts.size()]);
	        	for (int i=0; i<user.length; i++) {
	        		LocationView l = dataService.getUserLocation(user[i]);
	        		user[i].setUserLocation(l);
	        	}
	        	dataService.getAttrVals(user);

	            return user;
	        }
	        return null;
	    }


	public HomeUserAddressView getOLAddress(List addressList){

		boolean pFlag = false;
		boolean sFlag = false;
		HomeUserAddressView homeUserAddress = new HomeUserAddressView();
		if(addressList != null && addressList.size() >0){
		Iterator itr = addressList.iterator();
		while(itr.hasNext()){
			homeUserAddress = (HomeUserAddressView) itr.next();
			if(homeUserAddress != null){
				String usage = homeUserAddress.getUsage();
				logger.debug(" USAGE FOUND --> "+usage);
				if(usage != null){
					if(usage.equalsIgnoreCase("Primary")){
						pFlag = true;
						return homeUserAddress;
					}
					if(!pFlag && usage.equalsIgnoreCase("Secondary")){
						sFlag = true;
						return homeUserAddress;
					}
				}
			}
		}
		if(!pFlag && !sFlag){
				return (HomeUserAddressView) addressList.get(0);
		}
		}
		return homeUserAddress;
	}

	private HomeUserPhoneView getOLPhone(List phoneList){

		boolean pFlag = false;
		HomeUserPhoneView homeUserPhoneView = new HomeUserPhoneView();
		if(phoneList != null && phoneList.size() > 0){
			Iterator itr = phoneList.iterator();
			while(itr.hasNext()){
				homeUserPhoneView = (HomeUserPhoneView) itr.next();
				long cFlag = homeUserPhoneView.getContactFlag();
				logger.debug(" ContactFlag --"+cFlag +"--"+homeUserPhoneView.getPhone());
				if(cFlag == 1){
					pFlag = true;
					return homeUserPhoneView;
				}
			}
			if(!pFlag){
				if(phoneList !=null){
					return (HomeUserPhoneView)  phoneList.get(0);
				}
			}
			}
		return homeUserPhoneView;
	}


    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.expert.IExpertListService#getMyExpertList(java.lang.String)
      */

    /* (non-Javadoc)
     * @see com.openq.eav.expert.IExpertListService#getOLFromContactsForHomePage(java.lang.String)
     */
    public HomeUserView[] getOLFromContactsForHomePage(String staffid){

    	Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
		String presentDate= (dateFormat.format(date)).toString();

        if(staffid != null){
            List result = getHibernateTemplate().find("select c.kolId from Contacts c where c.staffid = "
            		+ staffid+ "and begindate <= '" + presentDate
    				+ "' and enddate >= '"+ presentDate +"'");
            logger.debug("result in getolfromcontactsforhomepage="+result);
            Object[] kolIds = result.toArray();
            List experts = new ArrayList();
            HomeUserView homeUserView = null;
            //since we do not expect more than one entry with the KOLID
            if(result.size() > 0)
            for(int i = 0; i<result.size();i++){
            	logger.debug(" KOLID--"+kolIds[i].toString());
            	List l = getHibernateTemplate().find("from HomeUserView u where id = " + kolIds[i].toString());
            	if(l != null && l.size() >0){
            		logger.debug("SIZE of the LIST "+l.size());
            		homeUserView = (HomeUserView)l.get(0);
            		//System.out.println("first name is :"+homeUserView.getFirstName());
            	}
            	List addressList = getHibernateTemplate().find(" from HomeUserAddressView u where id = " + kolIds[i].toString()+" order by usage");
            	HomeUserAddressView homeUserAddressView = getOLAddress(addressList);
            	if(homeUserAddressView !=null){
            		String city = homeUserAddressView.getCity();
            		String state = homeUserAddressView.getState();
            		String country = homeUserAddressView.getCountry();
            		String usage = homeUserAddressView.getUsage();
            		logger.debug(city+"|"+state+"|"+country+"|"+usage);
            		if(homeUserView != null){
            			homeUserView.setCity(city);
            			homeUserView.setState(state);
            			homeUserView.setCountry(country);
            		}
            	}
            	//System.out.println("st 1");
            	List phoneList = getHibernateTemplate().find(" from HomeUserPhoneView u where upper(u.type) = 'BUSINESS PHONE' and u.id = " + kolIds[i].toString()+" order by contactflag desc");
            	HomeUserPhoneView homeUserPhoneView = getOLPhone(phoneList);
            	if(homeUserPhoneView !=null){
            		String phoneN = homeUserPhoneView.getPhone();
            		logger.debug("PHONE-->"+phoneN);
            		if(homeUserView != null){
            			homeUserView.setPhone(phoneN);
            		}
            	}
            	if(homeUserView != null){
            		experts.add(homeUserView);
            	}
            }
            //System.out.println("st 2");
            if(experts != null){
            logger.debug(" EXPERT SIZE "+experts.size());
            }
            HomeUserView [] user = (HomeUserView []) experts.toArray(new HomeUserView[experts.size()]);
            //set location from EAV
            for (int i=0; i<user.length; i++) {

            	String speciality = "";
            	//System.out.println("st 3");

            	if(user[i].getSpecialty1()!=null && user[i].getSpecialty1().trim().length()>0){
            		speciality = user[i].getSpecialty1();
            	}
            	//System.out.println("speciality is "+speciality);
            	if(user[i].getSpecialty2() !=null && user[i].getSpecialty2().trim().length()>0){
            		if(speciality.trim().length()>0)
            	     	speciality = speciality + ", "+user[i].getSpecialty2();
            	    else
            		    speciality=user[i].getSpecialty2();
            	}
            	if(user[i].getSpecialty3() !=null && user[i].getSpecialty3().trim().length()>0){
            		if(speciality.trim().length()>0)
            	     	speciality = speciality + ", "+user[i].getSpecialty3();
            	    else
            		    speciality=user[i].getSpecialty3();
            	}
            	if(user[i].getSpecialty4() !=null && user[i].getSpecialty4().trim().length()>0){
            		if(speciality.trim().length()>0)
            	     	speciality = speciality + ", "+user[i].getSpecialty4();
            	    else
            		    speciality=user[i].getSpecialty4();
            	}
            	if(user[i].getSpecialty5() !=null && user[i].getSpecialty5().trim().length()>0){
            		if(speciality.trim().length()>0)
            	     	speciality = speciality + ", "+user[i].getSpecialty5();
            	    else
            		    speciality=user[i].getSpecialty5();
            	}
            	if(user[i].getSpecialty6() !=null && user[i].getSpecialty6().trim().length()>0){
            		if(speciality.trim().length()>0)
            	     	speciality = speciality + ", "+user[i].getSpecialty6();
            	    else
            		    speciality=user[i].getSpecialty6();
            	}
            	//System.out.println("speciality is "+speciality);
            	if(speciality !=null && speciality.length()>0){
            		speciality = speciality.substring(0,speciality.length());
            	}
            	user[i].setSpeciality(speciality);
            }
            Arrays.sort(user);
            return user;
        }
        return null;
    }



    /*public MyExpertList[] getMyExpertList(String staffid) {

        List result = getHibernateTemplate().find(
                "from MyExpertList e where e.staffid = " + staffid);
        return (MyExpertList[]) result.toArray(new MyExpertList[result.size()]);
    }*/

    /*public MyExpertList getMyExpert(long id) {

        return (MyExpertList) getHibernateTemplate().load(MyExpertList.class, new Long(id));
    }

    public MyExpertList getMyExpert(String id) {
        return getMyExpert(Long.parseLong(id));
    }*/

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.expert.IExpertListService#deleteMyExpert(com.openq.eav.expert.MyExpertList)
      */
    /*public void deleteMyExpert(MyExpertList myexpertList) {
        getHibernateTemplate().delete(myexpertList);
    }*/

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.expert.IExpertListService#addMyExpert(com.openq.eav.expert.MyExpertList)
      */
    /*public void addMyExpert(MyExpertList myexpertList) {


        List result = getHibernateTemplate().find("from MyExpertList e where e.staffid="+myexpertList.getStaffid()+" and e.kolid ="+myexpertList.getKolid());

        if (result.size() == 0)
            getHibernateTemplate().save(myexpertList);
    }*/

    /*public boolean addOL(Contacts contact){
        if(getHibernateTemplate().find("from Contacts where kolId=" + contact.getKolId() + "AND staffid=" + contact.getStaffid()).size() == 0) {
            getHibernateTemplate().save(contact);
            return true;
        }
        return false;
    }*/

    public boolean addOL(Contacts contact) throws IOException, ParseException {
		Date date = new Date(System.currentTimeMillis());

		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");

		String presentDate = (dateFormat.format(date)).toString();

		if (getHibernateTemplate().find(
				"from Contacts where kolId=" + contact.getKolId()
				+ "AND staffid=" + contact.getStaffid()
				+ "And begindate <= '" + presentDate
				+ "' and enddate >= '" + presentDate + "'").size() == 0) {
            
            dateFormat = new SimpleDateFormat("MM/dd/yyyy");
            presentDate = (dateFormat.format(date)).toString();
			contact.setBegindate(dateFormat.parse(presentDate));
			Properties p = DBUtil.getInstance().getDataFromPropertiesFile(
					PROPERTIES_FILE);
			contact.setEnddate(dateFormat.parse(p.getProperty(ENDDATE)));
			logger.debug("saving contact:"+contact.getContactId());
			getHibernateTemplate().save(contact);
			return true;
		}
		return false;
	}







   /*
    public Contacts[] getOLList(long staffId) {
        List result = getHibernateTemplate().find("from Contacts c where staffid = "+ staffId);
         return (Contacts[]) result.toArray(new Contacts[result.size()]);
    }
    */

    public Contacts[] getOLList(long staffId) {
		logger.info("Getting OL list for StaffId:"+staffId);
		Date date = new Date(System.currentTimeMillis());

		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");

		String presentDate = (dateFormat.format(date)).toString();
		List result = getHibernateTemplate().find(
				"from Contacts c where staffid = " + staffId
				+ " and begindate <= '" + presentDate
				+ "' and enddate >= '" + presentDate + "'");
		if(result ==null || result.size()==0){
			logger.debug("Query Returned No Results.Returning Null");
			return null;
		}
		logger.debug("Query Returned results of size:"+result.size());
		return (Contacts[]) result.toArray(new Contacts[result.size()]);
	}


    /*public MyExpertList[] searchMyExpertList(String name) {

    	// String lowercasename=name.toLowerCase();
        List result = getHibernateTemplate().find(
                "from MyExpertList e where UPPER(e.name) like '%"+name+"%'" );
        return (MyExpertList[]) result.toArray(new MyExpertList[result.size()]);
    }*/

    /*
    public void updateContactList(long staffId, Contacts[] newContacts)throws IOException, ParseException
	{
		Contacts [] existingContacts = getOLList(staffId);
		for (int i=0; i<newContacts.length; i++)
		{
			Contacts contact = newContacts[i];
			boolean found = false;
			for (int j=0; j<existingContacts.length; j++)
                if (existingContacts[j].getKolId() == contact.getKolId()) {
                    found = true;
                    break;
                }
			if (!found)
				addOL(contact);
		}

		for (int k=0; k<existingContacts.length; k++)
		{
			Contacts contact = existingContacts[k];
			boolean found = false;
			for (int j=0; j<newContacts.length; j++) {
				if (newContacts[j].getKolId() == contact.getKolId()) {
					found = true;
					break;
				}
			}
			if (!found)
				deleteContact(contact);
		}
	}
	*/
    public void updateContactList(long staffId, Contacts[] newContacts)
	throws IOException, ParseException {
        logger.debug("Update Contact List");
        Contacts[] existingContacts = getAllOLList(staffId);
        getHibernateTemplate().flush();
		if(newContacts!=null && newContacts.length!=0){
	        if(existingContacts==null || existingContacts.length==0){
				for (int j = 0; j < newContacts.length; j++){
					logger.info("New Contact Submitted:"+newContacts[j].getContactId());
					addOL(newContacts[j]);
				}
			}
			else{
				for(int i=0;i< existingContacts.length;i++){
						for (int j = 0; j < newContacts.length; j++){
							if(newContacts[j].getContactId()==existingContacts[i].getContactId()){
								logger.info("Old Contact Submitted:"+newContacts[j].getContactId());
								copyObject(newContacts[j],existingContacts[i]);
								updateContact(existingContacts[i]);
							}
							else if(newContacts[j].getContactId()==1){
								logger.info("New Contact Submitted:"+newContacts[j].getContactId());
								addOL(newContacts[j]);
							}
						}
				}
				for (int k = 0; k < existingContacts.length; k++) {
					Contacts contact = existingContacts[k];
					boolean found = false;
					for (int j = 0; j < newContacts.length; j++) {
						if (newContacts[j].getContactId() == contact.getContactId()) {
							found = true;
							break;
						}
					}
					if (!found){
						logger.debug("This Contact Not Found.Deleting it"+contact.getContactId());
						deleteContact(contact);
					}
				}
			}
		}
	}



    public void deleteContact(Contacts contact){
        getHibernateTemplate().delete(contact);
    }
/**
 * This method deletes the given experts from the myExpertList.
 * @param Array of kolIds to be deleted, staffId
 * @return void
 */
  public void deleteMyExperts(String[] kolIds,String staffId)
  {
    String kolIdsString = "";
    if(kolIds.length==1)
      kolIdsString=kolIds[0];
    else
    {
      if(kolIds.length>1)
      {
          for(int i=0;i<kolIds.length-1;i++)
          {
            kolIdsString += kolIds[i] + ",";
          }

        kolIdsString+=kolIds[kolIds.length-1];
      }
    }

    StringBuffer query = new StringBuffer("delete  from contacts c where c.staffId = "+Long.parseLong(staffId.trim())+" and  c.kolId in ("+ kolIdsString+ " )");
    logger.debug("Query involving in clause: " + query.toString());
    PreparedStatement oracleQuery = null;
    try {
      oracleQuery = this.getSession().connection()
      .prepareStatement(query.toString());
      oracleQuery.executeQuery();
    }
    catch(Exception e)
    {
      logger.error(e.getLocalizedMessage(), e);
    }
    finally {
      logger.debug("In the finally block");

      try {
        if (oracleQuery != null)
          oracleQuery.close();
      } catch (Exception e) {
        logger.error(e.getLocalizedMessage(), e);
      }
    }
  }

  public Contacts[] getAllOLList(long staffId) {
		logger.info("Getting All OL list for StaffId:"+staffId);

		List result = getHibernateTemplate().find(
				"from Contacts c where staffid = " + staffId);
		if(result ==null || result.size()==0){
			logger.debug("Query Returned No Results.Returning Null");
			return null;
		}
		logger.debug("Query Returned results of size:"+result.size());
		return (Contacts[]) result.toArray(new Contacts[result.size()]);
	}


	private IDataService dataService;
	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}

	private void copyObject(Contacts fromContactObj, Contacts toContactObj){
		toContactObj.setBegindate(fromContactObj.getBegindate());
		toContactObj.setEnddate(fromContactObj.getEnddate());
		toContactObj.setContactName(fromContactObj.getContactName());
		toContactObj.setStaffid(fromContactObj.getStaffid());
		toContactObj.setIsPrimaryContact(fromContactObj.getIsPrimaryContact());
		toContactObj.setEmail(fromContactObj.getEmail());
		toContactObj.setPhone(fromContactObj.getPhone());
		toContactObj.setKolId(fromContactObj.getKolId());
	}

	public boolean updateContact(Contacts contact) throws IOException, ParseException {
		logger.debug("Update Contact:"+contact.getContactId());
		getHibernateTemplate().update(contact);
		logger.debug("Updated Contact:"+contact.getContactId());
		return true;

	}

}
