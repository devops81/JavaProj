package com.openq.pubmed;

import java.io.IOException;
import java.util.Properties;

import org.apache.log4j.Logger;

import com.openq.kol.DBUtil;

public class PubmedCrawlerProperties {

	private static Logger logger = Logger.getLogger(PubmedCrawlerProperties.class);

	private static final String PUBMED_CRAWLER_PROPERTIES = "resources/PubmedCrawlerConfig.properties";

	public static final String PUBMED_NOTIFICATION_RECEIVER_ADDRESS = "PubmedNotificationReceiverAddress";
	
	public static final String PUBMED_NOTIFICATION_SENDER_ADDRESS = "PubmedNotificationSenderAddress";

	public static final String TOP_PUBLICATION_ENTITY_ID = "TOP_PUBLICATION_ENTITY_ID";

	public static final String PUBLICATION_ENTITY_TYPE_ID = "PUBLICATION_ENTITY_TYPE_ID";

	public static final String EAV_PUB_AUTHOR_ATTRIB_ID = "EAV_PUB_AUTHOR_ATTRIB_ID";

	public static final String EAV_PUB_TITLE_ATTRIB_ID = "EAV_PUB_TITLE_ATTRIB_ID";

	public static final String EAV_PUB_JOURNAL_REF_ATTRIB_ID = "EAV_PUB_JOURNAL_REF_ATTRIB_ID";

	public static final String EAV_PUB_MED_LINE_ID_ATTRIB_ID = "EAV_PUB_MED_LINE_ID_ATTRIB_ID";

	public static final String EAV_PUB_DATE_ATTRIB_ID = "EAV_PUB_DATE_ATTRIB_ID";

	public static final String EAV_PUB_ARTICLE_TYPE_ATTRIB_ID = "EAV_PUB_ARTICLE_TYPE_ATTRIB_ID";

	public static final String EAV_PUB_JOURNAL_ATTRIB_ID = "EAV_PUB_JOURNAL_ATTRIB_ID";

	public static final String EAV_PUB_AUTHOR_POSITION_ATTRIB_ID = "EAV_PUB_AUTHOR_POSITION_ATTRIB_ID";

	public static final String EAV_PUB_FIRST_AUTHOR_ATTRIB_ID = "EAV_PUB_FIRST_AUTHOR_ATTRIB_ID";

	public static final String EAV_PUB_PUBMED_ID_ATTRIB_ID = "EAV_PUB_PUBMED_ID_ATTRIB_ID";

	public static final String PUBLICATION_ENTITY_ID = "PUBLICATION_ENTITY_ID";

	public static final String EAV_PROFILE_ENTITY_ID = "EAV_PROFILE_ENTITY_ID";

	public static final String EAV_PROFILE_DETAILS_ENTITY_ID = "EAV_PROFILE_DETAILS_ENTITY_ID";

	public static final String EAV_PROFILE_DETAILS_FIRST_NAME_ATTRIB_ID = "EAV_PROFILE_DETAILS_FIRST_NAME_ATTRIB_ID";

	public static final String EAV_PROFILE_DETAILS_LAST_NAME_ATTRIB_ID = "EAV_PROFILE_DETAILS_LAST_NAME_ATTRIB_ID";
	
	public static final String EAV_PUB_CRAWL_FLAG_ATTRIB_ID = "EAV_PUB_CRAWL_FLAG_ATTRIB_ID";

	public static final String THREAD_POOL_SIZE = "ThreadPoolSize";
	
	public static final String MAX_THRESHHOLD_FAILURE = "MaxThreshholdFailure";

	public static final String PUBLICATION_ATTRIB_ID = "PUBLICATION_ATTRIB_ID";


	private static Properties props;

	static {
		try {
			props = DBUtil.getInstance().getDataFromPropertiesFile(PUBMED_CRAWLER_PROPERTIES);
		} catch (IOException e1) {
			logger.info("Could not load properties file " + PUBMED_CRAWLER_PROPERTIES);
		}
	}

	public static String getProperty(String property) {
		return props.getProperty(property);
	}

	public static long getLongProperty(String property) {
		String propertyValue = props.getProperty(property);
		return Long.parseLong(propertyValue);
	}

	public static int getIntProperty(String property) {
		String propertyValue = props.getProperty(property);
		return Integer.parseInt(propertyValue);
	}
}
