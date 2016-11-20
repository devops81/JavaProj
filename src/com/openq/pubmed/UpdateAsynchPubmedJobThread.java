package com.openq.pubmed;

import java.util.Map;
import java.util.TimerTask;

import org.apache.log4j.Logger;

import com.openq.eav.data.BooleanAttribute;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.user.IUserService;
import com.openq.user.User;

/**
 * This is the background thread that to mark the Ols to be flagged for update
 * (Based on flag that is stored in the EAV table)
 * 
 */
public class UpdateAsynchPubmedJobThread extends TimerTask {
	private static final long THRESHHOLD_GAP = 600000;
	private static Logger logger = Logger.getLogger(UpdateAsynchPubmedJobThread.class);
	public static long applicationInitialized = 0L;

	private IUserService userService;
	private IPubMedCrawlerService pubMedCrawlerService;
	private IDataService dataService;

	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}

	public void run() {
	    if(pubMedCrawlerService.isPubmedThreadEnabled()) {
    		logger.debug("===============================================");		
    		logger.debug("Starting the thread UpdateAsynchPubmedJobThread");
    		logger.debug("===============================================");		
    		
    		BooleanAttribute[] pubCrawlFlagAttributes = dataService.getBooleanAttribute(PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_CRAWL_FLAG_ATTRIB_ID)); 
    
    		if (pubCrawlFlagAttributes != null && pubCrawlFlagAttributes.length != 0) {
    			AsynchPubMedCrawlerJob crawlerJob = null;
    			Map pendingCrawlerJobItemsMap = pubMedCrawlerService.getPendingCrawlerJobItemMap();
    			
    			for (int i = 0; i < pubCrawlFlagAttributes.length; i++) {
    				if (pubCrawlFlagAttributes[i].getValue().booleanValue()) {
    					if (crawlerJob == null) {
    						crawlerJob=new AsynchPubMedCrawlerJob();
    						long scheduledTime = System.currentTimeMillis() + THRESHHOLD_GAP;
    						crawlerJob.setScheduledTime(scheduledTime);
    						crawlerJob.setStatus(AsynchPubMedCrawlerJob.STATUS_TO_BE_SCHEDULED);
    						pubMedCrawlerService.saveAsynchPubMedCrawlerJob(crawlerJob);
    						logger.debug("Saved asynch job with job id " + crawlerJob.getId());
    					}
    					
    					EntityAttribute profileDetailsAttribute = dataService.getEntityAttributeNew(pubCrawlFlagAttributes[i].getParent().getId());
    					EntityAttribute profileAttribute = dataService.getEntityAttributeNew(profileDetailsAttribute.getParent().getId());
    					User user = userService.getUserForKolId(profileAttribute.getParent().getId());
    					AsynchPubMedCrawlerJobItem pendingCrawlerJobItem = (AsynchPubMedCrawlerJobItem) pendingCrawlerJobItemsMap.get(new Long(user.getId()));
    					if (pendingCrawlerJobItem != null) {
    						continue;
    					}
    					
    					AsynchPubMedCrawlerJobItem crawlerJobItem = new AsynchPubMedCrawlerJobItem();
    					crawlerJobItem.setStatus(AsynchPubMedCrawlerJobItem.STATUS_IN_PROGRESS);
    					crawlerJobItem.setJobId(crawlerJob.getId());
    					crawlerJobItem.setOlId(user.getId());
    					crawlerJobItem.setFetchTime(0l);
    					
    					pubCrawlFlagAttributes[i].setValue(Boolean.FALSE);
    					dataService.saveOrUpdateAttribute(PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_CRAWL_FLAG_ATTRIB_ID),
    							pubCrawlFlagAttributes[i].getParent().getId(), Boolean.FALSE);
    					logger.debug("Creating job item for expertId " + user.getId() + " , jobId " + crawlerJob.getId());
    					// add values
    					pubMedCrawlerService.saveAsynchPubMedCrawlerJobItem(crawlerJobItem);
    				}
    			}
    		}
    		
    		logger.debug("===============================================");		
    		logger.debug("Finished the thread UpdateAsynchPubmedJobThread");
    		logger.debug("===============================================");		
	    }
	}

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}
	
	public IPubMedCrawlerService getPubMedCrawlerService() {
		return pubMedCrawlerService;
	}

	public void setPubMedCrawlerService(IPubMedCrawlerService pubMedCrawlerService) {
		this.pubMedCrawlerService = pubMedCrawlerService;
	}


}
