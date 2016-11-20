package com.openq.ovid;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by IntelliJ IDEA.
 * User: abhrap
 * Date: Sep 26, 2006
 * Time: 1:47:06 PM
 * To change this template use File | Settings | File Templates.
 */
public class OvidResultsDTO implements Serializable {

    private int authorId;

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    private String expertName;
    private int totalPublication;
    private int newPublications;
    private Date lastUpdate;

    public String getExpertName() {
        return expertName;
    }

    public void setExpertName(String expertName) {
        this.expertName = expertName;
    }

    public int getTotalPublication() {
        return totalPublication;
    }

    public void setTotalPublication(int totalPublication) {
        this.totalPublication = totalPublication;
    }

    public int getNewPublications() {
        return newPublications;
    }

    public void setNewPublications(int newPublications) {
        this.newPublications = newPublications;
    }

    public Date getLastUpdate() {
        return lastUpdate;
    }

    public void setLastUpdate(Date lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

}
