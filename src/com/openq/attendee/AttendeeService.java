package com.openq.attendee;

import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.user.User;



public class AttendeeService extends HibernateDaoSupport implements IAttendeeService{
	
	
	public Attendee [] getAllAttendees(long interactionId) {
	    List result = getHibernateTemplate().find(
				"from Attendee a where a.interaction = "
				+ interactionId);

		return (Attendee[]) result.toArray(new Attendee[result.size()]); 
	}

	
	public void saveAttendee(Attendee attendee)
	{
		getHibernateTemplate().save(attendee);
	}
	
	public void updateAttendee(Attendee attendee)
	{
		getHibernateTemplate().update(attendee);
	}
	
	public void deleteAttendee(Attendee attendee)
	{
		getHibernateTemplate().delete(attendee);
	}
	
	public void deleteAttendees(long interactionId)
	{
		Attendee[] existingAttendees = getAllAttendees(interactionId);
		for(int i=0;i<existingAttendees.length;i++)
		{
			deleteAttendee(existingAttendees[i]);
		}
	}
	
	public void updateAttendeeList(long interactionId, Attendee[] newAttendees)
	{
		Attendee [] existingAttendees = getAllAttendees(interactionId);
		for (int i=0; i<newAttendees.length; i++)
		{
			Attendee attendee = newAttendees[i];
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
			Attendee attendee = existingAttendees[k];
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

    public void updateAttendees(long interactionId, Attendee[] newAttendees) {
        if(newAttendees != null && newAttendees.length > 0) {
            Attendee [] existingAttendees = getAllAttendees(interactionId);
            if(null != existingAttendees && existingAttendees.length > 0) {
                for(int i=0;i<existingAttendees.length;i++) {
                    deleteAttendee(existingAttendees[i]);
                }
            }
            for (int i=0; i<newAttendees.length; i++) {
                saveAttendee(newAttendees[i]);
            }
        }
    }

    public Attendee [] getAttendees(long attendeeId) {

        List result = getHibernateTemplate().find("from Attendee a where a.userId="+attendeeId);
        return (Attendee[]) result.toArray(new Attendee[result.size()]);
    }
	
    /**
     * This function queries the count of attendee type in the attendee table
     */
    
    public int getAttendeeCountFromAttendees(long interactionId){
        List result= getHibernateTemplate().find(" from Attendee a where a.interaction="+interactionId);
    	if(result!=null){
    		return result.size();
		}else{
			return 0;
		}
	}
    
}
