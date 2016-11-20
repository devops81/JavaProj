package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.alerts.IAlertsService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.kol.KOLManager;
import com.openq.report.IReportService;
import com.openq.userPreference.IUserPreferenceService;
import com.openq.userPreference.UserPreference;
import com.openq.utils.PropertyReader;

public class HomeController extends AbstractController {

    IOptionService optionService;
    IReportService reportService;
    IOptionServiceWrapper optionServiceWrapper;
    IAlertsService alertsService;
    IUserPreferenceService userPreferenceService;
     public void setAlertsService(IAlertsService service) {
        this.alertsService = service;
    }

    public IAlertsService getAlertsService() {
        return alertsService;
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


    protected ModelAndView handleRequestInternal(HttpServletRequest arg0, HttpServletResponse arg1) throws Exception {
        // TODO Auto-generated method stub

        HttpSession session = arg0.getSession(true);
        session.setAttribute("CURRENT_LINK","HOME");
        session.removeAttribute("fromKOLStrategy");
        session.removeAttribute("ORG_LINK");
        session.removeAttribute("ORGID");
        String staffId = null;
        String userId;
        long userid = 0;
         if (arg0.getSession().getAttribute(Constants.CURRENT_USER) != null){
            staffId =  (String)session.getAttribute(Constants.CURRENT_STAFF_ID);
           userId = (String) session.getAttribute(Constants.USER_ID);
            userid = Long.parseLong(userId);
           session.setAttribute("STAFF_ID",staffId);
        }
 		String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);

        arg0.getSession().setAttribute("stateAbbriviation", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("STATE"), userGroupId));
        KOLManager kolManager = new KOLManager();
        session.setAttribute("MY_TACTIC_LIST",kolManager.getMyTacticList(staffId));

        session.setAttribute("reportsList", reportService.getAllReports(userGroupId));
        session.setAttribute(Constants.ALERT_QUEUE, getAlertsService().getAlertQueue((String)session.getAttribute(Constants.USER_ID)));
        
        UserPreference userPreference = new UserPreference();
        if(userPreference != null)
        session.setAttribute("userPreference", userPreference.getFrequency()+"");

        ModelAndView mav = new ModelAndView("home");
        return mav;
    }

  public void setReportService(IReportService reportService){
    this.reportService = reportService;
  }

public IUserPreferenceService getUserPreferenceService() {
	return userPreferenceService;
}

public void setUserPreferenceService(
		IUserPreferenceService userPreferenceService) {
	this.userPreferenceService = userPreferenceService;
}

}
