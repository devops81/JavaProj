package com.openq.web.forms;

/**
 * Encapsulate data corresponding to the form which is used for 
 * running a keyword crawl
 * 
 * @author Amit Arora
 *
 */
public class KeywordCrawlerForm {
    private String category;
    private String keyword;
    private String actionToPerform;
    private String[] categoryIds;

    public String getActionToPerform() {
        return actionToPerform;
    }

    public void setActionToPerform(String action) {
        this.actionToPerform = action;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public String[] getCategoryIds() {
        return categoryIds;
    }

    public void setCategoryIds(String[] categoryIds) {
        this.categoryIds = categoryIds;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}
