package com.openq.alerts.data;

import java.io.Serializable;

public class EmailTemplate  implements Serializable{
    public EmailTemplate() {}

    private long id;
    private String name;
    private String template;
    private int status;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getTemplate() {
        return template;
    }

    public void setTemplate(String template) {
        this.template = template;
    }
}