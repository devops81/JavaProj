package com.openq.pubmed;

import org.apache.log4j.Logger;

import com.openq.utils.EventNotificationMailSender;
import com.openq.utils.StringUtil;

public class PubmedNotificationService {

	private static Logger logger = Logger.getLogger(PubmedNotificationService.class);

	public static void sendAdminNotification(String msg, String subject) {
		String mailFrom = PubmedCrawlerProperties.getProperty(PubmedCrawlerProperties.PUBMED_NOTIFICATION_SENDER_ADDRESS);
		String mailTo = PubmedCrawlerProperties.getProperty(PubmedCrawlerProperties.PUBMED_NOTIFICATION_RECEIVER_ADDRESS);

		sendNotification(msg, subject, mailFrom, mailTo);
	}

	public static void sendNotification(String msg, String subject, String mailFrom, String mailTo) {
		logger.debug("**********************************************************");
		logger.debug("Sending notification: " + msg + "\n"
				+ "to " + mailTo + "\n"
				+ "from  " + mailFrom + "\n"
				+ "with subject: " + subject);
		logger.debug("**********************************************************");
		
		if (StringUtil.isEmptyString(mailFrom) || StringUtil.isEmptyString(mailTo) 
				|| StringUtil.isEmptyString(msg) || StringUtil.isEmptyString(subject)) {
			logger.error("One of the arguments is null or empty");
			throw new IllegalArgumentException("One of the arguments is empty or null while sending mail");
		}
			
		EventNotificationMailSender notificationMailSender = new EventNotificationMailSender();
		notificationMailSender.setFrom(mailFrom);
		notificationMailSender.setSubject(subject);
		notificationMailSender.setTo(mailTo);
		notificationMailSender.send(msg);
	}
}
