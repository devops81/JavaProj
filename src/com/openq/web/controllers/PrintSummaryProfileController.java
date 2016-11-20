package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.contacts.Contacts;
import com.openq.contacts.IContactsService;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.entitydetails.IEntityDetailsService;
import com.openq.eav.expert.ExpertDetails;
import com.openq.eav.expert.IExpertDetailsService;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.org.IOrgOlMapService;
import com.openq.eav.org.IOrganizationService;
import com.openq.eav.org.OrgOlMap;
import com.openq.eav.org.Organization;
import com.openq.eav.scripts.OlConstants;
import com.openq.interaction.IInteractionService;
import com.openq.interaction.Interaction;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.PropertyReader;

public class PrintSummaryProfileController extends AbstractController {

    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        HttpSession session = request.getSession();
        session.setAttribute("dataService", dataService);
        session.setAttribute("metadataService", metadataService);

        String kolIdString = request.getParameter("kolid");
        String userGroupIdStr = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
        long userGroupId = Long.parseLong(userGroupIdStr);
        String currentUser = (String) request.getSession().getAttribute(Constants.USER_ID);
        String isSAXAJVUserString = (String) session.getAttribute(Constants.IS_SAXA_JV_GROUP_USER);
        boolean isSAXAJVUser = false;
        if (isSAXAJVUserString != null && "true".equals(isSAXAJVUserString)) {
            isSAXAJVUser = true;
        }

        String isOTSUKAJVUserString = (String) session.getAttribute(Constants.IS_OTSUKA_JV_GROUP_USER);
    	boolean isOTSUKAJVUser = false;
    	if(isOTSUKAJVUserString != null && "true".equals(isOTSUKAJVUserString)){
    			isOTSUKAJVUser = true;
    	}

        ExpertDetails expDetails = expertDetailsService.getExpertDetailsOnUserid(kolIdString);
        session.setAttribute("expDetails", expDetails);
        session.setAttribute("kolid",String.valueOf(expDetails.getId()));

