package com.openq.audit;

public interface Auditable {

    /**
     * This routine determines whether the field is to be audited or not
     * 
     * @param field
     *            field name
     * @return
     */
    public abstract Boolean isFieldAuditable(String field);
}
