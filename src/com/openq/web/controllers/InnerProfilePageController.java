package com.openq.web.controllers;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.Notify.INotifyService;
import com.openq.Notify.Notification;
import com.openq.authentication.UserDetails;
import com.openq.authorization.IPrivilegeService;
import com.openq.authorization.Privilege;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.userPreference.IUserPreferenceService;
import com.openq.userPreference.UserPreference;
import com.openq.utils.PropertyReader;

public class InnerProfilePageController extends AbstractController {
	
	INotifyService notifyService;
	IUserPreferenceService userPreferenceService;
	
	public void setCallNotification(long kolId, long uId, String action) {
	    Notification notification = null ;     
        notification = new Notification();
        notification.setAttribute_id(-1);
        notification.setKolId(kolId);
        notification.setUserId(uId);
        
        if(action.equalsIgnoreCase("registerNotify")) {
           notifyService.deregisterNotification(notification);
           notifyService.registerNotification(notification);
           if(!userPreferenceService.userExist(notification.getUserId())) {
               UserPreference userPreference = new UserPreference();   
               userPreference.setFrequency(0);
               userPreference.setUserId(notification.getUserId());
               userPreferenceService.savePreference(userPreference) ;
           }
        }
        else
           if(action.equalsIgnoreCase("deregisterNotify"))
               notifyService.deregisterNotification(notification);
               /* Optimize the userPreference table*/
    }

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
        ModelAndView mav = new ModelAndView("innerProfilePage");
		String attributeIdString = request.getParameter("attributeId");
		String entityIdString = request.getParameter("entityId");
		String parentIdString = request.getParameter("parentId");
		String rootParentIdString = request.getParameter("rootParentId");
		String action = request.getParameter("action");
		String kolIdString = request.getParameter("kolId");
		
		String fromExpertFullProfile = request.getParameter("fromExpertFullProfile");
		
		request.setAttribute("ROOT_PARENT_ID", rootParentIdString);
		request.getSession().setAttribute("ROOT_PARENT_ID", rootParentIdString);
		
		request.setAttribute("displayName", request.getParameter("displayName"));
		
		session.setAttribute("ParID",parentIdString);
		long uId=-1;
		UserDetails userDetails = (UserDetails) request.getSession().getAttribute(Constants.CURRENT_USER);
		if(null!=userDetails){
			String userId = (String)userDetails.getId();
			uId = Long.parseLong(userId);
		}
		
		long attrId = -1;
		if(attributeIdString!=null)
		attrId = Long.parseLong(attributeIdString);
		long kolId = -1;
		if(kolIdString!=null)
		 kolId = Long.parseLong(kolIdString);
		AttributeType attr = null;
		if(attrId != -1)
		attr = metadataService.getAttributeType(attrId);

