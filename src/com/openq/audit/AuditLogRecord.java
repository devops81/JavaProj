package com.openq.audit;

import java.io.Serializable;
import java.util.Date;

/**
 * This class is responsible for handling all audit functions needed to be attached to the classes.
 */
public class AuditLogRecord implements Serializable {
    private static final long serialVersionUID = -1;

    private long id;
    private String entityId;
    private String entityClass;
    private String entityAttribute;
    private Date updatedDate;
    private String oldValue;
    private String newValue;
    private String operationType;
    private Long userId;
    private transient String userName;

    /**
     * Default constructor
     */
    public AuditLogRecord() {
    };

    /**
     * Copy constructor
     * 
     * @param auditRecord
     */
    public AuditLogRecord(AuditLogRecord auditRecord) {
        this.id = auditRecord.id;
        this.entityId = auditRecord.entityId != null ? new String(auditRecord.entityId) : null;
        this.entityClass = auditRecord.entityClass != null ? new String(auditRecord.entityClass) : null;
        this.entityAttribute = auditRecord.entityAttribute != null ? new String(auditRecord.entityAttribute) : null;
        this.updatedDate = new Date(auditRecord.updatedDate.getTime());
        this.oldValue = auditRecord.oldValue != null ? new String(auditRecord.oldValue) : null;
        this.newValue = auditRecord.newValue != null ? new String(auditRecord.newValue) : null;
        this.operationType = auditRecord.operationType != null ? new String(auditRecord.operationType) : null;
        this.userId = auditRecord.userId;
        this.userName = new String(auditRecord.getUserName() != null ? auditRecord.getUserName() : "");
    };

    /**
     * @return
     */
    public long getId() {
        return id;
    }

    /**
     * @param id
     */
    public void setId(long id) {
        this.id = id;
    }

    /**
     * @return the entityId
     */
    public String getEntityId() {
        return entityId;
    }

    /**
     * @param entityId
     *            the entityId to set
     */
    public final void setEntityId(String entityId) {
        this.entityId = entityId;
    }

    /**
     * @return the entityClass
     */
    public String getEntityClass() {
        return entityClass;
    }

    /**
     * @param entityClass
     *            the entityClass to set
     */
    public final void setEntityClass(String entityClass) {
        this.entityClass = entityClass;
    }

    /**
     * @return
     */
    public String getEntityAttribute() {
        return entityAttribute;
    }

    /**
     * @param entityAttribute
     */
    public void setEntityAttribute(String entityAttribute) {
        this.entityAttribute = entityAttribute;
    }

    /**
     * @return
     */
    public Date getUpdatedDate() {
        return updatedDate;
    }

    /**
     * @param updatedDate
     */
    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate = updatedDate;
    }

    /**
     * @return
     */
    public String getOldValue() {
        return oldValue;
    }

    /**
     * @param oldValue
     */
    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }

    /**
     * @return
     */
    public String getFormattedOldValue() {
        String value;

        if (oldValue == null) {
            return null;
        }
        if (oldValue.length() > 384) {
            value = oldValue.substring(0, 384).concat("....");
        } else {
            value = new String(oldValue);
        }

        value = value.replaceAll("\'", "`");
        return value;
    }

    /**
     * @return
     */
    public String getNewValue() {
        return newValue;
    }

    /**
     * @param newValue
     */
    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }

    /**
     * @return the message
     */
    public String getOperationType() {
        return operationType;
    }

    /**
     * @param message
     */
    public void setOperationType(String message) {
        this.operationType = message;
    }

    /**
     * @return the userId
     */
    public Long getUserId() {
        return userId;
    }

    /**
     * @param userId
     *            the userId to set
     */
    public void setUserId(Long userId) {
        this.userId = userId;
    }

    /**
     * @return the userName
     */
    public String getUserName() {
        return userName;
    }

    /**
     * @param userName
     *            the userName to set
     */
    public void setUserName(String userName) {
        this.userName = userName;
    }

    /**
     * @return
     */
    public String getMouseHoverTitle() {
        StringBuffer title = new StringBuffer("");
        title.append("Last Update : ");
        if (updatedDate != null) {
            title.append(updatedDate.toString());
        } else {
            title.append("Date not available");
        }
        title.append("\nPrevious Value : ");
        title.append(getFormattedOldValue());
        title.append("\nUser : ");
        if (userName != null) {
            title.append(userName);
        } else {
            title.append("User detail not available");
        }
        return title.toString();
    }

    /**
     * @return
     */
    public static String getMouseHoverTitle(AuditLogRecord auditRecord) {
        if (auditRecord == null) {
            return getNoUpdateTitle();
        }
        return auditRecord.getMouseHoverTitle();
    }

    /**
     * @param auditRecord1
     * @param auditRecord2
     * @param currentValue1
     * @param currentValue2
     * @return
     */
    public static AuditLogRecord merge(AuditLogRecord auditRecord1, AuditLogRecord auditRecord2, String currentValue1,
            String currentValue2) {
        return merge(auditRecord1, auditRecord2, currentValue1, currentValue2, "");
    }

    /**
     * @param auditRecord1
     * @param auditRecord2
     * @param currentValue1
     * @param currentValue2
     * @param initialString
     * @return
     */
    public static AuditLogRecord merge(AuditLogRecord auditRecord1, AuditLogRecord auditRecord2, String currentValue1,
            String currentValue2, String initialString) {
        AuditLogRecord auditRecord = null;
        if (auditRecord1 == null && auditRecord2 == null) {
            auditRecord = null;
        } else if (auditRecord1 == null) {
            auditRecord = new AuditLogRecord(auditRecord2);
            if (currentValue1 != null) {
                StringBuffer oldValue = new StringBuffer(initialString);
                oldValue.append(currentValue1);
                oldValue.append(", ");
                oldValue.append(auditRecord.getOldValue());
                auditRecord.setOldValue(oldValue.toString());
            }
        } else if (auditRecord2 == null) {
            auditRecord = new AuditLogRecord(auditRecord1);
            if (currentValue2 != null) {
                StringBuffer oldValue = new StringBuffer(initialString);
                oldValue.append(auditRecord.getOldValue());
                oldValue.append(", ");
                oldValue.append(currentValue2);
                auditRecord.setOldValue(oldValue.toString());
            }
        } else {
            auditRecord = new AuditLogRecord(auditRecord1);
            auditRecord.setOldValue(initialString + auditRecord.getOldValue() + ", " + auditRecord2.getOldValue());
            if ((auditRecord.getUpdatedDate() == null)
                    || ((auditRecord2.getUpdatedDate() != null) && auditRecord.getUpdatedDate().before(
                            auditRecord2.getUpdatedDate()))) {
                auditRecord.setUpdatedDate(auditRecord2.getUpdatedDate());
                auditRecord.setUserName(auditRecord2.getUserName());
            }
        }
        return auditRecord;
    }

    /**
     * @return
     */
    public static String getNoUpdateTitle() {
        return "No Updates";
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.lang.Object#toString()
     */
    public String toString() {
        return "entityId : '" + entityId + "' entityClass : '" + entityClass + "' entityAttribute : '" + entityAttribute
                + "' updatedDate : '" + updatedDate + "' newValue : '" + newValue + "' oldValue : '" + oldValue
                + "' operationType : '" + operationType + "' userId : '" + userId;
    }
}
