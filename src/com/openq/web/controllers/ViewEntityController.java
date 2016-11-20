package com.openq.web.controllers;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.utils.PropertyReader;

public class ViewEntityController extends AbstractController
{
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        ModelAndView mav = new ModelAndView("institutions");
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


            //Entering values in Entity Attribute Table for newly created node
            for (int i = 0; i < attrTypes.length; i++)
            {
                if (attrValuesMap != null && !attrValuesMap.containsKey(attrTypes[i]))
                {
                    long entityIdnew = -1;

                    if(attrValuesMap != null && attrValuesMap.get(attrTypes[i]) != null)
                       entityIdnew = ((EntityAttribute) attrValuesMap.get(attrTypes[i])).getMyEntity().getId();
                    long parentIdnew = entityId;
                    long attrIdnew = attrTypes[i].getAttribute_id();
                    entityIdnew = dataService.createEntityIfRequired(entityIdnew, attrIdnew, parentIdnew);
                    EntityAttribute[] eat = dataService.getEntityAttributes(entityIdnew);
                    attrValuesMap.put(attrTypes[i], eat[0]);
                }
            }            

            session.setAttribute("attrTypes", attrTypes);
			session.setAttribute("attributesMap", attrValuesMap);
            session.setAttribute("leftNavMap", initializeLeftNavMapForOrgs(entityId));
            session.setAttribute("ORGNAME",initializeLeftNavMapForOrgs(entityId).get(PropertyReader.getEavConstantValueFor("ORG_NAME")));
            session.setAttribute("ORGID",entityIdString);
            session.setAttribute("ORG_LINK","YES");
            mav.addObject("parentId", entityIdString);

        }

	
        String selectedTab = request.getParameter("selectedTab");
        if (selectedTab != null && !selectedTab.equals(""))
			mav.addObject("selectedTab", selectedTab);
		else
			mav.addObject("selectedTab", "0"); // default selected tab

		return mav;
	}
	
	private static final long ORG_PROFILE_ID = Long.parseLong(PropertyReader.getEavConstantValueFor("ORG_PROFILE"));

	/*private static final long NAME_ATTR_ID = OrganizationService.nameAttributeId;
	private static final long ADD_ATTR_ID = 175l;
	private static final long STATE_ATTR_ID = 179l;
	private static final long ZIP_ATTR_ID = 181l;
	private static final long PHONE_ATTR_ID = 169l;*/

	private HashMap initializeLeftNavMapForOrgs(long entityId) {
		HashMap leftNavMap = new HashMap();
		EntityAttribute [] profile = dataService.getEntityAttributes(entityId, ORG_PROFILE_ID);
		
		if (profile != null && profile.length > 0) {
			EntityAttribute p = profile[0];
			StringAttribute [] attributes = dataService.getStringAttribute(p.getMyEntity());

			for (int i=0; i<attributes.length; i++) {
				leftNavMap.put(attributes[i].getAttribute().getAttribute_id() + "", attributes[i].toString());
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