        if (kolIdString != null && !kolIdString.equals("")) {
            session.removeAttribute("societies");
            session.removeAttribute("patents");
            session.removeAttribute("honors");
            session.removeAttribute("industryactivites");
            session.removeAttribute("bmsTrials");
            session.removeAttribute("publication");
            session.removeAttribute("allTrials");
            session.removeAttribute("editorialBoards");
            session.removeAttribute("committees");
            session.removeAttribute("OL_Type");
            session.removeAttribute("olSelectCriteria");
            session.removeAttribute("sphereOfInfluence");            
            session.removeAttribute("presentation");
            session.removeAttribute("fullProfileDate");
            session.removeAttribute("basicProfileDate");
            session.removeAttribute("PUBLICATION_ID_LIST");
            session.removeAttribute("EXPERT_PUBLICATIONS");
            session.removeAttribute("bestDayForContact");
            session.removeAttribute("bestTimeForContact");
            session.removeAttribute("relatedOrgs");
            session.removeAttribute("SPEAKERCONTRACT_LIST");
            session.removeAttribute("SOCIETIES_LIST");
            session.removeAttribute("EDITORIALBOARD_LIST");
            session.removeAttribute("region");
            session.removeAttribute("subRegion");

            String entityIdString = request.getParameter("entityId");
            long entityId = Long.parseLong(entityIdString);

            try {
                long kolId = Long.parseLong(kolIdString);

                long[] entityIds = new long[1];
                entityIds[0] = entityId;
                long[] attributes = {OlConstants.KOL_Professional_Activities_Committees_Committees_Type,
                        OlConstants.KOL_Professional_Activities_Editorial_Boards_Editorial_Board_Journal,
                        OlConstants.KOL_Professional_Activities_Editorial_Boards_Editorial_Board_Position,
                        OlConstants.KOL_Professional_Activities_Editorial_Boards_Editorial_Board_Dates,
                        OlConstants.KOL_Professional_Activities_Honors_Honor_Description,
                        OlConstants.KOL_Professional_Activities_Industry_Activities_Industry_Type,
                        OlConstants.KOL_Professional_Activities_Patents_Patent_Title,
                        OlConstants.KOL_Professional_Activities_Presentation_Presentation_Title,
                        OlConstants.KOL_Professional_Activities_Societies_Societies_Description,
                        OlConstants.KOL_Professional_Activities_Societies_Societies_Board,
                        OlConstants.KOL_Professional_Activities_Societies_Societies_Title,
                        OlConstants.KOL_Professional_Activities_Societies_Societies_Years,
                        OlConstants.KOL_Professional_Activities_Patents_Patent_Title,
                        OlConstants.KOL_Trials_Bms_Trials_Bms_Trials_Title,
                        OlConstants.KOL_Trials_All_Trials_Trial_Name,
                        OlConstants.KOL_OL_Summary_Identifiers_Full_Profile_Date,
                        OlConstants.KOL_OL_Summary_Identifiers_Basic_Profile_Date,
                        OlConstants.KOL_OL_Summary_Profile_Best_Day_To_Contact_Ol,
                        OlConstants.KOL_OL_Summary_Profile_Best_Time_To_Contact_Ol,
                        OlConstants.KOL_Publications_Publications_Journal,
                        OlConstants.KOL_Publications_Publications_Medline_Id,
                        OlConstants.KOL_Publications_Publications_Pub_Title,
                        OlConstants.KOL_Publications_Publications_Publication_Date,
                        OlConstants.KOL_iPlan_Data_Product,
                        OlConstants.KOL_iPlan_Data_Active,
                        OlConstants.KOL_iPlan_Data_StartDate,
                        OlConstants.KOL_iPlan_Data_EndDate};

                List filters = new ArrayList();
                filters.add("PrintSummaryProfileFilterImpl");

                Map expertDetails = (Map) entityDetailsService.getOlDetails(entityIds, attributes, filters).get(
                        entityId + "");

                //set professional activities checkboxes details in session
                setProfessionalActivitiesDetails(expertDetails, session);

                //set full profile date and basic profile date string in session
                setProfileDateStrings(expertDetails, session);

                //set the best date and time to contact the Ol in session
                setBestDateAndTime(expertDetails, session);

                //set the publications data
                setPublicationData(expertDetails, session);

                setSpeakerContractData(expertDetails, session);

                setSocietiesData(expertDetails, session);

                setEditorialBoardsData(expertDetails, session);

                Interaction[] interactions = null;
                  if (isSAXAJVUser) {
                    long currUserId = Long.parseLong(currentUser);
                    OptionLookup[] productLovs = optionServiceWrapper.getValuesForOptionAndUser(PropertyReader
                            .getLOVConstantValueFor("PRODUCT"), currUserId, userGroupId);
                    if (productLovs != null && productLovs.length > 0) {
                        for (int i = 0; i < productLovs.length; i++) {
                            if (productLovs[i].getOptValue().trim().equalsIgnoreCase("Diabetes")) {
                                interactions = interactionService.getRecentInteractionsByExpert(kolId, productLovs[i],
                                        Constants.PRODUCT_MULTISELECT_IDS, isSAXAJVUser);
                            }
                        }
                    }
                }else if (isOTSUKAJVUser) {
                	long currUserId = Long.parseLong(currentUser);
                    OptionLookup[] productLovs = optionServiceWrapper.getValuesForOptionAndUser(PropertyReader
                            .getLOVConstantValueFor("PRODUCT"), currUserId, userGroupId);
                    if (productLovs != null && productLovs.length > 0) {
                        for (int i = 0; i < productLovs.length; i++) {
                            if (productLovs[i].getOptValue().trim().equalsIgnoreCase("Abilify")) {
                                 interactions = interactionService.getRecentInteractionsByExpert(kolId, productLovs[i],
                                        Constants.PRODUCT_MULTISELECT_IDS, isOTSUKAJVUser);

                            }
                        }
                    }
                }

                else
                    interactions = interactionService.getRecentInteractionsByExpert(kolId);
                if (interactions != null) {
                    int length = interactions.length > 3 ? 3 : interactions.length;
                    List interactionObjList = new ArrayList();
                    Map interactionBMSUserMap = new HashMap();
                    StringBuffer interactionIdsBuffer = new StringBuffer("");
                    for (int i = 0; i < length; i++) {
                        interactionObjList.add(interactions[i]);
                        interactionIdsBuffer.append(interactions[i].getId()).append(",");
                        User user = userService.getUser(interactions[i].getUserId());
                        if (user != null) {
                            interactionBMSUserMap.put(interactions[i].getId() + "", user.getLastName() + ", "
                                    + user.getFirstName());
                        }
                    }
                    Map interactionObjsMap = new HashMap();
                    if (interactionObjList != null) {
                        interactionObjsMap.put("InteractionList", interactionObjList);
                        // get interactionId and first topic map
                        if (interactionIdsBuffer != null && !"".equals(interactionIdsBuffer)
                                && interactionIdsBuffer.length() > 0) {
                            String interactionIds = interactionIdsBuffer.toString();
                            interactionIds = interactionIds.substring(0, interactionIds.length() - 1); // remove the last comma
                            Map interactionIdFirstTopicMap = interactionService
                                    .getInteractionIdFirstTopicMap(interactionIds);
                            interactionObjsMap.put("interactionIdFirstTopicMap", interactionIdFirstTopicMap);

                        }
                        if (interactionBMSUserMap != null)
                            interactionObjsMap.put("InteractionBMSUserNames", interactionBMSUserMap);
                        session.setAttribute("expertInteractions", interactionObjsMap);
                    }

                }

                Contacts[] contactForKol = contactsService.getContactsForKol(kolId);
                session.setAttribute("contacts", contactForKol);

                OrgOlMap[] relatedOrgMap = orgOlMapService.getAllOrgsForOl(kolId);
                if (relatedOrgMap != null && relatedOrgMap.length != 0) {
                    Organization[] relatedOrgs = new Organization[relatedOrgMap.length];

                    for (int i = 0; i < relatedOrgMap.length; i++) {
                        relatedOrgs[i] = orgService.getOrganizationByid(relatedOrgMap[i].getOrgId());
                        if (relatedOrgs[i] != null) {
                            relatedOrgs[i].setOrgOlMapId(relatedOrgMap[i].getId());
                            if (relatedOrgMap[i].getDivision() != null)
                                relatedOrgs[i].setDivision(relatedOrgMap[i].getDivision());
                            if (relatedOrgMap[i].getPosition() != null)
                                relatedOrgs[i].setPosition(relatedOrgMap[i].getPosition());
                            if (relatedOrgMap[i].getYear() != null)
                                relatedOrgs[i].setYear(relatedOrgMap[i].getYear());
                        }
                    }
                    session.setAttribute("relatedOrgs", relatedOrgs);
                }

            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }

        String entityIdString = request.getParameter("entityId");
        long entityId = Long.parseLong(entityIdString);
        EntityAttribute[] attributes = dataService.getAllEntityAttributes(entityId);
        //String OL_Type = "";
        String olSelectCriteria = "";
        String sphereOfInfluence = "";
        String region = "";
        String subRegion = "";
        String taAffiliations ="";
        String profAttributes = "";
        for (int p = 0; p < attributes.length; p++) {
            Entity e = attributes[p].getMyEntity();
            if(Constants.BMS_INFO_ENTITY_TYPE_ID == e.getType().getEntity_type_id()){
                request.setAttribute("BMSInfoTypeEntity", e.getId()+"");
            }
            AttributeType[] subAttributes = metadataService.getAllShowableAttributes(e.getType().getEntity_type_id());
            for (int k = 0; k < subAttributes.length; k++) {
                if (((PropertyReader.getEavConstantValueFor("OL_SELECTION_CRITERIA")).
                        equalsIgnoreCase(subAttributes[k].getName()))
                        || ((subAttributes[k].getName()).endsWith("Attributes")) ||
                        ((PropertyReader.getEavConstantValueFor("IDENTIFIERS")).equalsIgnoreCase(subAttributes[k].getName()))) {
                    EntityAttribute[] entityAttributes = dataService.getEntityAttributes(attributes[p].getMyEntity()
                            .getId(), subAttributes[k].getAttribute_id());
                    AttributeType[] subBasicAttributes = metadataService.getAllShowableAttributes(subAttributes[k]
                            .getType());
                    if (subBasicAttributes != null) {
                        for (int r = 0; r < entityAttributes.length; r++) {
                            for (int q = 0; q < subBasicAttributes.length; q++) {
                            	String subBasicAttribute = subBasicAttributes[q].getName().trim();

                            	/*if (subBasicAttribute.equalsIgnoreCase("MSL OL Type")) {
                                    StringAttribute olTypeString = dataService.getStringAttribute(entityAttributes[r]
                                            .getMyEntity().getId(), subBasicAttributes[q].getAttribute_id());
                                    if (olTypeString != null) {
                                        OL_Type = olTypeString.getValue();
                                    }
                                }
                                */
                            	if(PropertyReader.getEavConstantValueFor("OL_SELECTION_CRITERIA").equalsIgnoreCase(subAttributes[k].getName())){
                                    request.setAttribute("selectionCriteriaEntityId", entityAttributes[r].getMyEntity().getId()+"");
                                }
                            	if (((PropertyReader.getEavConstantValueFor("OL_SELECTION_CRITERIA")).
                            	        equalsIgnoreCase(subAttributes[k].getName()))
                                        && !subBasicAttribute.equalsIgnoreCase((PropertyReader.getEavConstantValueFor("MSL_OL_TYPE")))) {
                                    StringAttribute olSelectCriteriaString = dataService.getStringAttribute(
                                            entityAttributes[r].getMyEntity().getId(), subBasicAttributes[q]
                                                    .getAttribute_id());
                                    if (olSelectCriteriaString != null
                                            && "Yes".equalsIgnoreCase(olSelectCriteriaString.getValue())) {
                                        olSelectCriteria = olSelectCriteria + subBasicAttribute + ",";
                                    }
                                }
                                if (subBasicAttribute
										.equals(Constants.SPHERE_OF_INFLUENCE_SUFFIX)) {
									StringAttribute sphereOfInfluenceObj = dataService
											.getStringAttribute(entityAttributes[r].getMyEntity().getId(),
													subBasicAttributes[q].getAttribute_id());
									
									if (sphereOfInfluenceObj != null
											&& sphereOfInfluenceObj.getValue() != null) {
									
											sphereOfInfluence =  sphereOfInfluenceObj.getValue();
										
									}
									request.setAttribute("sphereOfInfluenceAttrId", subBasicAttributes[q].getAttribute_id()+"");
								}
                                //Adding Profile->Identifiers->region
                                if (subBasicAttribute.equals(Constants.REGION_SUFFIX)) {
									StringAttribute regionObj = dataService
											.getStringAttribute(entityAttributes[r].getMyEntity().getId(),
													subBasicAttributes[q].getAttribute_id());
									
									if (regionObj != null
											&& regionObj.getValue() != null) {
									
										region =  regionObj.getValue();
										
									}
									request.setAttribute("regionAttrId", subBasicAttributes[q].getAttribute_id()+"");
								}
                                //Adding Profile->Identifiers->sub-region
                                if (subBasicAttribute.equals(Constants.SUB_REGION_SUFFIX)) {
									StringAttribute subRegionObj = dataService
											.getStringAttribute(entityAttributes[r].getMyEntity().getId(),
													subBasicAttributes[q].getAttribute_id());
									
									if (subRegionObj != null
											&& subRegionObj.getValue() != null) {
									
										subRegion =  subRegionObj.getValue();
										
									}
									request.setAttribute("subRegionAttrId", subBasicAttributes[q].getAttribute_id()+"");
								}
                                
                                // Vinay Rao Adding TA Affiliations 
                                if (subBasicAttribute.endsWith(Constants.TA_AFFILIATIONS)){
                                	StringAttribute taAffiliationsobj = dataService.getStringAttribute(entityAttributes[r].getMyEntity().getId(), subBasicAttributes[q].getAttribute_id());
                                	if (taAffiliationsobj != null
											&& taAffiliationsobj.getValue() != null
											&& (taAffiliationsobj
													.getValue().trim()
													.equalsIgnoreCase("Yes"))) {
                                		 if((taAffiliationsobj.getAttribute().getName()).split(" ").length >0){
                                			 taAffiliations = taAffiliations+(taAffiliationsobj.getAttribute().getName()).substring(0,(taAffiliationsobj.getAttribute().getName()).length()-(Constants.TA_AFFILIATIONS.length()+1))+", ";
                                		 }
                                	}
	
                                }                                

                                if (subBasicAttribute.equals("Author")
                                        || subBasicAttribute.equals("Advisor")
                                        || subBasicAttribute.equals("Investigator")
                                        || subBasicAttribute.equals("Speaker")) {
                                    StringAttribute attributeString = dataService.getStringAttribute(
                                            entityAttributes[r].getMyEntity().getId(), subBasicAttributes[q]
                                                    .getAttribute_id());
									//boolean BMSInfoAttribute = optionServiceWrapper
									//.isBMSInfoAttribute(subBasicAttribute);

									if (attributeString != null && attributeString.getValue() != null
                                            && !(attributeString.getValue().trim().equalsIgnoreCase("N/A"))
                                            && !(attributeString.getValue().trim().equalsIgnoreCase("No"))) {

									    if ((!isSAXAJVUser && !isOTSUKAJVUser) ||
									            (isSAXAJVUser && subBasicAttribute.startsWith("CVMET")) ||
									            (isOTSUKAJVUser && subBasicAttribute.startsWith("Neuro"))) {

											profAttributes += subBasicAttribute + ", ";
										}
									}
                                }
                            }
                        }
                    }    
                }                                              
            }
        }

        //session.setAttribute("OL_Type", OL_Type);
        session.setAttribute("olSelectCriteria", olSelectCriteria);
        
        session.setAttribute("sphereOfInfluence", sphereOfInfluence);       
        session.setAttribute("region", region);
        session.setAttribute("subRegion", subRegion);
        
        //check whether user is a JV user and set TA affilations accordingy
        if(isSAXAJVUser){
			   if (taAffiliations.indexOf("CVMET")!=-1){
				  taAffiliations ="CVMET";
			  }
			   
        }else if (isOTSUKAJVUser ){
                  if(taAffiliations.indexOf("Neuro")!=-1)         	  
                	  taAffiliations="Neuro";
		}else if (taAffiliations != null && !taAffiliations.equals(""))
            		taAffiliations = taAffiliations.substring(0, taAffiliations.length() - 2);
        
        session.setAttribute("taAffiliations", taAffiliations);
        
        if (profAttributes != null && !profAttributes.equals(""))
            profAttributes = profAttributes.substring(0, profAttributes.length() - 2);
        session.setAttribute("attributes", profAttributes);

        return new ModelAndView("printSummaryProfile");
    }

