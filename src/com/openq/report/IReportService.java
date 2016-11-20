package com.openq.report;

import java.util.Collection;

public interface IReportService {
  public Report getReport(long reportID,long userGroupId);
  public Report getReport(String name,long userGroupId);
  public Collection getAllReports(long userGroupId);
  public void saveReport(Report report);
  public void deleteReport(long reportID, long userGroupId);
}
