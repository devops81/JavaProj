package com.openq.interaction;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.attendee.Attendee;
import com.openq.attendee.IAttendeeService;
import com.openq.eav.option.OptionLookup;
import com.openq.interactionData.InteractionData;
import com.openq.kol.DBUtil;
import com.openq.web.controllers.Constants;

public class InteractionService extends HibernateDaoSupport implements
        IInteractionService {

    public final static DateFormat format = new SimpleDateFormat("dd-MMM-yy");

    IAttendeeService attendeeService;

    public IAttendeeService getAttendeeService() {
        return attendeeService;
    }

    public void setAttendeeService(IAttendeeService attendeeService) {
        this.attendeeService = attendeeService;
    }

    public Interaction getInteraction(long interactionId) {

        return ((Interaction) getHibernateTemplate().load(Interaction.class,
                new Long(interactionId)));
    }
   public Interaction[] getRecentInteractionsByExpert(long expertId)
   {
	   List result=getHibernateTemplate().find("select a.interaction from Attendee a, Interaction i where upper(i.deleteFlag) not like upper('Y') "
                        + " and a.userId="+expertId+" and a.interaction=i.id order by i.interactionDate desc");
	   if(result!=null){
	   return (Interaction[])result.toArray(new Interaction[result.size()]);
	   }
	   
   return null;
   }
   public Interaction[] getRecentInteractionsByExpert(long expertId,
			OptionLookup product, String type, boolean isSAXAJVUser) {
		StringBuffer query = new StringBuffer(
				"select i from Attendee a, Interaction i,InteractionData intData where upper(i.deleteFlag) not like upper('Y') "
						+ " and a.userId="
						+ expertId
						+ " and a.interaction=i.id and intData.interaction=i.id and intData.type='"
						+ type + "' " + " and intData.lovId=" + product.getId());
		if (isSAXAJVUser) {
			query.append(" and intData.secondaryLovId is NULL and intData.tertiaryLovId is NULL ");
		}
		query.append(" order by i.interactionDate desc");
		List result = getHibernateTemplate().find(query.toString());

		if (result != null) {
			return (Interaction[]) result.toArray(new Interaction[result.size()]);
		}
		return null;
	}
    public Interaction[] getAllInteractionByUser(long userId) {
        List result = getHibernateTemplate().find(
                "from Interaction i where i.userId=" + userId);
        return (Interaction[]) result.toArray(new Interaction[result.size()]);
    }

    public void saveInteraction(Interaction interaction) {

        getHibernateTemplate().save(interaction);

        Iterator attendees = interaction.getAttendees().iterator();
        while (attendees.hasNext()) {
            Attendee attendee = (Attendee) attendees.next();
            attendeeService.saveAttendee(attendee);
        }
    }

    public void updateInteraction(Interaction interaction) {

        getHibernateTemplate().update(interaction);
    }

    public void deleteInteraction(Interaction interaction) {

        getHibernateTemplate().update(interaction);

    }
    public Interaction[] getCreatedByandUpdatedBy(Date fromDate, Date toDate){
    	List result = null ;
    	try{
    	result = getHibernateTemplate().find(
    			"from Interaction i where upper(i.deleteFlag) not like upper('Y') and i.createTime between  '"
                + format.format(fromDate) + "' and '"
                + format.format(toDate)+ "' or i.updateTime between '"
                + format.format(fromDate) + "' and '"
                + format.format(toDate)+"'"
                        );
    	}catch(Exception e){
    		logger.error(  "from Interaction i where upper(i.deleteFlag) not like upper('Y') and i.createTime between  '"
                        + format.format(fromDate) + "' and '"
                        + format.format(toDate)+ "' or i.updateTime between '"
                        + format.format(fromDate) + "' and '"
                        + format.format(toDate)+"'");
    		logger.error(e.getLocalizedMessage());
    	}
        return (Interaction[]) result.toArray(new Interaction[result.size()]);
    	
    }

    public Object[] getCreatedBy(long interactionId,long userId) {
        List result = getHibernateTemplate().find("from Interaction i, User u  where i.userId = u.id and i.id = " + interactionId + " and i.userId ="+userId);

         return (Object[])result.toArray(new Object[result.size()]);

    }

 	public InteractionTripletSectionMap[] getInteractionTripletSectionMap() {
		List result = getHibernateTemplate().find("from InteractionTripletSectionMap");
		if(result.size() > 0)
			return (InteractionTripletSectionMap[]) result.toArray(new InteractionTripletSectionMap[result.size()]);
		else
		return null;
	}

	public Map getInteractionIdFirstTopicMap(String commaSeparatedInteractionIds) {
		Map interactionIdFirstTopicMap = new HashMap();
		List result = getHibernateTemplate().find("from InteractionData intData where intData.interaction in (" + commaSeparatedInteractionIds + ") " +
				" and intData.type = '" +Constants.INTERACTION_TYPE_LOV_TRIPLET_IDS +"' order by intData.id");
		if(result.size() > 0){
			long currentId = -1;
			for(int i=0; i< result.size(); i++){
				InteractionData interactionData = (InteractionData) result.get(i);
				if(interactionData != null){
					Interaction interaction = interactionData.getInteraction();
					OptionLookup topicLookup = interactionData.getSecondaryLovId();
					if(interaction != null &&
							currentId != interaction.getId() &&
							topicLookup != null){
						currentId = interaction.getId();
						String topicName = topicLookup.getOptValue();
						Long interactionIdLong = new Long(currentId);
						if(!interactionIdFirstTopicMap.containsKey(interactionIdLong)){
							interactionIdFirstTopicMap.put(interactionIdLong, topicName);
						}
					}
				}
			}
		}
		return interactionIdFirstTopicMap;
	}
	   public List getInteractionResultsList (Date fromDate, Date toDate, long userId,
	            String OLOrgName, long productLOVId, boolean isJVUser, long expertId) {
	        
	        int maxInteractionSearchResults = getSearchResultCutoff();
            StringBuffer queryBuffer = new StringBuffer();
            queryBuffer.append(" from InteractionSearchView isv ");
            if (OLOrgName != null && OLOrgName.length() > 0 ){
                queryBuffer.append(" , Attendee att ");
            }
            if ( expertId > 0 ){
                queryBuffer.append(" , Attendee attExp ");
            }
            queryBuffer.append(" where isv.interactionId != 0 ");
            if (OLOrgName != null && OLOrgName.length() > 0 ){
                String keyword = "'%" + OLOrgName.toLowerCase() + "%'";
                queryBuffer.append(" and isv.interactionId = att.interaction and lower ( att.name ) like " +keyword);
            }
            if ( expertId > 0 ){
                queryBuffer.append(" and isv.interactionId = attExp.interaction and attExp.userId = " + expertId);
            }
            if( fromDate != null && toDate != null ){
                queryBuffer.append(" and isv.interactionDate between '"
                    + format.format(fromDate) + "' and '"
                    + format.format(toDate) + "' ");
            }
            if (userId > 0){
                queryBuffer.append(" and isv.userId = " +userId);
            }
            if(productLOVId >0){
                if(!isJVUser){
                    queryBuffer.append(" and ( isv.primaryProductId = " + productLOVId +
                    		" or  isv.secondaryProductId = " + productLOVId +
                    		" or isv.tertiaryProductId = " + productLOVId + " ) ");
                }else{
                    queryBuffer.append(" and isv.primaryProductId = " + productLOVId +
                            " and isv.secondaryProductId = 0 and isv.tertiaryProductId = 0 ");
                }
            }
            String query = queryBuffer.toString();
	        try{
	            Session hibernateSession = this.getSession();
	            String countQueryString = " select count(distinct isv.interactionId ) " + query;
	            Query countQuery = hibernateSession.createQuery(countQueryString);
	            Integer totalSearchCount = (Integer) countQuery.uniqueResult();
                List finalResultList = new ArrayList();
	            if( totalSearchCount.intValue() > 0){
	                StringBuffer dataQueryBuffer = new StringBuffer("  select distinct isv ").append(query);
	                dataQueryBuffer.append(" order by isv.interactionDate desc, lower(isv.userName), lower(isv.firstInteractionTopic), lower(isv.productList) ");
                    Query dataQuery = hibernateSession.createQuery(dataQueryBuffer.toString());
                    logger.debug("Interaction search query : " + dataQuery.getQueryString());
                    List result = (dataQuery.setMaxResults(maxInteractionSearchResults)).list();
                    if(result.size() > 0){
                        String message = totalSearchCount.intValue() + " interactions found";
                        if( totalSearchCount.intValue() > maxInteractionSearchResults ){
                            message =  message + ", showing most recent 100";
                        }
                        finalResultList.add(0, message);
                        List processedResults = processSearchResults( result );
                        finalResultList.add( 1, processedResults );
                        return finalResultList;
                    }
	            }
                finalResultList.add(0, Constants.INTERACTION_NO_DATA_FOUND);
                finalResultList.add(1, new ArrayList(0));
                return finalResultList;
	        }catch(Exception e){
	            logger.error("Error :  while fetching interaction search results" + e);
	            List finalResultList = new ArrayList();
	            finalResultList.add(0, "");
	            finalResultList.add(1, new ArrayList(0));
	            return finalResultList;
	        }
	    }
	public List getAllInteractionsByExpertId (long expertId){
	    return getInteractionResultsList(null, null, 0, null, 0, false, expertId);
	}
	
	public List getAllInteractionByNotfication(Date fromDate, Date toDate) {

        List result = getHibernateTemplate().find(
                "select i,n from Attendee a, Interaction i,Notification n where upper(i.deleteFlag) not like upper('Y') "
                        + " and a.userId=n.kolId and a.interaction=i.id and ((i.createTime between  '"
                + format.format(fromDate) + "' and '"
                + format.format(toDate)+ "') or (i.updateTime between '"
                + format.format(fromDate) + "' and '"
                + format.format(toDate)+"'))");

        return result;
    }
    private List processSearchResults(List searchResults){
        List processedResults = new ArrayList();
        if(searchResults.size() > 0){
            for(int i=0; i<searchResults.size(); i++){
                InteractionSearchView interactionSearchView = ( InteractionSearchView ) searchResults.get(i);
                Set attendees = interactionSearchView.getAttendees();
                Iterator itr = attendees.iterator();
                StringBuffer attendeeNameBuffer = new StringBuffer();
                Attendee attendee = new Attendee();
                for(boolean isFirst = true; itr.hasNext(); ){
                    attendee = ( Attendee ) itr.next();
                    if( isFirst ){
                        attendeeNameBuffer.append( attendee.getName() );
                        isFirst = false;
                    }else{
                        attendeeNameBuffer.append("; ").append( attendee.getName() );
                    }
                }
                interactionSearchView.setAttendeeList( attendeeNameBuffer.toString() );
                interactionSearchView.setAttendeeCount( attendees.size() );
                processedResults.add(interactionSearchView);
            }
        }
        return processedResults;
    }
	public int getSearchResultCutoff(){
	    
        Properties interactionProperties = DBUtil.getInstance().interactionProp;
        int maxInteractionSearchResults = 100;
        if( interactionProperties != null ){
            String maxInteractionSearchResultsStr = (String) interactionProperties.get("MAX_INTERACTION_SEARCH_RESULTS");
            if( maxInteractionSearchResultsStr != null){
                try{
                    maxInteractionSearchResults = Integer.parseInt(maxInteractionSearchResultsStr);
                }catch(Exception e){
                    logger.error("Error while fetching the cutoff for Interaction search results from resources/interactions.prop file.");
                }
            }
        }
        return maxInteractionSearchResults;
	}
	
    /*
     * (non-Javadoc)
     *
     * @see com.openq.interaction.IInteractionService#getAllInteractionByExpert(long)
     */
   public Interaction[] getAllInteractionByExpert(long expertId) {

       List result = getHibernateTemplate().find(
               "select a.interaction from Attendee a, Interaction i where upper(i.deleteFlag) not like upper('Y') "
                       + " and a.userId="+expertId+" and a.interaction=i.id");

       return (Interaction[]) result.toArray(new Interaction[result.size()]);
   }
}
