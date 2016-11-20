package com.openq.utils;

import java.util.Date;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.apache.log4j.Logger;

public class EventNotificationMailSender {
	
	private static Logger logger = Logger
	.getLogger(EventNotificationMailSender.class);

	private String smtpServer;
	private String username;
	private String password;
    public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getTo() {
        return to;
    }

    public void setTo(String to) {
        this.to = to;
    }

    private String to;
    private String from;

    public String getFrom() {
		return from;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    private String subject;
	private static EventNotificationMailSender mailSender;
	
	public EventNotificationMailSender() {
		init();
	}

	private void init() {
		smtpServer = PropertyReader.getServerConstantValueFor(
				"SmtpServer");
		to = PropertyReader.getServerConstantValueFor("MailTo");
		from = PropertyReader.getServerConstantValueFor(
				"MailFrom");
		subject = PropertyReader.getServerConstantValueFor(
				"MailSubject");
		username = PropertyReader.getServerConstantValueFor(
		"UserName");
		password = PropertyReader.getServerConstantValueFor(
		"Password");
	}

	private void initTest() {
		smtpServer = "localhost";
		to = "aanand@openq.com";
		from = "event-notification@openq.com";
		subject = "openQ Mail Notification System";
	}

	public synchronized static EventNotificationMailSender getInstance() { 
		if (mailSender == null) {
			mailSender = new EventNotificationMailSender();
		}
		return mailSender;
	}	

	public void send(String htmlString) {
		try {
			Properties props = new Properties();
			props.put("mail.smtp.host", smtpServer);

			Session session = Session.getInstance(props, null);
			// -- Create a new message --
			Message msg = new MimeMessage(session);
			// -- Set the FROM and TO fields --
			msg.setFrom(new InternetAddress(from));
			msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(
					to, false));
			msg.setSubject(subject);

			msg.setContent(htmlString, "text/html");
			// msg.setHeader("X-Mailer", "KulizaEmail");
			msg.setSentDate(new Date());
			Transport transport = session.getTransport("smtp");
			transport.send(msg);

			System.out.println("Message sent OK.");
            init();
        } catch (Exception ex) {
			logger.error(ex.getMessage());
			// if email sending fails and username and password in
			// EmailConfiguration.properties file are not null, then
			// try sending the email using authentication
			if(username!=null && password!=null && !("").equals(username) && !("").equals(password))
				sendAuthenticatedEmail(htmlString);
		}
		}
	 
		private void sendAuthenticatedEmail(String htmlString) {
			try {
				Properties props = System.getProperties();
				props.put("mail.smtp.starttls.enable", "true");
				props.put("mail.smtp.auth", "true");
				props.put("mail.smtp.host", smtpServer);
				props.put("mail.smtp.user", username);
				props.put("mail.smtp.password", password);
				Authenticator auth = new UserAuthenticator();
				Session session = Session.getInstance(props, auth);
				Message msg = new MimeMessage(session);
				msg.setFrom(new InternetAddress(from));
				InternetAddress[] address = { new InternetAddress(to) };
				msg.setRecipients(Message.RecipientType.TO, address);
				msg.setSubject(subject);
				msg.setContent(htmlString, "text/html");
				msg.setSentDate(new Date());

				Transport tr = session.getTransport("smtp");
				tr.connect(smtpServer, username, password);
				msg.saveChanges(); // Important
				tr.sendMessage(msg, msg.getAllRecipients());
				tr.close();
				logger.debug("Email sent successfully.");
			} catch (Exception e) {
				logger.error(e.getMessage());
			}
		
	}

		public void send(String htmlString,javax.activation.DataSource aAttachment) {
			try {
				Properties props = new Properties();
				props.put("mail.smtp.host", smtpServer);
				from = PropertyReader.getServerConstantValueFor(
				"ReportSender");
				subject = PropertyReader.getServerConstantValueFor(
						"ReportMailSubject");
				Session session = Session.getInstance(props, null);
				// -- Create a new message --
				Message msg = new MimeMessage(session);
				// -- Set the FROM and TO fields --
				msg.setFrom(new InternetAddress(from));
				msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(
						to, false));
				msg.setSubject(subject);

				msg.setContent(htmlString, "text/html");
				// msg.setHeader("X-Mailer", "KulizaEmail");
				msg.setSentDate(new Date());
				Transport transport = session.getTransport("smtp");
				//body of the mail
				MimeBodyPart htmlbodyPart = new MimeBodyPart();
				htmlbodyPart.setText(htmlString);
				htmlbodyPart.setDisposition(javax.mail.Part.INLINE);
				
				
				//Attach Report to the mail
				MimeBodyPart bodyPart = new MimeBodyPart();
				bodyPart = new MimeBodyPart();
		    	bodyPart.setDataHandler(new DataHandler(aAttachment));
		    	bodyPart.setDisposition(javax.mail.Part.ATTACHMENT);
		    	bodyPart.setFileName(aAttachment.getName());

		    	MimeMultipart mp = new MimeMultipart("related");
		    	mp.addBodyPart(bodyPart);
		    	mp.addBodyPart(htmlbodyPart);
		    	msg.setContent(mp);
		    	try{
				transport.send(msg);
		    	}catch(Exception exception)
		    	{
		    		System.err.println(exception);
		    	}

				System.out.println("Message sent OK.");
                init();
            } catch (Exception ex) {
				ex.printStackTrace();
			}
	}
	/*public static void main(String [] args) {
		EventNotificationEmail email = new EventNotificationEmail();
		EventNotificationMailSender.getInstance().send(email.returnCompleteHTMLString());
	}*/
		private class UserAuthenticator extends Authenticator {
			public PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		}
}
