package com.openq.pubmed;

import java.io.Serializable;

/**
 * This class is used to encapsulate the mapping between TAs and corresponding
 * keywords that need to be sent to Pubmed
 * 
 * @author Techno Czars
 */
public class TAKeywordMap implements Serializable {
    private long id;
    private String ta;
    private String keyword;
    
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public String getTa() {
        return ta;
    }
    
    public void setTa(String ta) {
        this.ta = ta;
    }
    
    public String getKeyword() {
        return keyword;
    }
    
    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }
}
