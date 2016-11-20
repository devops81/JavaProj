package com.openq.web.controllers;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authorization.IFeaturePermissionService;
import com.openq.report.IReportGroupMapService;
import com.openq.report.IReportGroupService;
import com.openq.report.IReportService;
import com.openq.report.ReportGroups;
import com.openq.web.ActionKeys;

public class ReportsGroupMapController extends AbstractController {
  private static Logger logger = Logger
      .getLogger(ReportsAdminController.class);
  IReportGroupService reportGroupService;
  IReportGroupMapService reportGroupMapService;
  IReportService reportService;
  IFeaturePermissionService  featurePermissionService;

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

public IReportService getReportService() {
    return reportService;
  }

  public void setReportService(IReportService reportService) {
    this.reportService = reportService;
  }

  protected ModelAndView handleRequestInternal(HttpServletRequest req,
    HttpServletResponse res) throws Exception {
    HttpSession session = req.getSession(true);
    session.setAttribute("CURRENT_LINK", "reportGroupMap");
    req.setAttribute("REPORT_PERMISSION_MAP", featurePermissionService.getEntityGroupMapping(Constants.REPORT_PERMISSION_ID));
    String action = req.getParameter("action");
          String groupIdString ="";
  		
  	    String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
  		long userGroupId = -1;
  		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
  		 userGroupId = Long.parseLong(userGroupIdString);
  		
      if(req.getParameter("groupId")!=null){
    	  groupIdString = (String)req.getParameter("groupId");
      }
  	  
      if(ActionKeys.REPORT_GROUP_MAP.equalsIgnoreCase(action)){
			
		}
      else if(action.equalsIgnoreCase("delete")){
    	  logger.debug(session.getClass());
    	  session.setAttribute("Refresh_parent","yes");
    	  if(req.getParameter("groupId")!=null){
        	  groupIdString = (String)req.getParameter("groupId");
          }
    	  
    	  String checkedUserIds = null;
	      if (null != req.getParameter("chkGroupIds")) {
	          checkedUserIds = req.getParameter("chkGroupIds");
	          logger.debug(checkedUserIds);
	          logger.debug("ids for deletion" + checkedUserIds.length());
		      
	      }
	      if (null != checkedUserIds && !"".equals(checkedUserIds)) {
	          String ids[] = null;
	          if (checkedUserIds.indexOf(",") != -1) {
	              ids = checkedUserIds.split(",");
	              if (null != ids && ids.length > 0) {
	                  for (int i = 0; i < ids.length; i++) {
	                	  logger.debug("id for deletion"+ids[i]);
	                	  reportGroupMapService.deleteReportGroupMap(Long.parseLong(ids[i]), Long.parseLong(groupIdString), userGroupId);
	                  }
	              }
	          } else {
	        	  logger.debug("id for deletion"+ids);
	        	  logger.debug("group id string " + groupIdString);
            	  reportGroupMapService.deleteReportGroupMap(Long.parseLong(checkedUserIds), Long.parseLong(groupIdString), userGroupId);
	          }
	      }
	      
			
      
      }else if(action.equalsIgnoreCase("add")){
    	  session.setAttribute("Refresh_parent","yes");
    	  if(req.getParameter("groupId")!=null){
        	  groupIdString = (String)req.getParameter("groupId");
          }
    	  
	      String checkedUserIds = null;
	      if (null != req.getParameter("chkGroupIds")) {
	          checkedUserIds = req.getParameter("chkGroupIds");
	      }
	      if (null != checkedUserIds && !"".equals(checkedUserIds)) {
	          String ids[] = null;
	          if (checkedUserIds.indexOf(",") != -1) {
	              ids = checkedUserIds.split(",");
	              if (null != ids && ids.length > 0) {
	                  for (int i = 0; i < ids.length; i++) {
	                	  reportGroupMapService.saveReportGroupMap(Long.parseLong(ids[i]), Long.parseLong(groupIdString));
	                  }
	              }
	          } else {
	        	  reportGroupMapService.saveReportGroupMap(Long.parseLong(checkedUserIds), Long.parseLong(groupIdString));
	          }
	      }
	      
			
      
      }
      
    if(!(groupIdString.equals(""))){
    	List rgm = reportGroupMapService.getAllReportsListForGroup(Long.parseLong(groupIdString), userGroupId);
		ReportGroups group = reportGroupService.getGroup(Long.parseLong(groupIdString));
		session.setAttribute("reportGroupMap", rgm);
		logger.debug("Size of report group map is " + rgm.size());
		session.setAttribute("Group", group);
    }
    session.setAttribute("CURRENT_LINK", "reportGroupMap");
    session.setAttribute("reportsList", reportService.getAllReports(userGroupId));
    ModelAndView mav = new ModelAndView("reportsGroupMap");
    // mav.addObject("reportList", reportService.getAllReports());
    return mav;
  }

/**
 * @return the reportGroupMapService
 */
public IReportGroupMapService getReportGroupMapService() {
	return reportGroupMapService;
}

/**
 * @param reportGroupMapService the reportGroupMapService to set
 */
public void setReportGroupMapService(
		IReportGroupMapService reportGroupMapService) {
	this.reportGroupMapService = reportGroupMapService;
}

/**
 * @return the reportGroupService
 */
public IReportGroupService getReportGroupService() {
	return reportGroupService;
}

/**
 * @param reportGroupService the reportGroupService to set
 */
public void setReportGroupService(IReportGroupService reportGroupService) {
	this.reportGroupService = reportGroupService;
}

}
