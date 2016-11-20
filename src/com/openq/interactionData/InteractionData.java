package com.openq.interactionData;

import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;
import com.openq.eav.option.OptionLookup;
import com.openq.interaction.Interaction;

/**
 * Created by IntelliJ IDEA.
 * User: radhikav
 * Date: Feb 14, 2007
 * Time: 5:12:53 PM
 * To change this template use File | Settings | File Templates.
 */
public class InteractionData implements Auditable, Comparable {

    private static final List auditableFields = Arrays.asList(new String[] { "Data", "lovId", "secondaryLovId",
            "tertiaryLovId", "type" });

	public InteractionData(){}

    private long id;
    
    private String data;

    private Interaction interaction;

    private String type;

    private OptionLookup lovId;

    private OptionLookup secondaryLovId;
    
    private OptionLookup tertiaryLovId;
      
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Interaction getInteraction() {
        return interaction;
    }

    public void setInteraction(Interaction interaction) {
        this.interaction = interaction;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public OptionLookup getLovId() {
        return lovId;
    }

    public void setLovId(OptionLookup lovId) {
        this.lovId = lovId;
    }

	/**
	 * @return the data
	 */
	public String getData() {
		return data;
	}

	/**
	 * @param data the data to set
	 */
	public void setData(String data) {
		this.data = data;
	}
	/**
	 * @return the secondaryLovId
	 */
	public OptionLookup getSecondaryLovId() {
		return secondaryLovId;
	}

	/**
	 * @param secondaryLovId the secondaryLovId to set
	 */
	public void setSecondaryLovId(OptionLookup secondaryLovId) {
		this.secondaryLovId = secondaryLovId;
	}

	/**
	 * @return the tertiaryLovId
	 */
	public OptionLookup getTertiaryLovId() {
		return tertiaryLovId;
	}

	/**
	 * @param tertiaryLovId the tertiaryLovId to set
	 */
	public void setTertiaryLovId(OptionLookup tertiaryLovId) {
		this.tertiaryLovId = tertiaryLovId;
	}

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field));
    }

	public int compareTo(Object o) {
		if(this.getId()> 0 && 
				((InteractionData)o).getId() > 0){
			
			Long thisId = new Long(this.getId());
			Long objectId = new Long(((InteractionData)o).getId());
			return thisId.compareTo(objectId);
		}
		return 0;
	}
}
