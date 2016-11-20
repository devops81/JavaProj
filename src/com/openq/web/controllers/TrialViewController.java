package com.openq.web.controllers;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.EavConstants;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.trials.TrialsConstants;

public class TrialViewController extends AbstractController
{
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        ModelAndView mav = new ModelAndView("trials");
		String entityIdString = request.getParameter("entityId");

		long entityId; // default entity to show

		if (entityIdString != null && !entityIdString.equals("")) {
			entityId = Long.parseLong(entityIdString);
			Entity entity = dataService.getEntity(entityId);
			EntityAttribute [] attributes = dataService.getAllEntityAttributes(entityId);		
			AttributeType [] attrTypes = metadataService.getAllAttributes(entity.getType().getEntity_type_id());
			
			HashMap attrValuesMap = new HashMap();
			for (int i=0; i<attrTypes.length; i++) {
				for (int j=0; j<attributes.length; j++) {
					if (attrTypes[i].getAttribute_id() == attributes[j].getAttribute().getAttribute_id()) {
						attrValuesMap.put(attrTypes[i], attributes[j]);
					}
				}
			}

			session.setAttribute("attrTypes", attrTypes);
			session.setAttribute("attributesMap", attrValuesMap);
            session.setAttribute("leftNavMap", initializeLeftNavMapForTrials(entityId));
            
            mav.addObject("parentId", entityIdString);

        }

	
        String selectedTab = request.getParameter("selectedTab");
        if (selectedTab != null && !selectedTab.equals(""))
			mav.addObject("selectedTab", selectedTab);
		else
			mav.addObject("selectedTab", "0"); // default selected tab

		return mav;
	}

	private HashMap initializeLeftNavMapForTrials(long entityId) {
		HashMap leftNavMap = new HashMap();
		EntityAttribute [] profile = dataService.getEntityAttributes(entityId, TrialsConstants.TRIAL_INFO_ATTRIB_ID);
		
		System.out.println("Found " + profile.length + " entity attribs of type " + TrialsConstants.TRIAL_INFO_ATTRIB_ID);
		
		if (profile != null && profile.length > 0) {
			for(int i=0; i<profile.length; i++) {
				EntityAttribute p = profile[i];
				StringAttribute [] attributes = dataService.getStringAttribute(p.getMyEntity());
	
				for (int j=0; j<attributes.length; j++) {
					System.out.println("Putting : " + attributes[j].getAttribute().getAttribute_id());
					leftNavMap.put(attributes[j].getAttribute().getAttribute_id() + "", attributes[j].toString());
				}
			}
		}
		return leftNavMap;
	}
	
	IMetadataService metadataService;
	IDataService dataService;
	
	public IMetadataService getMetadataService() {
		return metadataService;
	}

	public void setMetadataService(IMetadataService metadataService) {
		this.metadataService = metadataService;
	}

	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}
}
