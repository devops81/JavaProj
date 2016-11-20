package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;
import com.openq.interactionData.UserRelationship;
import com.openq.report.IReportService;
import com.openq.report.Report;
import com.openq.survey.ISurveyService;
import com.openq.utils.PropertyReader;

public class ReportsUserController extends AbstractController {
	private static Logger logger = Logger
	.getLogger(ReportsUserController.class);

	IReportService reportService;
	IOptionService optionService;
	ISurveyService surveyService;

	public ISurveyService getSurveyService() {
        return surveyService;
    }

    public void setSurveyService(ISurveyService surveyService) {
        this.surveyService = surveyService;
    }

    public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
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
		ModelAndView mav = new ModelAndView("reportsUser");
		String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
		session.setAttribute("REPORT_LIST", reportService.getAllReports(userGroupId));
		session.setAttribute("CURRENT_LINK", "REPORTS");
		String initialReportName = req.getParameter("reportName");
		if (initialReportName != null) {
			Report report = reportService.getReport(initialReportName, userGroupId);
			if (report != null) {
				session.setAttribute("initialReport", report);
				// Get a list of the parameters used by the report and add it to
				// the session
				JasperReport jasperReport = JasperCompileManager
				.compileReport(report.getReportDesignStream());
				if (jasperReport != null) {
					ArrayList reportParametersList = new ArrayList();
					JRParameter[] reportParametersName = jasperReport
					.getParameters();
					if (reportParametersName != null
							&& reportParametersName.length > 0) {

						for (int i = 0; i < reportParametersName.length; i++) {
						    if( !reportParametersName[i].isSystemDefined() ){
    							String parameterName = reportParametersName[i].getName();
    							if (!reportParametersList.contains(parameterName)){
    								reportParametersList.add(parameterName);
    							}
						    }
						}
						// TODO: Find way to access ArrayList.contains method in JSTL
						//  and then pass parameterlist using mav.addObject(modelName, modelObject)
						session.setAttribute("REPORT_PARAMETER_LIST",
								reportParametersList);
					}
				}
			}
		}
		UserRelationship currentUserRelationship = (UserRelationship) session.getAttribute(Constants.CURRENT_USER_RELATIONSHIP);
		if(currentUserRelationship != null){
			String userTerritoryString = currentUserRelationship.getTerritory();
			long userTerritory = -1;
			if(userTerritoryString != null){
				userTerritory = Long.parseLong(userTerritoryString);
			}
			mav.addObject("userTerritory", new Long(userTerritory));
		    //System.out.println("userTerritory is"+userTerritory +" \n ");
		}
		long reportLevel =  0;
		long territory = 0;
		if(currentUserRelationship != null){
			
		reportLevel =  Long.parseLong(currentUserRelationship.getReportLevel());
		if(reportLevel==2)
		{
			OptionLookup regionOpt = optionService.getOptionLookup(Long.parseLong(currentUserRelationship.getTerritory()));
			if(regionOpt!=null)
			{
			  OptionLookup taOpt =optionService.getOptionLookup(regionOpt.getParentId());
			  if(taOpt!=null)
			  {
				  //System.out.println("The TA for the region is"+taOpt.getOptValue()+"**\n");
				  mav.addObject("userParentTA", new Long(taOpt.getId()));
			  }
			}
		}
		else if(reportLevel==1)
		{
			OptionLookup territoryOpt = optionService.getOptionLookup(Long.parseLong(currentUserRelationship.getTerritory()));
			if(territoryOpt!=null)
			{
				OptionLookup regionOpt = optionService.getOptionLookup(territoryOpt.getParentId());
				if(regionOpt!=null)
				{
				  //System.out.println("The Region for the Territory is"+regionOpt.getOptValue());  
				  mav.addObject("userParentRAD", new Long(regionOpt.getId()));
				  OptionLookup taOpt =optionService.getOptionLookup(regionOpt.getParentId());
				  if(taOpt!=null)
				  {
					  //System.out.println("The TA for the region is"+taOpt.getOptValue()+"**\n");
					  mav.addObject("userParentTA", new Long(taOpt.getId()));
				  }
				}	
			}
			
		}
		 territory= Long.parseLong(currentUserRelationship.getTerritory());
		}