    private void setProfessionalActivitiesDetails(Map expertDetails, HttpSession session) {
        Object value = expertDetails.get(OlConstants.KOL_Professional_Activities_Societies + "");
        if (value != null && ((Boolean) value).booleanValue())
            session.setAttribute("societies", "true");

        value = expertDetails.get(OlConstants.KOL_Professional_Activities_Patents + "");
        if (value != null && ((Boolean) value).booleanValue())
            session.setAttribute("patents", "true");

        value = expertDetails.get(OlConstants.KOL_Professional_Activities_Honors + "");
        if (value != null && ((Boolean) value).booleanValue())
            session.setAttribute("honors", "true");

        value = expertDetails.get(OlConstants.KOL_Professional_Activities_Presentation + "");
        if (value != null && ((Boolean) value).booleanValue())
            session.setAttribute("presentation", "true");

        value = expertDetails.get(OlConstants.KOL_Professional_Activities_Industry_Activities + "");
        if (value != null && ((Boolean) value).booleanValue())
            session.setAttribute("industryactivites", "true");

        value = expertDetails.get(OlConstants.KOL_Trials_Bms_Trials + "");
        if (value != null && ((Boolean) value).booleanValue())
            session.setAttribute("bmsTrials", "true");

        value = expertDetails.get(OlConstants.KOL_Trials_All_Trials + "");
        if (value != null && ((Boolean) value).booleanValue())
            session.setAttribute("allTrials", "true");

        value = expertDetails.get(OlConstants.KOL_Professional_Activities_Editorial_Boards + "");
        if (value != null && ((Boolean) value).booleanValue())
            session.setAttribute("editorialBoards", "true");

        value = expertDetails.get(OlConstants.KOL_Professional_Activities_Committees + "");
        if (value != null && ((Boolean) value).booleanValue())
            session.setAttribute("committees", "true");

    }

