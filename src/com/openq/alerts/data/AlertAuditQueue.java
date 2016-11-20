package com.openq.alerts.data;

import java.io.Serializable;
import java.util.Date;

public class AlertAuditQueue implements Serializable {
    public static final int CREATE = 0;
    public static final int UPDATE = 1;
    public static final int DELETE = 2;

    public AlertAuditQueue(){}

    private long id;
    private long attributeId;
    private int operation;
    private String originalValue;
    private String newValue;
    private Date createdAt;
    private Date updatedAt;
    private Alert alert;
    private long kolId;

    public AlertDetail getAlertDetail() {
        return alertDetail;
    }

	public long getKolId() {
		return kolId;
	}

	public void setKolId(long kolId) {
		this.kolId = kolId;
	}

	public void setAlertDetail(AlertDetail alertDetail) {
        this.alertDetail = alertDetail;
    }

    private AlertDetail alertDetail;
    private String source;

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public Alert getAlert() {
        return alert;
    }

    public void setAlert(Alert alert) {
        this.alert = alert;
    }

    public long getAttribute() {
        return attribute;
    }

    public void setAttribute(long attribute) {
        this.attribute = attribute;
    }

    private long attribute;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getAttributeId() {
        return attributeId;
    }

    public void setAttributeId(long attributeId) {
        this.attributeId = attributeId;
    }

    public int getOperation() {
        return operation;
    }

    public void setOperation(int operation) {
        this.operation = operation;
    }

    public String getOriginalValue() {
        return originalValue;
    }

    public void setOriginalValue(String value) {
        this.originalValue = value;
    }

    public String getNewValue() {
        return newValue;
    }

    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final AlertAuditQueue that = (AlertAuditQueue) o;

        if (alert != null ? !alert.equals(that.alert) : that.alert != null) return false;

        return true;
    }

    public int hashCode() {
        return (alert != null ? alert.hashCode() : 0);
    }

}
