/**
 *
 */
package com.openq.audit;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.user.IUserService;
import com.openq.user.User;

/**
 * This service retrieves the audit information from the AuditLog table
 * 
 */
public class DataAuditService extends HibernateDaoSupport implements IDataAuditService {

    private static final int MYSQL_ARGUMENT_BATCH_SIZE = 999;

    private static Map allUsers = null;
    IUserService userService;

    /**
     *
     */
    private void fetchAllUsers() {
        if (allUsers == null) {
            allUsers = new HashMap();

            // Get all the users in an array;
            User[] users;
            try {
                users = userService.getAllUser();
            } catch (Exception e) {
                users = null;
                logger.error("[fetchAllUsers] Exception while fetching user details from db");
                logger.error(e);
            }

            // Convert the array into map
            if (users != null) {
                for (int i = 0; i < users.length; i++) {
                    allUsers.put(new Long(users[i].getId()), users[i].getUserName());
                }
            }
        }
    }

    /**
     * The method takes a string query and returns a list of AuditRecords
     * 
     * @param query
     * @return
     */
    private List getAuditRecords(String query) {
        // Fire the query
        List result;
        try {
            result = getHibernateTemplate().find(query);
        } catch (Exception e) {
            result = null;
            logger.error("[getAuditRecords] Exception while fetching audit records from db");
            logger.error(e);
        }

        if (result == null || result.size() == 0) {
            return null;
        }

        // Fetch all the user names
        fetchAllUsers();

        // Set the user names in the result
        boolean usersRefreshed = false;
        for (Iterator iterator = result.iterator(); iterator.hasNext();) {
            AuditLogRecord auditRecord = (AuditLogRecord) iterator.next();
            Long userId = auditRecord.getUserId();
            if ((allUsers == null) || (!usersRefreshed && !allUsers.containsKey(userId))) {
                // Possibly user has been added recently, lets refresh the list
                allUsers = null;
                fetchAllUsers();
                usersRefreshed = true;
            }

            // Set the user name
            if ((allUsers != null) && allUsers.containsKey(userId)) {
                auditRecord.setUserName((String) allUsers.get(userId));
            } else {
                auditRecord.setUserName(userId + "");
            }
        }
        return result;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.openq.audit.IDataAuditService#get(java.lang.String, java.lang.String, java.lang.String)
     */
    public List get(String entityId, String entityAttribute, String operationType) {
        if (entityId == null) {
            return null;
        }

        // Build the query
        String query = "from AuditLogRecord a";
        query += " where a.entityId='" + entityId + "'";
        query += entityAttribute != null ? " and a.entityAttribute='" + entityAttribute + "'" : "";
        query += operationType != null ? " and a.operationType='" + operationType + "'" : "";
        query += " order by a.id asc";

        return getAuditRecords(query);
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.openq.audit.IDataAuditService#getLatest(java.util.List, java.lang.String)
     */
    public Map getLatest(List entityId, String entityAttribute) {

        // MySql has a limit for list size in condition query, so break them in batches if required.
        if (entityId.size() <= MYSQL_ARGUMENT_BATCH_SIZE) {
            return getLatest(entityId, entityAttribute, entityId.size());
        }

        // Start and end indices of the list
        int start = 0;
        int end = 0;
        Map resultMap = new HashMap();

        // Make SQL queries in batches
        for (int i = 0; i < entityId.size(); i += MYSQL_ARGUMENT_BATCH_SIZE) {
            // Get the end indices
            end = end + MYSQL_ARGUMENT_BATCH_SIZE;
            if (end > entityId.size()) {
                end = entityId.size();
            }

            // Get a sub list for given indices range
            List subList = entityId.subList(start, end);

            // Get the audit entries for this sub list
            Map subMap = getLatest(subList, entityAttribute, end - start);

            // Add all the entries in the final result map
            resultMap.putAll(subMap);

            // Increment the start index
            start += MYSQL_ARGUMENT_BATCH_SIZE;
        }

        return resultMap;
    }

    /**
     * The method takes a list of entities and returns the attribute values for those entities
     * 
     * @param entityId
     * @param entityAttribute
     * @param listSize
     * @return
     */
    private Map getLatest(List entityId, String entityAttribute, int listSize) {
        // Check for the list size
        if (listSize > MYSQL_ARGUMENT_BATCH_SIZE) {
            throw new IllegalArgumentException("The argument listSize can't be greater than " + MYSQL_ARGUMENT_BATCH_SIZE
                    + ". Kindly use appropriate method.");
        }

        Map resultMap = new HashMap();
        if (entityId == null || entityId.size() == 0) {
            return resultMap;
        }

        // Build the entityId list
        StringBuffer entityIdList = new StringBuffer("'-1'");
        /*if (entityId.get(0) != null) {
            entityIdList.append("'");
            entityIdList.append(entityId.get(0).toString());
            entityIdList.append("',");
        }*/
        for (int i = 0; i < entityId.size(); i++) {
            if (entityId.get(i) != null) {
                entityIdList.append(",'");
                entityIdList.append(entityId.get(i).toString());
                entityIdList.append("'");
            }
        }

        // Build the query
        String query = "from AuditLogRecord a";
        query += !"".equals(entityIdList.toString()) ? " where a.entityId in (" + entityIdList + ")" : " where a.entityId in ('')";
        query += entityAttribute != null ? " and a.entityAttribute='" + entityAttribute + "'" : "";
        query += " order by a.id asc";

        // Fire the query
        List result = getAuditRecords(query);

        // Set the user names in the result, and fill up the map
        if (result == null || result.size() == 0) {
            return resultMap;
        }

        for (Iterator iterator = result.iterator(); iterator.hasNext();) {
            AuditLogRecord auditRecord = (AuditLogRecord) iterator.next();
            resultMap.put(auditRecord.getEntityId() + auditRecord.getEntityAttribute(), auditRecord);
        }

        return resultMap;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.openq.audit.IDataAuditService#getLatest(java.lang.String, java.util.List)
     */
    public Map getLatest(String entityId, List entityAttribute) {

        // MySql has a limit for list size in condition query, so break them in batches if required.
        if (entityAttribute.size() <= MYSQL_ARGUMENT_BATCH_SIZE) {
            return getLatest(entityId, entityAttribute, entityAttribute.size());
        }

        // Start and end indices of the list
        int start = 0;
        int end = 0;
        Map resultMap = new HashMap();

        // Make SQL queries in batches
        for (int i = 0; i < entityAttribute.size(); i += MYSQL_ARGUMENT_BATCH_SIZE) {
            // Get the end indices
            end = end + MYSQL_ARGUMENT_BATCH_SIZE;
            if (end > entityAttribute.size()) {
                end = entityAttribute.size();
            }

            // Get a sub list for given indices range
            List subList = entityAttribute.subList(start, end);

            // Get the audit entries for this sub list
            Map subMap = getLatest(entityId, subList, end - start);

            // Add all the entries in the final result map
            resultMap.putAll(subMap);

            // Increment the start index
            start += MYSQL_ARGUMENT_BATCH_SIZE;
        }

        return resultMap;
    }

    /**
     * The method takes an entity id and returns list of attribute values for that entity
     * 
     * @param entityId
     * @param entityAttribute
     * @param listSize
     * @return
     */
    private Map getLatest(String entityId, List entityAttribute, int listSize) {
        if (entityId == null) {
            return null;
        }

        // Check for the list size
        if (listSize > MYSQL_ARGUMENT_BATCH_SIZE) {
            throw new IllegalArgumentException("The argument listSize can't be greater than " + MYSQL_ARGUMENT_BATCH_SIZE
                    + ". Kindly use appropriate method.");
        }

        // Build the entityId list
        StringBuffer attributeList = new StringBuffer("");
        attributeList.append("'");
        attributeList.append(entityAttribute.get(0).toString());
        attributeList.append("'");
        for (int i = 1; i < entityAttribute.size(); i++) {
            attributeList.append(", '");
            attributeList.append(entityAttribute.get(i).toString());
            attributeList.append("'");
        }

        // Build the query
        String query = "from AuditLogRecord a";
        query += " where a.entityId ='" + entityId + "'";
        query += entityAttribute != null ? " and a.entityAttribute in (" + attributeList + ")" : "";
        query += " order by a.id asc";

        // Fire the query
        List result = getAuditRecords(query);

        // Set the user names in the result, and fill up the map
        Map resultMap = new HashMap();
        if (result == null || result.size() == 0) {
            return resultMap;
        }

        for (Iterator iterator = result.iterator(); iterator.hasNext();) {
            AuditLogRecord auditRecord = (AuditLogRecord) iterator.next();
            resultMap.put(auditRecord.getEntityId() + auditRecord.getEntityAttribute(), auditRecord);
        }

        return resultMap;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.openq.audit.IDataAuditService#getLatest(java.lang.String, java.lang.String)
     */
    public AuditLogRecord getLatest(String entityId, String entityAttribute) {
        List result = get(entityId, entityAttribute, null);
        return result == null ? null : ((AuditLogRecord) result.get(result.size() - 1));
    }

    /**
     * @return the userService
     */
    public IUserService getUserService() {
        return userService;
    }

    /**
     * @param userService
     *            the userService to set
     */
    public void setUserService(IUserService userService) {
        this.userService = userService;
    }
}