    /*
     * Check for the Full Profile Date and Basic Profile Date attributes and set the
     * session attributes
     */
    private void setProfileDateStrings(Map expertDetails, HttpSession session) {
        String fullProfileDateString = "N.A", basicProfileDateString = "N.A";

        Object value = expertDetails.get(OlConstants.KOL_OL_Summary_Identifiers_Basic_Profile_Date + "");
        if (value != null && ((String) value).trim().length() > 0)
            basicProfileDateString = (String) value;

        value = expertDetails.get(OlConstants.KOL_OL_Summary_Identifiers_Full_Profile_Date + "");
        if (value != null && ((String) value).trim().length() > 0)
            fullProfileDateString = (String) value;

        session.setAttribute("fullProfileDate", fullProfileDateString);
        session.setAttribute("basicProfileDate", basicProfileDateString);

    }

    /*
     * Check for the best date to contact and best time to contact attributes
     * and set these strings in session
     */
    private void setBestDateAndTime(Map expertDetails, HttpSession session) {
        String bestDayString = "";
        String bestTimeString = "";

        Object value = expertDetails.get(OlConstants.KOL_OL_Summary_Profile_Best_Day_To_Contact_Ol + "");
        if (value != null && ((String) value).trim().length() > 0)
            bestDayString = (String) value;

        value = expertDetails.get(OlConstants.KOL_OL_Summary_Profile_Best_Time_To_Contact_Ol + "");
        if (value != null && ((String) value).trim().length() > 0)
            bestTimeString = (String) value;

        session.setAttribute("bestDayForContact", bestDayString);
        session.setAttribute("bestTimeForContact", bestTimeString);

    }

