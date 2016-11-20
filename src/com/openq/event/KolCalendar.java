package com.openq.event;

import com.openq.eav.option.OptionLookup;

import java.io.Serializable;
import java.util.Date;
import java.util.Set;
import java.util.HashSet;

/**
 * Created by IntelliJ IDEA.
 * User: abhrap
 * Date: Nov 30, 2006
 * Time: 3:43:47 PM
 * To change this template use File | Settings | File Templates.
 */
public class KolCalendar implements Serializable{

    public KolCalendar() {}
    private long id;
    private long kolId;
    private String type;
    private Date preferenceDate;   

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getKolId() {
        return kolId;
    }

    public void setKolId(long kolId) {
        this.kolId = kolId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getPreferenceDate() {
        return preferenceDate;
    }

    public void setPreferenceDate(Date preferenceDate) {
        this.preferenceDate = preferenceDate;
    }



}
