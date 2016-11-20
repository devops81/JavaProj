package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.Date;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;
import java.util.HashMap;
import java.util.List;

import org.springframework.web.servlet.ModelAndView;

import com.openq.web.ActionKeys;
import com.openq.alerts.data.Alert;
import com.openq.alerts.data.AlertDetail;
import com.openq.alerts.data.Recipient;
import com.openq.alerts.IAlertsService;

public class EditAlertController extends AlertController {
    public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        session.setAttribute("CURRENT_LINK", "EDIT_ALERTS");

        String action = (String) request.getParameter("action");

        if( ActionKeys.ALERTS_STEP1.equalsIgnoreCase(action)) {
            Alert alert = getAlertsService().getAlert(Long.parseLong(request.getParameter("id")));
            List alertDetails = alert.getAlertDetails();
            Map savedAttrMap = new HashMap();

            for ( Iterator iter = alertDetails.iterator(); iter.hasNext(); ) {
              AlertDetail detail = (AlertDetail)iter.next();
              String attrId = String.valueOf(detail.getAttributeId());
              savedAttrMap.put(attrId, detail);
            }

            session.setAttribute(Constants.ALERT_OBJ, alert);
            session.setAttribute(Constants.SAVED_ATTRIBUTE_MAP, savedAttrMap);
            session.setAttribute(Constants.ATTRIBUTE_MAP, getAllAttributes());
            return new ModelAndView("editAlertStep1");
        }

        if( ActionKeys.ALERTS_STEP2.equalsIgnoreCase(action)) {
            session.setAttribute(Constants.ALERT_NAME, request.getParameter("alert_name"));
            session.setAttribute(Constants.ATTRIBUTE_LIST, request.getParameterValues("attributes"));
            return new ModelAndView("editAlertStep2");
        }

        if( ActionKeys.ALERTS_STEP3.equalsIgnoreCase(action)) {
            String[] attrList = (String[])session.getAttribute(Constants.ATTRIBUTE_LIST);
            Alert alert = (Alert)session.getAttribute(Constants.ALERT_OBJ);

            if(( attrList != null ) && ( attrList.length > 0 )) {
                Map map = new HashMap();
                for( int i = 0; i < attrList.length; i++ ) {
                    map.put(attrList[i], request.getParameter(attrList[i]));
                }
                session.setAttribute(Constants.ATTRIBUTE_ALERT_MAP, map);
            }

            List recipients = alert.getRecipients();
            Map savedRecipientMap = new HashMap();

            for ( Iterator iter = recipients.iterator(); iter.hasNext(); ) {
              Recipient recipient = (Recipient)iter.next();
              String recipientId = String.valueOf(recipient.getRecipientId());
              savedRecipientMap.put(recipientId, recipient);
            }

            session.setAttribute(Constants.SAVED_RECIPIENT_MAP, savedRecipientMap);
            session.setAttribute(Constants.GROUPS, getAllGroups());
            return new ModelAndView("editAlertStep3");
        }

        if( ActionKeys.ALERTS_SAVE.equalsIgnoreCase(action)) {
            //Get properties from the previous posts from the session
            Alert alert = (Alert)session.getAttribute(Constants.ALERT_OBJ);
            String alertName = (String)session.getAttribute(Constants.ALERT_NAME);
            Map attributeAlertMap = (Map)session.getAttribute(Constants.ATTRIBUTE_ALERT_MAP);
            Map groups = (Map)session.getAttribute(Constants.GROUPS);

            //Get properties from the recent post from the request
            String message = request.getParameter("message");
            String[] groupIds = request.getParameterValues("groups");
            Map groupMap = new HashMap();

            if(( groupIds != null ) && ( groupIds.length > 0 )) {
                for( int i = 0; i < groupIds.length; i++ ) {
                    groupMap.put(groupIds[i], groups.get(groupIds[i]));
                }
            }

            updateAlert(alert, alertName, message, attributeAlertMap, groupMap);
            session.setAttribute(Constants.ALERTS, getAlertsService().getAllAlerts());
            return new ModelAndView("alertStatus");
        }

        return null;
    }

    public void updateAlert(Alert alert, String alertName, String message, Map attributeAlertMap, Map groupMap) {
        List alertDetails = alert.getAlertDetails();
        List alertRecipients = alert.getRecipients();

        alert.setName(alertName);
        if(( message != null ) && ( !"".equals(message.trim()))) {
            alert.setMessage(message.trim());
        }
        alert.setDelivery(Alert.DELIVERY_UI);
        alert.setUpdatedAt(new Date());

        for( Iterator iter = alertDetails.iterator(); iter.hasNext(); ) {
            AlertDetail detail = (AlertDetail)iter.next();
            String attributeId = String.valueOf(detail.getAttributeId());
            String operator = (String)attributeAlertMap.get(attributeId);

            if(attributeAlertMap.containsKey(attributeId)) {
                detail.setOperator(Integer.parseInt(operator));
                attributeAlertMap.remove(attributeId);
            } else {
                iter.remove();
            }
        }

        for( Iterator iter = alertRecipients.iterator(); iter.hasNext(); ) {
            Recipient recipient = (Recipient)iter.next();
            String recipientId = String.valueOf(recipient.getRecipientId());

            if(groupMap.containsKey(recipientId)) {
                groupMap.remove(recipientId);
            } else {
                iter.remove();
            }
        }

        for( Iterator iter = attributeAlertMap.keySet().iterator(); iter.hasNext(); ) {
            String attributeId = (String)iter.next();
            String operator = (String)attributeAlertMap.get(attributeId);

            AlertDetail detail = new AlertDetail();
            detail.setAttributeId(Integer.parseInt(attributeId));
            detail.setOperator(Integer.parseInt(operator));
            alertDetails.add(detail);
        }

        for( Iterator iter = groupMap.keySet().iterator(); iter.hasNext(); ){
            String id = (String)iter.next();
            String name = (String)groupMap.get(id);

            Recipient recipient = new Recipient();
            recipient.setRecipientId(Integer.parseInt(id));
            recipient.setRecipientName(name);
            alertRecipients.add(recipient);
        }

        getAlertsService().updateAlert(alert);
    }
}