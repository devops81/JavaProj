package com.openq.alerts.data;

import java.io.Serializable;

public class Recipient  implements Serializable{
    private long id;
    private long recipientId;
    private String recipientName;

    public Recipient() {}

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getRecipientId() {
        return recipientId;
    }

    public void setRecipientId(long recipientId) {
        this.recipientId = recipientId;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String name){
        this.recipientName = name;
    }
}