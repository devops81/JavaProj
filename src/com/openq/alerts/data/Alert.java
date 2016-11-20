package com.openq.alerts.data;

import java.io.Serializable;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

public class Alert  implements Serializable{
    public static final int STATUS_INACTIVE = 0;
    public static final int STATUS_ACTIVE = 1;

    public static final int DELIVERY_EMAIL = 1;
    public static final int DELIVERY_UI = 2;
    public static final int DELIVERY_BOTH = 3;

    public Alert() {}

    private long id;
    private int status;
    private int delivery;
    private String name;
    private String message;
    private Date createdAt;
    private Date updatedAt;
    private Date lastFiredAt;

    private EmailTemplate template;
    private List alertDetails;
    private List recipients;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getStatusString() {
        switch(status) {
            case STATUS_ACTIVE: return "Active";
            case STATUS_INACTIVE: return "Inactive";
        }

        return "Unknown";
    }

    public int getDelivery() {
        return delivery;
    }

    public void setDelivery(int delivery) {
        this.delivery = delivery;
    }

    public String getDeliveryString() {
        switch(delivery) {
            case DELIVERY_EMAIL : return "Email";
            case DELIVERY_UI: return "UI";
            case DELIVERY_BOTH: return "Email, UI";
        }

        return "Unknown";
    }

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

    public Date getLastFiredAt() {
        return lastFiredAt;
    }

    public void setLastFiredAt(Date lastFiredAt) {
        this.lastFiredAt = lastFiredAt;
    }

    public List getAlertDetails() {
        return alertDetails;
    }

    public void setAlertDetails(List alertDetails) {
        this.alertDetails = alertDetails;
    }

    public List getRecipients() {
        return recipients;
    }

    public void setRecipients(List recipients) {
        this.recipients = recipients;
    }

    public String getRecipientString() {
        StringBuffer buf = null;
        for(Iterator iter = this.getRecipients().iterator(); iter.hasNext(); )
        {
            if( buf == null ) {
                buf = new StringBuffer();
            } else {
                buf.append(", ");
            }
            buf.append(((Recipient)iter.next()).getRecipientName());
        }

        return ( buf == null ) ? "No Recipients" : buf.toString();
    }

    public EmailTemplate getTemplate() {
        return template;
    }

    public void setTemplate(EmailTemplate template) {
        this.template = template;
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final Alert alert = (Alert) o;

        if (id != alert.id) return false;

        return true;
    }

    public int hashCode() {
        return (int) (id ^ (id >>> 32));
    }
}