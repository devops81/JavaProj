package com.openq.utils;

import java.util.Map;
import java.util.Set;

import com.openq.eav.metadata.AttributeType;

public interface IHibernateUtilService {
	
	/**
	 * This routine is used to get a unique negative number by using the Oracle
	 * sequence HIBERNATE_SEQUENCE.
	 */
	
	public String getUniqueNegativeCmaId();
	
	public long getUniqueRowId();
	
	public Map initializeAttributeTableMap();
		
}
