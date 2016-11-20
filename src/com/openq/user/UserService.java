package com.openq.user;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.contacts.Contacts;
import com.openq.eav.EavConstants;
import com.openq.eav.data.Entity;
import com.openq.eav.data.IDataService;
import com.openq.eav.expert.IExpertDetailsService;
import com.openq.eav.metadata.EntityType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.option.OptionLookup;
import com.openq.utils.PropertyReader;


public class UserService extends HibernateDaoSupport implements IUserService {
    IDataService dataService;
    IMetadataService metadataService;
    IExpertDetailsService expertDetailsService;


     public User[] getContactForKol(long kolId) {
        User [] users = null;
        List usersList = new ArrayList();
        List result = getHibernateTemplate().find("from Contacts where kolId=" + kolId);
        Contacts [] c = (Contacts []) result.toArray(new Contacts[result.size()]);
        for (int i=0; i<c.length; i++)
        {
            usersList.addAll(Arrays.asList(getUserForStaffId("" + c[i].getStaffid())));
        }
        return (User[]) usersList.toArray(new User[usersList.size()]);
     }

    public List getMSLs() {

     try{
    	 List results = getHibernateTemplate().find("from User where user_type_id = 2 or user_type_id = 650 and deleteFlag = 'N' ");
    	 System.out.println(results.size());
       return results;
     }catch(Exception e){
    	 System.err.println((e));
    	 return null;
     }
    }

     public User[] getKolsForContacts(long staffId) {
         User [] users = null;
         List usersList = new ArrayList();
         List result = getHibernateTemplate().find("from Contacts where staffId=" + staffId);
         Contacts [] c = (Contacts []) result.toArray(new Contacts[result.size()]);
         for (int i=0; i<c.length; i++)
         {
             usersList.add(getUser(c[i].getKolId()));
         }
         return (User[]) usersList.toArray(new User[usersList.size()]);
      }

    /* (non-Javadoc)
      * @see com.openq.user.IUserService#createUser(com.openq.user.User)
      */
    public long createUser(User user) {
        getHibernateTemplate().save(user);
        if(user.getUserType().getId() == 4l)
        {

            Entity entity=new Entity();

            EntityType entityType=metadataService.getEntityType(EavConstants.KOL_ENTITY_ID);
            entity.setType(entityType);
            dataService.saveEntity(entity);

            user.setKolid(entity.getId());

            dataService.saveOLProfile(dataService.getEntity(entity.getId()), user);
            return entity.getId();
        }
        return 0;
    }

    public void createUserForDataLoad(User user) {
        getHibernateTemplate().save(user);
    }

    /* (non-Javadoc)
      * @see com.openq.user.IUserService#createUserAddress(com.openq.user.UserAddress)
      */
    public void createUserAddress(UserAddress userAddress) {

        getHibernateTemplate().save(userAddress);
    }

    /* (non-Javadoc)
      * @see com.openq.user.IUserService#updateUserAddress(com.openq.user.UserAddress)
      */
    public void updateUserAddress(UserAddress userAddress) {

        getHibernateTemplate().update(userAddress);
    }

    /* (non-Javadoc)
      * @see com.openq.user.IUserService#deleteUserAddress(com.openq.user.UserAddress)
      */
    public void deleteUserAddress(UserAddress userAddress) {

        getHibernateTemplate().delete(userAddress);
    }
    /* (non-Javadoc)
      * @see com.openq.user.IUserService#deleteUser(com.openq.user.User)
      */

    public void deleteUser(User user) {
        getHibernateTemplate().update(user);
    }


    /* (non-Javadoc)
      * @see com.openq.user.IUserService#updateUser(com.openq.user.User)
      */
    public void updateUser(User user) {

    	try{
        getHibernateTemplate().update(user);
    	}catch(Exception e){
    		System.err.println(e);
    	}
    }




    public User getUser(String userName, String password) {
    	List results = null;

         results = getHibernateTemplate().find("from User u where u.userName='" + userName + "' and u.password='" + password + "' AND u.deleteFlag = 'N'");

        	//System.out.println(e.getLocalizedMessage());

        if (results.size() == 0)
            return null;
        return (User) results.get(0);
    }

