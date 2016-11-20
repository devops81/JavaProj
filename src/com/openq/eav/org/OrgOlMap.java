package com.openq.eav.org;

import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;

public class OrgOlMap implements Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "division", "olId", "orgId", "position", "year" });

	public OrgOlMap(){}

	private long id;
	private long orgId;
	private long olId;
	private String position;
	private String division;
	private String year;
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public long getOlId() {
		return olId;
	}
	public void setOlId(long olId) {
		this.olId = olId;
	}
	public long getOrgId() {
		return orgId;
	}
	public void setOrgId(long orgId) {
		this.orgId = orgId;
	}

	public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getDivision() {
        return division;
    }

    public void setDivision(String division) {
        this.division = division;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }	

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field));
    }
}
