package com.openq.pubmed;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.openq.expertdna.ig.pubmed.Article;

/**
 * This class provides services for crawling for and importing pubmed crawler services
 * 
 */
public interface IPubMedCrawlerService {

    public Date getLastFetchTimeForOl(long olId);

    public void saveAsynchPubMedCrawlerJob(AsynchPubMedCrawlerJob j);

    public AsynchPubMedCrawlerJob[] getPendingScheduledJobs();

    public void updateAsynchPubMedCrawlerJob(AsynchPubMedCrawlerJob j);

    public void saveAsynchPubMedCrawlerJobItem(AsynchPubMedCrawlerJobItem item);

    public void updateAsynchPubMedCrawlerJobItem(AsynchPubMedCrawlerJobItem item);
   
	public Map getLatestCrawlerJobItemMap();

	public Map getPendingCrawlerJobItemMap();

	public AsynchPubMedCrawlerJobItem[] getJobItemsForJob(long id);

	public void importSelectedPubsForOL(long olId, Article pub);
	
	public String getTAForOl(long olId);
	
	public String getKeywordForTA(String ta);
	
	public boolean isPubmedThreadEnabled();

	public List getSuccessfulJobItems(long jobId);

	public List getFailedJobItems(long jobId);
}
