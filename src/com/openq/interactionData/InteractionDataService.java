package com.openq.interactionData;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import java.util.List;

import com.openq.utils.PropertyReader;
import com.openq.web.controllers.Constants;


/**
 * Created by IntelliJ IDEA.
 * User: radhikav
 * Date: Feb 14, 2007
 * Time: 5:13:20 PM
 * To change this template use File | Settings | File Templates.
 */
public class InteractionDataService extends HibernateDaoSupport implements IInteractionDataService {

    public InteractionData [] getAllDataOnType(long interactionId,String type) {
            List result = getHibernateTemplate().find(
                    "from InteractionData i where i.interaction = "+ interactionId + " and i.type='" + type+"'");

            return (InteractionData[]) result.toArray(new InteractionData[result.size()]);
        }


        public void saveInteractionData(InteractionData interactionData){
        	try{
        		getHibernateTemplate().save(interactionData);
        	}catch(Exception e){
        		logger.error("Error saving Interaction Data. Exception : "+e);
        	}
        }

        public void updateInteractionData(InteractionData interactionData){
        	try{
        		getHibernateTemplate().update(interactionData);
	    	}catch(Exception e){
	    		logger.error("Error updating Interaction Data. Exception : "+e);
	    	}
        }

        public void deleteInteractionData(InteractionData interactionData)
        {
            getHibernateTemplate().delete(interactionData);
        }


        public void updateInteractionData(long interactionId,
        		InteractionData[] newInteractionData, String type) {

        	InteractionData[] existingInteractionData = getAllDataOnType(
        			interactionId, type);
        	if (null != existingInteractionData
        			&& existingInteractionData.length > 0) {
        		for (int i = 0; i < existingInteractionData.length; i++)
        			deleteInteractionData(existingInteractionData[i]);
        	}
        	if (newInteractionData != null && newInteractionData.length > 0) {
        		for (int i = 0; i < newInteractionData.length; i++) {
        			if (newInteractionData[i] != null) {
        				saveInteractionData(newInteractionData[i]);
        			}
        		}
        	}
        }
        public InteractionData [] getInteractionData(long id) {

            List result = getHibernateTemplate().find("from InteractionData a where a.id="+id);
            return (InteractionData[]) result.toArray(new InteractionData[result.size()]);
        }

  
        public int getInteractionsCountForEvent(long eventId)
        {
          List result = getHibernateTemplate().find("from InteractionData a where a.data='"+eventId+"'");
          if(result!=null)
        	  return result.size();
          return 0;
        }
      
 
  /**
 * this method queries the interaction_data table for a particular interaction id and gives the sum of "data" where the type is attendeetype
 */
        
public int getAttendeeCountFromInteractionData(long interactionId) {

	List result = getHibernateTemplate().find("select sum(a.data) from InteractionData a where a.type = '"
			+ Constants.INTERACTION_ATTENDEE_TYPE
			+ "' and a.interaction=" + interactionId +" group by a.interaction");
	if(result.size() > 0){
		try{
			return Integer.parseInt(result.get(0)+"");
		}catch(Exception e){
			logger.error(e);
			return 0;
		}
	}else{
		return 0;
	}
}


public void deleteInteractionDataByType(long interactionId, String type) {
	try{
		getHibernateTemplate().delete("from InteractionData a where a.interaction = "+interactionId+" and a.type = '"+type+"' ");
	}catch(Exception e){
		logger.error(e.getMessage());
	}
	
}


public void saveInteractionData(InteractionData[] newInteractionData) {
	if (newInteractionData != null && newInteractionData.length > 0) {
		for (int i = 0; i < newInteractionData.length; i++) {
			if (newInteractionData[i] != null) {
				saveInteractionData(newInteractionData[i]);
			}
		}
	}
}
}


