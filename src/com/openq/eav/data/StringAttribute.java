package com.openq.eav.data;

import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;

public class StringAttribute extends EavAttribute implements java.io.Serializable, Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "value" });

	public StringAttribute() {
	}

	private String value;

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
		super.val=value;
	}

	public String toString() {
		// Make e-mails link
		
		/*return value != null ? (value.indexOf("@") > 0
				&& value.indexOf(".") > 0 ? "<a href='mailto:" + value + "'>"
				+ value + "</a>" : value) : "";*/
		return value!=null?value:"";
  }

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field) || super.isFieldAuditable(field).booleanValue());
    }
}
