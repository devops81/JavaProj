package com.openq.report;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.SQLException;

import net.sf.hibernate.Hibernate;

public class Report {
  private long reportID;

  private String name;

  private String description;

  private Blob reportDesign;
  
  /*private String fileName;

  private boolean subReport;*/

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Blob getReportDesign() {
    return reportDesign;
  }

  public void setReportDesign(Blob reportDesign) {
    this.reportDesign = reportDesign;
  }

  public long getReportID() {
    return reportID;
  }

  public void setReportID(long reportID) {
    this.reportID = reportID;
  }

  public InputStream getReportDesignStream() throws SQLException {
    if (reportDesign != null)
      return reportDesign.getBinaryStream();
    return null;
  }

  public void setReportDesignStream(InputStream is) throws IOException {
    reportDesign = Hibernate.createBlob(is);
  }

  /*public String getFileName() {
    return fileName;
  }

  public void setFileName(String fileName) {
    this.fileName = fileName;
  }

  public boolean isSubReport() {
    return subReport;
  }

  public void setSubReport(boolean subReport) {
    this.subReport = subReport;
  }*/
}
