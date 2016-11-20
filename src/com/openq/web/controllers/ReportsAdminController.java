package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.core.style.ToStringCreator;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.report.IReportService;
import com.openq.report.Report;

public class ReportsAdminController extends AbstractController {
  private static Logger s_logger = Logger
      .getLogger(ReportsAdminController.class);

  IReportService reportService;

  public IReportService getReportService() {
    return reportService;
  }

  public void setReportService(IReportService reportService) {
    this.reportService = reportService;
  }

  protected ModelAndView handleRequestInternal(HttpServletRequest req,
      HttpServletResponse res) throws Exception {
    HttpSession session = req.getSession(true);
    session.setAttribute("CURRENT_LINK", "REPORTS");
    String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
	long userGroupId = -1;
	if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
	 userGroupId = Long.parseLong(userGroupIdString);
    

    if (req.getContentType() != null
        && req.getContentType().indexOf("multipart") >= 0) {

      s_logger.error(req.getClass());
      s_logger.error(""+(req instanceof MultipartHttpServletRequest));
      MultipartHttpServletRequest mreq = (MultipartHttpServletRequest)req;
      String action = mreq.getParameter("action");

      if ("add".equalsIgnoreCase(action)) {
        Report report = new Report();
        report.setName(mreq.getParameter("reportName"));
        report.setDescription(mreq.getParameter("reportDesc"));
        report.setReportDesignStream(mreq.getFile("browse").getInputStream());
        reportService.saveReport(report);
        
        s_logger.debug("Added report : " + new ToStringCreator(report).toString());
      } else if ("edit".equalsIgnoreCase(action)) {

      } else if ("update".equalsIgnoreCase(action)) {

      } else if ("delete".equalsIgnoreCase(action)) {
        String reportIDs[] = mreq.getParameterValues("reportID");
        for (int i = 0; i < reportIDs.length; i++) {
          reportService.deleteReport(Long.parseLong(reportIDs[i]),userGroupId);
        }
      }
    }

    
    session.setAttribute("reportsList", reportService.getAllReports(userGroupId));
    ModelAndView mav = new ModelAndView("reportsAdmin");
    // mav.addObject("reportList", reportService.getAllReports());
    return mav;
  }

}