    /*
     * Set the publication exists or not flag in the session
     * Also, set the 3 recent most publications data in the session
     */
    private void setPublicationData(Map expertDetails, HttpSession session) {
        Object value = expertDetails.get(OlConstants.KOL_Publications_Publications + "");
        if (value != null && ((Boolean) value).booleanValue())
            session.setAttribute("publication", "true");

        Object pubListObj = expertDetails.get("PUBLICATION_LIST");
        if (pubListObj != null && ((List) pubListObj).size() > 0) {
            session.setAttribute("PUBLICATION_LIST", pubListObj);
        }
        else
            session.setAttribute("PUBLICATION_LIST", new ArrayList());

    }

    private void setSpeakerContractData(Map expertDetails, HttpSession session) {
        Object value = expertDetails.get(OlConstants.KOL_iPlan_Data + "");

        Object speakerContractListObj = expertDetails.get("SPEAKERCONTRACT_LIST");
        if (speakerContractListObj != null && ((List) speakerContractListObj).size() > 0) {
            session.setAttribute("SPEAKERCONTRACT_LIST", speakerContractListObj);
        }
        else
            session.setAttribute("SPEAKERCONTRACT_LIST", new ArrayList());

    }

    private void setSocietiesData(Map expertDetails, HttpSession session) {
        Object value = expertDetails.get(OlConstants.KOL_Professional_Activities_Societies + "");

        Object societiesListObj = expertDetails.get("SOCIETIES_LIST");
        if (societiesListObj != null && ((List) societiesListObj).size() > 0) {
            session.setAttribute("SOCIETIES_LIST", societiesListObj);
        }
        else
            session.setAttribute("SOCIETIES_LIST", new ArrayList());

    }

