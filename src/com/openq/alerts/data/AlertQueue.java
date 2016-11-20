package com.openq.alerts.data;

import java.io.Serializable;
import java.util.Date;

public class AlertQueue implements Serializable, Comparable {
    public AlertQueue() {}

    private long id;
    private int delivered;
    private Alert alert;
    private Date createdAt;
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    private String message;


    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Alert getAlert() {
        return alert;
    }

    public void setAlert(Alert alert) {
        this.alert = alert;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getDelivered() {
        return delivered;
    }

    public void setDelivered(int delivered) {
        this.delivered = delivered;
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final AlertQueue that = (AlertQueue) o;

        if (alert != null ? !alert.equals(that.alert) : that.alert != null) return false;
        if (message != null ? !message.equals(that.message) : that.message != null) return false;

        return true;
    }

    public int hashCode() {
        int result;
        result = (alert != null ? alert.hashCode() : 0);
        result = 29 * result + (message != null ? message.hashCode() : 0);
        return result;
    }

 	public int compareTo(Object arg0) {
		return this.createdAt.compareTo(((AlertQueue)arg0).getCreatedAt());
	}

}