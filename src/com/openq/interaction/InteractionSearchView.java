package com.openq.interaction;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

public class InteractionSearchView {
	
	private long interactionId;
	
	private long userId;
	
	private String userName;
	
	private String productList;
	
	private String attendeeList;
	
	private String firstInteractionTopic;
	
	private long attendeeCount;
	
	private long otherAttendeeCount;
	
	private long primaryProductId;
	
	private long secondaryProductId;
	
	private long tertiaryProductId;

	private Date interactionDate;
	
	private Set attendees = new HashSet();

    public Set getAttendees() {
        return attendees;
    }

    public void setAttendees(Set attendees) {
        this.attendees = attendees;
    }

    public long getInteractionId() {
        return interactionId;
    }

    public void setInteractionId(long interactionId) {
        this.interactionId = interactionId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getPrimaryProductId() {
        return primaryProductId;
    }

    public void setPrimaryProductId(long primaryProductId) {
        this.primaryProductId = primaryProductId;
    }

    public long getSecondaryProductId() {
        return secondaryProductId;
    }

    public void setSecondaryProductId(long secondaryProductId) {
        this.secondaryProductId = secondaryProductId;
    }

    public long getTertiaryProductId() {
        return tertiaryProductId;
    }

    public void setTertiaryProductId(long tertiaryProductId) {
        this.tertiaryProductId = tertiaryProductId;
    }

 	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getProductList() {
		return productList;
	}

	public void setProductList(String productList) {
		this.productList = productList;
	}
	public String getAttendeeList() {
		return attendeeList;
	}

	public void setAttendeeList(String attendeeList) {
		this.attendeeList = attendeeList;
	}

	public String getFirstInteractionTopic() {
		return firstInteractionTopic;
	}

	public void setFirstInteractionTopic(String firstInteractionTopic) {
		this.firstInteractionTopic = firstInteractionTopic;
	}

	public long getAttendeeCount() {
		return attendeeCount;
	}

	public void setAttendeeCount(long attendeeCount) {
		this.attendeeCount = attendeeCount;
	}

	public long getOtherAttendeeCount() {
		return otherAttendeeCount;
	}

	public void setOtherAttendeeCount(long otherAttendeeCount) {
		this.otherAttendeeCount = otherAttendeeCount;
	}

    public Date getInteractionDate() {
        return interactionDate;
    }

    public void setInteractionDate(Date interactionDate) {
        this.interactionDate = interactionDate;
    }
	
}
