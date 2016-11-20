package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;

public class PopulateChildLOVController extends AbstractController{
	
	IOptionService optionService;
	/**
	 * @return the optionService
	 */
	public IOptionService getOptionService() {
		return optionService;
	}
	/**
	 * @param optionService the optionService to set
	 */
	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

		String parentIdString = (String) request.getParameter("parentId");
  	    String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
  		long userGroupId = -1;
  		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
  		 userGroupId = Long.parseLong(userGroupIdString);

   		String lovValuesToBeExcluded = (String) request.getParameter("lovValuesToBeExcluded");
   		String childLOVName = (String) request.getParameter("childLOVName");
   		String selectedOptionIdString = (String) request.getParameter("selectedOptionId");
   		long selectedOptionId = 0;
   		if(selectedOptionIdString != null && !"".equals(selectedOptionIdString)){
   			selectedOptionId = Long.parseLong(selectedOptionIdString);
   		}
   		String allowDeletedValues = (String) request.getParameter("allowDeletedValues");
   		boolean allowDeletedValuesFlag = false;
        if(allowDeletedValues != null && 
                !"".equals(allowDeletedValues) && 
                !"undefined".equalsIgnoreCase(allowDeletedValues)){
            
            allowDeletedValuesFlag = new Boolean ( allowDeletedValues ).booleanValue();
        }
  		List childLOVList = new ArrayList();
  		if(selectedOptionId != 0){
  			childLOVList = optionService.getLookupForOptionId(selectedOptionId, userGroupId);
  		}else if( childLOVName != null && !"".equals(childLOVName)){
  		  	childLOVList = optionService.getRelatedChildForParents(childLOVName, parentIdString, userGroupId, lovValuesToBeExcluded, allowDeletedValuesFlag);
  		}
		StringBuffer commaSeparatedLOVIds = new StringBuffer("");
		String responseText = "";
		if(childLOVList != null && childLOVList.size() >0){
			for(int i=0; i<childLOVList.size(); i++){
				OptionLookup childLOV = (OptionLookup) childLOVList.get(i);
				String idValuePair = childLOV.getId()+ Constants.DELIMITER_TO_SEPARATE_SUBVALUES + childLOV.getOptValue();
				commaSeparatedLOVIds.append(idValuePair).append(Constants.DELIMITER_TO_SEPARATE_VALUES);
			}
			if(commaSeparatedLOVIds != null && !"".equals(commaSeparatedLOVIds))
				responseText = commaSeparatedLOVIds.toString().substring(0,commaSeparatedLOVIds.length()-1); // remove the trailing comma
		}
		
		response.setContentType("text/xml");
		response.setHeader("Cache-Control", "no-cache");
		response.getWriter().write(responseText);
		response.getWriter().close();
		return null;
	}

}
