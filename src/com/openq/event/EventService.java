package com.openq.event;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.authorization.IFeaturePermissionService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;
import com.openq.utils.SqlAndHqlUtilFunctions;
import com.openq.web.controllers.Constants;


/**
 * Created by IntelliJ IDEA.
 * User: abhrap
 * Date: Nov 30, 2006
 * Time: 3:44:02 PM
 * To change this template use File | Settings | File Templates.
 */
public class EventService extends HibernateDaoSupport implements IEventService {
    public final static DateFormat format = new SimpleDateFormat("dd-MMM-yy");
    public final static SimpleDateFormat formatS = new SimpleDateFormat("MM/dd/yyyy");

    IEventService eventService;

    public IEventService getEventService() {
        return eventService;
    }

    public void setEventService(IEventService eventService) {
        this.eventService = eventService;
    }

    IOptionService optionService;

    public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}
	
	IFeaturePermissionService featurePermissionService;
	
	public IFeaturePermissionService getFeaturePermissionService() {
        return featurePermissionService;
    }

    public void setFeaturePermissionService(
            IFeaturePermissionService featurePermissionService) {
        this.featurePermissionService = featurePermissionService;
    }

    public void saveEvent(EventEntity event) {
        getHibernateTemplate().save(event);
       Iterator attendees = event.getAttendees().iterator();
        while (attendees.hasNext()) {
            EventAttendee attendee = (EventAttendee) attendees.next();
            eventService.saveAttendee(attendee);
        }
    }

    public void updateEvent(EventEntity event) {
        getHibernateTemplate().update(event);
    }

    public EventEntity[] searchEvent(TreeMap map, long userGroupId) throws ParseException {
        final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
        if (map != null && !map.isEmpty()) {
            Set keys = map.keySet();
            Iterator itr = keys.iterator();
            String key = null;
            String val = null;
            StringBuffer queryBuff0 = new StringBuffer();
            StringBuffer queryBuff1 = new StringBuffer();
            Date fromDate = null;
            Date toDate = null;
            int counter = 0;

            while (itr.hasNext()) {
                if (counter == 0) {
                    queryBuff0.append(" from EventEntity e where e.ta ")
                              .append(PERMISSION_APPEND_QUERY)
                              .append(" and ( e.therapy is null or e.therapy ")
                              .append(PERMISSION_APPEND_QUERY)
                              .append(" ) and ");
                }

                key = (String) itr.next();
                val = (String) map.get(key);
                if (counter > 0) {
                    if ("title".equals(key)) {
                        queryBuff1.append(" and upper(e.title) like upper('%").append(val).append("%')");
                    } else if ("toDate1".equals(key)) {
                        fromDate = formatS.parse(val);
                        queryBuff1.append(" and e.eventdate between '").append(format.format(fromDate)).append("'");
                    } else if ("toDate2".equals(key)) {
                        toDate = formatS.parse(val);
                        queryBuff1.append(" and '").append(format.format(toDate)).append("'");
                    } else if ("type".equals(key)) {
                        queryBuff1.append(" and e.event_type = ").append(val).append("");
                    } else if ("owner".equals(key)) {
                        queryBuff1.append(" and e.owner = '").append(val).append("'");
                    } else if ("ta".equals(key)) {
                        queryBuff1.append(" and e.ta = ").append(val).append("");
                    } else if ("therapy".equals(key)) {
                        queryBuff1.append(" and e.therapy = ").append(val).append("");
                    } else if ("staffId".equals(key)) {
                        queryBuff1.append(" and e.staffids = '").append(val).append("'");
                    }
                } else {
                    if ("title".equals(key)) {
                        queryBuff1.append("upper(e.title) like upper('%").append(val).append("%')");
                    } else if ("toDate1".equals(key)) {
                        fromDate = formatS.parse(val);
                        queryBuff1.append("e.eventdate between '").append(format.format(fromDate)).append("'");
                    } else if ("toDate2".equals(key)) {
                        toDate = formatS.parse(val);
                        queryBuff1.append("and '").append(format.format(toDate)).append("'");
                    } else if ("type".equals(key)) {
                        queryBuff1.append("e.event_type = ").append(val).append("");
                    } else if ("owner".equals(key)) {
                        queryBuff1.append("e.owner = '").append(val).append("'");
                    } else if ("ta".equals(key)) {
                        queryBuff1.append("e.ta = ").append(val).append("");
                    } else if ("therapy".equals(key)) {
                        queryBuff1.append("e.therapy = ").append(val).append("");
                    } else if ("staffId".equals(key)) {
                        queryBuff1.append("e.staffids = '").append(val).append("'");
                    }
                }
                counter++;
            }

            String finalQuery = queryBuff0
                                .append(queryBuff1)
                                .append(" and e.deleteflag='N' ")
                                .append(" order by e.eventdate, lower(e.title), lower(e.event_type.optValue)," +
                                " lower(e.ta.optValue), lower(e.city) ").toString();
            if (finalQuery != null && finalQuery.length() > 0) {
                List result = getHibernateTemplate().find(finalQuery);
                return (EventEntity[]) result.toArray(new EventEntity[result.size()]);
            }
        } else {
            List result = getHibernateTemplate().find(
                    "from EventEntity e where e.ta " + PERMISSION_APPEND_QUERY +
                    " and ( e.therapy is null or e.therapy " + PERMISSION_APPEND_QUERY 
                            + " ) order by e.eventdate ");
            return (EventEntity[]) result.toArray(new EventEntity[result.size()]);
        }
        return null;
    }

