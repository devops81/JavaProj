package com.openq.eav.data;

import com.openq.eav.metadata.AttributeType;

public class TableRow {
	private long rowId;
	private long rootEntityId;
	private AttributeType parentAttributeType;
	private EavAttribute [] columns;
	public EavAttribute[] getColumns() {
		return columns;
	}
	public void setColumns(EavAttribute[] columns) {
		this.columns = columns;
	}
	public long getRowId() {
		return rowId;
	}
	public void setRowId(long rowId) {
		this.rowId = rowId;
	}
	public AttributeType getParentAttributeType() {
		return parentAttributeType;
	}
	public void setParentAttributeType(AttributeType parentAttributeType) {
		this.parentAttributeType = parentAttributeType;
	}
	public long getRootEntityId() {
		return rootEntityId;
	}
	public void setRootEntityId(long rootEntityId) {
		this.rootEntityId = rootEntityId;
	}
}
