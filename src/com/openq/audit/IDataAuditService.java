/**
 * 
 */
package com.openq.audit;

import java.util.List;
import java.util.Map;

/**
 * @author aagarwal
 * 
 */
public interface IDataAuditService {

    public List get(String entityId, String entityAttribute, String operationType);
    
    public Map getLatest(List entityId, String entityAttribute);

    public Map getLatest(String entityId, List entityAttribute);

    public AuditLogRecord getLatest(String entityId, String entityAttribute);
}
