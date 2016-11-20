package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.business.ISelectionCriteriaService;
import com.openq.eav.data.EavAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.expert.ExpertDetails;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;


public class SelectionCriteriaPopupController extends AbstractController {
    
    public ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        
            ModelAndView mav = new ModelAndView("selectionCriteriaPopup");
           
            String entityIdString = request.getParameter("entityId");

            long entityId = -1;
            if(entityIdString != null && !"".equals(entityIdString)){
                entityId = Long.parseLong(entityIdString);
            }
            AttributeType [] basicAttributes = metadataService.getAllShowableAttributes(Constants.SELECTION_CRITERIA_ENTITYID);
            Map attrValueMap = new HashMap();
            ArrayList allAttributes = dataService.getAllAttributeValues(dataService.getEntity(entityId));
            for (int i=0; i <basicAttributes.length; i++) {
                for (int j=0; j<allAttributes.size(); j++) {
                    if (basicAttributes[i].getAttribute_id() == ((EavAttribute) allAttributes.get(j)).getAttribute().getAttribute_id()) {
                        attrValueMap.put(basicAttributes[i], allAttributes.get(j));
                    }
                }
            }
            
            
            String rootParentId = (String)request.getParameter("kolid");
			AttributeType regionAttrId = dataService.getAttributeIdFromName(Constants.TL_REGION);
			StringAttribute regionValue = dataService.getAttributeValue(new Long(rootParentId), new Long(regionAttrId.getAttribute_id()));
            
            List criteriaList = selectionCriteriaService.getSelectionCriteria(basicAttributes, attrValueMap, false);
            if(criteriaList != null && criteriaList.size() == 5){
                request.setAttribute("selectionCriteriaJSONArray", criteriaList.get(0));
                request.setAttribute("TLStatusAttr", criteriaList.get(1));
                request.setAttribute("TLStatusValue", criteriaList.get(2));
                request.setAttribute("SOIAttr", criteriaList.get(3));
                request.setAttribute("SOIValue", criteriaList.get(4));
                
            }
            String region ="";
            if (null!= regionValue){
            	region =regionValue.getVal();
            }
            request.setAttribute("regionOfTL", region);
            return mav;
    }
    ISelectionCriteriaService selectionCriteriaService;
    public ISelectionCriteriaService getSelectionCriteriaService() {
        return selectionCriteriaService;
    }
    public void setSelectionCriteriaService(
            ISelectionCriteriaService selectionCriteriaService) {
        this.selectionCriteriaService = selectionCriteriaService;
    }
    IMetadataService metadataService;
    public IMetadataService getMetadataService() {
        return metadataService;
    }
    public void setMetadataService(IMetadataService metadataService) {
        this.metadataService = metadataService;
    }
    IDataService dataService;
    public IDataService getDataService() {
        return dataService;
    }
    public void setDataService(IDataService dataService) {
        this.dataService = dataService;
    }
    
}