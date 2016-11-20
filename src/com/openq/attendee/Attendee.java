package com.openq.attendee;

import java.io.Serializable;
import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;
import com.openq.interaction.Interaction;

public class Attendee implements Serializable, Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "attendeeType", "id",
            "name", "userId"});

	public static final int KOL_ATTENDEE_TYPE = 1; // user.id, OL in our database
	public static final int OTHER_ATTENDEE_TYPE = 2; // no unique id, free text
	public static final int EMPLOYEE_ATTENDEE_TYPE = 3; // LDAP, unique id = staffid
	public static final int ORX_ATTENDEE_TYPE = 4; // ORX, unique id = agoid
	public static final int ORG_ATTENDEE_TYPE = 5;	// ORG
	
	public Attendee(){}
	
	private long id;
	
	private Interaction interaction;
	
	private String name;
	
	private long userId;
	
	private int attendeeType;

	/**
	 * @return the id
	 */
	public long getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(long id) {
		this.id = id;
	}

	/**
	 * @return the interaction
	 */
	public Interaction getInteraction() {
		return interaction;
	}

	/**
	 * @param interaction the interaction to set
	 */
	public void setInteraction(Interaction interaction) {
		this.interaction = interaction;
	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return the userId
	 */
	public long getUserId() {
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(long userId) {
		this.userId = userId;
	}

	/**
	 * @return the attendeeType
	 */
	public int getAttendeeType() {
		return attendeeType;
	}

	/**
	 * @param attendeeType the attendeeType to set
	 */
	public void setAttendeeType(int attendeeType) {
		this.attendeeType = attendeeType;
	}


	 public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field));
    }
}
