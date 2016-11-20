/* 
 * Date: 12-Feb-2008
 * Description: Changes to TimeReportController.java to complete RML Time Allocation functionality
 * 
 */
package com.openq.web.controllers;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.authentication.UserDetails;

import com.openq.time.ITimeReportService;
import com.openq.time.TimeReport;
import com.openq.web.ActionKeys;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.option.OptionLookupDoubleComparator;


public class TimeReportController extends AbstractController
{
	private ITimeReportService timeReportService;
	private IOptionServiceWrapper optionServiceWrapper;
	    
	/*
	private String region;
	*/
	
	protected ModelAndView handleRequestInternal(HttpServletRequest request, 
		HttpServletResponse response) throws Exception 
	{
		logger.info("Control in TimeReportController class");
		
		// Get only general information required across all action keys
		HttpSession session = request.getSession();
        String action = (String) request.getParameter("action");
        session.setAttribute("CURRENT_LINK", "TIME_REPORT");
        /*
        String tafaregion = null != session.getAttribute("TA_Fa_Region") ? (String)session.getAttribute("TA_Fa_Region") : null;
	    region=tafaregion.split("_")[2];
	    */
		String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
	    UserDetails user = (UserDetails) session.getAttribute(Constants.CURRENT_USER);
		
		// Set default dates for the results to be displayed
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");  
		GregorianCalendar cal = new GregorianCalendar();
		Date toDate = new Date();
		cal.setTime(toDate);
        cal.add(Calendar.DATE, -6);        
    	Date fromDate = cal.getTime();

		// If action is delete a report item
		if (ActionKeys.DELETE_TIMEREPORT.equalsIgnoreCase(action)) {
			logger.debug("Action Key is Delete Time Report");	        	
	       	deleteReport(request);
		}
	        
		// If action is save/update(edit) report item(s)
		if (ActionKeys.SAVE_TIMEREPORT.equalsIgnoreCase(action)) {
        	logger.debug("Action Key is Save Time Report");
        	saveReport(request, userGroupId);
        	
        	// Set report search range to be a week before the date of activity of the saved report
        	toDate = (getNewReport(request)).getActivityDate();
        	cal.setTime(toDate);
        	cal.add(Calendar.DATE, -6);
        	fromDate = cal.getTime();
		}
			    			
		// If there was a specific search lets overwrite the default search date range
		if (ActionKeys.SEARCH_TIMEREPORT.equalsIgnoreCase(action)) {
	       	logger.debug("Action Key is Search Time Report");	        	
	       	
	       	String tempDate = request.getParameter("fromDate");
            if (null != tempDate && !"".equals(tempDate)) {
            	fromDate = sdf.parse(tempDate);
            }
              
            tempDate = request.getParameter("toDate");
            if (null != tempDate && !"".equals(tempDate)) {
                toDate = sdf.parse(tempDate);
            }        
		}
			
		// Now that we have the range lets fetch the reports
		// Max of 31 days can be retrieved
		// If more than 31 days are being retrived, lets clip the range
		long dateDiff = toDate.getTime() - fromDate.getTime();
		dateDiff = (dateDiff/(1000*60*60*24))+1;
		if(dateDiff>31) {
			GregorianCalendar gCal = new GregorianCalendar();
			gCal.setTime(fromDate);
			gCal.add(GregorianCalendar.DATE, 30);
			toDate = gCal.getTime();
		}
		
		
		TimeReport[] timeReports = timeReportService.getTimeFrameReport(Long.parseLong(user.getId()), fromDate, toDate);			
				
		if(null != timeReports && timeReports.length!=0) {
			// Sort by date ascending to group time entries in order and together for later processing of combined finished flags
			Arrays.sort(timeReports);
			session.setAttribute("TIMEREPORT", timeReports);
		}
		else {
			session.setAttribute("MESSAGE", "No reports found for date range");
		}
	
	    // Set default search lovs, lookup service (lookup probably not the best way) for presentation
		session.setAttribute("SEARCH_FROM_DATE", fromDate);
		session.setAttribute("SEARCH_TO_DATE", toDate);
		session.setAttribute("TIME_TYPE", optionServiceWrapper.getUndeletedValuesForOptionName("Time Type", userGroupId));
		OptionLookup[] percentList = optionServiceWrapper.getUndeletedValuesForOptionName("Time Percentage", userGroupId);
		Arrays.sort(percentList, new OptionLookupDoubleComparator());
		session.setAttribute("TIME_SPENT", percentList);			
		session.setAttribute("OPTION_SRV_WRP", optionServiceWrapper);
						
		return new ModelAndView("timeReport"); 			
	}
		
	public ITimeReportService getTimeReportService() {
		return timeReportService;
	}

		public void setTimeReportService(ITimeReportService timeReportService) {
			this.timeReportService = timeReportService;
		}

