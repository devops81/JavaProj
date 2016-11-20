package com.openq.alerts.data;

import java.io.Serializable;

public class AlertDetail  implements Serializable{
    public AlertDetail() {}

    private long id;
    private long attributeId;
    private String value;
    private int operator;
    private int ruleOperator;

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

    public int getOperator() {
        return operator;
    }

    public void setOperator(int operator) {
        this.operator = operator;
    }

    public int getRuleOperator() {
        return ruleOperator;
    }

    public void setRuleOperator(int ruleOperator) {
        this.ruleOperator = ruleOperator;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
