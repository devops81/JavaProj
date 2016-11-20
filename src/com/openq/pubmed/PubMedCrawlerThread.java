package com.openq.pubmed;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;

import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.expertdna.ig.pubmed.Article;
import com.openq.expertdna.ig.pubmed.PubMedQuery;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.StringUtil;

/**
 * This is the thread that is used to crawl pubmed and store the results in db.
 */
public class PubMedCrawlerThread extends Thread {
	private static final SimpleDateFormat yyyyMMDDFormatter = new SimpleDateFormat("yyyy/MM/dd");

	private static Logger logger = Logger.getLogger(PubMedCrawlerThread.class);

	private IPubMedCrawlerService pubMedCrawlerService;

	private IDataService dataService;

	private IUserService userService;

	private List jobItems;

	private int startYear = 1997;

	private int startMonth = 0;

	private int startDay = 1;

	private boolean done = false;

	public static int noFailures = 0;

	public PubMedCrawlerThread(String name, List jobItems) {
		super(name);
		this.jobItems = jobItems;

	}

	public void run() {
		PubMedQuery pmq;
		pmq = new PubMedQuery();
		logger.debug("Starting pubmedcrawler thread with jobitem " + jobItems.size());
		GregorianCalendar today = new GregorianCalendar();
		GregorianCalendar startDate = new GregorianCalendar(startYear, startMonth, startDay);
		long timeDifference = today.getTime().getTime() - startDate.getTime().getTime();
		int daysDifference = (int) (timeDifference / (24 * 60 * 60 * 1000));

		int expertIndex = 0;
		for (Iterator jobItemsIter = jobItems.iterator(); jobItemsIter.hasNext();) {
			AsynchPubMedCrawlerJobItem jobItem = (AsynchPubMedCrawlerJobItem) jobItemsIter.next();
			if (jobItem == null) {
				logger.error("JOB Item is null");
				continue;
			}

			logger.debug("Got expert for jobItem "+jobItem.getId());
			// wrap all processing for a particular OL inside a try/catch block
			// so that the thread
			// can continue processing other OLs even in case a query for one of
			// the OL throws an Exception
			try {
				Expert expert = getExpertForJobItem(jobItem);
				logger.debug("Starting the crawling of expert " + expert.getExpertID() + ", jobItem id " + jobItem.getId());
				expertIndex++;
				logger.debug("expert.getFirstInitials() " + expert.getFirstInitials());
				if (!StringUtil.isEmptyString(expert.getFirstInitials())) {
					String expertQuery = createPubMedAuthorQuery(expert);

					// Change the status of the jobitem for this OL
					jobItem.setStatus(AsynchPubMedCrawlerJobItem.STATUS_IN_PROGRESS);
					pubMedCrawlerService.updateAsynchPubMedCrawlerJobItem(jobItem);

					// Find matching publications
					List articles = null;
					articles = pmq.findMatchingArticles(expertQuery, daysDifference);
					logger.debug("Recieved articles " + (articles != null ? articles.size() : 0));
					for (Iterator iterator = articles.iterator(); iterator.hasNext();) {
						Article a = (Article) iterator.next();
						try {
							pubMedCrawlerService.importSelectedPubsForOL(expert.getExpertID(), a);
						} catch (Exception e) {
							logger.error("==========================================================");
							logger.error("Error in saving article with Id : " + a.getPubMedID());
							logger.error(e);
							logger.error("==========================================================");
							throw new RuntimeException(e);
						}
					}

					// Mark the job item as success
					jobItem.setFetchTime(System.currentTimeMillis());
					jobItem.setStatus(AsynchPubMedCrawlerJobItem.STATUS_SUCCESS);
					pubMedCrawlerService.updateAsynchPubMedCrawlerJobItem(jobItem);
				} else {
					logger.debug(this.getName() + ": " + "Skipping due to no FirstName or First Initials. Last Name: "
							+ expert.getLastName());
				}

				logger.info(this.getName() + ": " + "Got " + expert.getPublications().size() + " results for expert : "
						+ expert.getLastName() + " " + expert.getFirstInitials());

			} catch (Exception e) {
				logger.error(this.getName() + ": Exception caught during run for expert " + jobItem.getOlId(), e);

				// Mark the job item as failed
				if (jobItem != null) {
					Writer result = new StringWriter();
					PrintWriter printWriter = new PrintWriter(result);
					e.printStackTrace(printWriter);
					logger.debug("exceptionString " + result.toString());
					jobItem.setStatus(AsynchPubMedCrawlerJobItem.STATUS_FAILED);
					pubMedCrawlerService.updateAsynchPubMedCrawlerJobItem(jobItem);

					synchronized (this) {
						noFailures++;
					}
					if (noFailures >= PubmedCrawlerProperties.getIntProperty(PubmedCrawlerProperties.MAX_THRESHHOLD_FAILURE)) {
						throw new RuntimeException("Failures have reached a threshhold of " + noFailures);
					}
				}
			} catch (OutOfMemoryError err) {
				logger.error("**************************************************************************");
				logger.error("");
				logger.error("Thread '" + this.getName() + "' - ran out of memory at OL : " + jobItem.getOlId());
				logger.error("Thread '" + this.getName() + "' - Still had " + (jobItems.size() - expertIndex)
						+ " items to go...");
				logger.error("");
				logger.error("**************************************************************************");

				String msg = "There was an out of memory error";
				String subject = msg;
				PubmedNotificationService.sendAdminNotification(msg, subject);
				throw err;
			}

		}

		// Mark that this thread has finished it's work
		logger.info("Thread ' " + this.getName() + "' - Crawled for : " + jobItems.size() + " OLs");
		done = true;
	}

