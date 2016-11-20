package com.openq.pubmed;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.TimerTask;

import org.apache.log4j.Logger;

import com.openq.eav.data.IDataService;
import com.openq.user.IUserService;
import com.openq.utils.EventNotificationMailSender;
import com.openq.utils.StringUtil;

/**
 * This is the background Pubmed thread which keeps checking if any crawler run
 * needs to be kicked-off
 * 
 */
public class PubMedBackgroundSchedulerThread extends TimerTask {
	private static Logger logger = Logger.getLogger(PubMedBackgroundSchedulerThread.class);
	public static long applicationInitialized = 0L;

	private IUserService userService;
	private IDataService dataService;
	private IPubMedCrawlerService pubMedCrawlerService;

	public void run() {
	    if(pubMedCrawlerService.isPubmedThreadEnabled()) {
    		logger.debug("===================================================");
    		logger.debug("PubMedCrawlerBackgroundThread started a crawler run");
    		logger.debug("===================================================");
    
    		// check if any PubMedCrawler job needs to be kicked off
    		List jobsToSchedule = checkPubMedJobsToSchedule();
    
    		if (jobsToSchedule == null || jobsToSchedule.size() == 0) {
    			logger.info("No crawler jobs found");
    		}
    
    		for (Iterator iterator = jobsToSchedule.iterator(); iterator.hasNext();) {
    			AsynchPubMedCrawlerJob job = (AsynchPubMedCrawlerJob) iterator.next();
    
    			try {
    				job.setStatus(AsynchPubMedCrawlerJob.STATUS_RUNNING);
    				pubMedCrawlerService.updateAsynchPubMedCrawlerJob(job);
    				run(job);
    			} catch (Exception e) {
    				String msg = "Could not run job with job id " + job.getId() + "\n";
    				logger.error(msg + e.getMessage());
    				String subject = msg;
    				msg = msg + getStatisticStringForJob(job.getId());
    				PubmedNotificationService.sendAdminNotification(msg, subject);
    				e.printStackTrace();
    				continue;
    			}
    
    		}
    
    		logger.debug("Checked if any Pubmed Job was to be submitted");
	    }
	}

	private List checkPubMedJobsToSchedule() {
		AsynchPubMedCrawlerJob[] pendingJobs = pubMedCrawlerService.getPendingScheduledJobs();
		long currentTime = System.currentTimeMillis();
		List pendingJobsToSchedule = new ArrayList();
		for (int i = 0; i < pendingJobs.length; i++) {
			logger.debug("Pubmed Crawler job with id : " + pendingJobs[i].getId() + " was supposed to be scheduled "
					+ ((currentTime - pendingJobs[i].getScheduledTime()) / 1000) + " seconds ago");
			if (currentTime >= pendingJobs[i].getScheduledTime()) {
				pendingJobsToSchedule.add(pendingJobs[i]);
			}
		}

		return pendingJobsToSchedule;
	}

