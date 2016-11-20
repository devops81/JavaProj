  package com.openq.web.controllers;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.jasperreports.engine.export.JExcelApiExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authentication.UserDetails;
import com.openq.authorization.IPrivilegeService;
import com.openq.eav.EavConstants;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;

public class ExpertFullProfileController extends AbstractController {

  IMetadataService metadataService;

  IUserService userService;

  IDataService dataService;

  // ITierService tierService;
  IPrivilegeService privilegeService;

  IOptionServiceWrapper optionServiceWrapper;
  protected ModelAndView handleRequestInternal(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    HttpSession session = request.getSession();
    String action = (String) request.getParameter("action");

	if (ActionKeys.DOWNLOAD_VCARD.equals(action)) {
		String fileName = (session.getAttribute(Constants.CURRENT_KOL_ID) != null ?
				session.getAttribute(Constants.CURRENT_KOL_ID) + ".vcf" : "vcard.vcf");
		response.setContentType("application/text");
		response.setHeader("content-disposition", "attachment; name=\""
				+ fileName + "\"; filename=\""
				+ fileName + "\"");

		String vcardText = (String) session.getAttribute(Constants.VCARD_TEXT);
		if(vcardText != null){
			response.setContentLength(vcardText.length());
			response.getOutputStream().write(vcardText.getBytes());
			response.getOutputStream().close();
		}
		return null;
	}
    session.setAttribute("firstname", getIdAsString("FIRST_NAME"));
    session.setAttribute("lastname", getIdAsString("LAST_NAME"));
    session.setAttribute("middlename", getIdAsString("MIDDLE_NAME"));
    session.setAttribute("image", getIdAsString("PHOTO"));
    session.setAttribute("specialty1", getIdAsString("SPECIALTY_1"));
    session.setAttribute("specialty2", getIdAsString("SPECIALTY_2"));
    session.setAttribute("specialty3", getIdAsString("SPECIALTY_3"));
    session.setAttribute("specialty4", getIdAsString("SPECIALTY_4"));
    session.setAttribute("specialty5", getIdAsString("SPECIALTY_5"));
    session.setAttribute("specialty6", getIdAsString("SPECIALTY_6"));
    session.setAttribute("gender", getIdAsString("GENDER"));
    session.setAttribute("prefix", getIdAsString("PREFIX"));
    session.setAttribute("suffix", getIdAsString("SUFFIX"));
    session.setAttribute("showPrintIcon", "true");

    ModelAndView mav = new ModelAndView("expertfullprofile");

    String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
    long userGroupId = -1;
    if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
     userGroupId = Long.parseLong(userGroupIdString);
    
    OptionLookup[] interactionTypes = optionServiceWrapper.getValuesForOption(PropertyReader.getLOVConstantValueFor("INTERACTION_TYPE"), userGroupId);
    session.setAttribute("INTERACTION_TYPES", interactionTypes);
    String entityIdString = request.getParameter("entityId");
    String kolName = request.getParameter(Constants.CURRENT_KOL_NAME);
    session.setAttribute("PRINTPROFILE_ROOT_PARENT_ID", entityIdString);
    String kolId = request.getParameter("kolid");
    mav.addObject("userId", kolId);
    request.setAttribute("go", request.getParameter("go"));
    session.setAttribute("KOLID", kolId);

    String fromInteactionLink = (String) request
        .getParameter("fromInteraction");
    request.setAttribute("fromInteractionLink", fromInteactionLink);

    String fromKOLStrategy = null;
    if (null != request.getParameter("fromKOLStrategy")) {
      fromKOLStrategy = (String) request.getParameter("fromKOLStrategy");
    }

    if (null != fromKOLStrategy && "true".equalsIgnoreCase(fromKOLStrategy)) {
      session.setAttribute("CURRENT_LINK", "KOL_Strategy");
    }

    if (kolName != null && !kolName.equals("")) {
      request.getSession().setAttribute(Constants.CURRENT_KOL_NAME, kolName);
    }

    User user = null;
    if (kolId != null && !kolId.equals("")) {
      request.getSession().setAttribute(Constants.CURRENT_KOL_ID, kolId);
      long kId = Long.parseLong(kolId);
      user = userService.getUserForProfileSummary(kId);

      mav.addObject("kolUser", user);
    }

    long entityId = -1; // default entity to show

    if (entityIdString != null)
    {
      entityId = Long.parseLong(entityIdString);
    }
    request.setAttribute("ROOT_PARENT_ID", entityIdString);

//    mav.addObject("rootParentId", entityIdString);


    Entity entity = dataService.getEntity(entityId);
    EntityAttribute[] attributes = dataService.getAllEntityAttributes(entityId);
    AttributeType[] attrTypes = metadataService
        .getAllShowableAttributesFilteredByPermissions(entity.getType()
            .getEntity_type_id(), ((UserDetails) request.getSession()
            .getAttribute(Constants.CURRENT_USER)).getId(), privilegeService);

    HashMap attrValuesMap = new HashMap();

    for (int i = 0; i < attrTypes.length; i++) {
      for (int j = 0; j < attributes.length; j++) {
        if (attrTypes[i].getAttribute_id() == attributes[j].getAttribute()
            .getAttribute_id()) {
          attrValuesMap.put(attrTypes[i], attributes[j]);

        }
      }
    }

    //Entering values in Entity Attribute Table for newly created node
    for (int i = 0; i < attrTypes.length; i++)
    {
          if (attrValuesMap != null && !attrValuesMap.containsKey(attrTypes[i])){
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

    //making map for entity Ids for all subtab for a given 1st level tab.

    mav.addObject("parentId", entityIdString);
    session.setAttribute("expId", entityIdString);
    HashMap subAttrMap=new HashMap();

    HashMap attrEntityMap=new HashMap();
    long fEntityId;
    for(int i=0;i<attrValuesMap.size();i++){
    	HashMap subAttrEntityMap=new HashMap();
    	fEntityId=((EntityAttribute) attrValuesMap.get(attrTypes[i])).getMyEntity().getId();
    	Entity fentity = dataService.getEntity(fEntityId);
        AttributeType[] fsubAttributes = metadataService.getAllShowableAttributesFilteredByPermissions(fentity.getType().getEntity_type_id(), ((UserDetails) request.getSession()
                        .getAttribute(Constants.CURRENT_USER)).getId(), privilegeService);
		//test code
		EntityAttribute[] entityAttributes = dataService.getAllEntityAttributes(fentity);
		if (entityAttributes != null && entityAttributes.length > 0) {
			for(int k=0;k<fsubAttributes.length;k++){
				boolean found = false;
				for (int j = 0; j < entityAttributes.length; j++) {
					if (entityAttributes[j].getAttribute().getAttribute_id() == fsubAttributes[k].getAttribute_id()) {
//						 make sure that array elements do not get added twice
						found = true;
						if (!subAttrEntityMap.containsKey(fsubAttributes[k])){
							subAttrEntityMap.put(fsubAttributes[k],entityAttributes[j]);
						}
						break;
					}
				}
				if (!found) {
					// this could be an array element with no child
					if (!subAttrEntityMap.containsKey(fsubAttributes[k])) {
						EntityAttribute eat = new EntityAttribute();
						eat.setId(fsubAttributes[k].getAttribute_id());
						Entity myE = new Entity();
						myE.setId(-1);
						eat.setMyEntity(myE);
						eat.setParent(fentity);
						//map.put(subAttributes[i], eat);
					}
				}

			}
		}
//		 Entering values in entity attribute table for newly added nodes
		   for (int index = 0; index < fsubAttributes.length; index++) {
			   if (!subAttrEntityMap.containsKey(fsubAttributes[index]))
					{
						long entityIdnew = -1;
						//long parentIdnew = entityId;
						//MODIFIED BY TAPAN HERE
						long tempEntityId = entityId;
						long tempAttributeId = ((EntityAttribute) attrValuesMap.get(attrTypes[i])).getAttribute().getAttribute_id();
						EntityAttribute ent = dataService.getMyEntityIdFromEntitiesAttribute(tempAttributeId,tempEntityId);
						long parentIdnew = ent.getMyEntity().getId();
						long attrIdnew = fsubAttributes[index].getAttribute_id();
						entityIdnew = dataService.createEntityIfRequired(entityIdnew, attrIdnew, parentIdnew);
						EntityAttribute[] eat = dataService.getEntityAttributes(entityIdnew);
						subAttrEntityMap.put(fsubAttributes[index], eat[0]);
					}
				}
		//test code ends

		subAttrMap.put(attrTypes[i], fsubAttributes);
		attrEntityMap.put(attrTypes[i], subAttrEntityMap);

    }
    request.setAttribute("subAttrMap", subAttrMap);
    request.setAttribute("attrEntityMap", attrEntityMap);

    HashMap leftNavMap = new HashMap();
    if (entity.getType().getEntity_type_id() == EavConstants.KOL_ENTITY_ID) {
      initializeLeftNavMap(entityId, leftNavMap);
      request.getSession().setAttribute("leftNavMap", leftNavMap);
      /*Properties props = DBUtil.getInstance().getDataFromPropertiesFile(
          "resources/ServerConfig.properties");
      session.setAttribute("PHOTOS_URL", (String) props
          .getProperty("photos.url"));*/
    }

    session.setAttribute("attrTypes", attrTypes);
    session.setAttribute("attributesMap", attrValuesMap);
    request.setAttribute("KOL_ID", request.getParameter("kolid"));
    request.setAttribute("EXPERT_ID", request.getParameter("entityId"));

    String selectedTab = request.getParameter("selectedTab");
    if (selectedTab != null && !selectedTab.equals(""))
      mav.addObject("selectedTab", selectedTab);
    else
      mav.addObject("selectedTab", "0"); // default selected tab

    if (fromInteactionLink != null && "yes".equals(fromInteactionLink)) {
      OptionLookup userType = (OptionLookup) session
          .getAttribute(Constants.USER_TYPE);
      String userTypeText = userType.getOptValue();
      session.setAttribute("CURRENT_LINK", "INTERACTIONS");
      if (userTypeText != null && userTypeText.equalsIgnoreCase("Viewer")) {
        return new ModelAndView("search_interaction_main");
      }
      request.setAttribute("FROM", "fromSearchHome");
    }
    session.setAttribute("ORG_LINK", "NO");
    if ("fromSearchHome".equalsIgnoreCase(action)) {
      request.setAttribute("FROM", "fromSearchHome");
    }
    String fromTaskList = null;
    if (null != request.getParameter("fromTaskList")) {
      fromTaskList = (String) request.getParameter("fromTaskList");
      session.setAttribute("SELECTED_PLAN", "yes");
    }

    if (request.getParameter("CURRENT_LINK") != null) {
      session
          .setAttribute("CURRENT_LINK", request.getParameter("CURRENT_LINK"));
    }

    if (user != null) {
		//user = dataService.setUserFields1(Long.parseLong(entityIdString));
		String vcardtext = user.getVCardText();
		session.setAttribute(Constants.VCARD_TEXT, vcardtext);
	}
    return mav;
  }

  private void initializeLeftNavMap(long entityId, HashMap leftNavMap) {
    EntityAttribute[] olSummary = dataService.getEntityAttributes(entityId,
        dataService.getAttributeIdFromName(
            PropertyReader.getEavConstantValueFor("EXPERT_SUMMARY"))
            .getAttribute_id());
    if (olSummary != null && olSummary.length > 0) {
      EntityAttribute olSum = olSummary[0];
      // get profile info (name, title ...)
      EntityAttribute[] profile = dataService.getEntityAttributes(olSum
          .getMyEntity().getId(), dataService.getAttributeIdFromName(
          PropertyReader.getEavConstantValueFor("EXPERT_PROFILE"))
          .getAttribute_id());// 148

      if (profile != null && profile.length > 0) {
        EntityAttribute pro = profile[0];
        StringAttribute[] attributes = dataService.getStringAttribute(pro
            .getMyEntity());
        for (int i = 0; i < attributes.length; i++) {
          leftNavMap.put(attributes[i].getAttribute().getAttribute_id() + "",
              attributes[i].toString());
        }
      }

      // get tier info
      AttributeType expClassification = dataService.getAttributeIdFromName(PropertyReader.getEavConstantValueFor("EXPERT_CLASSIFICATION"));
      if(expClassification != null)
      profile = dataService.getEntityAttributes(olSum.getMyEntity().getId(),
          dataService.getAttributeIdFromName(
              PropertyReader.getEavConstantValueFor("EXPERT_CLASSIFICATION"))
              .getAttribute_id());// 158

      if (profile != null && profile.length > 0) {
        String[] tierInfo = new String[profile.length];
        for (int k = 0; k < profile.length; k++) {
          EntityAttribute ea = profile[k];
          StringAttribute[] attributes = dataService.getStringAttribute(ea
              .getMyEntity());
          String therupticArea = "", tier = "";
          for (int i = 0; i < attributes.length; i++) {
            if (dataService.getAttributeIdFromName(PropertyReader
                .getEavConstantValueFor("THERAPEUTIC_AREA")) != null
                && dataService.getAttributeIdFromName(PropertyReader
                    .getEavConstantValueFor("TIER")) != null) {
              if (attributes[i].getAttribute().getAttribute_id() == dataService
                  .getAttributeIdFromName(
                      PropertyReader.getEavConstantValueFor("THERAPEUTIC_AREA"))
                  .getAttribute_id()) { // 159
                therupticArea = attributes[i].getValue();
              } else if (attributes[i].getAttribute().getAttribute_id() == dataService
                  .getAttributeIdFromName(
                      PropertyReader.getEavConstantValueFor("TIER"))
                  .getAttribute_id()) { // This 160 id is for Expert
                                        // Classification Tier
                tier = attributes[i].getValue();
              }
            }
          }
          tierInfo[k] = (therupticArea == null ? "" : therupticArea)
              + (tier == null ? "" : " (" + tier + ")");
        }
        leftNavMap.put("tierInfo", tierInfo);
      }

     // get image info
      profile = dataService.getEntityAttributes(olSum.getMyEntity().getId(),
          dataService.getAttributeIdFromName(
              PropertyReader.getEavConstantValueFor("IDENTIFIERS"))
              .getAttribute_id());
      if (profile != null && profile.length > 0) {
        EntityAttribute ea = profile[0];
        StringAttribute[] attributes = dataService.getStringAttribute(ea
            .getMyEntity());
        for (int i = 0; i < attributes.length; i++) {
          leftNavMap.put(attributes[i].getAttribute().getAttribute_id() + "",
              attributes[i].toString());
        }
      }
    }
  }

  public String getIdAsString(String attrName) {
    String returnValue = "N.A.";

    if (PropertyReader.getEavConstantValueFor(attrName) == null)

      return returnValue;

    AttributeType attributeType = dataService
        .getAttributeIdFromName(PropertyReader.getEavConstantValueFor(attrName));

    if (attributeType == null)

      return returnValue;

    attrName = attributeType.getAttribute_id() + "";

    return attrName;

  }

  public IDataService getDataService() {
    return dataService;
  }

  public void setDataService(IDataService dataService) {
    this.dataService = dataService;
  }

  public IUserService getUserService() {
    return userService;
  }

  public void setUserService(IUserService userService) {
    this.userService = userService;
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
  
  public IOptionServiceWrapper getOptionServiceWrapper() {
      return optionServiceWrapper;
  }
  public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
      this.optionServiceWrapper = optionServiceWrapper;
  }
}
