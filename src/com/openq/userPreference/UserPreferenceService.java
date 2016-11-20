package com.openq.userPreference;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class UserPreferenceService extends HibernateDaoSupport implements IUserPreferenceService{

    private static Logger logger = Logger.getLogger(UserPreferenceService.class);
    
	public boolean userExist(long userId) {
		List results = null;
		try{
		  results = getHibernateTemplate().find("from UserPreference u where u.userId = " +userId);
		}catch(Exception e)
		{
		    logger.error("Exception occured: " + e);
		}
		if( results == null)
			return false;
		else if(results.size()>0)
				return true;
			else
				return false;
		
	}

	public void savePreference(UserPreference userPreference) {
	   
		getHibernateTemplate().save(userPreference);
		
	}

	public void updatePreference(UserPreference userPreference) {
		
		logger.debug(" fre"+userPreference.getFrequency());
		try{
		getHibernateTemplate().update(userPreference);
		 
		}catch(Exception e)
		{
		    logger.error("Exception occured: " + e);
		}		 
		
	}
	public void saveOrUpdatePreference(UserPreference userPreference) {
		   
		getHibernateTemplate().saveOrUpdate(userPreference);
		
	}
	
	public UserPreference getUserPreference(long userId){
		
		List results = getHibernateTemplate().find("from UserPreference u where u.userId = " +userId);
		if( results == null )
			return null;
		else 
			if(results.size()>0)
				return ((UserPreference)results.get(0));
			else
				return null;
	}
	
	/*public long getPreference(long userId)
	{
		List results = getHibernateTemplate().find("from UserPreference u where u.userId = " +userId);
		if( results == null )
			return -1;
		else 
			if(results.size()>0)
				return (((UserPreference)results.get(0)).getFrequency());
			else
				return -1;
		
	}*/
	
	

}
