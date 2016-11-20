package com.openq.eav.data;

import java.io.Serializable;
import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;

public class EntityAttribute extends EavAttribute implements Serializable, Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "value" });

	public EntityAttribute() {}

	private Entity myEntity;
	
	private String value;

	public Entity getMyEntity() {
		return myEntity;
	}

	public void setMyEntity(Entity myEntity) {
		this.myEntity = myEntity;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field) || super.isFieldAuditable(field).booleanValue());
    }
}
