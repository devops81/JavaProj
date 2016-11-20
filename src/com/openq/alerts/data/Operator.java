package com.openq.alerts.data;

import java.io.Serializable;

public class Operator implements Serializable{
    public Operator() {}

    private long id;
    private String operator;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getOperator() {
        return operator;
    }

    public void setOperator(String operator) {
        this.operator = operator;
    }
}
