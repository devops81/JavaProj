package com.openq.alerts;

import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.Notify.Notification;
import com.openq.alerts.data.Alert;
import com.openq.alerts.data.AlertAuditQueue;
import com.openq.alerts.data.AlertDetail;
import com.openq.alerts.data.AlertQueue;
import com.openq.alerts.data.Recipient;
import com.openq.eav.data.DateAttribute;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.metadata.MetadataService;
import com.openq.eav.scripts.OlConstants;
import com.openq.group.UserGroupMap;
import com.openq.user.User;
import com.openq.utils.EventNotificationMailSender;
//import com.openq.utils.IGlobalConstantsService;
import com.openq.web.controllers.Constants;

public class AlertsService extends HibernateDaoSupport implements
IAlertsService {

	Set orgAttributeIds = null;

	Set trialAttributeIds = null;
	
	private static final String ATTRIBUTE_CHANGE_NOTIFICATION = "openQ - Attribute Change Notification";
	
	public final static DateFormat format = new SimpleDateFormat("dd-MMM-yy");

	public Alert[] getAllAlerts() {
		List result = getHibernateTemplate().find("from Alert");
		return ((Alert[]) result.toArray(new Alert[result.size()]));
	}

	public Alert getAlert(long id) {
		Alert alert = (Alert) getHibernateTemplate().find(
				"from Alert where id=" + id).get(0);
		return alert;
	}

	public void saveAlert(Alert alert) {
		getHibernateTemplate().save(alert);
	}

	public void updateAlert(Alert alert) {
		getHibernateTemplate().update(alert);
	}

	public void deleteAlert(long id) {
		Alert alert = getAlert(id);
		getHibernateTemplate().delete(
				"from AlertQueue q where q.alert.id=" + id);
		getHibernateTemplate().delete(alert);
	}

	public void saveAlertQueue(AlertQueue alertQueue) {
		getHibernateTemplate().save(alertQueue);
	}

	public void updateAlertQueue(AlertQueue queue) {
		getHibernateTemplate().update(queue);
	}

	public void deleteAlertQueueList(List queue) {
		getHibernateTemplate().deleteAll(queue);
	}

	public void deleteAlertQueue(AlertQueue queue) {
		getHibernateTemplate().delete(queue);
	}

	public AlertQueue[] getAlertQueue(String id) {

		List result1 = getHibernateTemplate().find("from AlertQueue a");
		Set result = new HashSet();
		Iterator iterator = result1.iterator();
		List userGrps = getHibernateTemplate().find(
				"from UserGroupMap ug where ug.user_id=" + id);
		while (iterator.hasNext()) {
			AlertQueue alertQueue = (AlertQueue) iterator.next();
			if (isCandidateForDelivery(alertQueue.getAlert().getRecipients(),
					userGrps)) {
				result.add(alertQueue);
			}
		}
		AlertQueue[] alertQueues = ((AlertQueue[]) result
				.toArray(new AlertQueue[result.size()]));
		Arrays.sort(alertQueues);
		return alertQueues;
	}

	public AlertQueue[] getAlertQueue(long alertId) {
		List result = getHibernateTemplate().find(
				"from AlertQueue as q where q.alert.id = " + alertId);

		AlertQueue[] alertQueues = ((AlertQueue[]) result
				.toArray(new AlertQueue[result.size()]));
		Arrays.sort(alertQueues);
		return alertQueues;
	}

	public AlertAuditQueue[] getAuditQueue() {
		List result = getHibernateTemplate().find("from AlertAuditQueue q");
		if(result != null && result.size()>0)
		return ((AlertAuditQueue[]) result.toArray(new AlertAuditQueue[result
		                                                               .size()]));
		return null;
	}

	public void updateAuditQueue(AlertAuditQueue queue) {
		getHibernateTemplate().update(queue);
	}


	public void processAlerts() {
		Alert[] alerts = getAllAlerts();
		AlertAuditQueue[] queue = getAuditQueue();
		List nonmatchedAlertAuditQueue = new ArrayList();
		Set matchedAlertAuditQueueSet = new HashSet();
		AlertAuditQueue alertAuditQueue = null;
		System.out.println("In Alert");
		
		// for each alerts-> for each each alert details -> processes alert
		// Queue audit ( put in alter queue or delete)
		for (int i = 0; i < alerts.length; i++) {
			Alert alert = alerts[i];
			List details = alert.getAlertDetails();
			Iterator iter = details.iterator();
			while (iter.hasNext()) {
				AlertDetail detail = (AlertDetail) iter.next();
				for (int j = 0; j < queue.length; j++) {
					alertAuditQueue = queue[j];
					AttributeType attributeType = metadataService.getAttributeType(detail.getAttributeId());
					attributeType = metadataService.getAttributeForEntity(attributeType.getParent().getEntity_type_id());
					
					if ( attributeType.getAttribute_id() == queue[j].getAttributeId()
				 			&& detail.getOperator() == queue[j].getOperation()
							&& !matchedAlertAuditQueueSet
							.contains(alertAuditQueue)) {
						alertAuditQueue.setAlert(alert);

						matchedAlertAuditQueueSet.add(alertAuditQueue);
					}
					nonmatchedAlertAuditQueue.add(alertAuditQueue);
				}
			}
		}

		Iterator iter = matchedAlertAuditQueueSet.iterator();

		while (iter.hasNext()) {

			String m = getMessage(alertAuditQueue);
			if (m != null) {
				alertAuditQueue = (AlertAuditQueue) iter.next();
				AlertQueue alertQueue = new AlertQueue();
				alertQueue.setAlert(alertAuditQueue.getAlert());
				alertQueue.setCreatedAt(new Date());
				alertQueue.setMessage(m);
				saveAlertQueue(alertQueue);
				alertAuditQueue.getAlert().setLastFiredAt(new Date());
				updateAlert(alertAuditQueue.getAlert());
			} else
				iter.next();
		}
		if(queue != null)
		deleteAlertQueueList(Arrays.asList(queue));
		/*Contract Expiration  Commented
		 * List contracts = null;
		try{
		 contracts = getHibernateTemplate()
		.find(
				"from User u, DateAttribute dt,DateAttribute dt1,EntityAttribute e,StringAttribute st," 
				+"EntityAttribute en "
				+ "where u.kolid =  e.parent.id and " 
				+ "en.parent.id = e.myEntity.id and "
				+ "dt.parent.id = en.myEntity.id and "
				+ "dt.attribute.attribute_id = 83079242 and "
				+ "dt1.attribute.attribute_id = 83079243 and "
				+ "dt.parent.id = dt1.parent.id and "
				+ "st.value = 'yes' and "
				+ "st.parent.id = dt1.parent.id order by dt1.value asc");
		}catch(Exception e)
		{
			System.err.println(e);
		}*/

		/*
		 * for each contract we find out the expiration due If it is >60 don't
		 * alert <60 Alert <0 delete the alert
		 * 
		 * If a user has more than one contract and more than one contract is
		 * going to expire then we will alert with the contract which has the
		 * least days
		 */
		/*
		 * Contract Expiration Commented
		 * for (int i = 0; i < contracts.size(); i++) {
			Object[] objArr = (Object[]) contracts.get(i);
			User u = (User) objArr[0];
			int flag = 0;
			DateAttribute endDate = (DateAttribute) objArr[2];
			long duration = findDuration(endDate.getValue());

			String msg = "";
			if (duration <= 60 && duration >= 0) {

				msg = getMessage(u.getKolid(), duration);
				flag = 1;
			}
			Alert alert = getAlertByName("Contract Expiration Alert");
			if (flag == 1) {

				if (!existingContract(u.getKolid(), alert.getId())) {
					AlertQueue alertQueue = new AlertQueue();

					alertQueue.setAlert(alert);
					alertQueue.setCreatedAt(new Date());
					alertQueue.setMessage(msg);
					alertQueue.setKolid(u.getKolid());

					try {
						getHibernateTemplate().save(alertQueue);
					} catch (Exception e) {
						System.err.println(e);
					}
				} else {
					AlertQueue alertQueue = getContract(u.getKolid(), alert
							.getId());
					try {

						if (alertQueue != null) {
							alertQueue.setMessage(msg);
							getHibernateTemplate().update(alertQueue);
						}
					} catch (Exception e) {

						System.err.println(e);

					}
				}

			}

			if (flag == 0 && existingContract(u.getKolid(), alert.getId()))
				deleteContract(u.getKolid(), alert.getId());
		}*/

		/*
		 * Notification for attribute changes **********************************
		 * Using the existing service to monitor the changes Tables:-
		 * Notify_table and change_notify table
		 */

		List notificationList = getNotifyObject();

		if (notificationList != null) {
			for (int i = 0; i < notificationList.size(); i++) {
				Object[] arrObj = (Object[]) notificationList.get(i);
				Notification notification = (Notification) arrObj[0];
				long attribute_id = notification.getAttribute_id();
				long userId = notification.getUserId();
				long kolId = notification.getKolId();
				String msg = generateHtmlString(attribute_id, userId, kolId);
				List result = getHibernateTemplate().find(
						"from User u where u.id = " + userId);

				if (result.size() > 0) {
					User user = (User) result.get(0);

					EventNotificationMailSender notificationMailSender = new EventNotificationMailSender();
					notificationMailSender.setTo(user.getEmail());
					notificationMailSender
					.setSubject(ATTRIBUTE_CHANGE_NOTIFICATION);
					//notificationMailSender.send(msg);

				}
			}

		}
		List changenotifyList = getNotifyList();
		if (changenotifyList != null) {
			//deleteNotificationList(changenotifyList);
		}

	}

	private void deleteContract(long kolid, long alertId) {
		getHibernateTemplate().delete(
				"from AlertQueue q where q.kolid=" + kolid
				+ " and  q.alert.id=" + alertId);

	}

	private String getMessage(long kolid, long duration) {
		String msg = "";
		List result = getHibernateTemplate().find(
				"from User u where u.kolid = " + kolid);
		User u = null;
		if (result != null && result.size() > 0) {

			u = (User) result.get(0);
			msg = "Dr."+u.getLastName() +" "+ u.getFirstName()
			+ "'s Contract is going to expire in " + duration
			+ " days ";
		}
		return msg;
	}

	private boolean existingContract(long kolid, long alertId) {
		List result = getHibernateTemplate().find(
				"from AlertQueue q where q.alert.id =" + alertId
				+ " and  q.kolid =" + kolid);
		if (result != null && result.size() > 0)
			return true;

		return false;
	}

	private AlertQueue getContract(long kolid, long alertId) {
		List result = getHibernateTemplate().find(
				"from AlertQueue q where q.alert.id =" + alertId
				+ " and  q.kolid =" + kolid);
		if (result != null && result.size() > 0)
			return (AlertQueue) result.get(0);

		return null;
	}

	private long findDuration(Date endDate) {
		long diff = 0;
		try {
			String currDateString = new SimpleDateFormat("MM/dd/yyyy")
			.format(new Date());
			Date currDate = new SimpleDateFormat("MM/dd/yyyy")
			.parse(currDateString);
			String endDateString = new SimpleDateFormat("MM/dd/yyyy")
			.format(endDate);
			endDate = new SimpleDateFormat("MM/dd/yyyy").parse(endDateString);
			diff = endDate.getTime() - currDate.getTime();
		} catch (Exception e) {
			logger.error("Error");
		}
		return (diff / (1000 * 60 * 60 * 24));

	}

	private List getNotifyList() {
		List result = getHibernateTemplate().find("from ChangeNotify");
		return result;

	}

	private void deleteNotificationList(List changeNotificationList) {
		getHibernateTemplate().deleteAll(changeNotificationList);
	}

	private List getNotifyObject() {
		List result = getHibernateTemplate()
		.find(
				"from Notification n,ChangeNotify cn where cn.attribute_id = n.attribute_id and "
				+ "cn.kolId = n.kolId");

		if (result.size() == 0)
			return null;
		else {
			return result;

		}

	}

	private String generateHtmlString(long attrId, long userId, long kolId) {

		List result = getHibernateTemplate().find(
				"from AttributeType where attribute_id = " + attrId);
		if (result.size() > 0) {
			AttributeType attributeType = (AttributeType) result.get(0);
			// String attrName = attributeType.getName();
			result = getHibernateTemplate().find(
					"from User u where u.id = " + kolId);
			if (result.size() > 0) {
				User u = (User) result.get(0);

				StringBuffer sb = new StringBuffer();
				sb.append("<html> ");
				sb.append("<head> ");
				sb
				.append("<title>Expert Profile Details Edited Notification</title> ");
				sb.append("</head> ");
				sb.append("<body> ");
				sb
				.append("Dear Recipient,<br><br>This is an auto generated email to notify you the <font color='#006699'>"
						+ attributeType.getName() + "</font> tab of");
				sb
				.append(" <font color='#006699'>"
						+ "Dr."
						+ " "
						+ u.getFirstName()
						+ " "
						+ u.getLastName()
						+ "</font> profile has been edited.<br><br>Please log onto the application for the details.");
				sb.append("<br><br><br>Thanks,<br>Administrator");
				return sb.toString();
			} else
				return "Profile has changed";
		} else
			return null;

	}

	private String getMessage(AlertAuditQueue alertAuditQueue) {
		String message = "Data has changed";
		try {
			if (orgAttributeIds == null)
				setIds();

			// if profile data has changed
			List result = null;
			// Attribute deleted
			if ("2".equals(alertAuditQueue.getOperation() + "")) {
				List userList = getHibernateTemplate().find("from User u where u.deleteFlag='N' and u.kolid="+alertAuditQueue.getAttribute());
				List attributeTypeList = getHibernateTemplate()
				.find(
						"from AttributeType A1 where A1.type in ( select A2.parent.entity_type_id from AttributeType A2 where A2.attribute_id="
						+ alertAuditQueue.getAttributeId()
						+ ")");

				if (userList.size() > 0 && attributeTypeList.size()>0) {
					User userObj = (User) userList.get(0);
					AttributeType attributeObj = (AttributeType) attributeTypeList.get(0);
					message = "Dr. " + userObj.getLastName() + ", "
					+ userObj.getFirstName() + "'s " + attributeObj.getName()
					+ " deleted.";
					
					return message;
				}
			} else {
				result = getHibernateTemplate()
				.find(
						"from Entity A, EntityAttribute B, EntityAttribute C,"
						+ alertAuditQueue.getSource()
						+ " D where D.id="
						+ alertAuditQueue.getAttribute()
						+ " and D.parent=C.myEntity and C.parent=B.myEntity "
						+ "and B.parent=A.id and A.type=101");
				System.out.println("results:"+result.size()+" "+alertAuditQueue.getAttribute());
			}

			Object objArr[] = null;
			if (result.size() > 0) {
				objArr = (Object[]) result.get(0);
				long kolId = ((Entity) (objArr[0])).getId();
				AttributeType attributeType = ((EntityAttribute) (objArr[2]))
				.getAttribute();
				result = getHibernateTemplate().find(
						"from User u where u.kolid = " + kolId);

				if (result.size() > 0) {
					User u = (User) result.get(0);
					if ("0".equals(alertAuditQueue.getOperation() + "")){ // record created
						message = "Dr. " + u.getLastName() + ", "
						+ u.getFirstName() + "'s " + attributeType.getName()
						+ " created.";
					}else if ("1".equals(alertAuditQueue.getOperation() + "")){ // record updated
						message = "Dr. " + u.getLastName() + ", "
						+ u.getFirstName() + "'s " + attributeType.getName()
						+ " updated.";
					}
						
				} else
					message = "Profile data has changed";
				return message;
			} else {
				StringBuffer sb = new StringBuffer(
				"from StringAttribute s where s.id > ")
				.append(alertAuditQueue.getAttribute() - 20);
				sb.append(" and s.id < ").append(
						alertAuditQueue.getAttribute() + 20).append(
						" and s.attribute.attribute_id = ").append(
								alertAuditQueue.getAttributeId());

				result = getHibernateTemplate().find(sb.toString());
				if (result != null && result.size() > 0) {
					StringAttribute sa = (StringAttribute) result.get(0);
					result = getHibernateTemplate()
					.find(
							"from StringAttribute s where s.attribute.attribute_id in (118,82619764) and s.parent.id="
							+ sa.getParent().getId());
					if (result != null && result.size() > 0)
						message = ((StringAttribute) result.get(0)).getValue()
						+ " data has changed";
				}
			}

			if (trialAttributeIds.contains(alertAuditQueue.getAttributeId()
					+ "")) {
				message = "Trial: " + message;
				return message;
			} else if (orgAttributeIds.contains(alertAuditQueue
					.getAttributeId()
					+ "")) {
				message = "Org: " + message;
				return message;
			} else
				return null;
		} catch (Exception e) {
			logger.error(" exception occured " + e);
		}
		return message;
	}

	private void setIds() {
		orgAttributeIds = getAttributeIds(12l);
		trialAttributeIds = getAttributeIds(15l);
	}

	private Set getAttributeIds(long parentId) {
		List result = getHibernateTemplate().find(
				"from AttributeType a where a.parent.entity_type_id="
				+ parentId);
		Iterator iterator = result.iterator();
		StringBuffer sb = new StringBuffer(
		"from AttributeType a where a.parent.entity_type_id. in (");
		while (iterator.hasNext()) {
			AttributeType attributeType = (AttributeType) iterator.next();

			sb.append(attributeType.getType()).append(", ");
		}
		sb.append("-1 )");
		result = getHibernateTemplate().find(sb.toString());
		Set ids = new HashSet();
		while (iterator.hasNext()) {
			AttributeType attributeType = (AttributeType) iterator.next();
			ids.add(attributeType.getAttribute_id() + "");
		}
		return ids;
	}

	private boolean isCandidateForDelivery(List recipients, List userGrps) {
		boolean isCandidate = false;
		Iterator it1 = recipients.iterator();
		Iterator it2 = userGrps.iterator();
		Set grpIds = new HashSet();
		while (it2.hasNext()) {
			grpIds.add(((UserGroupMap) it2.next()).getGroup_id() + "");
		}
		while (it1.hasNext()) {
			if (grpIds.contains(((Recipient) it1.next()).getRecipientId() + "")) {
				isCandidate = true;
				break;
			}
		}
		return isCandidate;
	}

	public AlertQueue getAlertQueueByKolid(long alertId, long kolid) {
		List result = getHibernateTemplate().find(
				"from AlertQueue q where q.alert.id=" + alertId
				+ " and q.kolid=" + kolid);
		if (result != null && result.size() > 0) {
			return (AlertQueue) result.get(0);
		} else {
			return null;
		}
	}

	public Alert getAlertByName(String alertName) {
		List result = getHibernateTemplate().find(
				"from Alert a where a.name like '" + alertName + "'");
		if (result != null && result.size() > 0) {
			return (Alert) result.get(0);
		} else {
			logger.debug("getAlertByName for " + alertName
					+ " returned 0 rows.");
			return null;
		}
	}

	public boolean deleteAlertQueueRecord(AlertQueue alertQueue) {
		try {
			getHibernateTemplate().delete(alertQueue);
			return true;
		} catch (Exception e) {
			logger.error("Error deleting Alert message : " + e.getMessage());
			return false;
		}
	}

	public List getChangesInTheLastMonth(Date fromDate,Date endDate){
		
		List result = null;
		try{
		result = getHibernateTemplate().find(
                "from  AlertAuditQueue a where ((a.createdAt between  '"
                + format.format(fromDate) + "' and '"
                + format.format(endDate)+ "') or (a.updatedAt between '"
                + format.format(fromDate) + "' and '"
                + format.format(endDate)+"'))");
		}catch(Exception e){
			System.err.println(e);
			System.out.println(e.getMessage());
		}
        return result;
		
	}
	
	/**
	 * Calculates the Total Payment made to a KOL. If the payment amount is
	 * greater than or equal to 70% of the KOL_SPENDING_CAP defined in the
	 * GLOBAL_CONSTANTS table then an Alert message is inserted in the
	 * ALERT_QUEUE table.
	 * 
	 * @param <code>String</code> currentKOLName
	 * @param <code>long</code> kolId
	 * 
	 * @return <code>boolean</code> success/failure flag
	 * @author Deepak Singh Rawat
	 * @version 1.0, 06/22/2008
	 * 
	 */

	/*Payment Alert - Commented
	 * public boolean setPaymentCapAlert(String currentKOLName, long kolId) {
		String spendingCap = null;
		spendingCap = globalConstantsService
		.getValueByName(Constants.KOL_SPENDING_CAP);
		StringAttribute[] stringAttributesForKOL = dataService
		.getAllValueForAttribute(kolId,
				OlConstants.KOL_MED_ED_PROFILE_PAYMENT_AMOUNT);
		double spendingCapAmount = 0;
		double paymentTotal = 0;
		if (spendingCap != null) {
			spendingCapAmount = Double.parseDouble(spendingCap);
		}
		if (stringAttributesForKOL != null && stringAttributesForKOL.length > 0) {
			for (int i = 0; i < stringAttributesForKOL.length; i++) {
				paymentTotal = paymentTotal
				+ Double.parseDouble(stringAttributesForKOL[i]
				                                            .getValue());
			}
		}
		double percentageSpent = (paymentTotal / spendingCapAmount) * 100;
		Alert alert = getAlertByName(Constants.PAYMENT_CAP_ALERT);
		if (percentageSpent >= Constants.PAYMENT_CAP_PERCENTAGE
				&& alert != null) {
			// format percentage to 2 decimal places
			String percentageRounded = new DecimalFormat("#.##")
			.format(percentageSpent);
			String alertMessage = percentageRounded
			+ "% threshold reached for Dr. " + currentKOLName;
			AlertQueue alertQueue = getAlertQueueByKolid(alert.getId(), kolId);
			if (alertQueue != null) { // message already present for the KOL.
				// Therefore, just update the message
				alertQueue.setMessage(alertMessage);
				updateAlertQueue(alertQueue);
			} else { // create a new record in the alert queue
				AlertQueue newAlertQueue = new AlertQueue();
				newAlertQueue.setAlert(alert);
				newAlertQueue.setCreatedAt(new Date());
				newAlertQueue.setMessage(alertMessage);
				newAlertQueue.setKolid(kolId);
				saveAlertQueue(newAlertQueue);
			}
		} else if (alert != null) {
			AlertQueue alertQueue = getAlertQueueByKolid(alert.getId(), kolId);
			if (alertQueue != null) { // message present for the KOL. However,
				// payment<Constants.PAYMENT_CAP_PERCENTAGE,
				// therefore delete the message
				deleteAlertQueueRecord(alertQueue);
			}

		}
		return false;
	}

	IGlobalConstantsService globalConstantsService;

	IDataService dataService;

	public IGlobalConstantsService getGlobalConstantsService() {
		return globalConstantsService;
	}

	public void setGlobalConstantsService(
			IGlobalConstantsService globalConstantsService) {
		this.globalConstantsService = globalConstantsService;
	}

	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}*/
	IMetadataService metadataService;

	public IMetadataService getMetadataService() {
		return metadataService;
	}

	public void setMetadataService(IMetadataService metadataService) {
		this.metadataService = metadataService;
	}
}
