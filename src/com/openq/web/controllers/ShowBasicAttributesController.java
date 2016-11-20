package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.audit.IDataAuditService;
import com.openq.authentication.UserDetails;
import com.openq.authorization.IPrivilegeService;
import com.openq.authorization.Privilege;
import com.openq.eav.audit.AuditInfo;
import com.openq.eav.audit.IAuditService;
import com.openq.eav.data.EavAttribute;
import com.openq.eav.data.EavTableRowComparator;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.group.IUserGroupMapService;
import com.openq.web.ActionKeys;

public class ShowBasicAttributesController extends AbstractController {

    protected ModelAndView handleRequestInternal(HttpServletRequest request,
                                                 HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("showBasicAttributes");
        request.getSession().removeAttribute("attrValueMap");
        request.getSession().removeAttribute("primaryAddressExists");
        request.getSession().removeAttribute("preferredContactExists");
        request.getSession().removeAttribute("totalPositionToAmgenScienceExists");
        String fromProfile = (String) request.getSession().getAttribute("FromProfile");
        if(fromProfile !=null && fromProfile.equalsIgnoreCase(ActionKeys.SHOW_EVENTS_BY_EXPERT)){
            mav = new ModelAndView("eventsByExpert");
            return mav;
        }
        // This entity has basic attributes only
        String attrIdString = request.getParameter("attributeId");
        long attrId = Long.parseLong(attrIdString);
        mav.addObject("attributeId", attrIdString);
        String entityIdString = request.getParameter("entityId");
        long entityId = -1;
        if (entityIdString != null && !entityIdString.trim().equals(""))
            entityId = Long.parseLong(entityIdString);
        mav.addObject("entityId", entityIdString);
        String parentIdString = request.getParameter("parentId");
        long parentId = Long.parseLong(parentIdString);
        String fromEditAttr = request.getParameter("fromEdit");
        if(fromEditAttr!=null&&fromEditAttr.equals("true"))
        {
          System.out.println("edited and saved");
          System.out.println("Attribute Id"+attrId+"EntityId"+entityId+"ParnetId"+parentId);
          
          request.getSession().setAttribute("FROM_EDIT_ATTR", "true");
        }
        else
        {
          request.getSession().removeAttribute("FROM_EDIT_ATTR");
        }
        String fromProfileSummary = request.getParameter("profileSummary");
        if(fromProfileSummary!=null)
        {
        	//mav.addObject("profileSummary", fromProfileSummary);
            request.getSession().setAttribute("profileSummary","true");
            request.setAttribute("profileSummary","true");
            
        }
        else
        {
        	request.getSession().removeAttribute("profileSummary");
        }
        entityId = createEntityIfRequired(entityId, attrId, parentId);
        entityIdString = "" + entityId;
        String userId = ((UserDetails) request.getSession().getAttribute(Constants.CURRENT_USER)).getId();
        long uId = Long.parseLong(userId);
       
        AttributeType attrType = metadataService.getAttributeType(attrId);
        setCRUDPermissions(mav, attrId, attrType.getParent().getEntity_type_id(), uId, request);

        String [] rowsToDelete = request.getParameterValues("rowsToDelete");
        for (int i=0; rowsToDelete != null && i < rowsToDelete.length; i++) {
            dataService.deleteArrayElement(Long.parseLong(rowsToDelete[i]));
        }


        AttributeType [] basicAttributes = metadataService.getAllShowableAttributes(attrType.getType());

        if (entityIdString != null && !entityIdString.equals("") && !attrType.isArraylist()) {
            ArrayList allAttributes = dataService.getAllAttributeValues(dataService.getEntity(entityId));
            HashMap map = new HashMap();
            
            List idList = new ArrayList();
            for (int i=0; i <basicAttributes.length; i++) {
                for (int j=0; j<allAttributes.size(); j++) {
                    if (basicAttributes[i].getAttribute_id() == ((EavAttribute) allAttributes.get(j)).getAttribute().getAttribute_id()) {
                        map.put(basicAttributes[i], allAttributes.get(j));
                        idList.add(new Long(((EavAttribute) allAttributes.get(j)).getId()));
                    }
                }
            }
            
            request.getSession().setAttribute("attrValueMap", map);

            //Audit data should be disabled in PrintSummaryProfile page
            if(fromProfileSummary == null){
                // This map maintains audit data of the attributes
            Map auditMap = dataAuditService.getLatest(idList, "value");
            
            //AuditInfo source = auditService.getOldestAuditInfo(entityId);
            AuditInfo source = auditService.getOldestAuditInfo(entityId);
//            request.getSession().setAttribute("auditLastUpdated", lastUpdated);
            // Set the audit info in the session
            request.getSession().setAttribute("auditLastUpdated", auditMap);
            request.getSession().setAttribute("dataSource", source);
            }
            else{
                //To avoid any exception create empty objects
                request.getSession().setAttribute("auditLastUpdated", new HashMap());
                request.getSession().setAttribute("dataSource", new AuditInfo());
            }
        } else if (entityIdString != null && !entityIdString.equals("")) {
            // we are dealing with array type
            mav.addObject("parentId", parentIdString);

            EntityAttribute [] entityArray = dataService.getEntityAttributes(parentId, attrId);
            if (entityArray != null) {
                EavTableRowComparator comparator = new EavTableRowComparator();
                comparator.setDataService(dataService);
                SortedMap map = new TreeMap(comparator);
                //HashMap map = new HashMap();

                List idList = new ArrayList();
                for (int i=0; i<entityArray.length; i++) {
                    Entity myEntity = entityArray[i].getMyEntity();
                    ArrayList allAttributes = dataService.getAllAttributeValues(myEntity);
                    map.put(entityArray[i], allAttributes);
                   //qsaz customChecks(entityArray[i], (ArrayList) map.get(entityArray[i]), request);

                    for (int j=0; j<allAttributes.size(); j++) {
                        idList.add(new Long(((EavAttribute) allAttributes.get(j)).getId()));
                    }
                }
                
                // This map maintains audit data of the attributes
                Map auditMap = dataAuditService.getLatest(idList, "value");

                request.getSession().setAttribute("attrValueMap", map);

                // Set the audit info in the session
                request.getSession().setAttribute("auditLastUpdated", auditMap);
            }
        }

        request.getSession().setAttribute("basicAttributes", basicAttributes);
        request.getSession().setAttribute("parentIsArray", attrType.isArraylist() ? "true" : "false");

        return mav;
    }