public EventEntity[] searchEvent(String eventDate, long userGroupId)throws ParseException{
    final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
	StringBuffer queryBuff = new StringBuffer();
	Date evenDate = null;
	evenDate = formatS.parse(eventDate);
	queryBuff.append("from EventEntity e where (( ");
	queryBuff.append("e.eventdate <= '").append(format.format(evenDate)).append("' and e.endDate>='").append(format.format(evenDate)).append("')");
	queryBuff.append("or e.eventdate = '").append(format.format(evenDate)).append("' ) ");
	queryBuff.append(" and ( e.therapy is null or e.therapy ").append(PERMISSION_APPEND_QUERY);
	queryBuff.append(" ) and e.ta ").append(PERMISSION_APPEND_QUERY).append(" order by e.eventdate ");
	List result = getHibernateTemplate().find(queryBuff.toString());
	if(result!=null&&result.size()>0)
	{
		return (EventEntity[]) result.toArray(new EventEntity[result.size()]);
	}

return null;
}
    public EventEntity getEventbyId(long id) {
        List result = getHibernateTemplate().find("from EventEntity e where e.id = " + id);
        EventEntity eventEntity = null;
        if(result.size() > 0){
            eventEntity = (EventEntity) result.get(0);
        }
        return eventEntity;
    }

    public void saveEventAttendee(EventAttendee eventAttendee) {
       getHibernateTemplate().save(eventAttendee);
    }


    public void saveAttendee(EventAttendee eventAttendee) {
        getHibernateTemplate().save(eventAttendee);
    }

    public EventAttendee [] getAllAttendees(long eventId) {
            List result = getHibernateTemplate().find("from EventAttendee e where e.eventId = "+ eventId);

            return (EventAttendee[]) result.toArray(new EventAttendee[result.size()]);
        }

    public EventAttendee getAttendee(long eventId, long expertId)
    {
        List result=getHibernateTemplate().find("Select from EventAttendee ea where ea.eventId= "+eventId+" and ea.expertId= "+expertId);
        return ((EventAttendee)(result.get(0)));
    }

    public void updateEventAttendeeStatus(long attendeeId, String status) {
        EventAttendee eventAttendee = (EventAttendee) getHibernateTemplate().load(EventAttendee.class, new Long(attendeeId));
        eventAttendee.setAcceptanceStatus(status);
        getHibernateTemplate().update(eventAttendee);
    }

    public void updateAttendeeList(long eventId, EventAttendee[] newAttendees)
    {
        EventAttendee [] existingAttendees = getAllAttendees(eventId);
        for (int i=0; i<newAttendees.length; i++)
        {
            EventAttendee attendee = newAttendees[i];
            boolean found = false;
            for (int j=0; j<existingAttendees.length; j++) {
                if (existingAttendees[j].getId() == attendee.getId()) {
                    found = true;
                    break;
                }
            }
            if (!found)
                saveAttendee(attendee);
        }

        for (int k=0; k<existingAttendees.length; k++)
        {
            EventAttendee attendee = existingAttendees[k];
            boolean found = false;
            for (int j=0; j<newAttendees.length; j++) {
                if (newAttendees[j].getId() == attendee.getId()) {
                    found = true;
                    break;
                }
            }
            if (!found)
                deleteAttendee(attendee);
        }
    }

    public void deleteAttendee(EventAttendee attendee)
    {
        getHibernateTemplate().delete(attendee);
    }
    public Object[] getEventsByExpert(long expertId) {
        List result = getHibernateTemplate().find(
                "from EventEntity e,EventAttendee e1,OptionLookup o,OptionLookup p ,OptionLookup q  where o.id = e.event_type and p.id = e.ta and q.id = e.therapy and e.id = e1.eventId and e1.expertId= "+expertId);
       return (Object[]) result.toArray(new Object[result.size()]);
    }

    public EventEntity[] getAllEvents(){
        List result = getHibernateTemplate().find("from EventEntity");
        if(result != null && result.size()!= 0)
            return (EventEntity[])result.toArray(new EventEntity[result.size()]);
        return null;
    }

    public void deleteEvent(EventEntity event) {
        getHibernateTemplate().delete(event);
    }

    public EventEntity[] getEvents(String eventIds) {
       List result = getHibernateTemplate().find(
                "from EventEntity e where e.id in ("+eventIds+")");
       return (EventEntity[]) result.toArray(new EventEntity[result.size()]);
    }

    public EventAttendee[] isAttended(long eventId, long expertId) {
        List result = getHibernateTemplate().find("from EventAttendee where event_Id = "+ eventId + " and expert_Id = "+expertId);

        return (EventAttendee[]) result.toArray(new EventAttendee[result.size()]);
    }


    public List getUnAvailableDates(List userIds){
        StringBuffer sb = new StringBuffer();
        Iterator i =  userIds.iterator();
        String userId = "";
        int j=0;
        while ( i.hasNext())
        {
            userId = i.next().toString();
            if(j==0){
                sb.append(userId);
            }
            else{
               sb.append(",").append(userId);
            }
            j++;
        }
        //sb.append(userId);

        StringBuffer queryB  = new StringBuffer("select a.eventdate from EventEntity a where a.userid in (").append(sb.toString()).append(")");
        List result1 =getHibernateTemplate().find(queryB.toString());

        queryB = new StringBuffer("select a.eventdate from EventEntity a, EventAttendee ea where a.id=ea.eventId and ea.expertId in (").append(sb.toString()).append(")");
        List result2 =getHibernateTemplate().find(queryB.toString());

        queryB = new StringBuffer("select a.preferenceDate from KolCalendar a where a.type='2' and a.kolId in (").append(sb.toString()).append(")");
        List result3 =getHibernateTemplate().find(queryB.toString());
        result2.addAll(result1);
        result2.addAll(result3);
        return result2;
    }

    public Set getEventsByType(String type,OptionLookup[] typeLookup)
    {
    	Set resultSet = null, finalSet = new HashSet();
		if(typeLookup!=null && typeLookup.length>0)
		{
	    	for (int i = 0; i < typeLookup.length; i++) {
				String eventQuery = "from EventEntity a where a."+type+" = " + typeLookup[i].getId() + "";
	    		List results = getHibernateTemplate().find(eventQuery);
				resultSet = null;
				if (results != null || results.size() > 0) {
					resultSet = getEventIds((EventEntity[]) results.toArray(new EventEntity[results.size()]));
				}
				if (resultSet != null)
					finalSet.addAll(resultSet);
			}
			return finalSet;
		}
		return null;
    }

    private Set getEventIds(EventEntity[] eventMiscData)
	{
		Set eventMiscDataSet = new HashSet();
		for (int i = 0; i < eventMiscData.length; i++) {
			eventMiscDataSet.add(eventMiscData[i].getId() + "");
		}
		return eventMiscDataSet;
	}

    public Set searchEvents(Map attributes)
	{
		Set miscSet = new HashSet();
		Set eventresults = new HashSet();
		boolean miscFlag = false, eventsFlag = false;
		if (attributes != null && attributes.size() > 0) {
			Set taSet = new HashSet(), theraphySet = new HashSet();
			if (attributes.get("ta") != null) {
				long[] lovIds = (long[]) attributes.get("ta");
				OptionLookup[] taLookup = new OptionLookup[lovIds.length];
				for(int cnt=0;cnt<lovIds.length;cnt++)
					taLookup[cnt] = optionService.getOptionLookup(lovIds[cnt]);

				taSet = getEventsByType("ta", taLookup);
				attributes.remove("ta");
				if (taSet != null && taSet.size() > 0) {
					miscFlag = true;
					miscSet = taSet;
				}
				else
					return null;
			}
			if (attributes.get("therapy") != null) {
				long[] lovIds = (long[]) attributes.get("therapy");
				OptionLookup[] therapyLookup= new OptionLookup[lovIds.length];
				for(int cnt=0;cnt<lovIds.length;cnt++)
					therapyLookup[cnt] = optionService.getOptionLookup(lovIds[cnt]);

				theraphySet = getEventsByType("therapy", therapyLookup);
				attributes.remove("therapy");
				if (theraphySet != null && theraphySet.size() > 0) {
					if (miscFlag) {
						miscSet = getIntersection((HashSet) miscSet, (HashSet) theraphySet);
					} else {
						miscFlag = true;
						miscSet = theraphySet;
					}
				}
				else
					return null;
			}

			if (attributes != null && attributes.size() > 0) {
				StringBuffer queryBuff = new StringBuffer("from EventEntity a where");
				boolean hasAdded = false;
				Iterator itr = attributes.keySet().iterator();
				while (itr.hasNext()) {
					String key = (String) itr.next();
					Object value = attributes.get(key);
					if (hasAdded) {
						queryBuff.append(" and ");
					} else {
						queryBuff.append(" ");
						hasAdded = true;
					}
					if (value.getClass().getName().equals("java.lang.Long")) {
						queryBuff.append("a." + key + " like '" + ((Long) value).longValue() + "'");
					} else if (value.getClass().getName().equals("java.lang.String")) {
						queryBuff.append("upper(a." + key + ") like '%" + ((String) value).toUpperCase() + "%'");
					} else if (value.getClass().getName().equals("java.util.HashSet")) {
						String[] queryClause = SqlAndHqlUtilFunctions.constructInClauseForQuery((Set) value);
						queryBuff.append("a." + key + " in (" + queryClause[0] + ")");
					}
				}

				List results = getHibernateTemplate().find(queryBuff.toString());
				Set resultSet = new HashSet();
				resultSet.addAll(results);
				if (results != null && results.size() > 0) {
					for (int i = 0; i < results.size(); i++)
						eventresults.add(((EventEntity) results.get(i)).getId() + "");
				}
				eventsFlag = hasAdded;
			}
			if (eventsFlag) {
				HashSet finalEventResults = (HashSet) eventresults;
				if (miscFlag) {
					finalEventResults = getIntersection((HashSet) eventresults, (HashSet) miscSet);
				}
				return finalEventResults;
			} else if (miscFlag && !eventsFlag) {
				return miscSet;
			}

		} else {
			EventEntity[] allEvents = getAllEvents();
			if (allEvents != null && allEvents.length > 0) {
				Set allEventsSet = new HashSet();

				for (int i = 0; i < allEvents.length; i++) {
					allEventsSet.add(allEvents[i].getId() + "");
				}
				return allEventsSet;
			}
		}
		return null;
	}

	public HashSet getIntersection(HashSet set1, HashSet set2)
	{
		HashSet results = new HashSet();
		if (set1 != null && !set1.isEmpty() && set2 != null && !set2.isEmpty()) {
			Iterator itr = set1.iterator();
			String kol = null;
			while (itr.hasNext()) {
				kol = (String) itr.next();
				if (set2.contains(kol)) {
					results.add(kol);
				}
			}
		}
		return results;
	}

    public EventEntity[] getFilteredEvents(long selectedTA, String[] selectedTherapys) {
        StringBuffer commaSeparatedTherapyIds = new StringBuffer("-1");
        if(selectedTherapys != null){
            for(int i=0; i<selectedTherapys.length; i++){
                commaSeparatedTherapyIds.append(", ").append(selectedTherapys[i]);
            }
         }
        String query = "from EventEntity e where e.ta = " + selectedTA + 
        " and ( e.therapy is NULL or e.therapy  in ( " + commaSeparatedTherapyIds + " ) ) ";
        logger.debug(query);
        List results = getHibernateTemplate().find( query );
        if( results.size() > 0 ){
            return (EventEntity[]) results.toArray(new EventEntity[results.size()]);
        }else{
            return null;
        }
    }

    public EventEntity[] getAllAllowedEvents(long userGroupId) {
        final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
        String queryString = "from EventEntity e where e.ta " + PERMISSION_APPEND_QUERY + 
        " and ( e.therapy is null or e.therapy " + PERMISSION_APPEND_QUERY +  " ) order by e.eventdate, lower(e.title) ";
        List results = getHibernateTemplate().find(queryString);
        if( results.size() > 0 ){
            return (EventEntity[]) results.toArray(new EventEntity[results.size()]);
        }else{
            return null;
        }
    }

    public void deleteAttendeeByEventId(long eventId) {
        String queryString = " from EventAttendee ea where ea.eventId = " + eventId;
        getHibernateTemplate().delete(queryString);
        
    }

    public void deleteEventByEventId(long eventId) {
        String queryString = " from EventEntity ee where ee.id = " + eventId;
        getHibernateTemplate().delete(queryString);
        
    }

}
