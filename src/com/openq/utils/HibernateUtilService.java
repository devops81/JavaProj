package com.openq.utils;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.hibernate.Session;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.eav.metadata.AttributeType;

public class HibernateUtilService extends HibernateDaoSupport implements
IHibernateUtilService{
	
    protected void initDao()
    throws Exception
{
    	logger.debug("In initDao method, initializing the metadata cache");
    	this.initializeAttributeTableMap();
}
	
	public String getUniqueNegativeCmaId() {
		
		PreparedStatement query = null;
		ResultSet result = null;
		String uniqueNegativeCmaId = "";
		Session session = this.getSession();
		try {
			query = session.connection().prepareStatement(
			"select HIBERNATE_SEQUENCE.NEXTVAL*-1 from dual");
			result = query.executeQuery();
			if (result != null && result.next()) {
				uniqueNegativeCmaId = "" + result.getLong(1);
			}
			return uniqueNegativeCmaId;
		} catch (Exception e) {
			logger.error("Exception while using hibernate_sequence.");
			logger.error(e.getStackTrace());
			return null;
		} finally {
			logger.debug("In the finally block");
			try {
				if (result != null)
					result.close();
			} catch (Exception e) {
				logger.error(e.getLocalizedMessage(), e);
			}
			try {
				if (query != null)
					query.close();
			} catch (Exception e) {
				logger.error(e.getLocalizedMessage(), e);
			}
			this.releaseSession(session);
		}
	}
	
    public long getUniqueRowId() {
		
		PreparedStatement query = null;
		ResultSet result = null;
		long uniqueRowId = 0;
		Session session = this.getSession();
		try {
			query = session.connection().prepareStatement(
			"select TABLE_ENTITY_ROW_SEQUENCE.NEXTVAL from dual");
			result = query.executeQuery();
			if (result != null && result.next()) {
				uniqueRowId =result.getLong(1);
			}
			return uniqueRowId;
		} catch (Exception e) {
			logger.error("Exception while using hibernate_sequence.");
			logger.error(e.getStackTrace());
			return 0;
		} finally {
			logger.debug("In the finally block");
			try {
				if (result != null)
					result.close();
			} catch (Exception e) {
				logger.error(e.getLocalizedMessage(), e);
			}
			try {
				if (query != null)
					query.close();
			} catch (Exception e) {
				logger.error(e.getLocalizedMessage(), e);
			}
			this.releaseSession(session);
		}
	}
	
    public static Map attributeTableCache=null;
    
  	public Map initializeAttributeTableMap()
	{
        logger.debug("Caching the attribute table");
		if (attributeTableCache == null) {
			logger.debug("attributetableCache is null, so querying the database");
			Map toReturn = new HashMap();
			List result = getHibernateTemplate().find("from AttributeType");
			for (int i = 0; i < result.size(); i++) {
				AttributeType at = (AttributeType) result.get(i);
				if (!toReturn.containsKey(new Long(at.getAttribute_id()))) {
					toReturn.put(new Long(at.getAttribute_id()), at);
				} else
					logger.warn("Unique Attribute Id constraint violated.");
			}
			attributeTableCache = toReturn;
		}
		return attributeTableCache;
	}
	
}
