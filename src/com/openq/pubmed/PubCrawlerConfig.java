package com.openq.pubmed;

import java.io.Serializable;

/**
 * This class is used to maintain Pubmed Crawler related config values in the DB
 * 
 * @author Techno Czars
 */
public class PubCrawlerConfig implements Serializable {
    private long id;
    private String propKey;
    private String propValue;
    
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public String getPropKey() {
        return propKey;
    }
    
    public void setPropKey(String propKey) {
        this.propKey = propKey;
    }
    
    public String getPropValue() {
        return propValue;
    }
    
    public void setPropValue(String propValue) {
        this.propValue = propValue;
    }
}
