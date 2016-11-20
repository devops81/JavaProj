package com.openq.event;
import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;
import com.openq.event.EventEntity;
import com.openq.user.User;
/**
 * Created by IntelliJ IDEA.
 * User: radhikav
 * Date: Dec 7, 2006
 * Time: 1:47:53 PM
 * To change this template use File | Settings | File Templates.
 */
public class EventAttendee implements java.io.Serializable, Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "acceptanceStatus", "approverId", "attended",
            "expertId", "userId" });

    public EventAttendee(){}
    
    public static final String DEFAULT_STATUS = "Pending";
    public static final String ACCEPTED_STATUS = "Accepted";
    public static final String DECLIEND_STATUS = "Declined";
    
    private long id;

    private EventEntity eventId;

    private User expertId;
    private long approverId;

    private long userId;

    private String attended;

    private String acceptanceStatus = DEFAULT_STATUS;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }
    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getAttended() {
        return attended;
    }

    public void setAttended(String attended) {
        this.attended = attended;
    }

     public EventEntity getEventId() {
        return eventId;
    }

    public void setEventId(EventEntity eventId) {
        this.eventId = eventId;
    }

	public String getAcceptanceStatus() {
		if (acceptanceStatus == null || acceptanceStatus.trim().equals(""))
			return DEFAULT_STATUS;

		return acceptanceStatus;
	}

	public void setAcceptanceStatus(String status) {
		this.acceptanceStatus = status;
	}
	public long getApproverId() {
		return approverId;
	}

	public void setApproverId(long approverId) {
		this.approverId = approverId;
	}

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field));
    }

    public User getExpertId() {
        return expertId;
    }

    public void setExpertId(User expertId) {
        this.expertId = expertId;
    }
    
}
