package com.openq.event;

import java.text.ParseException;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import com.openq.eav.option.OptionLookup;

/**
 * Created by IntelliJ IDEA.
 * User: abhrap
 * Date: Nov 30, 2006
 * Time: 3:44:21 PM
 * To change this template use File | Settings | File Templates.
 */
public interface IEventService {

   public EventAttendee getAttendee(long eventId, long expertId);

   public void saveEvent(EventEntity event);

   public void updateEvent(EventEntity event);

   public EventEntity[] getAllEvents();

   public EventEntity[] searchEvent(TreeMap map, long userGroupId) throws ParseException;

   public EventEntity[] searchEvent(String eventDate, long userGroupId)throws ParseException;

   public EventEntity getEventbyId(long id);

   public void saveEventAttendee(EventAttendee eventAttendee);

   public void saveAttendee(EventAttendee eventAttendee);

   public EventAttendee [] getAllAttendees(long eventId) ;

   public void updateAttendeeList(long eventId, EventAttendee[] newAttendees);

   public void deleteAttendee(EventAttendee attendee);

   public Object[] getEventsByExpert(long expertId);

   public void deleteEvent(EventEntity event);

   public EventEntity[] getEvents(String eventIds);

   public EventAttendee[]  isAttended(long eventId, long expertId);

   public void updateEventAttendeeStatus(long attendeeId, String status);

   public List getUnAvailableDates(List userIds);

   public Set searchEvents(Map attributes);

   public HashSet getIntersection(HashSet set1, HashSet set2);

   public Set getEventsByType(String type,OptionLookup[] lookUp);
   
   public EventEntity[] getFilteredEvents(long selectedTA, String[] selectedTherapys);
   
   public EventEntity[] getAllAllowedEvents(long userGroupId);
   
   public void deleteAttendeeByEventId(long eventId);
   
   public void deleteEventByEventId(long eventId);

}
