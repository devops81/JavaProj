package com.openq.time;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class TimeReportService extends HibernateDaoSupport implements
        ITimeReportService {
	public static Logger logger = Logger.getLogger(TimeReportService.class);
	public final static DateFormat format = new SimpleDateFormat("dd-MMM-yy");


public TimeReport[] getAllTimeReportforUser(long userId) {

    logger.debug("Getting All TimeReport");
	List result = getHibernateTemplate().find("from TimeReport t where t.userId="+userId);
	if(result == null) 
	{
		logger.debug("result is null in getAlltimeReport function");
		return null;
	}
	return (TimeReport[]) result.toArray(new TimeReport[result.size()]);
    
}

public TimeReport[] getTimeFrameReport(long userId, Date fromDate, Date toDate) {
	
    logger.debug("Getting All TimeReport in a Time Frame");
    List result = getHibernateTemplate().find("from TimeReport t where t.activityDate between '"+ format.format(fromDate) + "' and '"+ format.format(toDate) +"' and t.userId="+userId);
    if(result == null) {
		logger.debug("result is null in getAlltimeReport function");
		return null;
    }
    return (TimeReport[]) result.toArray(new TimeReport[result.size()]);
}

public void saveTimeReport(TimeReport timeReport) {

	logger.debug("Saving TimeReport");
	logger.debug("Time Report Object:ActivityId:"+timeReport.getActivityId()+",Comments"+timeReport.getComments()+",DeleteFlag"+timeReport.getDeleteFlag()+",FinishedFlag"+timeReport.getFinishedFlag()+",ReportID"+
			timeReport.getId()+",Percentage"+timeReport.getPercentage()+",UserID"+timeReport.getUserId()+",ActivityDate"+timeReport.getActivityDate()+",CreateDate"+timeReport.getCreateDate()+",UpdateDate"+timeReport.getUpdateDate());
   getHibernateTemplate().save(timeReport);
    // If report updated was finished, finish all time reports for the same day
	if(timeReport.isFinished()) {
		updateOtherReportsFinshedFlag(timeReport);
	}
}

public void updateTimeReport(TimeReport timeReport) {

	logger.debug("Updating TimeReport");
	
	getHibernateTemplate().update(timeReport);
	
	// Since we can update finished reports,
    // lets update all reports on the same day to the same finished status
	updateOtherReportsFinshedFlag(timeReport);	
	
    
}

public void deleteTimeReport(TimeReport timeReport) {

	logger.debug("Deleting TimeReport");
	long reportID = timeReport.getId();
	
	// New rule says we can delete finished reports, so if we are deleting any finished report
	// we should set all other reports on that day as unfinished
	if(timeReport.isFinished()) {		
		timeReport.setFinishedFlag("N");
		updateOtherReportsFinshedFlag(timeReport);
	}
	
	TimeReport deleteReport = getTimeReport(reportID);
    getHibernateTemplate().delete(deleteReport);
}	

public TimeReport getTimeReport(long id) {

	logger.debug("Getting TimeReport");
//    return (TimeReport) getHibernateTemplate().find("from TimeReport t where t.id="+id);
    List result = getHibernateTemplate().find("from TimeReport t where t.id="+id);
  
    if(result == null) {
		logger.debug("result is null in getTimeReport function");
		return null;
    }
    TimeReport[] tr = (TimeReport[]) result.toArray(new TimeReport[result.size()]);
    return tr[0];
}

private void updateOtherReportsFinshedFlag(TimeReport timeReport) {
	
	logger.debug("UpdateOtherReportsFinishedFlag");
	
	TimeReport[] reports = getTimeFrameReport(timeReport.getUserId(), timeReport.getActivityDate(), timeReport.getActivityDate());
	if(null == reports || reports.length==0) {
		return;
	}
	for(int i=0; i<reports.length; i++) {
		logger.debug("updating report id: " + reports[i].getId());
		if(reports[i].getId()==timeReport.getId()) {
			logger.debug("skip...");
			continue;
		}
		TimeReport reportHolder = getTimeReport(reports[i].getId());
		if(timeReport.isFinished()) {
			reportHolder.setFinishedFlag("Y");
		}
		else {
			reportHolder.setFinishedFlag("N");
		}
		getHibernateTemplate().update(reportHolder);
	}
}

}