		public IOptionServiceWrapper getOptionServiceWrapper() {
			return optionServiceWrapper;
		}

		public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
			this.optionServiceWrapper = optionServiceWrapper;
		}
		
		private void deleteReport(HttpServletRequest request) {
			logger.debug("Deleting a Report");
			
			String reportIdParam = request.getParameter("timeReportId");
	       	if (null != reportIdParam && !"".equals(reportIdParam)) {
	       		long reportId = Long.parseLong(reportIdParam);
	       		TimeReport existingReport = timeReportService.getTimeReport(reportId);
	       		
	       		// business check-1:
	       		// only an unfinished report entry can be deleted
	       		// (This is a double check to reinforce the rule, as UI will have delete button disabled for such cases)
	       		// This rule is no longer true, so we will allow deletion
	       		/* 
	       		if(existingReport.isFinished()) {
	       			return;
	       		}
	       		*/
	       		timeReportService.deleteTimeReport(existingReport);		
        	}
		}
		
	private void saveReport(HttpServletRequest request, long userGroupId) {

		logger.debug("Saving Report");
		
		TimeReport timeReport = getNewReport(request);
		if(null==timeReport) {
			// code here to add failure message
			return;
		}		
			
        if(isEditUseCase(request)) {
        	logger.debug("edit case");
        	double curSpentTime = getTimeSpentOnSameDay(timeReport, userGroupId);
        	TimeReport existingReport = timeReportService.getTimeReport(timeReport.getId());        		
        	/* business check-1:
        	 * only an unfinished report entry can be updated
        	 * this is no longer true
        	 */
        	/*
        	if(existingReport.isFinished()) {
        		return;
        	}
        	*/
        	/* business check-2:
        	 * if new report is not finished yet check to ensure total time will be <=100 
        	 */        		
        	double toBeSpentTime = curSpentTime - Double.parseDouble((optionServiceWrapper.getValuesForId(existingReport.getPercentage(), userGroupId)).getOptValue())
        								+ Double.parseDouble((optionServiceWrapper.getValuesForId(timeReport.getPercentage(), userGroupId)).getOptValue());
        		
        	if(!timeReport.isFinished()) {
        		if(toBeSpentTime>10.0) {
	        		return;
	       		}	
       		}
        		
        	/* business check-3:
        	 * if new report is finished check to ensure total time sums to 100
        	 */
        	/* not need for king
        	if(timeReport.isFinished()) {
        		if(toBeSpentTime!=100) {
       				return;
       			}	        			
       		}
       		*/
        		
        	// all rules passed and so we can update the current time report
        	timeReportService.updateTimeReport(timeReport);
        	return;	
        }
        
        // If we are here, we are dealing with a request to save a brand new time report
        logger.debug("save case");
        
       	SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
       	boolean saveRange = isRangeEntry(request);
        		
       	Date uptill = null;
       	// if it is a range to save lets find the end date
       	if(saveRange) {
       		logger.debug("inside save range check");
       		String toDate = request.getParameter("addToDate");
        	if((null != toDate) && !("".equals(toDate))) {	
        		try {
        			uptill = sdf.parse(toDate);
        		}
        		catch(Exception ex)
        		{
        			logger.debug("date exception");
        			logger.debug(ex.toString());
        			// code here should message back
        			return;
        		}
	        }
	       	else {
	       		saveRange = false;
	       	}
       	}
       	
       	logger.debug("before the looping");
       	// for each date in the save range we need to do the below code here replace loop
       	long dateDiff = 1;
       	if(saveRange) {
       		dateDiff = uptill.getTime() - timeReport.getActivityDate().getTime();
       		dateDiff = (dateDiff/(1000*60*60*24))+1;
       	}

   		// Create date holder to iterate over the date range
       	GregorianCalendar nextDate = new GregorianCalendar();
   		nextDate.setTime(timeReport.getActivityDate());
   		nextDate.add(Calendar.DATE, -1);

       	while(dateDiff>0) {
       		// Set a new date into the time report
       		nextDate.add(Calendar.DATE, 1);
       		       	
			/*
       		// Skip creating reports for weekends
       		if((Calendar.SUNDAY==nextDate.get(Calendar.DAY_OF_WEEK))||(Calendar.SATURDAY==nextDate.get(Calendar.DAY_OF_WEEK))) {
       			if(!saveRange) {       				
       				HttpSession session = request.getSession();
       				session.setAttribute("UPDATE_MESSAGE", "The time report was not created as the day falls on a weekend");
       			}
       			dateDiff--;
       			continue;
       		}
			*/
       		
       		timeReport.setActivityDate(nextDate.getTime());      		
       		
       		logger.debug("will savereport for date: " + timeReport.getActivityDate().toString());
       		
       		double curSpentTime = getTimeSpentOnSameDay(timeReport, userGroupId);
       		
       		double toBeSpentTime = curSpentTime + Double.parseDouble((optionServiceWrapper.getValuesForId(timeReport.getPercentage(), userGroupId)).getOptValue());
       		
       		logger.debug("toBeSpentTime is: " + toBeSpentTime);
       		System.out.println("To be spent time is"+toBeSpentTime);
       		/* business check-1:
        	 * if new report is not finished yet check to ensure total time will be <=100 
        	 */        		
        	if(!timeReport.isFinished()) {
        		if(toBeSpentTime>10.0) {
        			if(!saveRange) {       				
           				HttpSession session = request.getSession();
           				session.setAttribute("UPDATE_MESSAGE", "The time report was not created because it would have exceeded 100% for the day");
           			}
        			dateDiff--;
	        		continue;
	       		}	
       		}
        	logger.debug("rule 1 passed");
        	
        	/* business check-2:
        	 * if new report is finished check to ensure total time sums to 100
        	 */
        	/* not needed for king
        	if(timeReport.isFinished()) {
        		if(toBeSpentTime!=100) {
           			if(!saveRange) {       				
           				HttpSession session = request.getSession();
           				session.setAttribute("UPDATE_MESSAGE", "The time report was not created because finished flag is set but total time spent is not 100% for the day");
           			}
        			dateDiff--;
       				continue;
       			}	        			
       		}
        	logger.debug("rule 2 passed");
        	*/
        		
        	// all rules passed and so we can update the current time report
        	logger.debug("Time Report Object:ActivityId:"+timeReport.getActivityId()+",Comments"+timeReport.getComments()+",DeleteFlag"+timeReport.getDeleteFlag()+",FinishedFlag"+timeReport.getFinishedFlag()+",ReportID"+
        			timeReport.getId()+",Percentage"+timeReport.getPercentage()+",UserID"+timeReport.getUserId()+",ActivityDate"+timeReport.getActivityDate()+",CreateDate"+timeReport.getCreateDate()+",UpdateDate"+timeReport.getUpdateDate());

        	timeReportService.saveTimeReport(timeReport);  
        	
        	dateDiff--;       	
       	}	
	}
		private boolean isEditUseCase(HttpServletRequest request) {
        	String existingId = request.getParameter("addTimeEntryId");
        	if((null != existingId) && !("".equals(existingId))) {
        		return true;
        	}
        	return false;
		}
		
		private boolean isRangeEntry(HttpServletRequest request) {
			logger.debug("inside isRangeEntry");
			String entryType = request.getParameter("addEntryType");
        	if((null != entryType) && ("rangeEntry".equals(entryType))) {
        		return true;
        	}
        	return false;
		}
		
		private TimeReport getNewReport(HttpServletRequest request) {
        
			logger.debug("Getting new Report");
			
			// Get all paramaters from session/post request
        	
			HttpSession session = request.getSession();
			
			TimeReport timeReport = new TimeReport();

			timeReport.setUserId(Long.parseLong((String) session.getAttribute(Constants.USER_ID)));
       	
        	boolean editUseCase = isEditUseCase(request);
        	if(editUseCase) {
        		timeReport.setId(Long.parseLong(request.getParameter("addTimeEntryId")));
        	}
        	SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
        	
        	try {
        		timeReport.setActivityDate(sdf.parse(request.getParameter("addFromDate")));
        	}
        	catch (Exception ex)
        	{
        		logger.debug(ex.toString());
        		return null;
        	}
        	
        	timeReport.setActivityId(Long.parseLong(request.getParameter("addTimeType")));
        	timeReport.setPercentage(Long.parseLong(request.getParameter("addTimeSpent")));
         	timeReport.setComments(request.getParameter("addComments"));
         	if(request.getParameter("addFinished").equalsIgnoreCase("true")) {
     			timeReport.setFinishedFlag("Y");
         	}
         	else {
         		timeReport.setFinishedFlag("N");
         	}
         		
         	Date recordDate = new Date(System.currentTimeMillis());
         	if(editUseCase) {
         		timeReport.setCreateDate((timeReportService.getTimeReport(timeReport.getId())).getCreateDate());
         	}
         	else {
         		timeReport.setCreateDate(recordDate);		
         	}
         	timeReport.setUpdateDate(recordDate);
        	timeReport.setDeleteFlag("N");
        	        	
        	return timeReport;

		}
		
		private double getTimeSpentOnSameDay(TimeReport timeReport, long userGroupId) {
			TimeReport[] dayReports = timeReportService.getTimeFrameReport(timeReport.getUserId(), timeReport.getActivityDate(), timeReport.getActivityDate());
			double curSpentTime = 0;
	        
			if(null!= dayReports && dayReports.length!=0) {
				for(int i=0; i<dayReports.length; i++) {
					curSpentTime+= Double.parseDouble((optionServiceWrapper.getValuesForId(dayReports[i].getPercentage(), userGroupId)).getOptValue());
				}
			}
			return curSpentTime;
		}
}