    public String getUserName(User user){
        StringBuffer nameBuffer = new StringBuffer();
        String firstName="";
        String lastName = "";
        String middleName = "";

        firstName = user.getFirstName();
        lastName = user.getLastName();
        middleName = user.getMiddleName();

        // Name Formulation
        if (lastName != null && !"".equals(nameBuffer)) {
            nameBuffer.append(lastName);
        }
        if (firstName != null && !"".equals(firstName) && firstName.length() > 0) {
            nameBuffer.append(" ").append(firstName.substring(0, 1));
        }
        if (middleName != null && !"".equals(middleName) && middleName.length() > 0) {
            nameBuffer.append(middleName.substring(0, 1));
        }
        return (nameBuffer.toString());
    }

    /**
     * @see IUserService#getAllExperts()
     */
    public User[] getAllExperts() {
        StringBuffer query = new StringBuffer("from User u where u.userType = 4");
        query.append(" AND u.deleteFlag = 'N'");
        query.append(" order by u.lastName");
        List result = getHibernateTemplate().find(query.toString());
        User[] experts = (User []) result.toArray(new User[result.size()]);

        // Override the expert address with values read from the location view
        overrideExpertAddressesFromLocationView(experts);

        return experts;
    }

    public User[] getAllExperts(int expLen){
        if(expLen==-1){
            List result = getHibernateTemplate().find("from User u where u.userType = 4 and u.deleteFlag = 'N'" );
            return (User[]) result.toArray(new User[result.size()]);
        }
        List result = getHibernateTemplate().find("from User u where u.userType = 4 and u.deleteFlag = 'N'and rownum<" +expLen );
        return (User[]) result.toArray(new User[result.size()]);
    }


    public User userExist(String userName, String staffid){
        List results = getHibernateTemplate().find("from User u where u.userName='" + userName + "' and u.staffid='" + staffid + "' AND u.deleteFlag = 'N'");
        if(results.size() == 0)
            return null;
        return (results != null ?(User) results.get(0):null);
    }

    /* (non-Javadoc)
      * @see com.openq.user.IUserService#getUser(long)
      */
    public User getUser(long userId) {
        User u = ((User) getHibernateTemplate().load(User.class, new Long(userId)));
        if (u.getUserType().getId() == 4l) {
            dataService.getCustomAttributesForOl(u);
            u = getUserAddress(userId,u);
        }
        return u;
    }

    public User getUserForProfileSummary(long userId) {
        User u = ((User) getHibernateTemplate().load(User.class, new Long(userId)));
        if (u.getUserType().getId() == 4l) {
            expertDetailsService.populateUserObject(u);
        }
        return u;
    }

