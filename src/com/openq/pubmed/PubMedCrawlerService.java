package com.openq.pubmed;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.eav.audit.AuditInfo;
import com.openq.eav.audit.IAuditService;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.EntityType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.expertdna.ig.pubmed.Article;
import com.openq.expertdna.ig.pubmed.Author;
import com.openq.utils.IHibernateUtilService;

/**
 * This class provides services for crawling for and importing new publications for OLs
 * 
 */
public class PubMedCrawlerService extends HibernateDaoSupport implements IPubMedCrawlerService {

    private static Logger logger = Logger.getLogger(PubMedCrawlerService.class);

    private IDataService dataService;

    private IMetadataService metadataService;

    private IAuditService auditService;

    private IHibernateUtilService hibernateUtilService;
    
    public IDataService getDataService() {
        return dataService;
    }

    public void setDataService(IDataService dataService) {
        this.dataService = dataService;
    }

    public IMetadataService getMetadataService() {
        return metadataService;
    }

    public void setMetadataService(IMetadataService metadataService) {
        this.metadataService = metadataService;
    }

    public IAuditService getAuditService() {
        return auditService;
    }

    public void setAuditService(IAuditService auditService) {
        this.auditService = auditService;
    }

    public void setHibernateUtilService(IHibernateUtilService hibernateUtilService) {
        this.hibernateUtilService = hibernateUtilService;
    }

    public IHibernateUtilService getHibernateUtilService() {
        return hibernateUtilService;
    }

    public void saveAsynchPubMedCrawlerJob(AsynchPubMedCrawlerJob j) {
        getHibernateTemplate().save(j);
    }

    public AsynchPubMedCrawlerJob[] getPendingScheduledJobs() {
        List result = getHibernateTemplate().find(
                "from AsynchPubMedCrawlerJob where status = '" + AsynchPubMedCrawlerJob.STATUS_TO_BE_SCHEDULED + "'");
        return (AsynchPubMedCrawlerJob[]) result.toArray(new AsynchPubMedCrawlerJob[result.size()]);
    }

    public AsynchPubMedCrawlerJob getAsynchPubMedCrawlerJob(long jobId) {
        List result = getHibernateTemplate().find("from AsynchPubMedCrawlerJob where id = " + jobId);

        if (result == null || result.size() == 0) {
            return null;
        }
        return (AsynchPubMedCrawlerJob) result.get(0);
    }

    public AsynchPubMedCrawlerJob[] getAllCrawlerJobs() throws Exception {
        List result = getHibernateTemplate().find("from AsynchPubMedCrawlerJob");
        AsynchPubMedCrawlerJob[] allJobs = (AsynchPubMedCrawlerJob[]) result.toArray(new AsynchPubMedCrawlerJob[result.size()]);

        // now get a count of job items for each job
        for (int i = 0; i < allJobs.length; i++) {
            try {
                Integer count = (Integer) this.getSession().createQuery(
                        "select count(*) from AsynchPubMedCrawlerJobItem where jobId = " + allJobs[i].getId()).uniqueResult();
                allJobs[i].setCrawledOLCount(count.intValue());
            }
            catch (Exception e) {
                logger.error("Error while retrieving details of crawler job with id : " + allJobs[i].getId(), e);
                throw e;
            }
        }

        return allJobs;
    }

    public void updateAsynchPubMedCrawlerJob(AsynchPubMedCrawlerJob j) {
        getHibernateTemplate().update(j);
    }

    public void saveAsynchPubMedCrawlerJobItem(AsynchPubMedCrawlerJobItem item) {
        getHibernateTemplate().save(item);
    }

    public void updateAsynchPubMedCrawlerJobItem(AsynchPubMedCrawlerJobItem item) {
        getHibernateTemplate().update(item);
    }

    public Map getLatestCrawlerJobItemMap() {
        Map crawlerJobItemMap = new HashMap();

        try {
            List result = getHibernateTemplate().find(
                    "from AsynchPubMedCrawlerJobItem groupBy ol_id having max fetchTime where status = '"
                            + AsynchPubMedCrawlerJobItem.STATUS_SUCCESS + "'");
            AsynchPubMedCrawlerJobItem[] allJobItems = (AsynchPubMedCrawlerJobItem[]) result
                    .toArray(new AsynchPubMedCrawlerJobItem[result.size()]);
            // now get a count of job items for each job
            for (int i = 0; i < allJobItems.length; i++) {
                AsynchPubMedCrawlerJobItem jobItem = allJobItems[i];
                crawlerJobItemMap.put(new Long(jobItem.getOlId()), jobItem);
            }
        }
        catch (Exception e) {
            logger.error("Error while retrieving details for crawler jobs ", e);
        }

        return crawlerJobItemMap;
    }

