package com.openq.web.controllers;

import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.alerts.IAlertsService;
import com.openq.eav.EavConstants;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.EntityType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.group.Groups;
import com.openq.group.IGroupService;
import com.openq.web.ActionKeys;

public class AlertController extends AbstractController {
    private IGroupService groupService;
    private IAlertsService alertsService;
    private IMetadataService metadataService;

    public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = null;

        HttpSession session = request.getSession();
        session.setAttribute("CURRENT_LINK", "ALERTS");
        String action = (String) request.getParameter("action");

        if( ActionKeys.ALERTS_DELETE.equalsIgnoreCase(action)) {
            String[] alertsToDel = (String[])request.getParameterValues("selected_alerts");
            if((alertsToDel != null) && (alertsToDel.length > 0 )) {
                for( int i = 0; i < alertsToDel.length; i++) {
                    alertsService.deleteAlert(Long.parseLong(alertsToDel[i]));
                }
            }
        }

        if( ActionKeys.ALERTS_STATUS.equalsIgnoreCase(action) ||
            ActionKeys.ALERTS_DELETE.equalsIgnoreCase(action)) {
            session.setAttribute(Constants.ALERTS, alertsService.getAllAlerts());
            mav = new ModelAndView("alertStatus");
        }

        if( mav == null ){
            mav = new ModelAndView("alertMain");
        }

        return mav;
    }

    public Map getAllGroups() {
        Map groupMap = new LinkedHashMap();
        Groups[] groups = groupService.getAllGroups();

        for(int i = 0; i < groups.length; i++ ) {
            groupMap.put(String.valueOf(groups[i].getGroupId()), groups[i].getGroupName());
        }

        return groupMap;
    }

    public Map getAllAttributes() {
        Map map = new LinkedHashMap();
        EntityType kol = metadataService.getEntityType(EavConstants.KOL_ENTITY_ID);
        EntityType institution = metadataService.getEntityType(EavConstants.INSTITUTION_ENTITY_ID);

        flattenEntityTree(EavConstants.KOL_ENTITY_ID, map, kol.getName());
        flattenEntityTree(EavConstants.INSTITUTION_ENTITY_ID, map, institution.getName());

        return map;
    }

    protected void flattenEntityTree(long id, Map map, String path) {
        AttributeType[] attrs = metadataService.getAllAttributes(id);
        String name = ( path !=null ) ? path : "";

        if (attrs != null && attrs.length > 0) {
            for (int i = 0; i < attrs.length; i++) {
                if (attrs[i].isEntity()) {
                    flattenEntityTree(attrs[i].getType(), map, name + " / " + attrs[i].getName() );
                } else {
                    map.put(String.valueOf(attrs[i].getAttribute_id()), name + " / " + attrs[i].getName());
                }
            }
        }
    }

    public void setAlertsService(IAlertsService service) {
        this.alertsService = service;
    }

    public IAlertsService getAlertsService() {
        return alertsService;
    }

    public void setMetadataService(IMetadataService service) {
        this.metadataService = service;
    }

    public IMetadataService getMetadataService() {
        return metadataService;
    }

    public void setGroupService(IGroupService service) {
        this.groupService = service;
    }

    public IGroupService getGroupService() {
        return groupService;
    }
}