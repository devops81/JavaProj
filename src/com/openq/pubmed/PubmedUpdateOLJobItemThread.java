package com.openq.pubmed;

import java.util.Date;
import java.util.Map;
import java.util.TimerTask;

import org.apache.log4j.Logger;

import com.openq.user.IUserService;
import com.openq.user.User;

/**
 * This is the background thread that to mark the Ols to be flagged for update (Based on last profiled time/other metrics)
 * 
 */
public class PubmedUpdateOLJobItemThread extends TimerTask {
	private static final long threshHoldTime = 24*3600*1000*30; // 1 month
	private static Logger logger = Logger.getLogger(PubmedUpdateOLJobItemThread.class);
	public static long applicationInitialized = 0L;

	private IUserService userService;
	private IPubMedCrawlerService pubmedCrawlerService;

	/*
	 * Get the list of all OLs
	 * Get the corresponding list of job items for all OLs
	 * Iterate over the OLs 
	 * for each OL see if the pending job item is there
	 * if no then  then make a new entry in the job item
	 * else
	 * check of the job item has been completed long ago
	 * if yes then make a new entry in the job item/update that
	 * if no then skip
	 */
	public void run() {
		User[] allExperts = userService.getAllExperts();
		
		Map allCrawlerJobItemsMap = pubmedCrawlerService.getLatestCrawlerJobItemMap();
		Map pendingCrawlerJobItemsMap = pubmedCrawlerService.getPendingCrawlerJobItemMap();
		
		AsynchPubMedCrawlerJob crawlerJob = null;
		
		for (int i = 0; i < allExperts.length; i++) {
			User expert = allExperts[i];
			AsynchPubMedCrawlerJobItem crawlerJobItem = (AsynchPubMedCrawlerJobItem) allCrawlerJobItemsMap.get(new Long(expert.getId()));
			AsynchPubMedCrawlerJobItem pendingCrawlerJobItem = (AsynchPubMedCrawlerJobItem) pendingCrawlerJobItemsMap.get(new Long(expert.getId()));
			if (pendingCrawlerJobItem != null) {
				continue;
			}
			if (crawlerJob == null) {
				crawlerJob = new AsynchPubMedCrawlerJob();
				long scheduledTime = System.currentTimeMillis();
				crawlerJob.setScheduledTime(scheduledTime);
				crawlerJob.setStatus(AsynchPubMedCrawlerJob.STATUS_TO_BE_SCHEDULED);
				pubmedCrawlerService.saveAsynchPubMedCrawlerJob(crawlerJob);
			}
			
			if (crawlerJobItem != null){
				Date lastThreshHoldDate = new Date(System.currentTimeMillis() - threshHoldTime);
				if (!crawlerJobItem.getFetchDate().before(lastThreshHoldDate)) {
					continue;
				}
			}
			crawlerJobItem = new AsynchPubMedCrawlerJobItem();
			crawlerJobItem.setStatus(AsynchPubMedCrawlerJobItem.STATUS_IN_PROGRESS);
			crawlerJobItem.setJobId(crawlerJob.getId());
			crawlerJobItem.setOlId(expert.getId());
			crawlerJobItem.setFetchTime(0l);
			logger.debug("Creating job item for expertId " + expert.getId() + " , jobId " + crawlerJob.getId());
			// add values
			pubmedCrawlerService.updateAsynchPubMedCrawlerJobItem(crawlerJobItem);
		}
	
	}


	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	public IPubMedCrawlerService getPubmedCrawlerService() {
		return pubmedCrawlerService;
	}

	public void setPubmedCrawlerService(IPubMedCrawlerService pubmedCrawlerService) {
		this.pubmedCrawlerService = pubmedCrawlerService;
	}
}
