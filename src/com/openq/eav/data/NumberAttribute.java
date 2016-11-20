package com.openq.eav.data;

import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;

public class NumberAttribute extends EavAttribute implements Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "value" });

	public NumberAttribute() {}
	private long value;

	public long getValue() {
		return value;
	}
	public void setValue(long value) {
		this.value = value;
	}
	public String toString() {
		return value + "";
	}	

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field) || super.isFieldAuditable(field).booleanValue());
    }
}
