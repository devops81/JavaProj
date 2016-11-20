package com.openq.eav.data;

import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;

public class BooleanAttribute extends EavAttribute implements Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "value" });

	public BooleanAttribute() {}
	private Boolean value;

	public Boolean getValue() {
		return value;
	}
	public void setValue(Boolean value) {
		this.value = value;
		super.val=this.toString();
	}
	public String toString() {
		return value.booleanValue() ? "<img src='images/icon_check.gif' width='12' height='12' align='middle'>" : "";
	}	

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field) || super.isFieldAuditable(field).booleanValue());
    }
}