        if(action!=null) {
            setCallNotification(kolId, uId, action);
        }
        session.setAttribute("profile_id", dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ORG")).getAttribute_id()+"");                
        
        if(fromExpertFullProfile !=null) {
            if(fromExpertFullProfile.equals("true")) {
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write("");
                response.getWriter().close();
                return null;
            }
        }
    
		String page = request.getParameter("page");
		
		//if(!"contactsNotify".equalsIgnoreCase(request.getParameter("page")) && !"print")
		{
		mav =  new ModelAndView("innerProfilePage");
		setCRUDPermissions(mav, attrId, attr.getParent().getEntity_type_id(), uId,session);
		if (entityIdString != null && !entityIdString.equals("")) {
			// if all its attributes are leaf nodes, just propogate this entity
			// Id
			long entityId = Long.parseLong(entityIdString);
			Entity entity = dataService.getEntity(entityId);
			AttributeType[] subAttributes = metadataService
				.getAllShowableAttributesFilteredByPermissions(entity.getType().getEntity_type_id(), ((UserDetails) request.getSession()
                    .getAttribute(Constants.CURRENT_USER)).getId(), privilegeService);

			request.getSession().setAttribute("attribute", attr);
			request.getSession().setAttribute("subAttributes", subAttributes);
			request.removeAttribute("selectedTab");
			request.removeAttribute("selectedTabName");

			mav.addObject("selectedTab", "" + attrId);
			mav.addObject("selectedTabName", "" + attr.getName());

			// does this entity have sub entities
			if (!attr.isArraylist() && subAttributes != null
					&& subAttributes.length > 0 && subAttributes[0].isEntity()) {
				// set default selected inner tab
				mav.addObject("selectedTab", ""
						+ subAttributes[0].getAttribute_id());
				mav.addObject("selectedTabName", ""
						+ subAttributes[0].getName());

				EntityAttribute[] entityAttributes = dataService
						.getAllEntityAttributes(entity);
                HashMap map = new HashMap();
                if (entityAttributes != null && entityAttributes.length > 0) {

					for (int i = 0; i < subAttributes.length; i++) {
						boolean found = false;
						for (int j = 0; j < entityAttributes.length; j++) {
							if (entityAttributes[j].getAttribute()
									.getAttribute_id() == subAttributes[i]
									.getAttribute_id()) {
								// make sure that array elements do not get
								// added twice
								found = true;
								if (!map.containsKey(subAttributes[i]))
									map.put(subAttributes[i],
											entityAttributes[j]);
								break;
							}
						}
						if (!found) {
							// this could be an array element with no child
							if (!map.containsKey(subAttributes[i])) {
								EntityAttribute eat = new EntityAttribute();
								eat.setId(subAttributes[i].getAttribute_id());
								Entity myE = new Entity();
								myE.setId(-1);
								eat.setMyEntity(myE);
								eat.setParent(entity);
								//map.put(subAttributes[i], eat);
							}
						}
					}

			}
				// Entering values in entity attribute table for newly added nodes
		   for (int i = 0; i < subAttributes.length; i++) {
			   if (!map.containsKey(subAttributes[i]))
					{
						long entityIdnew = -1;
						long parentIdnew = entityId;
						long attrIdnew = subAttributes[i].getAttribute_id();
						entityIdnew = dataService.createEntityIfRequired(entityIdnew, attrIdnew, parentIdnew);
						EntityAttribute[] eat = dataService.getEntityAttributes(entityIdnew);
						map.put(subAttributes[i], eat[0]);
					}
				}
				request.getSession().setAttribute("entityAttributesMap",
						map);
				mav.addObject("entityId", ((EntityAttribute) map.get(subAttributes[0])).getMyEntity()
						.getId()
						+ "");
				mav.addObject("parentId", entityIdString);


            } else {
				// this is an array or normal entity (an entity that does not contain sub-entities)
				mav.addObject("parentId", parentIdString);
				mav.addObject("entityId", entityIdString);
				//setCRUDPermissions(mav, attrId, attr.getParent().getEntity_type_id(), uId);
			}
		} else if (attributeIdString != null && !attributeIdString.equals("")) {
			//long attrId = Long.parseLong(attributeIdString);
			//setCRUDPermissions(mav, attrId, attr.getParent().getEntity_type_id(), uId);

			// Get attribute of this tab
			//AttributeType attr = metadataService.getAttributeType(attrId);
			AttributeType[] subAttributes = metadataService
			.getAllShowableAttributesFilteredByPermissions(attr.getType(), ((UserDetails) request.getSession()
                    .getAttribute(Constants.CURRENT_USER)).getId(), privilegeService);

			request.getSession().setAttribute("attribute", attr);
			request.getSession().setAttribute("subAttributes", subAttributes);
			request.removeAttribute("selectedTab");
			request.removeAttribute("selectedTabName");

			mav.addObject("selectedTab", "" + attrId);
			mav.addObject("selectedTabName", "" + attr.getName());

			if (!attr.isArraylist() && subAttributes != null
					&& subAttributes.length > 0 && subAttributes[0].isEntity()) {
				// set default selected inner tab
				mav.addObject("selectedTab", ""
						+ subAttributes[0].getAttribute_id());
				mav.addObject("selectedTabName", ""
						+ subAttributes[0].getName());
			}
		  }
				
		}
	
		return mav;
	}

	public void setCRUDPermissions(ModelAndView mav, long attrId, long entityTypeId, long userId,HttpSession session) {
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
		
		if (!privilegeService.wrappedIsOperationAllowed(userId, featureKey, Privilege.READ)) {
			// hide edit button
			session.setAttribute("readEntity", "disabled");
		}
	}

	IMetadataService metadataService;
	IPrivilegeService privilegeService;
	IDataService dataService;

	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}

	public IMetadataService getMetadataService() {
		return metadataService;
	}

	public void setMetadataService(IMetadataService metadataService) {
		this.metadataService = metadataService;
	}

	public IPrivilegeService getPrivilegeService() {
		return privilegeService;
	}

	public void setPrivilegeService(IPrivilegeService privilegeService) {
		this.privilegeService = privilegeService;
	}

	public INotifyService getNotifyService() {
		return notifyService;
	}

	public void setNotifyService(INotifyService notifyService) {
		this.notifyService = notifyService;
	}

	public IUserPreferenceService getUserPreferenceService() {
		return userPreferenceService;
	}

	public void setUserPreferenceService(
			IUserPreferenceService userPreferenceService) {
		this.userPreferenceService = userPreferenceService;
	}
}
