package com.openq.ig.pubmed.crawler.keyword;

import org.springframework.orm.hibernate.HibernateTemplate;
import org.springframework.core.io.ClassPathResource;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import net.sf.hibernate.SessionFactory;

import java.util.Iterator;

/**
 * Created by IntelliJ IDEA.
 * User: Lenovo
 * Date: Jan 16, 2008
 * Time: 2:36:20 PM
 * To change this template use File | Settings | File Templates.
 */
public class KeywordCrawlerBatchProcessor {

    protected XmlBeanFactory factory;
    protected HibernateTemplate hibernateTemplate;
    private INetworkMapDataService iNetworkMapDataService;

    public void run()
    {

        ClassPathResource res = new ClassPathResource("crawler.xml");
        factory = new XmlBeanFactory(res);
        hibernateTemplate = new HibernateTemplate((SessionFactory) factory.getBean("sessionFactory"));
        iNetworkMapDataService = (INetworkMapDataService) factory.getBean("networkMapDataService");
        while(true)
        {

            try
            {
                Thread.sleep(1000);
            }
            catch (Exception e ) {}

            Iterator it = iNetworkMapDataService.getKeywordCategoryInRunningState().iterator();
            while(it.hasNext())
            {
                KeywordCategory keywordCategory = (KeywordCategory)it.next();
                try {
                    KeywordCrawlQuery keywordCrawlQuery = new KeywordCrawlQuery(iNetworkMapDataService, "C:\\AZ\\output\\AZ");
                    keywordCrawlQuery.findMatchingArticles(keywordCategory.getKeywords(), 0);
		  iNetworkMapDataService.updateKeywordCategoryId(keywordCategory.getId() + "", KeywordCategory.STATUS_DORMANT);
		    keywordCrawlQuery.finalize(); 	
                    
                }
                catch(Exception e)
                {
                      System.out.println(" Error: " + e);
		      	
                }
                System.out.println(" Finished Running the crawler \n\n ");
            }
            System.out.println(" No Job to process \n\n ");

        }

    }


    public static void main(String args[])
    {
        KeywordCrawlerBatchProcessor keywordCrawlerBatchProcessor = new KeywordCrawlerBatchProcessor();
        keywordCrawlerBatchProcessor.run();
    }

}