    private void setEditorialBoardsData(Map expertDetails, HttpSession session) {
        Object value = expertDetails.get(OlConstants.KOL_Professional_Activities_Editorial_Boards + "");

        Object editorialBoardListObj = expertDetails.get("EDITORIALBOARD_LIST");
        if (editorialBoardListObj != null && ((List) editorialBoardListObj).size() > 0) {
            session.setAttribute("EDITORIALBOARD_LIST", editorialBoardListObj);
        }
        else
            session.setAttribute("EDITORIALBOARD_LIST", new ArrayList());

    }



    private IEntityDetailsService entityDetailsService;

    private IDataService dataService;

    private IMetadataService metadataService;

    private IInteractionService interactionService;

    private IUserService userService;

    private IContactsService contactsService;

    private IOrgOlMapService orgOlMapService;

    private IOrganizationService orgService;

    private IOptionServiceWrapper optionServiceWrapper;

    private IExpertDetailsService expertDetailsService;

    /**
     * @return the expertDetailsService
     */
    public IExpertDetailsService getExpertDetailsService() {
        return expertDetailsService;
    }

    /**
     * @param expertDetailsService the expertDetailsService to set
     */
    public void setExpertDetailsService(IExpertDetailsService expertDetailsService) {
        this.expertDetailsService = expertDetailsService;
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

    public IInteractionService getInteractionService() {
        return interactionService;
    }

    public void setInteractionService(IInteractionService interactionService) {
        this.interactionService = interactionService;
    }

    public IUserService getUserService() {
        return userService;
    }

    public void setUserService(IUserService userService) {
        this.userService = userService;
    }

    public IContactsService getContactsService() {
        return contactsService;
    }

    public void setContactsService(IContactsService contactsService) {
        this.contactsService = contactsService;
    }

    public IOrgOlMapService getOrgOlMapService() {
        return orgOlMapService;
    }

    public void setOrgOlMapService(IOrgOlMapService orgOlMapService) {
        this.orgOlMapService = orgOlMapService;
    }

    public IOrganizationService getOrgService() {
        return orgService;
    }

    public void setOrgService(IOrganizationService orgService) {
        this.orgService = orgService;
    }

    public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

    public IEntityDetailsService getEntityDetailsService() {
        return entityDetailsService;
    }

    public void setEntityDetailsService(IEntityDetailsService entityDetailsService) {
        this.entityDetailsService = entityDetailsService;
    }

}
