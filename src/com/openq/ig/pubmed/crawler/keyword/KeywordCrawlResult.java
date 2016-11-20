package com.openq.ig.pubmed.crawler.keyword;

/**
 * This class is used to encapsulate resultant rows fetched as part of a Keyword-based
 * Search functionality. 
 * 
 * @author Amit
 *
 */
public class KeywordCrawlResult {
    private long id;
    private String authorName;
    private long pubCount;
    
    public KeywordCrawlResult() {
        
    }

    public KeywordCrawlResult(String name, long count) {
        authorName = name;
        pubCount = count;
    }

    public String getAuthorName() {
        return authorName;
    }
    
    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }
    
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public long getPubCount() {
        return pubCount;
    }
    
    public void setPubCount(long pubCount) {
        this.pubCount = pubCount;
    }
}
