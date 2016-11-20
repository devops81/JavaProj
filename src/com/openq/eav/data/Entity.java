package com.openq.eav.data;

import java.io.Serializable;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.openq.audit.Auditable;
import com.openq.eav.metadata.EntityType;

public class Entity implements Serializable, Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "deleteFlag" });

	public Entity() {}

    private long id;

	private EntityType type;	
	
	private String deleteFlag = "N";
	
	private Set entityAttribute=new HashSet();
	
	private Set valueString=new HashSet();
	
	private Set valueBoolean=new HashSet();
	
	private Set valueNumber=new HashSet();
	
	private Set valueDate=new HashSet();
	

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}


	
	public Set getValueBoolean() {
		return valueBoolean;
	}

	public void setValueBoolean(Set valueBoolean) {
		this.valueBoolean = valueBoolean;
	}

	public Set getValueDate() {
		return valueDate;
	}

	public void setValueDate(Set valueDate) {
		this.valueDate = valueDate;
	}

	public Set getValueNumber() {
		return valueNumber;
	}

	public void setValueNumber(Set valueNumber) {
		this.valueNumber = valueNumber;
	}

	public Set getValueString() {
		return valueString;
	}

	public void setValueString(Set valueString) {
		this.valueString = valueString;
	}

	public Set getEntityAttribute() {
		return entityAttribute;
	}

	public void setEntityAttribute(Set entityAttribute) {
		this.entityAttribute = entityAttribute;
	}

	public EntityType getType() {
		return type;
	}

	public void setType(EntityType type) {
		this.type = type;
	}

	public String getDeleteFlag() {
		return deleteFlag;
	}

	public void setDeleteFlag(String deleteFlag) {
		this.deleteFlag = deleteFlag;
	}

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field));
    }
}
