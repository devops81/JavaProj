package com.openq.eav.data;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import com.openq.audit.Auditable;

public class DateAttribute extends EavAttribute implements java.io.Serializable, Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "value" });

	public final static DateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
	
	public DateAttribute() {}
	private Date value;
	public Date getValue() {
		return value;
	}
	public void setValue(Date value) {
		this.value = value;
	}
	public String toString() {
		return value != null ? formatter.format(value) : "";
	}

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field) || super.isFieldAuditable(field).booleanValue());
    }
}