    public void setCRUDPermissions(ModelAndView mav, long attrId, long entityTypeId, long userId, HttpServletRequest request) {
        String featureKey = metadataService.getFeatureKeyForAttribute(entityTypeId, attrId);
        if (!privilegeService.wrappedIsOperationAllowed(userId, featureKey, Privilege.CREATE)) {
            // hide add button
            mav.addObject("disableAddButton", "disabled");
        }
        if (!privilegeService.wrappedIsOperationAllowed(userId, featureKey, Privilege.DELETE)) {
            // hide delete button
            mav.addObject("disableDeleteButton", "disabled");
        }
        if (!privilegeService.wrappedIsOperationAllowed(userId, featureKey, Privilege.UPDATE)) {
            // hide edit button
            mav.addObject("disableEditButton", "disabled");
        }
		// Custom rule: Is this a GCO user
		long groupId = userGroupMapService.getGroupIdForUser(userId);
		/*if ((groupId >= 33 && groupId <= 39) || groupId == 31)
		{
			request.getSession().setAttribute("_hideAdvisoryBoardRow", "true");
		}*/
    }

    private long createEntityIfRequired(long entityId, long attrId, long parentId) {
        if (entityId > 0)
            return entityId;
        if (entityId < 0 && attrId > 0 && parentId >0) {
            // create the child entity
            EntityAttribute ea = new EntityAttribute();
            ea.setParent(dataService.getEntity(parentId));
            dataService.saveEntityAttribute(ea, metadataService.getAttributeType(attrId));
            return ea.getMyEntity().getId();
        }
        return entityId;
    }

   /* private void customChecks(EntityAttribute attribute, ArrayList list, HttpServletRequest request) {
        for (int i=0; (list != null && i<list.size()); i++) {
            if (((EavAttribute) list.get(i)).getAttribute().getAttribute_id() == OlConstants.KOL_OL_Summary_Address_Usage) {
                // address usage
                if (("" + list.get(i)).equals("Primary")) {
                    request.getSession().setAttribute("primaryAddressExists", "true");
                }
            } else if (((EavAttribute) list.get(i)).getAttribute().getAttribute_id() == OlConstants.KOL_OL_Summary_Contact_Mechanism_Preferred_Contact) {
                // preferred contact
                if (!("" + list.get(i)).equals("")) {
                    request.getSession().setAttribute("preferredContactExists", "true");
                }
            } else if (((EavAttribute) list.get(i)).getAttribute().getAttribute_id() == OlConstants.KOL_Amgen_Profile_Position_to_Amgen_Science_Therapy) {
                if (("" + list.get(i)).trim().equals("Total")) {
                    request.getSession().setAttribute("totalPositionToAmgenScienceExists", attribute.getId() + "");
                }
            }
        }
    }*/

    IMetadataService metadataService;
    IDataService dataService;
    IAuditService auditService;
    IDataAuditService dataAuditService;
    IPrivilegeService privilegeService;
	IUserGroupMapService userGroupMapService;

	public IUserGroupMapService getUserGroupMapService() {
		return userGroupMapService;
	}


	public void setUserGroupMapService(IUserGroupMapService userGroupMapService) {
		this.userGroupMapService = userGroupMapService;
	}

    public IPrivilegeService getPrivilegeService() {
        return privilegeService;
    }

    public void setPrivilegeService(IPrivilegeService privilegeService) {
        this.privilegeService = privilegeService;
    }

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

    public IAuditService getAuditService() {
        return auditService;
    }

    public void setAuditService(IAuditService auditService) {
        this.auditService = auditService;
    }

    public IDataAuditService getDataAuditService() {
        return dataAuditService;
    }

    public void setDataAuditService(IDataAuditService dataAuditService) {
        this.dataAuditService = dataAuditService;
    }
}