	    //System.out.println("Report level is "+reportLevel+"\n"); 
		OptionLookup userTypelookup = (OptionLookup)session.getAttribute(Constants.USER_TYPE);
		long userTypeId = userTypelookup.getId();
		mav.addObject("surveyName",surveyService.getLaunchedSurveyMap(userGroupId,userTypeId,false));
		mav.addObject("reportsProducts", optionService
				.getValuesForOptionByDeleteStatus(PropertyReader
						.getLOVConstantValueFor("PRODUCT"), userGroupId, true));
		mav.addObject("reportsUnOffLabelProducts", optionService
				.getValuesForOptionByDeleteStatus(PropertyReader
						.getLOVConstantValueFor("OFF_LABEL_PRODUCT"), userGroupId, true));
		mav.addObject("reportsFA", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("FUNCTIONAL_AREA"), userGroupId));
		mav.addObject("reportsEventRegion", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("EVENT_REGION"), userGroupId));
		mav.addObject("reportsTherapy", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("THERAPY"), userGroupId));
		mav.addObject("reportsEventSubType", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("EVENT_SUB_TYPE"), userGroupId));
		mav.addObject("reportsEventDivision", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("EVENT_DIVISION"), userGroupId));
		mav.addObject("reportsEventStatus", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("EVENT_STATUS"), userGroupId));
		mav.addObject("reportsEventType", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("EVENT_TYPES"), userGroupId));
		mav.addObject("reportsState", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("STATE"), userGroupId));
		mav.addObject("reportsQualifiedFor", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("QUALIFIED_FOR"), userGroupId));
		mav.addObject("reportsAgreementTerms", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("AGREEMENT_TERM"), userGroupId));
		mav.addObject("reportsContactMechanismType", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("CONTACT_MECHANISM_TYPE"), userGroupId));

		mav.addObject("reportsHeadQuarters", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("HEAD_QUARTERS"), userGroupId));
		
	      mav.addObject("reportsAreaOfExpertise", optionService
	                .getValuesForOption(PropertyReader
	                        .getLOVConstantValueFor("AREA_OF_EXPERTISE"), userGroupId));
	      
	      mav.addObject("reportsDiseaseArea", optionService
	                .getValuesForOption(PropertyReader
	                        .getLOVConstantValueFor("DISEASE_AREA"), userGroupId));
	      
		if(Constants.HQ_REPORT_LEVEL == reportLevel){
			List list =optionService.getRelatedChild(PropertyReader
					.getLOVConstantValueFor("THERAPEUTIC_AREA"), territory, userGroupId);
					if(list!=null && list.size()>0)
			 mav.addObject("reportsTA", (OptionLookup[]) list.toArray(new OptionLookup[list.size()]));
		}

		if(Constants.TA_REPORT_LEVEL == reportLevel  ){
			mav.addObject("reportsTA", optionService
					.getValuesForOption(PropertyReader
							.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
			List list = optionService.getRelatedChild(PropertyReader
					.getLOVConstantValueFor("RAD"), territory, userGroupId);
			if(list!=null && list.size()>0)
			mav.addObject("reportsRAD",(OptionLookup[]) list.toArray(new OptionLookup[list.size()]));
	
		}
		if(Constants.RAD_REPORT_LEVEL == reportLevel ){
			mav.addObject("reportsTA", optionService
					.getValuesForOption(PropertyReader
							.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
			mav.addObject("reportsRAD", optionService
					.getValuesForOption(PropertyReader
							.getLOVConstantValueFor("RAD"), userGroupId));
			List list = optionService.getRelatedChild(PropertyReader
					.getLOVConstantValueFor("TERRITORY"), territory, userGroupId);
			if(list!=null && list.size()>0)
			mav.addObject("reportsTerritory", (OptionLookup[]) list.toArray(new OptionLookup[list.size()]));
					
			
		}
		if(Constants.MSL_REPORT_LEVEL == reportLevel){
			mav.addObject("reportsTA", optionService
					.getValuesForOption(PropertyReader
							.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
			mav.addObject("reportsRAD", optionService
					.getValuesForOption(PropertyReader
							.getLOVConstantValueFor("RAD"), userGroupId));
			mav.addObject("reportsTerritory", optionService
					.getValuesForOption(PropertyReader
							.getLOVConstantValueFor("TERRITORY"), userGroupId));
		 }
		mav.addObject("MSLOLType", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("MSL_OL_TYPE"), userGroupId));
		mav.addObject("CVMETSphereOfInfluence", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("SPHERE_OF_INFLUENCE"), userGroupId));
		mav.addObject("saxaOLCharacteristics", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("SAXA_OL_CHARACTERISTICS"), userGroupId));
		mav.addObject("reportResultsLevel", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("REPORT_LEVEL"), userGroupId));
		mav.addObject("reportInteractionType", optionService
				.getValuesForOption(PropertyReader
						.getLOVConstantValueFor("INTERACTION_TYPE"), userGroupId));
		
		
		
		
		return mav;
	}

}
