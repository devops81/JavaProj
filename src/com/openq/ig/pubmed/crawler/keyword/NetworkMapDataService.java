package com.openq.ig.pubmed.crawler.keyword;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Date;

import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;
import net.sf.hibernate.Session;

/**
 * @see #INetworkMapDataService
 *
 * @author Amit
 */
public class NetworkMapDataService extends HibernateDaoSupport implements INetworkMapDataService {

    private static Logger logger = Logger.getLogger(NetworkMapDataService.class);

    public void storeKeywordCrawlResults(HashMap results) {
        // clear off the previous results
        getHibernateTemplate().delete("select r from KeywordCrawlResult r");

        // now iterate over the hash-map to store the new results
        Iterator iter = results.keySet().iterator();

        try
        {
            Session session = getSession();
            net.sf.hibernate.Transaction tx = session.beginTransaction();
            int c = 0;
            while(iter.hasNext()) {
                String authorName = (String) iter.next();
                AuthorDetails authDetails = (AuthorDetails) results.get(authorName);
                KeywordCrawlResult r = new KeywordCrawlResult(authorName, authDetails.getPubCount());
                session.save(r);
                if ( c++ % 20 == 0 )
                {
                    session.flush();
                    session.clear();
                }
            };
            tx.commit();
            session.close();
        }
        catch (Exception e)
        {
            System.out.println(" Exception occured while saving Keyword Results " + e);
        }

    }

    public KeywordCrawlResult[] getKeywordCrawlResults() {
        List result = getHibernateTemplate().find("from KeywordCrawlResult");

        logger.debug("Found " + result.size() + " results from the keyword crawl");

        return (KeywordCrawlResult[]) result.toArray(new KeywordCrawlResult[result.size()]);
    }

    public KeywordCategory[] getAllKeywordCategories() {
        List result = getHibernateTemplate().find("from KeywordCategory");

        logger.debug("Found " + result.size() + " keyword categories");

        return (KeywordCategory[]) result.toArray(new KeywordCategory[result.size()]);
    }

    public void storeNewKeywordCategory(String category, String keywords) {
        KeywordCategory kc = new KeywordCategory(category, keywords);
        getHibernateTemplate().save(kc);
    }

    public String getKeywordForCategory(String categoryId) {
        List result = getHibernateTemplate().find("from KeywordCategory where id = " + categoryId);

        if(result.size() != 0) {
            KeywordCategory k = (KeywordCategory) result.get(0);
            return k.getKeywords();
        }

        return null;
    }

    public void updateKeywordCategory(String category, String status) {
        List result = getHibernateTemplate().find("from KeywordCategory where category = '"+category+"'");

        if(result.size() != 0) {
            KeywordCategory k = (KeywordCategory) result.get(0);
            k.setStatus(status);
            k.setLastRuntime(new Date());
            getHibernateTemplate().save(k);
        }
    }

    public void updateKeywordCategoryId(String id, String status) {
        List result = getHibernateTemplate().find("from KeywordCategory where id = " + id);

        if(result.size() != 0) {
            KeywordCategory k = (KeywordCategory) result.get(0);
            k.setStatus(status);
            k.setLastRuntime(new Date());
            getHibernateTemplate().save(k);
        }
    }

    public List getKeywordCategoryInRunningState()
    {
        return getHibernateTemplate().find("from KeywordCategory where status = '" + KeywordCategory.STATUS_RUNNING+ "'");
    }


    public void deleteCategories(String[] categoryIds) {
        for(int i=0; i<categoryIds.length; i++) {
            List result = getHibernateTemplate().find("from KeywordCategory where id = " + categoryIds[i]);
            if(result.size() > 0) {
                KeywordCategory k = (KeywordCategory) result.get(0);
                getHibernateTemplate().delete(k);
            }
        }
    }
}