	public String createPubMedAuthorQuery(Expert expert) {
		String keyword = "";
		if (!StringUtil.isEmptyString(expert.getExtraKeyword())) {
			keyword = " AND " + expert.getExtraKeyword();
		}
		String edateRangeString = getEdateRangeString(expert);

		return expert.getLastName() + " " + expert.getFirstName() + "[au]" + keyword + edateRangeString;
	}

	private String getEdateRangeString(Expert expert) {
		Date lastFetchDate = expert.getLastFetchTime();
		if (lastFetchDate != null) {
			String startDate = yyyyMMDDFormatter.format(lastFetchDate);
			String endDate = yyyyMMDDFormatter.format(new Date());
			 return " AND (\"" + startDate + "\"[EDat] : \"" + endDate
			 + "\"[EDat])";
		}

		return "";
	}

	public Expert getExpertForJobItem(AsynchPubMedCrawlerJobItem jobItem) {
		logger.debug("In getExpertForJobItem" + jobItem.getId() + " for ol " + jobItem.getOlId());

		User user = userService.getUser(jobItem.getOlId());

		Expert newExpert = new Expert();
		newExpert.setExpertID(user.getKolid());
		
        EntityAttribute[] profileAttributes = dataService.getEntityAttributes(user.getKolid(),
                PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PROFILE_ENTITY_ID));
        if (profileAttributes != null && profileAttributes.length != 0) {

            EntityAttribute profileAttribute = profileAttributes[0];

            EntityAttribute[] profileDetailsEntityAttributes = dataService.getEntityAttributes(profileAttribute
                    .getMyEntity().getId(), PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PROFILE_DETAILS_ENTITY_ID));

            if (profileDetailsEntityAttributes != null && profileDetailsEntityAttributes.length != 0) {
                EntityAttribute profileDetailsAttribute = profileDetailsEntityAttributes[0];

                StringAttribute firstNameAttrib = dataService.getAttribute(profileDetailsAttribute.getMyEntity().getId(),
                        PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PROFILE_DETAILS_FIRST_NAME_ATTRIB_ID));

                StringAttribute lastNameAttrib = dataService.getAttribute(profileDetailsAttribute.getMyEntity().getId(),
                        PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PROFILE_DETAILS_LAST_NAME_ATTRIB_ID));
                
                if (lastNameAttrib != null) {
                	newExpert.setLastName(lastNameAttrib.getValue());
                }
                
                if (firstNameAttrib != null) {
                	newExpert.setFirstName(firstNameAttrib.getValue());
                }
            }
        }

        if (newExpert.getLastName() == null || newExpert.getLastName().equals("")) {
        	newExpert.setLastName(user.getLastName());
        }
        
        if (newExpert.getFirstName() == null || newExpert.getFirstName().equals("")) {
        	newExpert.setFirstName(user.getFirstName());
        }
        
		newExpert.setFirstInitials(newExpert.getFirstName().substring(0, 1));
		
		String ta = pubMedCrawlerService.getTAForOl(user.getKolid());
		newExpert.setTherapeauticArea(ta);
		
		String keyword = pubMedCrawlerService.getKeywordForTA(ta);
		keyword = (keyword == null) ? "" : keyword;
		
		logger.debug("Got TA " + ta + "for ol with id " + user.getKolid() + " and keyword " + keyword);
		
		newExpert.setExtraKeyword(keyword);
		Date lastFetchTime = pubMedCrawlerService.getLastFetchTimeForOl(jobItem.getOlId());
		newExpert.setLastFetchTime(lastFetchTime);
		return newExpert;
	}


	public boolean isDone() {
		return done;
	}

	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}

	public void setPubMedCrawlerService(IPubMedCrawlerService pubMedCrawlerService) {
		this.pubMedCrawlerService = pubMedCrawlerService;
	}

	public IPubMedCrawlerService getPubMedCrawlerService() {
		return pubMedCrawlerService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	public IUserService getUserService() {
		return userService;
	}
}
