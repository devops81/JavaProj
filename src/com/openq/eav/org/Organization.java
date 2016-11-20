package com.openq.eav.org;

import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;

public class Organization implements Comparable,java.io.Serializable, Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "acronym", "city", "country", "entityId", "name",
            "state", "type" });

	private long entityId;
	private String name;
	private String acronym;
	private String type;
	private String country;
    private String state;
    private String city;

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final Organization that = (Organization) o;

        if (entityId != that.entityId) return false;

        return true;
    }

    public int hashCode() {
        return (int) (entityId ^ (entityId >>> 32));
    }

    private long orgOlMapId;
    private String position;
	private String division;
	private String year;    

    public long getOrgOlMapId() {
        return orgOlMapId;
    }

    public void setOrgOlMapId(long orgOlMapId) {
        this.orgOlMapId = orgOlMapId;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getAcronym() {
		return acronym;
	}
	public void setAcronym(String acronym) {
		this.acronym = acronym;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public long getEntityId() {
		return entityId;
	}
	public void setEntityId(long entityId) {
		this.entityId = entityId;
	}
	
	public int compareTo(Object o) {
		return this.name.compareTo(((Organization) o).name);
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