    public User getUserAddress(long kolID,User user){

        List addressList = getHibernateTemplate().find(" from HomeUserAddressView u where id = " + Long.toString(kolID)+" order by usage");
        HomeUserAddressView homeUserAddressView = getOLAddress(addressList);
        LocationView locationView = dataService.getUserLocation(user);
        if(homeUserAddressView !=null){
            String state = homeUserAddressView.getState();
            String country = homeUserAddressView.getCountry();
            String usage = homeUserAddressView.getUsage();
            String city=null;
            if(locationView !=null)
                    city = locationView.getCity();
            /*
                * Location is changed to (city, country) from (state, country)
                * for AbbottVascular Demo.
                */
            logger.debug(city+"|"+country+"|"+usage);
            if(user != null){
                String location="";
                if(city!=null)
                    location = city;
                if(country!=null && !((country.equalsIgnoreCase("United States")) || (country.equalsIgnoreCase("USA"))  || (country.equalsIgnoreCase("United Ststes of America"))))
                    location=location+", "+country;
                if(country!=null && ((country.equalsIgnoreCase("United States")) || (country.equalsIgnoreCase("USA")) || (country.equalsIgnoreCase("United Ststes of America") )))
                	location=location+",  "+state;
                user.setLocation(location);
            }

        }
        return user;
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

    /* (non-Javadoc)
    * @see com.openq.user.IUserService#getAllUser()
    */
    public User [] getAllUser() {

        List result = getHibernateTemplate().find("from User where deleteFlag = 'N'");
        return (User[]) result.toArray(new User[result.size()]);
    }

    /* (non-Javadoc)
      * @see com.openq.user.IUserService#getUser(java.lang.String)
      */
    public User getUser(String username) {
        User u = ((User) getHibernateTemplate().load(User.class, new String(username)));
        if (u.getUserType().getId() == 4l) {
            dataService.getCustomAttributesForOl(u);
        }
        return u;
    }
/*A method to obtain user based on his username
 * */
    public User getUserByUserName(String username) {
    	List results = null;

        results = getHibernateTemplate().find("from User u where u.userName='" + username + "' and u.deleteFlag = 'N'");

       	//System.out.println(e.getLocalizedMessage());

       if (results.size() == 0)
           return null;
       return (User) results.get(0);
    }
    /* (non-Javadoc)
      * @see com.openq.user.IUserService#searchUser(java.lang.String)
      */
    public User[] searchUser(String username) {

        String uppercasename = username.trim().toUpperCase();
        List result = getHibernateTemplate().find(
                "from User u where UPPER(u.lastName) like '%" + uppercasename + "%' and u.deleteFlag = 'N' order by lower(u.lastName), lower(u.firstName)");
        User [] experts = (User[]) result.toArray(new User[result.size()]);
        for (int i=0; i<experts.length; i++) {
            LocationView l = dataService.getUserLocation(experts[i]);
            experts[i].setUserLocation(l);
        }
        dataService.getAttrVals(experts);

        return experts;
    }
    public User[] searchEmployee(String username) {
        if( username != null && !"".equals(username)){
        	String uppercasename = username.trim().toUpperCase();
        	String frontEndAdmin = PropertyReader
        	.getEavConstantValueFor("FRONT_END_ADMIN");
        	List result = getHibernateTemplate().find(
        			"from User u where (UPPER(u.lastName) like '%" + uppercasename
        			+ "%' or UPPER(u.firstName) like '%" + uppercasename
        			+ "%') and u.userType in(2," + frontEndAdmin
        			+ ") and u.deleteFlag = 'N' order by upper(u.lastName), upper(u.firstName)");
        	User[] experts = (User[]) result.toArray(new User[result.size()]);
        	return experts;
        }else{
            return new User[0];
        }
    }

    /*
	 * Search on lastname
	 *
	 * @see com.openq.user.IUserService#searchExpert(java.lang.String)
	 */
    public List searchExpert(String name) {
        return searchExpert(null, name, null, null);
    }

    public List searchExpert(String firstName, String lastName) {
        return searchExpert(firstName, lastName, null, null);
    }
    public List searchExpert(String firstName, String lastName, String city){
    	return searchExpert(firstName, lastName,null,city);
    }

    public List searchExpert(String firstName, String lastName, String state,
            String city) {
        StringBuffer query = new StringBuffer("from ExpertDetails ed where ed.deleteFlag != 'Y' ");
        if (null != firstName && firstName.trim().length() > 0) {
            query.append(" AND UPPER(ed.firstName) LIKE ('%"
                    + firstName.toUpperCase() + "%')");
        }
        if (null != lastName && lastName.trim().length() > 0) {
            query.append(" AND UPPER(ed.lastName) LIKE ('%"
                    + lastName.toUpperCase() + "%')");
        }
        if (null != state && state.trim().length() > 0) {
            query.append(" AND UPPER(ed.addressState) LIKE ('%"
                    + state.toUpperCase() + "%')");
        }
        if (null != city && city.trim().length() > 0) {
            query.append(" AND UPPER(ed.addressCity) LIKE ('%"
                    + city.toUpperCase() + "%')");
        }
        query.append(" order by lower(ed.lastName), lower(ed.firstName), lower(ed.title), lower(ed.addressCity), lower(ed.addressState), lower(ed.addressCountry) ");
        List result = getHibernateTemplate().find(query.toString());
        return result;
    }

    /**
     * @see IUserService#updateGeocodeAddressForUser(long, float, float)
     */
    public void updateGeocodeAddressForUser(long userId, float latitude, float longitude) {
        User user = getUser(userId);
        user.setLatitude(latitude);
        user.setLongitude(longitude);

        updateUser(user);
    }

    /**
     * This routine is used to override addresses for the specified list of experts
     * with values as read from the location view
     */
    private void overrideExpertAddressesFromLocationView(User[] allExperts) {
        List result = getHibernateTemplate().find("from LocationView l " +
                " where l.addressType = 'Primary'");

        HashMap expertAddressMap = new HashMap();

        // First create a map of expert addresses to their primary addresses
        for(int i=0; i<result.size(); i++) {
            LocationView l = (LocationView) result.get(i);
            expertAddressMap.put(new Long(l.getId()), l);
        }

        // Now traverse over the array of all experts and set address for each
        for(int i=0; i<allExperts.length; i++) {
            User expert = allExperts[i];

            // Check if we have data for this expert in the LocationView
            if(expertAddressMap.get(new Long(expert.getId())) != null) {
                LocationView l = (LocationView) expertAddressMap.get(new Long(expert.getId()));

                UserAddress add = expert.getUserAddress();
                add.setAddress1(l.getAddress1());
                add.setAddress2(l.getAddress2());
                add.setCity(l.getCity());
                OptionLookup state = new OptionLookup();
                state.setOptValue(l.getState());
                add.setState(state);
                OptionLookup country = new OptionLookup();
                country.setOptValue(l.getCountry());
                add.setCountry(country);
                add.setZip(l.getZip());
            }
        }
    }

    public User[] getUserForStaffId(String staffId) {
		logger.debug("Getting User for staffId:" + staffId);
		String query = "from User u where u.userType!= 4 and u.staffid='" + staffId +"' AND u.deleteFlag = 'N'";
		logger.info("query="+query);
		List result = getHibernateTemplate().find(query);
		if(result == null || result.size() == 0){
			logger.info("get user for id returns NULL");
		}
        return (User[]) result.toArray(new User[result.size()]);
	}
    public User[] getUserForStaffIdInOLAlignment(String staffId) {
        List result = getHibernateTemplate().find("from User u where u.staffid='"+staffId+"'");
        logger.info("result="+result);
        return (User[]) result.toArray(new User[result.size()]);
    }

    /* (non-Javadoc)
    * @see com.openq.user.IUserService#searchUser(java.lang.String, com.openq.eav.option.OptionLookup)
    */
    public String[] searchUser(String username, OptionLookup userType) {

        String uppercasename = username.trim().toUpperCase();

        List result = getHibernateTemplate().find(
                "select distinct u.id from User u,UserGroupMap ug where u.id=ug.user_id and UPPER(u.userName) like '%" + uppercasename + "%' and u.userType=" + userType.getId() +" u.deleteFlag = 'N'");


        String[] ids = new String[result.size()];

        for (int i = 0; i < result.size(); i++) {

            ids[i] = ((Long) result.get(i)).toString();
        }

        return ids;

    }

    public String[] searchUser(String name, OptionLookup userType,long groupId) {

        StringBuffer query = new StringBuffer("SELECT u.id FROM User u where u.id>0 ");
        if(name != null && name.length()> 0){
             String username=name.trim().toUpperCase();
             String keyword = "'%"+username+"%'";
             query.append(" AND (UPPER(u.userName) LIKE ("+keyword+") OR UPPER(u.firstName) LIKE ("+keyword+") OR UPPER(u.middleName) LIKE ("+keyword+") OR UPPER(u.lastName) LIKE ("+keyword+"))");
        }
        if(userType.getId() != -1){
            query.append(" AND u.userType ="+userType.getId());
        }
        if(groupId != -1){
            StringBuffer group = new StringBuffer("SELECT DISTINCT ug.user_id FROM User u, UserGroupMap ug WHERE u.id=ug.user_id");
            if (name != null && name.length()> 0){
                String username=name.trim().toUpperCase();
                String keyword = "'%"+username+"%'";
                group.append(" AND (UPPER(u.userName) LIKE ("+keyword+") OR UPPER(u.firstName) LIKE ("+keyword+") OR UPPER(u.middleName) LIKE ("+keyword+") OR UPPER(u.lastName) LIKE ("+keyword+"))");
            }
            if (userType.getId() != -1){
                group.append(" AND u.userType ="+userType.getId());
            }
            if (groupId != -1){
                group.append(" AND ug.group_id ="+groupId);
            }
            query = group;
        }
        query.append(" AND u.deleteFlag = 'N' ");
        List result = getHibernateTemplate().find(query.toString());


        String[] ids = new String[result.size()];

        for (int i = 0; i < result.size(); i++) {

            ids[i] = ((Long) result.get(i)).toString();
        }

        return ids;

    }
    public User getLightWeightOLForId(String userId) {
		logger.debug("Getting User from userID");
		logger.info("User ID: " + userId);
		List results = getHibernateTemplate().find(
				"from User u where u.id='" + userId
				+ "' AND u.deleteFlag = 'N'");
		if (results.size() == 0)
			return null;
		return (results != null ? (User) results.get(0) : null);
	}

    //Since there is problem of mismatch in kolId and userId in DB.
    public User getOLForId(long userId) {
		logger.debug("Getting User from userID");
		logger.info("User ID: " + userId);
		List results = getHibernateTemplate().find(
				"from User u where u.id='" + userId
				+ "' AND u.deleteFlag = 'N'");
		if (results.size() == 0)
			return null;
		return (results != null ? (User) results.get(0) : null);
	}

    public User[] getUsers(String kolids) {
        List result = getHibernateTemplate().find(" from User u where u.id in("+kolids+")");
        return (User[]) result.toArray(new User[result.size()]);
    }

    public User getUserForKolId(long kolId) {
        List results = getHibernateTemplate().find("from User u where u.kolid='" + kolId + "' AND u.deleteFlag = 'N'");
        if(results==null || results.size() == 0)
            return null;
        return (results != null ?(User) results.get(0):null);   }

    public User[] getUsersByType(long userTypeId) {
        if(userTypeId != 0){
            List result = getHibernateTemplate().find("from User u where u.userType="+userTypeId);
            if(result.size()>0)
                return (User[]) result.toArray(new User[result.size()]);
        }
        return null;
    }

    public User[] getUsersNotIntheList(String whitePageUserList) {
        List results = getHibernateTemplate().find("from User u where u.staffid not in "+whitePageUserList);

        if(results!=null && results.size()>0)
            return (User[]) results.toArray(new User[results.size()]);
        else
            return null;

    }

    public User getUserByStaffId(String staffId) {
        // TODO Auto-generated method stub
        List results = getHibernateTemplate().find("from User u where u.staffid ='"+staffId+"'");
        if(results!=null && results.size()>0)
        {
            System.out.println(results.size());
            return (User) results.get(0);
        }

        return null;
    }
    
    public User checkExistUserNameStaffID(String userName,String staffId){
    	List results=getHibernateTemplate().find("from User u where u.userName ='"+userName+"'or u.staffid='"+staffId+"'");
    	if(results !=null&&results.size()>0){    		
    		return (User)results.get(0);    		
    		}
    	return null;
    	
    }
   
    /**
     * @return the expertDetailsService
     */
    public IExpertDetailsService getExpertDetailsService() {
        return expertDetailsService;
    }

    /**
     * @param expertDetailsService the expertDetailsService to set
     */
    public void setExpertDetailsService(IExpertDetailsService expertDetailsService) {
        this.expertDetailsService = expertDetailsService;
    }

    public IDataService getDataService() {
        return dataService;
    }

    public void setDataService(IDataService dataService) {
        this.dataService = dataService;
    }

    public IMetadataService getMetadataService() {
        return metadataService;
    }

    public void setMetadataService(IMetadataService metadataService) {
        this.metadataService = metadataService;
    }


   /* public List getMSLTemp() {

        try{
       	 List results = getHibernateTemplate().find("from User where user_type_id = 2 and deleteFlag = 'N'");
       	 System.out.println(results.size());
          return results;
        }catch(Exception e){
       	 System.err.println((e));
       	 return null;
        }
       }*/
   

}