    /**
     * This gets all the pending jobitems that are still in progress. Sees if the job it is assigned to is also in to be scheduled
     * state, if yes then adds to the map corresponding the ol id. This ensures no duplicate job items for same ol.
     */
    public Map getPendingCrawlerJobItemMap() {
        List result = getHibernateTemplate().find(
                "from AsynchPubMedCrawlerJobItem where status = '" + AsynchPubMedCrawlerJobItem.STATUS_IN_PROGRESS + "'");
        AsynchPubMedCrawlerJobItem[] allJobItems = (AsynchPubMedCrawlerJobItem[]) result
                .toArray(new AsynchPubMedCrawlerJobItem[result.size()]);
        Map crawlerJobItemMap = new HashMap();
        // now get a count of job items for each job
        for (int i = 0; i < allJobItems.length; i++) {
            AsynchPubMedCrawlerJobItem jobItem = allJobItems[i];
            AsynchPubMedCrawlerJob asynchPubMedCrawlerJob = getAsynchPubMedCrawlerJob(jobItem.getJobId());
            if (asynchPubMedCrawlerJob != null
                    && asynchPubMedCrawlerJob.getStatus().equals(AsynchPubMedCrawlerJob.STATUS_TO_BE_SCHEDULED)) {
                crawlerJobItemMap.put(new Long(jobItem.getOlId()), jobItem);
            }
        }
        return crawlerJobItemMap;
    }

    public AsynchPubMedCrawlerJobItem[] getJobItemsForJob(long id) {
        logger.debug("Start getJobItemsForJob " + id);
        List result = getHibernateTemplate().find("from AsynchPubMedCrawlerJobItem where jobId = " + id);
        logger.debug("End found " + result.size());
        return (AsynchPubMedCrawlerJobItem[]) result.toArray(new AsynchPubMedCrawlerJobItem[result.size()]);
    }

    public Date getLastFetchTimeForOl(long olId) {
        List result = getHibernateTemplate().find(
                "select max(a1.fetchTime) from AsynchPubMedCrawlerJobItem a1 where a1.olId=" + olId + " and status = '"
                        + AsynchPubMedCrawlerJobItem.STATUS_SUCCESS + "'");

        long fetchDate = 0;
        if (result != null && result.size() > 0 && result.get(0) != null) {
            fetchDate = ((Long) result.get(0)).longValue();
            return new Date(fetchDate);
        }

        return null;
    }

    public void importSelectedPubsForOL(long olId, Article pub) {

        // First get access to the top-most publication attribute
        EntityAttribute[] attribs = dataService.getEntityAttributes(olId, PubmedCrawlerProperties
                .getLongProperty(PubmedCrawlerProperties.TOP_PUBLICATION_ENTITY_ID));
        EntityAttribute topPubAttrib = null;

        if (attribs == null || attribs.length == 0) {
            Entity entity = new Entity();
            EntityType entityType = metadataService.getEntityType(PubmedCrawlerProperties
                    .getLongProperty(PubmedCrawlerProperties.PUBLICATION_ENTITY_TYPE_ID));
            entity.setType(entityType);
            entity.setDeleteFlag("N");
            dataService.saveEntity(entity);
            topPubAttrib = new EntityAttribute();

            topPubAttrib.setParent(dataService.getEntity(olId));
            AttributeType at = metadataService.getAttributeType(PubmedCrawlerProperties
                    .getLongProperty(PubmedCrawlerProperties.TOP_PUBLICATION_ENTITY_ID));
            topPubAttrib.setAttribute(at);
            dataService.saveEntityAttribute(topPubAttrib, at);
            logger.debug("Saved Top level publication " + topPubAttrib.getMyEntity().getId());
        }
        else {
            topPubAttrib = attribs[0];
        }

        EntityAttribute[] allPubEntityAttributes = dataService.getEntityAttributes(topPubAttrib.getMyEntity().getId(),
                PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.PUBLICATION_ENTITY_ID));
        EntityAttribute newPubAttrib = null;
        
