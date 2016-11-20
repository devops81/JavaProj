package com.openq.eav.api;

import com.openq.eav.data.TableRow;

public interface IEavDataService {
	public void saveOrUpdateRow(TableRow row);
	public TableRow getRow(long parent, long attributeId, long rowId);
	public TableRow [] getAllRows(long parent, long attributeId);	

	public TableRow getRow(long parent, String attributeQualifiedName, long rowId);
	public TableRow [] getAllRows(long parent, String attributeQualifiedName);
}
