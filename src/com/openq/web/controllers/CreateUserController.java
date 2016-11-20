package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.option.OptionServiceWrapper;
import com.openq.utils.PropertyReader;

public class CreateUserController extends AbstractController{
	
	IOptionService optionService;
	IOptionServiceWrapper optionServiceWrapper;

		protected ModelAndView handleRequestInternal(HttpServletRequest arg0,
				HttpServletResponse arg1) throws Exception {
			//EntityType user = (EntityType) request.getSession().getAttribute(Constants.CURRENT_USER);
			//String staffid=user.getStaffId();
			String userGroupIdString = (String) arg0.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
			long userGroupId = -1;
			if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
			 userGroupId = Long.parseLong(userGroupIdString);
			ModelAndView mav = new ModelAndView("createUser");
			
				OptionLookup[] optionLookup = (OptionLookup[]) optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("SCIENTIFIC_TOPICS"), userGroupId);
	
				mav.addObject("optionLookup", optionLookup);
			
			return mav;
		}


	

		public IOptionService getOptionService() {
			return optionService;
		}


		public void setOptionService(IOptionService optionService) {
			this.optionService = optionService;
		}
		public IOptionServiceWrapper getOptionServiceWrapper() {
	        return optionServiceWrapper;
	    }

	    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
	        this.optionServiceWrapper = optionServiceWrapper;
	    }

	

}
