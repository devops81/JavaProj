package com.openq.batchNotification;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.Notify.Notification;
import com.openq.alerts.IAlertsService;
import com.openq.alerts.data.AlertAuditQueue;
import com.openq.attendee.Attendee;
import com.openq.attendee.IAttendeeService;
import com.openq.eav.metadata.AttributeType;
import com.openq.interaction.IInteractionService;
import com.openq.interaction.Interaction;
import com.openq.kol.DBUtil;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.userPreference.IUserPreferenceService;
import com.openq.userPreference.UserPreference;
import com.openq.utils.EventNotificationMailSender;



/**
 * This is a scheduled process which runs everyday once at a particular time specified in openq-servlet.xml
 * @author Dayanand
 *
 */

public class NotificationService extends HibernateDaoSupport implements
INotificationService{
	
	
	private IAttendeeService attendeeService;
	private IInteractionService interactionService;
	private IUserPreferenceService userPreferenceService;
	private IUserService userService;
	private IAlertsService alertsService;
	
	
	
	private static final String ATTRIBUTE_CHANGE_NOTIFICATION = "Attribute Change Notification as Batch";
	private static final String MAIL_FROM_PROFILE = "synergy@bms.com";
	private static final String MAIL_FROM_INTERACTION = "synergy@bms.com";
	private static final String INTERACTION_CHANGE_NOTIFICATION = "Interaction - Change Notification";
	
	private static final long MONTHLY_DATE = 27;
	private static final long DAILY_PREFERENCE = 0;
	private static final long WEEKLY_PREFERENCE = 1;
	private static final long MONTHLY_PREFERENCE = 2;
	
	
	public void getPreferencesMap(Map userPreferenceMap)
	{
		List results = getHibernateTemplate().find("from UserPreference up");
		
		if(results != null)
		{
			for(int i = 0;i<results.size();i++)
			{
				UserPreference userPreference = (UserPreference) results.get(i);
				userPreferenceMap.put(userPreference.getUserId()+"", userPreference);
			}
		
		}
		

	}
	
	public User getUser(long userId) {
        User u = ((User) getHibernateTemplate().load(User.class, new Long(userId)));
       
        return u;
    }
	

	public void processNotifications()
	{
		notifyProfileChanges();
		Map userPreferenceMap = new HashMap();
		getPreferencesMap(userPreferenceMap);
		 notifyInteractionChanges(userPreferenceMap);
		
	}
	
	private void notifyInteractionChanges(Map userPreferenceMap) {
		
		/*
		 * get All the interactions
		 * get Attendees for each interaction
		 * get ContactList for each attendee
		 * get preference for each contact
		 * if daily preference put the html message as value in the Dailymap with the key as userId
		 * if weekly preference put the html message as value in the Weeklymap with the key as userId
		 * if monthly preference put the html message as value in the Monthlymap with the key as userId
		 * Get the mode = 0 , 1 ,2 
		 * you know your date range
		 * you get interactions in this data range
		 * process interactions and get messages, hash of users who has to receive the message
		 * if mode = 0 , then get msl whoes pref is daily and hash them
		 * if mode = 1,  then get msl whoes pref is daily or weekly 
		 * if mode = 2 you get all
		 * 
		 */

		Map weeklyMap = new HashMap();
		Map dailyMap = new HashMap();
		Map monthlyMap = new HashMap();
		Calendar today = Calendar.getInstance();
		Calendar lastMonth = Calendar.getInstance();
		lastMonth.add(Calendar.MONTH, -1);
		/*Interaction[] interactions = interactionService.getCreatedByandUpdatedBy(lastMonth.getTime(), new Date());*/
		List result = interactionService.getAllInteractionByNotfication(lastMonth.getTime(), new Date());
		
		Properties props = new Properties();
		try {
			 props = DBUtil.getInstance().getDataFromPropertiesFile("resources/ServerConfig.properties");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String weekly = props.getProperty("WEEKLY");
		long weeklyDay = 0;
		if(weekly != null && !"".equalsIgnoreCase(weekly))
			weeklyDay = Long.parseLong(weekly);
		String monthly = props.getProperty("MONTHLY");
		long monthlyDay = 0;
		if(monthly != null && !"".equalsIgnoreCase(monthly))
			monthlyDay = Long.parseLong(monthly);
		
		
		
		for(int i = 0;i<(result!=null?result.size():0);i++)
		{
			
			Object[] objArr = (Object[]) result.get(i);
			Interaction interaction = (Interaction) objArr[0];
			Notification notification = (Notification) objArr[1];
			
			/*Attendee[] attendees = attendeeService.getAllAttendees(interactions[i].getId());
			if(attendees != null)
			{
			
			for(int j = 0;j<attendees.length;j++)
			{
				
				User user = userService.getUser(attendees[j].getUserId());
				if(user!=null)
				{
					
					User[] users = userService.getContactForKol(user.getId() );
				
					  
					for(int k = 0;k<users.length;k++)
					{*/
						
						/*
						 * For each contact generate the map with the required message
						 * Based on the user's preference, the message will go into different maps(dailyMap,weeklyMap,monthlyMap
						 */
				
						long userId = notification.getUserId();
						long kolId = notification.getKolId();
						
						UserPreference userPreference = (UserPreference) userPreferenceMap.get(userId+"");
						
						
						
						
						if(userPreference == null)
						{
							userPreference = new UserPreference();
							userPreference.setFrequency(0);
							userPreference.setUserId(userId);
							userPreferenceService.savePreference(userPreference);
							userPreferenceMap.put(userId+"", userPreference);
						}
						
						if(userPreference.getFrequency() == DAILY_PREFERENCE)
						{
							//processNotifyMessages(dailyMap,interactions[i],attendees,0,24.00);
							
							
							double createDateDiff = findDateDifference(interaction.getCreateTime(), DAILY_PREFERENCE);
							double updateDateDiff = findDateDifference(interaction.getUpdateTime(), DAILY_PREFERENCE);
							String msg = ""; 
							boolean flag = false;
							if(createDateDiff <= 24 && createDateDiff != -1 )
							{
								System.out.println("inside if");
								 msg = generateMessage(interaction,kolId,0);
								 if(msg!=null){
										addMsgToMap(dailyMap,msg,userId);
								 		flag = true;
								 }
								 
							}
							
							if(updateDateDiff <= 24 && updateDateDiff != -1  && !flag)
							{
								msg = generateMessage(interaction,kolId,1);
								
								if(msg!=null)
									addMsgToMap(dailyMap,msg,userId);
							}	
							
							
						}
						else
						{
							
							if(userPreference.getFrequency() == WEEKLY_PREFERENCE &&  today.get(Calendar.DAY_OF_WEEK) == weeklyDay)
							{
								
								double createDateDiff = findDateDifference(interaction.getCreateTime(), WEEKLY_PREFERENCE);
								double updateDateDiff = findDateDifference(interaction.getUpdateTime(), WEEKLY_PREFERENCE);
								String msg = ""; 
								boolean flag = false;
								
								if(createDateDiff <= 7 && createDateDiff != -1)
								{
									 msg = generateMessage(interaction,kolId,0);
									 if(msg!=null){
											addMsgToMap(weeklyMap,msg,userId);
											flag = true;
									 }
									 
									 
								}
								if(updateDateDiff <= 7 && updateDateDiff != -1 && !flag)
								{
									msg = generateMessage(interaction,kolId,1);
									if(msg!=null)
										addMsgToMap(weeklyMap,msg,userId);
									
								}	
								
									
							}
							else
							 {
								
								if( userPreference.getFrequency() == MONTHLY_PREFERENCE && today.get(Calendar.DAY_OF_MONTH) ==  monthlyDay)
								{
									
									boolean createDateInRange = isDateInRange(interaction.getCreateTime()) ;
									boolean updateDateInRange = isDateInRange(interaction.getUpdateTime()) ;
								    String msg = "";
									if(createDateInRange)
									{
										msg = generateMessage(interaction ,kolId,0);
										if(msg!=null)
											addMsgToMap(monthlyMap,msg,userId);
									}
									if(updateDateInRange)
									{
										if(interaction .getCreateTime().compareTo(interaction.getUpdateTime()) != 0){
										msg = generateMessage(interaction ,kolId,1);
										if(msg!=null)
											addMsgToMap(monthlyMap,msg,userId);
										}
									}
								}

							}
						 }	
						}
		if(today.get(Calendar.DAY_OF_WEEK) == weeklyDay)
			sendMailforInteractions(weeklyMap);
		if(today.get(Calendar.DAY_OF_MONTH) == monthlyDay)
			sendMailforInteractions(monthlyMap);
		 sendMailforInteractions(dailyMap);
		
		
	}
    private String generateMessage(Interaction interaction, long userId, int i) {
		
    	SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
    	if(interaction.getType() != null && interaction.getType().getOptValue() != "")
		{
		StringBuffer sb = new StringBuffer();
		sb.append("Interaction with the type ");
		sb.append("<font color='#006699'>"+
				//interaction.getId()+
				interaction.getType().getOptValue()+
				"</font>");
		sb.append(" has been ");
		if(i == 0)
		 sb.append("created ");
		else
		 sb.append("updated ");
		 sb.append("with <font color='#006699'>");
		  User user =  getUser(userId);	
		  if(user != null)
		sb.append(user.getLastName()+", "+user.getFirstName());
		sb.append("</font>");
		sb.append(" as one of the Attendees , dated on <font color='#006699'>");
		System.out.println(sdf.format(interaction.getInteractionDate()));
		sb.append(sdf.format(interaction.getInteractionDate()));
		sb.append("</font>");
		return sb.toString();
		}
	  return null;
    	
	 
	}



	private void sendMailforInteractions(Map subscriptionMap) {
		System.out.println("Inside Sending "+ subscriptionMap.size());
		if(subscriptionMap.size()>0)
		{
			 for (Iterator itr = subscriptionMap.entrySet().iterator(); itr
                .hasNext();) {
            Map.Entry entry = (Map.Entry) itr.next();
            Set messageDataSet = (HashSet)entry.getValue();
            String msg = generateHtmlMessage(messageDataSet);
            long userId = Long.parseLong(entry.getKey()+"");
            send(msg,userId,MAIL_FROM_INTERACTION,INTERACTION_CHANGE_NOTIFICATION);
            
		
			 }
		}	 
	}



	private void send(String msg, long userId, String mailFrom, String subject) {
		
		
		EventNotificationMailSender notificationMailSender = new EventNotificationMailSender();
		User user = getUser(userId);
		notificationMailSender.setFrom(mailFrom);
		notificationMailSender
		.setSubject(subject);
		if(user!=null){
		notificationMailSender.setTo(user.getEmail());
		System.out.println("Email Id :"+user.getEmail()+"\n"+msg);
		notificationMailSender.send(msg);}
		
	}

	private String generateHtmlMessage(Set distinctMessagesSet) {
		
		/*
		 * Generate Html  string for the user with the associated messages 
		 */
		
		StringBuffer sb = new StringBuffer();
		sb.append("<html> ");
		sb.append("<head> ");
		sb
		.append("<title>Interaction Details Edited Notification</title> ");
		sb.append("</head> ");
		sb.append("<body> ");
		
		sb
		.append("Dear Recipient,<br><br>This is an auto generated email to notify you the <br><br>");
		for (Iterator itr = distinctMessagesSet.iterator(); itr
        .hasNext();) {
		 	
			sb.append(itr.next()+"<br>");
		}
		sb.append("<br><br>Please log onto the application for the details.");
		sb.append("<br><br><br>Thanks,<br>Administrator");
		sb.append("</body>");
		sb.append("</html>");
		return sb.toString();
	}

	private void addMsgToMap(Map subscriptionMap, String msg,long userId) {
				
		/*
		 * Create Map with the passed message using the userId as key
		 * If the user is already added to the map,add the message with the existing list
		 * else
		 * create a new list and add the message.
		 */
		
		Set userNotificationList = (HashSet)subscriptionMap.get(userId +"");
		
		if(userNotificationList == null)
		{
			Set tempList = new HashSet();
			tempList.add(msg);
			subscriptionMap.put(userId+"", tempList);
		}
		else
		{
			userNotificationList.add(msg);
			subscriptionMap.put(userId+"", userNotificationList);
		}
		
	}
		
		
		
	

	private String generateMessage(Interaction interaction, Attendee[] attendees,int i) {
		
		
		
		/* 
		 * Extract the required info from interaction and attendees 
		 * Construct a message using this information.
		 */
		
		if(interaction.getType() != null && interaction.getType().getOptValue() != "")
		{
		StringBuffer sb = new StringBuffer();
		sb.append("Interaction with the type ");
		try{
		sb.append("<font color='#006699'>"+
				//interaction.getId()+
				interaction.getType().getOptValue()+
				"</font>");
		}
		catch(Exception e)
		{
			System.err.println(e);
		}
		sb.append(" has been ");
		if(i == 0)
		 sb.append("created ");
		else
		 sb.append("updated ");
		if(attendees.length != 0)
		{	
			sb.append("with the following Attendees <font color='#006699'>");
			
			try{
			sb.append(attendees[0].getName());
			for(int j=1;j<attendees.length;j++){
			sb.append(", "+attendees[j].getName());
			}
			}catch(Exception e)
			{
				System.out.println(e.getLocalizedMessage());
			}
			sb.append("</font>");
		}
		sb.append(" , dated on ");
		try{
		sb.append(interaction.getInteractionDate().toString());
		}catch(Exception e)
		{
			System.err.println(e);
		}
		
		return sb.toString();
		}
		else
			return null;
	}

	public void notifyProfileChanges()
	{
		/*
		 * Pseudo Code:
		 * 
		 * Find the day and date
		 * if current day is MONDAY then do the processing for daily mail delivery and weekly delivery
		 * if current date is 1st of the month then do the processing for daily,weekly,monthly delivery
		 */
		Properties props = new Properties();
		try {
			 props = DBUtil.getInstance().getDataFromPropertiesFile("resources/ServerConfig.properties");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String weekly = props.getProperty("WEEKLY");
		long weeklyDay = 0;
		if(weekly != null && !"".equalsIgnoreCase(weekly))
			weeklyDay = Long.parseLong(weekly);
		String monthly = props.getProperty("MONTHLY");
		long monthlyDay = 0;
		if(monthly != null && !"".equalsIgnoreCase(monthly))
			monthlyDay = Long.parseLong(monthly);
		
		
		Calendar today = Calendar.getInstance();
		if(today.get(Calendar.DAY_OF_WEEK) == weeklyDay)
		{
			/* 
			 * Get all the entries that got changed within a week and distribute the list of
			 * changes across the user based on their subscription.
			 * Create a Map which maps the user and altered attributes.
			 * Then generate the HTML file using this Map
			 */
			Map weeklyMap = new HashMap();
			generateMap(weeklyMap,WEEKLY_PREFERENCE);
			sendMail(weeklyMap);
			
			
			
		}
		
		if(today.get(Calendar.DAY_OF_MONTH) == monthlyDay)
		{
			/* 
			 * Get all the entries that got changed within a month and distribute the list of
			 * changes across the user based on their subscription.
			 * Create a Map which maps the user and altered attributes.
			 * Then generate the HTML file using this Map
			 */
			Map monthlyMap = new HashMap();
			generateMap(monthlyMap,MONTHLY_PREFERENCE);
			sendMail(monthlyMap);
			
			
		}
		/* 
		 * Get all the entries that got changed within a day and distribute the list of
		 * changes across the user based on their subscription.
		 * Create a Map which maps the user and altered attributes.
		 * Then generate the HTML file using this Map
		 */
		Map dailyMap = new HashMap();
		generateMap(dailyMap,DAILY_PREFERENCE);
		sendMail(dailyMap);
		if(today.get(Calendar.DAY_OF_MONTH) == 9){
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.DATE, -10);
		Date tenDaysBefore = calendar.getTime();
		calendar.add(calendar.MONTH,-1);
		Date lastMonthStartingDate  = calendar.getTime();
		List alertAuditQueue = alertsService.getChangesInTheLastMonth(tenDaysBefore, lastMonthStartingDate);
		if(alertAuditQueue != null)
		alertsService.deleteAlertQueueList( alertAuditQueue);
		}
		
	}
	
	private void sendMail(Map subscriptionMap) {
		
		if(subscriptionMap.size()>0)
		{
			 for (Iterator itr = subscriptionMap.entrySet().iterator(); itr
                .hasNext();) {
            Map.Entry entry = (Map.Entry) itr.next();
            Set notificationDataSet = (HashSet) entry.getValue();
            
		    	
            String msg = generateHtmlString(notificationDataSet);
            
            if (msg !=null )
            {
            	StringBuffer sb = new StringBuffer();
            	sb.append("<html> ");
    			sb.append("<head> ");
    			sb
    			.append("<title>Expert Profile Details Edited Notification</title> ");
    			sb.append("</head> ");
    			sb.append("<body> ");
    			
    			sb
    			.append("Dear Recipient,<br><br>This is an auto generated email to notify you the <br><br>");
            	sb.append(msg);
            	sb.append("<br><br>Please log onto the application for the details.");
       		    sb.append("<br><br><br>Thanks,<br>Administrator");
	       		sb.append("</body>");
	     		sb.append("</html>");
	            	long userId = Long.parseLong(entry.getKey()+"");
            	send(sb.toString(),userId,MAIL_FROM_PROFILE,ATTRIBUTE_CHANGE_NOTIFICATION);
			}
            
		}
		
	}

	}


	private String generateHtmlString(Set  notificationDistinctSet) {
		
		if(notificationDistinctSet.size() == 0)
			return null;

		Map hashedMessages = new HashMap();
		 for (Iterator itr = notificationDistinctSet.iterator(); itr
            .hasNext();) {
			 	//Map.Entry entry = (Map.Entry) 
			   
				String notificationString = (String) itr.next();
				String[] stringList = notificationString.split(",");
				List attributeList = (ArrayList)hashedMessages.get(stringList[0]);
				if(attributeList != null){
					attributeList.add(stringList[1]);
					hashedMessages.put(stringList[0],attributeList);
				}
				else{
					List tempList = new ArrayList();
					tempList.add(stringList[1]);
					hashedMessages.put(stringList[0], tempList);
				}
								
				 
			 }
		 
		 StringBuffer sb = new StringBuffer();
		 	
		 
		 for (Iterator itr = hashedMessages.entrySet().iterator(); itr
            .hasNext();) {
			 Map.Entry entry = (Map.Entry) itr.next();
			 long userId = Long.parseLong((String)entry.getKey());
			 List attributeList = (ArrayList) entry.getValue();
			 String attributeListString = "-1";
			 if(attributeList != null){
			   for(int i = 0;i<attributeList.size();i++){
				   attributeListString = attributeListString+","+(String) attributeList.get(i);
			   }
			 }
			 	User u = null;
				AttributeType attributeType = null;
				List result = getHibernateTemplate().find(
						"from AttributeType a where a.attribute_id in ("
								+ attributeListString+")");
				
				String attributeName = "";
				if(result!=null && result.size() >0){
				
					attributeType = (AttributeType)result.get(0);
					attributeName =  attributeType.getName();
					for(int i=1;i<result.size();i++){
			        	attributeType = (AttributeType)result.get(i);
			        	attributeName = attributeName +","+ attributeType.getName();
					}
				u =  getUser(userId);
				if (u != null){
					sb.append(generateHTMLBody(u,attributeName)+"<br>");
			}
		 }
	}
		
		 
		 
			
return sb.toString();





}

	private String generateHTMLBody(User u, String attributeName) {
		

		StringBuffer sb = new StringBuffer();
		
		sb.append("<font color='#006699'>"
				+   attributeName + "</font> tab(s) of");
		sb.append(" <font color='#006699'>" + "Dr." + " "
			+ u.getFirstName() + " "
		+ u.getLastName()
		+ "</font> profile has been edited.<br>");
		

		return sb.toString();
		
	}



	private void generateMap(Map subscriptionMap, long frequency) {
		
		/* Calls getUserNotificationMap iteratively to generate a map with key as
		 * user_id and value as array of notifications
		 */
		
		System.out.println("generateMap");
		
		List results = null; 
		try{
		
		  results = getHibernateTemplate().find("from AlertAuditQueue aq,Notification n,UserPreference up where" +
													" aq.kolId = n.kolId " +
													" and n.userId = up.userId and up.frequency = "+ frequency );
		}catch(Exception e)
		{
			System.err.println(e);
		}
		if(results!=null)
		{
			
			for(int i = 0;i< results.size();i++)
			{
				Object[] objArr = (Object[]) results.get(i);
				AlertAuditQueue alertAuditQueue = (AlertAuditQueue)objArr[0];
				Notification notification = (Notification)objArr[1];
				ProfileNotification profileNotification = new ProfileNotification();
				profileNotification.setKolId(alertAuditQueue.getKolId());
				profileNotification.setAttributeId(alertAuditQueue.getAttributeId());
				double diff = findDateDifference(alertAuditQueue.getUpdatedAt(),frequency);
				if(frequency == 0 && diff<=24 && diff != -1)
				{
//					/* diff in hours for daily*/
						//getUserNotificationMap(notification,subscriptionMap);
					    getUserNotificationMap(notification.getUserId(),profileNotification,subscriptionMap);
				}
				else 
				{
					if(frequency == 1 && diff <= 7 && diff != -1)
					{
					/* diff in days for weekly and monthly */
						//getUserNotificationMap(notification,subscriptionMap);
						getUserNotificationMap(notification.getUserId(),profileNotification,subscriptionMap);
						
					}
					else
					{
						if(frequency == 2 && isDateInRange(alertAuditQueue.getUpdatedAt()) && diff != -1)
						{
							getUserNotificationMap(notification.getUserId(),profileNotification,subscriptionMap);
						}
					}
				}
			}
			 
		}
		
		
	}

	private void getUserNotificationMap(long userId, ProfileNotification profileNotification, Map subscriptionMap) {
		 
	   Set userNotificationList = (HashSet)subscriptionMap.get(userId+"");
		
		if(userNotificationList == null)
		{
			Set tempList = new HashSet();
			tempList.add(profileNotification.getKolId()+","+profileNotification.getAttributeId());
			subscriptionMap.put(userId+"", tempList);
		}
		else
		{
			userNotificationList.add(profileNotification.getKolId()+","+profileNotification.getAttributeId());
			subscriptionMap.put(userId +"", userNotificationList);
		}
		
		
		
	}



	private void getUserNotificationMap(Notification notification, Map subscriptionMap) {
		/*Add the notification to the arraylist if the userId is already present
		 * else create an arraylist and add the notification.
		 */
		Set userNotificationList = (HashSet)subscriptionMap.get(notification.getUserId()+"");
		
		if(userNotificationList == null)
		{
			Set tempList = new HashSet();
			tempList.add(notification);
			subscriptionMap.put(notification.getUserId()+"", tempList);
		}
		else
		{
			userNotificationList.add(notification);
			subscriptionMap.put(notification.getUserId()+"", userNotificationList);
		}
		
	}

	
	/* finds the difference between current date and the passed date */
	private double findDateDifference(Date updatedAt, long frequency) {
		double diff = 0;
		 
			
			if(updatedAt != null)
			{	
		
			try {
				String currDateString = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss")
				.format(new Date());
				Date currDate = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss")
				.parse(currDateString);
				String endDateString = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss")
				.format(updatedAt);
				updatedAt = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss").parse(endDateString);
				diff =  currDate.getTime()- updatedAt.getTime() ;
			} catch (Exception e) {
				logger.error("Error");
			}
			if(frequency == 0)
				return ((double)diff / (1000 * 60 * 60 ));
			else
				return ((double)diff / (1000 * 60 * 60 * 24));

			}
			else
				return -1;
	}
	
	
	
	public boolean isDateInRange(Date updatedAt)
	{
		
		if(updatedAt == null)
			return false;
		Calendar lastMonth = Calendar.getInstance();
		lastMonth.add(Calendar.MONTH, -1);
		Date date = new Date();
		if(updatedAt.after(lastMonth.getTime()) && (updatedAt.before(date) || updatedAt.compareTo(date) == 0))
			return true;
		return false;		
			
			
		
	}

	public IAttendeeService getAttendeeService() {
		return attendeeService;
	}

	public void setAttendeeService(IAttendeeService attendeeService) {
		this.attendeeService = attendeeService;
	}

	public IInteractionService getInteractionService() {
		return interactionService;
	}

	public void setInteractionService(IInteractionService interactionService) {
		this.interactionService = interactionService;
	}

	public IUserPreferenceService getUserPreferenceService() {
		return userPreferenceService;
	}

	public void setUserPreferenceService(
			IUserPreferenceService userPreferenceService) {
		this.userPreferenceService = userPreferenceService;
	}

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}



	public IAlertsService getAlertsService() {
		return alertsService;
	}



	public void setAlertsService(IAlertsService alertsService) {
		this.alertsService = alertsService;
	}
		
		
	}