	private void run(AsynchPubMedCrawlerJob job) throws InterruptedException {
		logger.info("Running job with id " + job.getId());

		AsynchPubMedCrawlerJobItem[] jobItemsForJob = pubMedCrawlerService.getJobItemsForJob(job.getId());
		logger.debug("Got job items" + jobItemsForJob);

		// Update the job details to record total # of OLs to be crawled as a
		// part of this job
		job.setTotalOLCount(jobItemsForJob.length);
		pubMedCrawlerService.updateAsynchPubMedCrawlerJob(job);
		logger.info("Updated job " + jobItemsForJob);

		if (jobItemsForJob == null || jobItemsForJob.length == 0) {
			logger.info("No experts found to crawl for job id " + job.getId());
			job.setStatus(AsynchPubMedCrawlerJob.STATUS_DONE);
			pubMedCrawlerService.updateAsynchPubMedCrawlerJob(job);
			return;
		}
		// Now segregate all experts into multiple batches
		List expertBatches = createJobBatches(jobItemsForJob, PubmedCrawlerProperties.getIntProperty(PubmedCrawlerProperties.THREAD_POOL_SIZE));

		logger.info("Created jobs with size" + expertBatches.size());

		// First run a thread with just one expert to see if that works around
		// Axis thread-safe issue
		List initialList = new ArrayList();
		initialList.add(jobItemsForJob[0]);
		logger.info("Creating initial list " + jobItemsForJob[0].getJobId());
		PubMedCrawlerThread t = new PubMedCrawlerThread("PubMedCrawlerThread-InitialRunner", initialList);
		t.setPubMedCrawlerService(pubMedCrawlerService);
		t.setDataService(dataService);
		t.setUserService(userService);
		logger.info("-------------------------------------------------------------");
		logger.info("PubMed Crawler starting at : " + new Date());
		logger.info("-------------------------------------------------------------");
		t.start();
		t.join();

		// Create the required number of PubMedCrawlerThreads and hand them one
		// batch of experts each
		PubMedCrawlerThread[] crawlerThreads = new PubMedCrawlerThread[expertBatches.size()];
		for (int i = 0; i < expertBatches.size(); i++) {
			crawlerThreads[i] = new PubMedCrawlerThread("PubMedCrawlerThread-" + i, (List) expertBatches.get(i));
			logger.debug("PubMedCrawlerThread-" + i + " will crawl for : " + ((List) expertBatches.get(i)).size() + " OLs");
			crawlerThreads[i].setPubMedCrawlerService(pubMedCrawlerService);
			crawlerThreads[i].setDataService(dataService);
			crawlerThreads[i].setUserService(userService);
			crawlerThreads[i].start();
		}

		// Let's wait till all threads complete their work
		String msg = "Successfully completed pubmed crawler job with job id " + job.getId() + "\n";
		String subject = msg;
		for (int i = 0; i < expertBatches.size(); i++) {
			try {
				crawlerThreads[i].join();
			} catch (InterruptedException e) {
				logger.info("Caught exception " + e.getMessage());
				msg = "There was an exception while executing some job items. Exception in thread \n";
				subject = "Error while running crawler thread";
			}
		}

		msg += getStatisticStringForJob(job.getId());
		if (!StringUtil.isEmptyString(msg)) {
			PubmedNotificationService.sendAdminNotification(msg, subject);
		}
		job.setStatus(AsynchPubMedCrawlerJob.STATUS_DONE);
		pubMedCrawlerService.updateAsynchPubMedCrawlerJob(job);
		
		logger.info("All PubMedCrawlerThreads have finished processing");
		logger.info("Crawler finished at : " + new Date());
	}

	private String getStatisticStringForJob(long jobId) {
		List successfulJobItems = pubMedCrawlerService.getSuccessfulJobItems(jobId);
		String msg = "No of successfully crawled ols " + successfulJobItems.size() + "\n";
		List failedJobItems = pubMedCrawlerService.getFailedJobItems(jobId);
		for (Iterator iterator = failedJobItems.iterator(); iterator.hasNext();) {
			AsynchPubMedCrawlerJobItem jobItem = (AsynchPubMedCrawlerJobItem) iterator.next();
			msg += "Failed job for ol " + jobItem.getOlId() + "\n";
		}
		return msg;
	}

	/**
	 * This routine is used to take the entire list of experts and segregate it
	 * into the specified number of batches
	 * 
	 * @param pubMedCrawlerJobItems
	 * @param numBatches
	 * @return
	 */
	private List createJobBatches(AsynchPubMedCrawlerJobItem[] pubMedCrawlerJobItems, int numBatches) {
		logger.debug("START - createJobBatches " + pubMedCrawlerJobItems.length + " , " + numBatches);
		// Find out what the approx size of each batch should be
		int batchSize = (int) Math.ceil(((double) pubMedCrawlerJobItems.length / (double) numBatches));

		List batches = new ArrayList();
		int index = 0;
		List jobBatch = null;

		while (index < pubMedCrawlerJobItems.length) {
			if ((index % batchSize) == 0) {
				// time to start a new batch
				jobBatch = new ArrayList();
				batches.add(jobBatch);
			}

			// add the current expert to this batch
			jobBatch.add(pubMedCrawlerJobItems[index]);

			// move the index to the next expert
			index++;
		}

		logger.debug("END - createJobBatches " + batches.size());
		return batches;
	}

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}

	public IPubMedCrawlerService getPubMedCrawlerService() {
		return pubMedCrawlerService;
	}

	public void setPubMedCrawlerService(IPubMedCrawlerService pubMedCrawlerService) {
		this.pubMedCrawlerService = pubMedCrawlerService;
	}

	public void sendNotification(String msg, String subject, String mailFrom, String mailTo) {
		if (isNull(mailFrom) || isNull(mailTo) || isNull(msg) || isNull(subject)) {
			return;
		}

		EventNotificationMailSender notificationMailSender = new EventNotificationMailSender();
		notificationMailSender.setFrom(mailFrom);
		notificationMailSender.setSubject(subject);
		notificationMailSender.setTo(mailTo);
		notificationMailSender.send(msg);
	}

	private boolean isNull(String str) {
		return (str == null || str.equals(""));
	}

}
