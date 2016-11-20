package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authentication.UserDetails;
import com.openq.eav.EavConstants;
import com.openq.eav.business.ISelectionCriteriaService;
import com.openq.eav.data.EavAttribute;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.expert.ExpertDetails;
import com.openq.eav.expert.IExpertDetailsService;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.EntityType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.trials.TrialsConstants;
import com.openq.orx.agmen.ORXServices;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.IGlobalConstantsService;
import com.openq.utils.IHibernateUtilService;
import com.openq.utils.PropertyReader;

public class EditProfileAttributesController extends AbstractController {

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
			userGroupId = Long.parseLong(userGroupIdString);
		ModelAndView mav = new ModelAndView("editProfileAttributes");
		request.getSession().removeAttribute("attributesToAdd");
		request.getSession().removeAttribute("optionMap");
		request.getSession().removeAttribute("valueMap");
		request.getSession().removeAttribute("Message1");
		String editor = ((UserDetails) request.getSession().getAttribute(
				Constants.CURRENT_USER)).getUserName();
		session.setAttribute("profile_id", dataService.getAttributeIdFromName(
				PropertyReader.getEavConstantValueFor("ORG")).getAttribute_id()
				+ "");

		String attrIdString = request.getParameter("attributeId");
		long attributeId = Long.parseLong(attrIdString);
		String actionString = request.getParameter("action");

		if(attributeId == Constants.SELECTION_CRITERIA_ATTRIBUTEID &&
				!"save".equalsIgnoreCase(actionString)){
			AttributeType [] basicAttributes = (AttributeType []) request.getSession().getAttribute("basicAttributes");
			Map attrValueMap = (Map) session.getAttribute("attrValueMap");

			List criteriaList = selectionCriteriaService.getSelectionCriteria(basicAttributes, attrValueMap, true);
			if(criteriaList != null && criteriaList.size() == 5){

				JSONArray selectionCriteriaJSONArr = JSONArray.fromString(criteriaList.get(0)+"");
				Map selectionCriteriaMap = new HashMap();

				if(selectionCriteriaJSONArr != null && selectionCriteriaJSONArr.length() > 0){
					for(int i=0; i<selectionCriteriaJSONArr.length(); i++){
						JSONObject jsonObj = (JSONObject) selectionCriteriaJSONArr.get(i);
						selectionCriteriaMap.put(jsonObj.get("question"), jsonObj.get("type")) ;
					}
				}
				request.setAttribute("selectionCriteriaMap", selectionCriteriaMap);
				String TLStatusAttr = globalConstantsService.getValueByName("MSL_OL_TYPE");
				String SOIAttr = globalConstantsService.getValueByName("SPHERE_OF_INFLUENCE");
				request.setAttribute("TLStatusAttr", TLStatusAttr);
				request.setAttribute("SOIAttr", SOIAttr);
				request.setAttribute("TLStatusAttrId", criteriaList.get(1));
				request.setAttribute("SOIAttrId", criteriaList.get(3));
			}
			request.setAttribute("subTabAttributeIdString", attrIdString);
		}

		mav.addObject("attributeId", attrIdString);

		String entityIdString = request.getParameter("entityId") == null ? "-1"
				: request.getParameter("entityId");
		long entityId = Long.parseLong(entityIdString);
		mav.addObject("entityId", entityIdString);

		String parentIdString = request.getParameter("parentId");
		long parentId = Long.parseLong(parentIdString);
		mav.addObject("parentId", parentIdString);

		String entityAttrString = request.getParameter("entityAttr") == null ? "-1"
				: request.getParameter("entityAttr");
		long entityAttrId = Long.parseLong(entityAttrString);
		mav.addObject("entityAttr", entityAttrString);

		String tabName = request.getParameter("tabName");
		String currentKOLName = request.getParameter("currentKOLName");