        if (allPubEntityAttributes != null && allPubEntityAttributes.length != 0) {
            for (int i = 0; i < allPubEntityAttributes.length; i++) {
                StringAttribute entityAttribute = dataService.getAttribute(allPubEntityAttributes[i].getMyEntity().getId(),
                        PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_PUBMED_ID_ATTRIB_ID));
                if (entityAttribute != null && entityAttribute.getValue() != null
                        && entityAttribute.getValue().equals(pub.getPubMedID())) {
                    logger.debug("Got a publication for given pubmed id " + pub.getPubMedID());
                    newPubAttrib = allPubEntityAttributes[i];
                    break;
                }
            }
        }
        long rowId = hibernateUtilService.getUniqueRowId();
        
        if (newPubAttrib == null) {
            // Pubmed id not found so create new records
            newPubAttrib = new EntityAttribute();
            newPubAttrib.setParent(topPubAttrib.getMyEntity());
            AttributeType at = metadataService.getAttributeType(PubmedCrawlerProperties
                    .getLongProperty(PubmedCrawlerProperties.PUBLICATION_ENTITY_ID));
            newPubAttrib.setAttribute(at);
            dataService.saveEntityAttribute(newPubAttrib, at);

            logger.debug("Saved new publication : " + pub.getPubMedID() + ", as entity : " + newPubAttrib.getMyEntity().getId());

            saveNonNullAttrib(PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_PUBMED_ID_ATTRIB_ID),
                    olId, newPubAttrib, pub.getPubMedID(), rowId);

        }

        // now set the various basic attributes for this. This updates if already exists.
        saveNonNullAttrib(PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_AUTHOR_ATTRIB_ID), olId, 
                newPubAttrib, pub.createAuthorsText(), rowId);
        saveNonNullAttrib(PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_TITLE_ATTRIB_ID), olId, 
                newPubAttrib, pub.getTitle(), rowId);
        saveNonNullAttrib(PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_JOURNAL_ATTRIB_ID), olId, 
                newPubAttrib, pub.getJournalName(), rowId);
        saveNonNullAttrib(PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_JOURNAL_REF_ATTRIB_ID), olId,
                newPubAttrib, pub.getJournalReference(), rowId);
        saveNonNullAttrib(PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_DATE_ATTRIB_ID), olId, 
                newPubAttrib, pub.getPublicationDate(), rowId);
        saveNonNullAttrib(PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_ARTICLE_TYPE_ATTRIB_ID),
                olId, newPubAttrib, "Journal Article", rowId);
        saveNonNullAttrib(PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_MED_LINE_ID_ATTRIB_ID),
                olId, newPubAttrib, pub.getPubMedID(), rowId);

        String authorPosition = "Other";
        if (pub.isFirstAuthor()) {
            authorPosition = "First";
        }
        if (pub.isLastAuthor()) {
            authorPosition = "Last";
        }

        String firstAuthor = ((Author) pub.getAuthors().get(0)).getFullName();

        saveNonNullAttrib(PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_AUTHOR_POSITION_ATTRIB_ID),
                olId, newPubAttrib, authorPosition, rowId);
        saveNonNullAttrib(PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.EAV_PUB_FIRST_AUTHOR_ATTRIB_ID),
                olId, newPubAttrib, firstAuthor, rowId);

        // make entry into audit table for this new publication
        AuditInfo info = new AuditInfo();
        info.setEditedEntityId(newPubAttrib.getMyEntity().getId());
        info.setUserName("openQ Crawler");
        auditService.saveAuditInfo(info);

        logger.debug("Imported publication : " + pub.getPubMedID() + " for ol " + olId);

    }

    private void saveNonNullAttrib(long attribId, long olId, EntityAttribute eavEntityAttrib, String attribVal, long rowId) {
        if (attribVal != null) {
            dataService.saveOrUpdateAttribute(attribId, eavEntityAttrib.getMyEntity().getId(), attribVal, 
                    PubmedCrawlerProperties.getLongProperty(PubmedCrawlerProperties.PUBLICATION_ATTRIB_ID),
                    olId, rowId);
        }
    }

    public String getTAForOl(long olId) {
        List result = getHibernateTemplate().find("select e.ta from ExpertTADetails e where e.kolId=" + olId);

        String ta = "";
        if (result != null && result.size() > 0 && result.get(0) != null) {
            ta = (String) result.get(0);
        }
        return ta;
    }

    public String getKeywordForTA(String ta) {
        List result = getHibernateTemplate().find("select t.keyword from TAKeywordMap t where t.ta = '" + ta + "'");

        String keyword = "";
        if (result != null && result.size() > 0 && result.get(0) != null) {
            keyword = (String) result.get(0);
        }

        return keyword;
    }

    public List getFailedJobItems(long jobId) {
        logger.debug("Start getJobItemsForJob " + jobId);
        List result = getHibernateTemplate().find(
                "from AsynchPubMedCrawlerJobItem where jobId = " + jobId + " and status = '"
                        + AsynchPubMedCrawlerJobItem.STATUS_FAILED + "'");
        logger.debug("End found " + result.size());
        return result;
    }

    public List getSuccessfulJobItems(long jobId) {
        logger.debug("Start getJobItemsForJob " + jobId);
        List result = getHibernateTemplate().find(
                "from AsynchPubMedCrawlerJobItem where jobId = " + jobId + " and status = '"
                        + AsynchPubMedCrawlerJobItem.STATUS_SUCCESS + "'");
        logger.debug("End found " + result.size());
        return result;
    }

    public boolean isPubmedThreadEnabled() {
        logger.debug("Checking whether Pubmed thread is enabled or not...");

        List result = getHibernateTemplate().find("select c.propValue from PubCrawlerConfig c where c.propKey = 'Pubcrawler.run'");

        boolean runThread = false;
        if (result != null && result.size() > 0 && result.get(0) != null) {
            runThread = (Boolean.valueOf((String) result.get(0))).booleanValue();
        }

        logger.debug("Pubcrawler thread run : " + runThread);

        return runThread;
    }
}
