package com.openq.ig.pubmed.crawler.keyword;

import java.util.HashMap;
import java.util.List;


/**
 * This class provides all services related to persistance and retrieval of 
 * data needed for the Network Map Applet
 * 
 * @author Amit Arora
 *
 */
public interface INetworkMapDataService {
    public void storeKeywordCrawlResults(HashMap results);
    public KeywordCrawlResult[] getKeywordCrawlResults();
    public KeywordCategory[] getAllKeywordCategories();
    public void storeNewKeywordCategory(String category, String keywords);
    public String getKeywordForCategory(String categoryId);
    public void deleteCategories(String[] categoryIds);
    public void updateKeywordCategory(String category, String status);
    public void updateKeywordCategoryId(String id, String status);
    public List getKeywordCategoryInRunningState();
}