		if (actionString != null && actionString.equals("save")) {
			long returnedEntityId = 0;
			if(session.getAttribute("ORG_LINK")!=null && !"NO".equalsIgnoreCase((String)session.getAttribute("ORG_LINK"))){
				EntityAttribute ea = new EntityAttribute();	

				ea = dataService.getEntityAttributeNew(entityId);
				if(ea!=null ){
					returnedEntityId = saveOrUpdate(request, ea.getMyEntity().getId(), attributeId, ea.getMyEntity().getId(), -1, editor);
					response.sendRedirect("showBasicAttributes.htm?attributeId="
							+ attrIdString + "&entityId=" + returnedEntityId+""
							+ "&parentId=" + parentIdString + "&currentKOLName="
							+ currentKOLName + "&tabName=" + tabName+"&fromEdit=true");
				}

			}else{
				returnedEntityId = saveOrUpdate(request, entityId, attributeId, parentId,
						entityAttrId, editor);

				if(attributeId == Constants.SELECTION_CRITERIA_ATTRIBUTEID &&
						"save".equalsIgnoreCase(actionString)){
					// refresh the My List cache
					String staffId = (String) session.getAttribute(Constants.CURRENT_STAFF_ID);
					if(staffId != null){
						List resultList = expertDetailsService.getExpertDetails(staffId);
						ExpertDetails[] myOL = null;
						if (resultList != null && resultList.size() > 0){
							myOL = (ExpertDetails[])(resultList.toArray(new ExpertDetails[resultList.size()]));
						}
						session.setAttribute("myOL", myOL);
					}
				}
				if("true".equals(request.getParameter("fromSelectionCriteriaPopup"))){
					return null;
				}else{
					response.sendRedirect("showBasicAttributes.htm?attributeId="
							+ attrIdString + "&entityId=" + returnedEntityId+""
							+ "&parentId=" + parentIdString + "&currentKOLName="
							+ currentKOLName + "&tabName=" + tabName+"&fromEdit=true");
				}
			}
			return null;
		}



		if (actionString != null && actionString.equals("createOrg")) {
			System.out.print("This is in the createorg key");
			session.setAttribute("Message1","The Organization has been added successfully");

			// create new organization
			EntityType et = metadataService
			.getEntityType(EavConstants.INSTITUTION_ENTITY_ID);
			Entity entity = new Entity();
			entity.setType(et);
			dataService.saveEntity(entity);

			EntityAttribute ea = new EntityAttribute();
			ea.setParent(entity);
			dataService.saveEntityAttribute(ea, metadataService
					.getAttributeType(Long.parseLong(PropertyReader
							.getEavConstantValueFor("ORG_PROFILE")))); // org
			// profile
			// id
			saveOrUpdate(request, ea.getMyEntity().getId(), attributeId, ea.getMyEntity().getId(), -1, editor);

			// response.sendRedirect("showBasicAttributes.htm?attributeId=" +
			// attrIdString + "&entityId=" + entityIdString + "&parentId=" +
			// parentIdString);
			// return mav;
		}

		// Amit - Code for creating a new trial
		if (actionString != null && actionString.equals("createTrial")) {
			// create new trial
			EntityType et = metadataService
			.getEntityType(TrialsConstants.TRIAL_ENTITY_ID);
			Entity entity = new Entity();
			entity.setType(et);
			entity.setDeleteFlag("N");
			dataService.saveEntity(entity);

			// Save the Trial Details attribute
			AttributeType type = metadataService.getAttributeType(TrialsConstants.TRIAL_DETAILS_ATTRIB_ID);
			EntityAttribute entityAttribute = new EntityAttribute();
			entityAttribute.setParent(entity);
			entityAttribute.setAttribute(type);
			dataService.saveEntityAttribute(entityAttribute, type);

			// Save the Trial Info attribute
			EntityAttribute ea = new EntityAttribute();
			ea.setParent(entity);
			dataService.saveEntityAttribute(ea, metadataService
					.getAttributeType(TrialsConstants.TRIAL_INFO_ATTRIB_ID)); 
			saveOrUpdate(request, ea.getMyEntity().getId(), attributeId, 
					et.getEntity_type_id(), -1, editor);


			// Redirect to trials info page
			mav = new ModelAndView("redirect:trials.htm");
			mav.addObject("entityId", entity.getId() + "");
		}
		// Amit - End of code for creating a new trial

