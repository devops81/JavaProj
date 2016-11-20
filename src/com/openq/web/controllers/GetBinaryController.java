package com.openq.web.controllers;

import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.core.style.ToStringCreator;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.data.BinaryAttribute;
import com.openq.eav.data.IDataService;
import com.openq.report.IReportService;
import com.openq.report.Report;

public class GetBinaryController extends AbstractController {
  private static Logger s_logger = Logger
      .getLogger(GetBinaryController.class);

  IDataService dataService;

  public IDataService getReportService() {
    return dataService;
  }

  public void setDataService(IDataService dataService) {
    this.dataService = dataService;
  }

  protected ModelAndView handleRequestInternal(HttpServletRequest req,
      HttpServletResponse res) throws Exception {
    long entityID = Long.parseLong(req.getParameter("entityID"));
    long attrID = Long.parseLong(req.getParameter("attrID"));
    BinaryAttribute ba = dataService.getBinaryAttribute(entityID, attrID);

    res.setBufferSize(8192);
    res.setContentType("application/octet-stream");
    res.setHeader("Content-Disposition", "attachment; filename=\""+ ba.getFileName() + "\"");
    
    InputStream is = ba.getDataStream();
    OutputStream os = res.getOutputStream();
    try{
      FileCopyUtils.copy(ba.getDataStream(), res.getOutputStream());
    }finally{
      is.close();
      os.flush();
      os.close();
    }
    return null;
  }

}
