package com.openq.eav.audit;

public interface IAuditService {

	public void saveAuditInfo(AuditInfo auditInfo);

	public AuditInfo getLatestAuditInfo(long entityId);

	public AuditInfo getOldestAuditInfo(long entityId);

}