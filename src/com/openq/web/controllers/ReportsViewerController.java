package com.openq.web.controllers;

import java.io.ByteArrayOutputStream;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanArrayDataSource;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.export.JExcelApiExporter;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.j2ee.servlets.BaseHttpServlet;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;
import com.openq.interactionData.IUserRelationshipService;
import com.openq.interactionData.UserRelationship;
import com.openq.report.IReportService;
import com.openq.report.Report;
import com.openq.user.User;
import com.openq.utils.ByteArrayDataSource;
import com.openq.web.ActionKeys;

public class ReportsViewerController extends AbstractController {
	private static Logger logger = Logger
	.getLogger(ReportsViewerController.class);
	//private static String taName = "";


	protected ModelAndView handleRequestInternal(HttpServletRequest req,
			HttpServletResponse res) throws Exception {
		HttpSession session = req.getSession(true);
		String action = (String) req.getParameter("action");
		String page = (String)req.getParameter("page");
		String sessionDataSourceAttrib = (String) req
		.getParameter("sessionDSAttrib");
		String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		String taName ="";
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
			userGroupId = Long.parseLong(userGroupIdString);
		String ExpertList = "KOLID IN (";

		/*Territory Relationship code goes here*/
		UserRelationship currentUserRelationship = (UserRelationship) session.getAttribute(Constants.CURRENT_USER_RELATIONSHIP);
		long reportLevel = 0;
		long territory = 0;
		String usersList = "";
		String userListFullTree ="" ;


		if (!ActionKeys.EXPORT_XLS.equals(action)
				&& !ActionKeys.EXPORT_PDF.equals(action)
				&& !ActionKeys.EMAIL_REPORT.equals(action) && req.getParameter("searchResults") == null){
			if(currentUserRelationship != null){	
				String TA = (String)session.getAttribute(Constants.CURRENT_USER_TA);

				if(TA!=null && !"".equalsIgnoreCase(TA)){

					OptionLookup optionLookup = optionService.getOptionLookup(Long.parseLong(TA)); 
					if(optionLookup != null)
						taName =  optionLookup.getOptValue();

				}
				if("home".equalsIgnoreCase(page))
				{

					reportLevel = Long.parseLong(currentUserRelationship.getReportLevel());
					territory = Long.parseLong(currentUserRelationship.getTerritory()) ;
					/*String TA = (String)session.getAttribute(Constants.CURRENT_USER_TA);



   			if(TA!=null && !"".equalsIgnoreCase(TA)){

   				OptionLookup optionLookup = optionService.getOptionLookup(Long.parseLong(TA)); 
   				if(optionLookup != null)
   					taName =  optionLookup.getOptValue();

   			}*/
					//taName  =  (String)session.getAttribute(Constants.CURRENT_USER_TA);//get from session




				}
				else{
					if(!("All".equalsIgnoreCase((String)req.getParameter("reportTerritory"))) && req.getParameter("reportTerritory")!=null)
					{
						reportLevel = 1;
						OptionLookup optionLookup = optionService.getOptionForOptionValue((String)req.getParameter("reportTerritory"));
						if(optionLookup != null)
							territory = optionLookup.getId();


					}
					else
					{
						if(!("All".equalsIgnoreCase((String)req.getParameter("reportRegion"))) && req.getParameter("reportRegion")!=null)
						{
							reportLevel = 2;
							OptionLookup optionLookup = optionService.getOptionForOptionValue((String)req.getParameter("reportRegion"));
							if(optionLookup != null)
								territory = optionLookup.getId();

						}
						else{
							if(!("All".equalsIgnoreCase((String)req.getParameter("reportTherapeuticArea")))&& req.getParameter("reportTherapeuticArea")!=null)
							{
								reportLevel = 3;
								OptionLookup optionLookup = optionService.getOptionForOptionValue((String)req.getParameter("reportTherapeuticArea"));
								if(optionLookup != null){
									territory = optionLookup.getId();
									taName = optionLookup.getOptValue();

								}

							}
							else
							{
								if(("All".equalsIgnoreCase((String)req.getParameter("headQuarters")))&& req.getParameter("headQuarters")!=null){
									reportLevel = 4;
									territory = optionService.getIdForOptionValueAndParentName("HQ", "HeadQuarters");//(String)req.getParameter("headQuarters"));
									taName = "%";
								}
							}
						}
					}
				}
			}	
		}

		if(territory!=0 && reportLevel !=0){
			String territoryIds = getTerritoryIds(reportLevel,territory,userGroupId,"");
			usersList = getUsersforTerritoryIds(territoryIds);
			
			List reportParameterList = (List)req.getSession().getAttribute("REPORT_PARAMETER_LIST");
			session.removeAttribute("REPORT_PARAMETER_LIST");
			if(null!= reportParameterList && reportParameterList.contains("userListFullTree")){
				String territoryIdsfullTree =getTerritoryIdsfullTree(reportLevel, territory, userGroupId, "");
				userListFullTree =getUsersforTerritoryIds(territoryIdsfullTree);
			}
			//usersList = usersList + userIds ;

		}

		/*Territory Code ends here */

		ModelAndView mav = new ModelAndView("reportsViewer");

		long reportID = 0;
		if (req.getParameter("reportID") != null) {
			reportID = Long.parseLong(req.getParameter("reportID"));
		} else if (req.getParameter("reportName") != null) {
			Report reportObj = reportService.getReport(req.getParameter("reportName"), userGroupId);
			if(reportObj !=null)
				reportID = reportObj.getReportID();
		} else if (req.getSession().getAttribute("reportID") != null) {
			reportID = Long.parseLong((String) req.getSession().getAttribute(
			"reportID"));
		}

		session.setAttribute("reportID", reportID + "");

		String reportName = "Report";
		Report report = reportService.getReport(reportID,userGroupId);

		if (report != null) {
			reportName = report.getName();
		}
		logger.debug("Report Id : Report Name = " + reportID + " : "
				+ reportName);
		if (ActionKeys.EXPORT_XLS.equals(action)
				|| ActionKeys.EXPORT_PDF.equals(action)
				|| ActionKeys.EMAIL_REPORT.equals(action)) {
			logger.debug("Export report action : " + action);
			JasperPrint jasperPrint = null;
			if ((JasperPrint) session
					.getAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE) != null) {
				jasperPrint = (JasperPrint) session
				.getAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE);

				if (ActionKeys.EXPORT_XLS.equals(action)) {
					res.setContentType("application/xls");
					String downloadFileName = reportName + ".xls";
					res.setHeader("content-disposition", "attachment; name=\""
							+ downloadFileName + "\"; filename=\""
							+ downloadFileName + "\"");

					ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
					JExcelApiExporter xlsExporter = new JExcelApiExporter();
					xlsExporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.FALSE);
					xlsExporter.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
					xlsExporter.setParameter(
							JRXlsExporterParameter.JASPER_PRINT, jasperPrint);
					xlsExporter.setParameter(
							JRXlsExporterParameter.OUTPUT_STREAM, byteStream);

					xlsExporter.exportReport();
					res.setContentLength(byteStream.toByteArray().length);
					res.getOutputStream().write(byteStream.toByteArray());
					return null; // Fix : org.apache.jasper.JasperException:
					// getOutputStream() has already been called for this
					// response

				} else if (ActionKeys.EXPORT_PDF.equals(action)) {
					res.setContentType("application/pdf");
					String downloadFileName = reportName + ".pdf";
					res.setHeader("content-disposition", "attachment; name=\""
							+ downloadFileName + "\"; filename=\""
							+ downloadFileName + "\"");

					ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
					JRPdfExporter pdfExporter = new JRPdfExporter();
					pdfExporter.setParameter(
							JRPdfExporterParameter.JASPER_PRINT, jasperPrint);
					pdfExporter.setParameter(
							JRPdfExporterParameter.OUTPUT_STREAM, byteStream);

					pdfExporter.exportReport();
					res.setContentLength(byteStream.toByteArray().length);
					res.getOutputStream().write(byteStream.toByteArray());
					return null; // Fix : org.apache.jasper.JasperException:
					// getOutputStream() has already been called for this
					// response
				} else if (ActionKeys.EMAIL_REPORT.equals(action)) {

					ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
					JRPdfExporter pdfExporter = new JRPdfExporter();
					pdfExporter.setParameter(
							JRPdfExporterParameter.JASPER_PRINT, jasperPrint);
					pdfExporter.setParameter(
							JRPdfExporterParameter.OUTPUT_STREAM, byteStream);

					pdfExporter.exportReport();

					javax.activation.DataSource aAttachment = new ByteArrayDataSource(
							reportName + ".pdf", byteStream.toByteArray(),
					"application/pdf");

					/*
					 * ReportEMail mail = new ReportEMail(); mail.kolName =
					 * PropertyReader.getInstance().getEmailConfigValueFor("DEMO_CONTACT_LAST_NAME") + ", " +
					 * PropertyReader.getInstance().getEmailConfigValueFor("DEMO_CONTACT_FIRST_NAME");
					 * mail.username = (String)
					 * req.getSession().getAttribute(Constants.COMPLETE_USER_NAME);
					 * EventNotificationMailSender.getInstance().send(mail.returnCompleteHTMLString(),aAttachment);
					 */
				}
			}
			return mav;
		} else {
			Report reportObject = reportService.getReport(reportID,userGroupId);
			if(reportObject!=null){
				JasperReport jasperReport = JasperCompileManager
				.compileReport(reportObject.getReportDesignStream());
				Connection conn = null;
				JasperPrint jasperPrint = null;

				Map paramMap = new HashMap();
				if (req.getParameter("searchResults") != null) {

					Map expertsFound = (Map) session.getAttribute("experts");
					LinkedHashMap totalExpertsFound = (LinkedHashMap) session.getAttribute("EXPERT_RESULT_MAP");
					List filteredResultSet = null;

					if (expertsFound != null && totalExpertsFound != null) {
						filteredResultSet = new ArrayList(totalExpertsFound.keySet());
						long kolidsAddedCount = 0;
						for (int i = 0; i < filteredResultSet.size() - 1; i++) {
							kolidsAddedCount ++ ;
							if (kolidsAddedCount%1000 == 0)
							{
								ExpertList = ExpertList.substring(0, ExpertList.length()-1);
								ExpertList = ExpertList + ") OR KOLID IN (";

							}
							else
							{
								ExpertList = ExpertList
								+ ((User) filteredResultSet.get(i)).getKolid()
								+ ",";
							}
						}
						ExpertList = ExpertList
						+ ((User) filteredResultSet.get(filteredResultSet
								.size() - 1)).getKolid() + ")";
						paramMap.put("ExpertList", ExpertList);
					}
				} else {

					loadStaticParameters(paramMap,session);
					if(usersList.length()>1){
						paramMap.put("usersList",usersList);
					}
					if(userListFullTree.length()> 1){
						paramMap.put("userListFullTree",userListFullTree);
					}
					paramMap.put("TA", session.getAttribute(Constants.CURRENT_USER_TA));
					if("".equalsIgnoreCase(taName)){
						taName = req.getParameter("reportTherapeuticArea");
					}
					paramMap.put("taName", taName);
					String territoryName = req.getParameter("reportTerritory");
					String radName = req.getParameter("reportRegion");
					//if(!radName.equalsIgnoreCase("All"))
					paramMap.put("radName", radName);
					//if(!territoryName.equalsIgnoreCase("All"))
					paramMap.put("territoryName", territoryName);

					for (Enumeration paramNames = req.getParameterNames(); paramNames
					.hasMoreElements();) {
						String paramName = paramNames.nextElement().toString();
						if (req.getParameter(paramName) != null) {
							paramMap.put(paramName, req.getParameter(paramName));
						}
					}
					// adding metadata of the user for reports
					paramMap.put("userGroupId", userGroupIdString);
					paramMap.put("userStaffId", (String) session.getAttribute(Constants.CURRENT_STAFF_ID));
					paramMap.put("username", (String) session.getAttribute(Constants.COMPLETE_USER_NAME));
				}
				logger.debug("Report Parametr Size : " + paramMap.size());
				try {
					conn = dataSource.getConnection();

					if (sessionDataSourceAttrib != null
							&& sessionDataSourceAttrib.length() != 0) {
						Object dataSource = session
						.getAttribute(sessionDataSourceAttrib);
						JRDataSource jrDataSource = null;
						if (dataSource instanceof Object[]) {
							jrDataSource = new JRBeanArrayDataSource(
									(Object[]) dataSource);
						} else if (dataSource instanceof Collection) {
							jrDataSource = new JRBeanCollectionDataSource(
									(Collection) dataSource);
						} else {
							jrDataSource = new JRBeanArrayDataSource(
									new Object[] { dataSource });
						}
						jasperPrint = JasperFillManager.fillReport(jasperReport,
								paramMap, jrDataSource);
					} else {
						jasperPrint = JasperFillManager.fillReport(jasperReport,
								paramMap, conn);
					}

				} catch (Exception e) {
					logger.error(e.getMessage());
				} finally {
					conn.close();
				}

				session.setAttribute(
						BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE,
						jasperPrint);
				if (req.getParameter("searchResults") != null)
					res
					.sendRedirect("reportsViewer.htm?reportName=SearchReport&action=exportToXls&searchResults=yes");

			}
			return mav;
		}
	}

	private void loadStaticParameters(Map paramMap, HttpSession session) {


		/*String TA = (String)session.getAttribute(Constants.CURRENT_USER_TA);

		if(TA!=null && !"".equalsIgnoreCase(TA)){

			OptionLookup optionLookup = optionService.getOptionLookup(Long.parseLong(TA)); 
			if(optionLookup != null)
			paramMap.put("taName", optionLookup.getOptValue());

		}*/

		//paramMap.put("taName", taName);

	}

	private String getUsersforTerritoryIds(String territoryIds) {

		if(territoryIds == null || "".equalsIgnoreCase(territoryIds))
			return "-1";

		UserRelationship[] userRelationship = userRelationshipService.getUserRelationshipForTerritories(territoryIds.substring(0, territoryIds.length()-1));
		String userIds="";
		for(int i=0;i<(userRelationship!=null?userRelationship.length:0);i++){
			userIds = userIds+userRelationship[i].getUserId()+",";
		}
		if(!"".equalsIgnoreCase(userIds) && userIds != null)
			return userIds.substring(0,userIds.length()-1);

		return userIds;

	}


	private String getTerritoryIds(long reportLevel, long territory, long userGroupId, String territoryIds) {

		if(reportLevel == 1)
			return territory+","+territoryIds;
		// else
		//{
		String optionName = "";
		if(reportLevel == 4)
			optionName = "Therapeutic Area";
		if(reportLevel == 3)
			optionName ="RAD";
		else
			if(reportLevel == 2)
				optionName = "Territory";
		List list = optionService.getRelatedChild(optionName, territory, userGroupId);

		for(int i = 0;i<list.size();i++)
		{
			OptionLookup optionLookup = (OptionLookup) list.get(i);
			territoryIds =  getTerritoryIds(reportLevel-1, optionLookup.getId(), userGroupId, territoryIds);
		}
		return territoryIds;

		//}


	}
	private String getTerritoryIdsfullTree(long reportLevel, long territory, long userGroupId, String territoryIds) {

		if(reportLevel == 1)
			return territory+","+territoryIds;
		// else
		//{
		String optionName = "";
		if(reportLevel == 4)
			optionName = "Therapeutic Area";
		if(reportLevel == 3)
			optionName ="RAD";
		else
			if(reportLevel == 2)
				optionName = "Territory";
		List list = optionService.getRelatedChild(optionName, territory, userGroupId);

		for(int i = 0;i<list.size();i++)
		{
			OptionLookup optionLookup = (OptionLookup) list.get(i);
			territoryIds =  getTerritoryIds(reportLevel-1, optionLookup.getId(), userGroupId, territoryIds);
			territoryIds = territory+","+territoryIds;
		}
		return territoryIds;

		//}


	}


	IReportService reportService;
	IOptionService optionService;
	DataSource dataSource;
	IUserRelationshipService userRelationshipService;

	public DataSource getDataSource() {
		return dataSource;
	}

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public IReportService getReportService() {
		return reportService;
	}

	public void setReportService(IReportService reportService) {
		this.reportService = reportService;
	}

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

	public IUserRelationshipService getUserRelationshipService() {
		return userRelationshipService;
	}

	public void setUserRelationshipService(
			IUserRelationshipService userRelationshipService) {
		this.userRelationshipService = userRelationshipService;
	}

}