		loadData(request, attributeId, entityAttrId, entityId,userGroupId);
		return mav;
	}

	private void loadData(HttpServletRequest request, long attrId,
			long entityAttrId, long entityId,long userGroupId) {
		HashMap optionMap = new HashMap();
		AttributeType type = metadataService.getAttributeType(attrId);
		long entityTypeId = type.getType();
		AttributeType[] attributes = metadataService
		.getAllShowableAttributes(entityTypeId);

		for (int i = 0; i < attributes.length; i++) {
			if (attributes[i].getType() == EavConstants.DROPDOWN_ID
					|| attributes[i].getType() == EavConstants.MULTI_SELECT_ID) {
				if(attributes[i].getParent().getName().equalsIgnoreCase(Constants.THOUGHT_LEADER_CRITERIA)){
//					Add custom code for thought selection criteria based on region of TL
					String rootParentId = (String) request.getSession().getAttribute("ROOT_PARENT_ID");
					AttributeType regionAttrId = dataService.getAttributeIdFromName(Constants.TL_REGION);
					StringAttribute regionValue = dataService.getAttributeValue(new Long(rootParentId), new Long(regionAttrId.getAttribute_id()));
					String region ="";
		            if (null!= regionValue){
		            	region =regionValue.getVal();
		            }
		            request.setAttribute("regionOfTL", region);
					String excludedValues[] = new String[2];
					if(optionService.getOptionNames(attributes[i].getOptionId()).getName().equalsIgnoreCase(Constants.SELECTION_CRITERIA_ANSWERS)){

						if(null!=regionValue && ""!= regionValue.getVal() && regionValue.getVal().equalsIgnoreCase(Constants.TL_REGION_INTERCON)){
							excludedValues[0] ="Yes";
						}else{
							excludedValues[0]="International";
							excludedValues[1]="National";
						}
					}
					OptionLookup options[] = optionService
					.getValuesForOptionWithExcludedValues(attributes[i].getOptionId(), userGroupId,excludedValues);
					optionMap.put(attributes[i],options);
					request.getSession().setAttribute("regionOfTL", region);
//					end of custom code for Thought Criteria
				}else{
					optionMap.put(attributes[i],optionService
							.getValuesForOption(attributes[i].getOptionId(), userGroupId));	
				}
			}
		}

		if (entityId == -1 && entityAttrId != -1) {
			entityId = dataService.getEntityAttribute(entityAttrId)
			.getMyEntity().getId();
		}

		HashMap valueMap = new HashMap();
		if (entityId != -1) {
			Entity entity = dataService.getEntity(entityId);
			ArrayList values = dataService.getAllAttributeValues(entity);

			// Create a map of option lookups
			for (int i = 0; i < values.size(); i++) {
				for (int j = 0; j < attributes.length; j++) {
					if (attributes[j].getAttribute_id() == ((EavAttribute) values
							.get(i)).getAttribute().getAttribute_id()) {
						valueMap.put(attributes[j], values.get(i));
					}
				}
			}
		}

		request.getSession().setAttribute("attributesToAdd", attributes);
		request.getSession().setAttribute("optionMap", optionMap);
		request.getSession().setAttribute("valueMap", valueMap);
		
	}

	private long saveOrUpdate(HttpServletRequest request, long entityId,
			long attributeId, long parentId, long entityAttrId, String editor) {
		// entityId is not available
		if (entityId == -1 && entityAttrId == -1) {
			// need to create a child node of this type
			EntityAttribute entityAttribute = new EntityAttribute();
			entityAttribute.setParent(dataService.getEntity(parentId));
			AttributeType at = metadataService.getAttributeType(attributeId);
			entityAttribute.setAttribute(at);
			dataService.saveEntityAttribute(entityAttribute, at);

			// dataService.saveOLProfile(entityAttribute.getMyEntity());
			entityId = entityAttribute.getMyEntity().getId();
		} else if (entityId == -1 && entityAttrId != -1) {
			// get the entity id if of this entity attribute
			entityId = dataService.getEntityAttribute(entityAttrId)
			.getMyEntity().getId();
		}


		long tabAttributeId = attributeId;
		//This is the attribute Id of the Tab
		// Now to figure out how to find the kolid ie the rootEntityId from the parentId
		//	which is the entityId of the Profile.
		EntityAttribute[] entityAttrs = dataService.getEntityAttributes(parentId);
		long rootEntityId = entityAttrs[0].getParent().getId();
		rootEntityId = entityAttrs[0].getParent().getId();
		long rowId = 0;

		if(metadataService.getAttributeType(tabAttributeId).isArraylist())
		{
			if(entityAttrs[0].getRowId()<=0)
			{ rowId = hibernateUtilService.getUniqueRowId() ;
			logger.info("Row Id did not exist\n\n"+rowId+"\n\n");
			}
			else
			{ 
				rowId= entityAttrs[0].getRowId();
				logger.info("Row Id existed\n\n"+rowId+"\n\n");
			}
		}
		//Code ends here
		boolean register = dataService.saveOrUpdateAttributes(entityId,
				request, editor,tabAttributeId,rootEntityId,rowId);
		// if this Ol needs to be registered with ORX
		if (register) {
			try {
				String kolIString = (String) request.getSession().getAttribute(
						Constants.CURRENT_KOL_ID);
				long kId = Long.parseLong(kolIString);
				User user = userService.getUser(kId);
				dataService.getCustomAttributesForOl(user);
				ORXServices orxService = new ORXServices();
				orxService.registerObject(user.getFirstName(), user
						.getMiddleName(), user.getLastName(),
						user.getId() + "", user.getSpeciality(), user
						.getLocation());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		// Amit - set the last update time for this OL

		// TODO: check if this is the right place to set the update time
		if (request.getSession().getAttribute(Constants.CURRENT_KOL_ID) != null) {
			String kolIString = (String) request.getSession().getAttribute(
					Constants.CURRENT_KOL_ID);
			//System.out.println("current KOL Id is " + kolIString);
			long kId = Long.parseLong(kolIString);
			if(kId!=-1){
				User user = userService.getUser(kId);

				user.setLastUpdateTime(System.currentTimeMillis());
				userService.updateUser(user);
			}	
		}
		return entityId;
		// Amit - set the last update time for this OL
	}

	private IDataService dataService;

	private IMetadataService metadataService;

	private IOptionService optionService;

	private IUserService userService;

	private IHibernateUtilService hibernateUtilService;

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

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

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	public IHibernateUtilService getHibernateUtilService() {
		return hibernateUtilService;
	}

	public void setHibernateUtilService(IHibernateUtilService hibernateUtilService) {
		this.hibernateUtilService = hibernateUtilService;
	}
	ISelectionCriteriaService selectionCriteriaService;

	public ISelectionCriteriaService getSelectionCriteriaService() {
		return selectionCriteriaService;
	}

	public void setSelectionCriteriaService(
			ISelectionCriteriaService selectionCriteriaService) {
		this.selectionCriteriaService = selectionCriteriaService;
	}
	IGlobalConstantsService globalConstantsService;

	public IGlobalConstantsService getGlobalConstantsService() {
		return globalConstantsService;
	}

	public void setGlobalConstantsService(
			IGlobalConstantsService globalConstantsService) {
		this.globalConstantsService = globalConstantsService;
	}
	IExpertDetailsService expertDetailsService;

	public IExpertDetailsService getExpertDetailsService() {
		return expertDetailsService;
	}

	public void setExpertDetailsService(IExpertDetailsService expertDetailsService) {
		this.expertDetailsService = expertDetailsService;
	}

}
