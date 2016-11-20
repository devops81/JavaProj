package com.openq.eav.api;

public interface IRowIdGenerator {
	public long getNextRowId(long parentId, long attributeId);
}
