package com.openq.ig.pubmed.crawler.keyword;

import java.util.Date;

/**
 * This class is used to encapsulate data for keyword categories
 * 
 * @author Amit
 */
public class KeywordCategory {
    private long id;
    private String category;
    private String keywords;
    private Date createtime;
    private Date lastRuntime;
    private String status;

    public static String STATUS_RUNNING = "RUNNING";
    public static String STATUS_DORMANT = "COMPLETED";

    public KeywordCategory() {
    }

    public KeywordCategory(String category, String keywords) {
        this.category = category;
        this.keywords = keywords;
        this.createtime = new Date();
        this.status = "DORMANT";
    }

    public Date getCreatetime() {
        return createtime;
    }

    public void setCreatetime(Date createtime) {
        this.createtime = createtime;
    }

    public Date getLastRuntime() {
        return lastRuntime;
    }

    public void setLastRuntime(Date lastRuntime) {
        this.lastRuntime = lastRuntime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }


    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getKeywords() {
        return keywords;
    }

    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }
}