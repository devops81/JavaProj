package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authorization.IFeaturePermissionService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.option.OptionNames;
import com.openq.web.ActionKeys;

public class ValueListController extends AbstractController {

    IOptionService optionService;
    IFeaturePermissionService featurePermissionService;

        /**
	 * @return the featurePermissionService
	 */
	public IFeaturePermissionService getFeaturePermissionService() {
		return featurePermissionService;
	}

	/**
	 * @param featurePermissionService the featurePermissionService to set
	 */
	public void setFeaturePermissionService(
			IFeaturePermissionService featurePermissionService) {
		this.featurePermissionService = featurePermissionService;
	}

		protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {

        ModelAndView mav = new ModelAndView("valueList");
        request.setAttribute("LOV_VALUE_PERMISSION_MAP", featurePermissionService.getEntityGroupMapping(Constants.LOV_VALUE_PERMISSION_ID));
       String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
        // Getting new option value from the jsp page (for adding new option)
        String newOptionName = (String) request.getParameter("newOption");
        String selectedId = (String) ((request.getParameter("displayOption") == null || request.getParameter("displayOption").equals("")) ? "-1" : request.getParameter("displayOption"));
        String updatedList = (String) request.getParameter("updateField");
        String updateListID = (String) request.getParameter("updateListID");
        String updateOptionName = (String) request.getParameter("updateOptionName");
        String updateOptionNameId = (String) request.getParameter("updateOptionNameId");

        String newList = (String) request.getParameter("newList");
        String optionLookupParent= request.getParameter("optionLookupSelect");

        long parentOptionId = Long.parseLong("0");
        if(request.getParameter("optionSelect")!=null)
        	parentOptionId = Long.parseLong(request.getParameter("optionSelect"));

        String defaultValueAction = (String) request.getParameter("defaultValueAction");
        long existingOptionLookupId = 0;
        long newOptionLookupId = 0;
        
        if(request.getParameter("existingDefaultValue") != null && !"".equals(request.getParameter("existingDefaultValue"))){
        	existingOptionLookupId = Long.parseLong((String) request.getParameter("existingDefaultValue"));
        }
        if(request.getParameter("newDefaultValue") != null && !"".equals(request.getParameter("newDefaultValue"))){
        	newOptionLookupId = Long.parseLong((String) request.getParameter("newDefaultValue"));
        }	
        if(defaultValueAction != null && !"".equals(defaultValueAction)){
        	if(defaultValueAction.equals(ActionKeys.SET_DEFAULT_LOV_VALUE)){
				boolean isUpdateSuccessful = optionService.setDefaultDisplayValue(existingOptionLookupId, newOptionLookupId, userGroupId);
		    	if(isUpdateSuccessful)
		    		logger.debug("Default value for  optionLookupId = "+newOptionLookupId+" updated successfully.");
        	} else if(defaultValueAction.equals(ActionKeys.DELETE_DEFAULT_LOV_VALUE)){
        		boolean isDeleteSuccessful = optionService.deleteDefaultDisplayValue(existingOptionLookupId, userGroupId);
		    	if(isDeleteSuccessful)
		    		logger.debug("Default value for  optionLookupId = "+newOptionLookupId+" deleted successfully.");
        	}
        }

        String newDisplayOrder = (String) request.getParameter("newDisplayOrder");
        String existingDisplayOrder = (String) request.getParameter("existingDisplayOrder");
        if( newDisplayOrder != null && !"".equals(newDisplayOrder) &&
        		existingDisplayOrder != null && !"".equals(existingDisplayOrder) &&
        		!newDisplayOrder.equals(existingDisplayOrder)){

        	String[] idDisplayOrderPairs = newDisplayOrder.split(",");
			for(int i=0;i<idDisplayOrderPairs.length;i++){
				String[] idDisplayOrderPair = idDisplayOrderPairs[i].split(":");
				OptionLookup optionLookup = optionService.getOptionLookup(Long.parseLong(idDisplayOrderPair[0]));
				if(optionLookup != null){
					if(idDisplayOrderPair[1]!=null){
						optionLookup.setDisplayOrder(Long.parseLong(idDisplayOrderPair[1]));
						optionService.updateOptionLookupDisplayOrder(optionLookup);
					}
				}
							
			}
        }
        if(newList != null && !newList.equals("")){
            OptionNames on = optionService.getOptionNames(Long.parseLong(selectedId));
            optionService.addValueToOptionLookup(on,newList,Long.parseLong(optionLookupParent));
        }

        if(newOptionName != null && !newOptionName.equals("") && parentOptionId !=0){
            OptionNames optionNames = new OptionNames();
            optionNames.setName(newOptionName);
            System.out.println(parentOptionId);
            optionNames.setParentId(parentOptionId);
            optionService.createOptionName(optionNames);
			request.getSession().setAttribute("NEW_OPTION_NAME", "TRUE");
        }

        if(updateOptionName != null && !updateOptionName.equals("") && updateListID != null && !updateListID.equals("")){
            optionService.saveUpdateOptionName(Long.parseLong(updateOptionNameId), updateOptionName);
        }

        if(updatedList != null && !updatedList.equals("") && updateListID != null && !updateListID.equals("")){

                optionService.saveUpdateOptionLookup(Long.parseLong(updateListID), updatedList,Long.parseLong(optionLookupParent), userGroupId);
        }

        // getting all the rows from OPTION_NAMES table


        OptionNames [] optionNamesFromdb = optionService.getAllOptionNames();

        if(selectedId.equals("-1") && optionNamesFromdb.length !=0)
            selectedId = "1";
		OptionLookup[] listValuesFrom = optionService.getValuesForOption(Long.parseLong(selectedId), userGroupId);
		
		String actionDelLov = request.getParameter("delLov");
		
		if (actionDelLov != null) {
			for (int i = 0; i < listValuesFrom.length; i++) {
				String softDelLov = request.getParameter("check"
						+ listValuesFrom[i].getId());
				if (softDelLov != null) {
					optionService.deleteOptionLookup(listValuesFrom[i], userGroupId);
				} else {
					if (listValuesFrom[i].getDeleteFlag().equalsIgnoreCase("Y"))
						optionService.saveUpdateOptionLookup(listValuesFrom[i].getId(), listValuesFrom[i].getOptValue(), userGroupId);
				}
			}
		}
		
        OptionLookup [] listValuesFromdb = optionService.getValuesForOption(Long.parseLong(selectedId), userGroupId);
        long parentId = Long.parseLong("0");;
        if(request.getParameter("parentId")!=null)
        	parentId = Long.parseLong(request.getParameter("parentId"));
        
        OptionLookup [] parentList = null;
        if(parentId != -1)
        	parentList = optionService.getValuesForOption(parentId, userGroupId);
        
        String[] grandParentList = null;
        if(parentList!=null) {
            grandParentList = new String[parentList.length];
            for(int i=0;i<parentList.length;i++) {
                grandParentList[i] = (optionService.getOptionLookup(parentList[i].getParentId(), userGroupId)).getOptValue();
            }
        }
        
        String[] parentOfOptionNames = new String[optionNamesFromdb.length];
        for(int i=0;i<optionNamesFromdb.length;i++) {
        	parentOfOptionNames[i] = new String();
        	if(optionNamesFromdb[i].getParentId() == -1)
        		parentOfOptionNames[i] = "None";
        	else
        		parentOfOptionNames[i] = optionService.getOptionNames(optionNamesFromdb[i].getParentId()).getName();
        }
        
        String[] parentOfOptionvalues = new String[listValuesFromdb.length];
        
        for(int i=0;i<listValuesFromdb.length;i++) {
        	parentOfOptionvalues[i] = new String();
        	OptionLookup optionLookup = optionService.getOptionLookup(listValuesFromdb[i].getParentId());
        	if(listValuesFromdb[i].getParentId() == -1 || optionLookup == null)
        		parentOfOptionvalues[i] = "None";
        	else 
        		parentOfOptionvalues[i] = optionLookup.getOptValue();
        }
        request.getSession().setAttribute("displayOptionName", optionNamesFromdb);
        request.getSession().setAttribute("displayList", listValuesFromdb);
        request.getSession().setAttribute("selectedOptionId", selectedId);
        request.getSession().setAttribute("parentList", parentList);
        request.getSession().setAttribute("parentOfOptionNames", parentOfOptionNames);
        request.getSession().setAttribute("parentOfOptionvalues", parentOfOptionvalues);
        request.getSession().setAttribute("grandParentList", grandParentList);
        
       String parentJsonObj= makeJson(parentList);
   	   request.setAttribute("parentJsonObj", parentJsonObj);
        if("listTree".equals(request.getParameter("action"))) {
            return new ModelAndView("list_tree");
        }
        return mav;
    }
		
		private String makeJson(OptionLookup[] parentList){
			JSONObject json = new JSONObject();
			json.put("label", "Parent list");
			
			List model = new ArrayList();
			if(null!=parentList)
			{
				for(int i=0; i < parentList.length; i++){
					Map m = new HashMap();
					m.put("parentValue",parentList[i].getOptValue()+"");
					m.put("parentId",parentList[i].getId()+"");
					model.add(m);
				}
			}
            // convert list into array
			if(null!=model && model.size()>0)
			{
				json.put("data",(Map[])model.toArray(new Map[model.size()]));
			}
			else
			{
				json= new JSONObject();
				json.put("data", new Object[0]);
			}
			return json.toString();
			
		}

    public IOptionService getOptionService() {
        return optionService;
    }

    public void setOptionService(IOptionService optionService) {
        this.optionService = optionService;
    }
}
