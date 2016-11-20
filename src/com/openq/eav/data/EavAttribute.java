package com.openq.eav.data;

import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;
import com.openq.eav.metadata.AttributeType;

public class EavAttribute implements Auditable {
    private long id;
    private AttributeType attribute;
    private Entity parent;
    public String val;
    
    public long rootEntityId;
    public long rootEntityType;
    public long tabAttributeId;
    public boolean table;
    public long rowId;
	public boolean isTable()
	{
		return table;
	}
	public void setTable(boolean table)
	{
		this.table = table;
	}
	public long getRootEntityId()
	{
		return rootEntityId;
	}
	public void setRootEntityId(long rootEntityId)
	{
		this.rootEntityId = rootEntityId;
	}
	public long getRootEntityType()
	{
		return rootEntityType;
	}
	public void setRootEntityType(long rootEntityType)
	{
		this.rootEntityType = rootEntityType;
	}
	
	public long getTabAttributeId()
	{
		return tabAttributeId;
	}
	public void setTabAttributeId(long tabAttributeId)
	{
		this.tabAttributeId = tabAttributeId;
	}
	public AttributeType getAttribute() {
		return attribute;
	}
	public void setAttribute(AttributeType attribute) {
		this.attribute = attribute;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public Entity getParent() {
		return parent;
	}
	public void setParent(Entity parent) {
		this.parent = parent;
	}

	
	public long getRowId() {
		return rowId;
	}
	public void setRowId(long rowId) {
		this.rowId = rowId;
	}

    public Boolean isFieldAuditable(String field) {
        return Boolean.FALSE;
    }
	public String getVal() {
    	return val;
    }
    
    public String toString()
    {
    	return val != null ? val : "";
    }

	public boolean equals(Object o) {
		/*if (!(o instanceof EavAttribute)) {
			return false;
		}
		EavAttribute e = (EavAttribute) o;
		return (getId() == e.getId());*/
		return this == o;
	}
}
