package com.openq.attendee;

public interface IAttendeeService {

	public Attendee[] getAllAttendees(long interactionId);

	public void saveAttendee(Attendee attendee);

	public void updateAttendee(Attendee attendee);

	public void deleteAttendee(Attendee attendee);
	
	public void deleteAttendees(long InteractionId);
	
	public void updateAttendeeList(long interactionId, Attendee[] attendees);
	
	public Attendee [] getAttendees(long attendeeId);

    public void updateAttendees(long interactionId, Attendee[] newAttendees);
    public int getAttendeeCountFromAttendees(long interactionId);

}