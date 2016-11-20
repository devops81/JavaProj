package com.openq.report;

import java.util.Collection;
import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.authorization.IFeaturePermissionService;
import com.openq.web.controllers.Constants;

public class ReportService extends HibernateDaoSupport implements
    IReportService {

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
	
  public Collection getAllReports(long userGroupId) {
	final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.REPORT_PERMISSION_ID, userGroupId);
    return getHibernateTemplate().find("select r FROM Report r where r.reportID "+ PERMISSION_APPEND_QUERY +
    		" order by r.name");
  }
  
  

  public Report getReport(long reportID, long userGroupId) {
	  final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.REPORT_PERMISSION_ID, userGroupId);
    List reportList = getHibernateTemplate().find(
        "select r FROM Report r WHERE r.reportID  "+ PERMISSION_APPEND_QUERY + 
    		" and r.reportID = "+ reportID);
    if (reportList.size() == 1)
      return (Report) reportList.get(0);
    return null;
  }

  public Report getReport(String name, long userGroupId) {
	  final String PERMISSION_APPEND_QUERY = featurePermissionService.getPermissionAppendQuery(Constants.REPORT_PERMISSION_ID, userGroupId);
    List reportList = getHibernateTemplate().find(
        "select r FROM Report r WHERE r.reportID "+ PERMISSION_APPEND_QUERY +
        " and r.name = '" + name + "'");
    if (reportList.size() == 1)
      return (Report) reportList.get(0);
    return null;
  }

  public void deleteReport(long reportID, long userGroupId) {
    Report report = getReport(reportID, userGroupId);
    getHibernateTemplate().delete(report);    
  }

  public void saveReport(Report report) {    
    getHibernateTemplate().save(report);
  }
  /*synchronized void init() throws Exception{
    List reports = getHibernateTemplate().find("FROM Report WHERE subReport = true");
    reports.addAll(getHibernateTemplate().find("FROM Report WHERE subReport = false"));

    String reportsTempDir = PropertyReader.getServerConfig("report.temp.dir");

    for(Iterator itr=reports.iterator();itr.hasNext();){
      Report report = (Report)itr.next();
      String reportFileName = reportsTempDir+System.getProperty("file.separator")+report.getFileName();
      saveStreamToFile(report.getReportDesignStream(), reportFileName);
      JasperCompileManager.compileReportToFile(reportFileName);      
    }
  }
  
  private static void saveStreamToFile(InputStream is, String fileName) throws IOException{
    OutputStream os = new FileOutputStream(fileName,false);
    int c;
    try{
    while((c=is.read())!=-1){
      os.write(c);
    }
    }finally{
      os.close();
    }
  }*/
}
