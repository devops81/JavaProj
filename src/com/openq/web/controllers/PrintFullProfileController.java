package com.openq.web.controllers;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.data.IDataService;
import com.openq.eav.metadata.IMetadataService;
import com.openq.kol.DBUtil;

public class PrintFullProfileController extends AbstractController
{
	
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
	                                             HttpServletResponse response)
	throws Exception
	{
		// request.getSession().setAttribute("entityId", request.getParameter("entityId"));
		
		// ROOT_PARENT_ID is root level Expert or Organization
		request.setAttribute("ROOT_PARENT_ID", request
				.getParameter("rootParentId"));
    request.setAttribute("PRINTPROFILE_ROOT_PARENT_ID", request
        .getSession().getAttribute("PRINTPROFILE_ROOT_PARENT_ID"));
		request.getSession().setAttribute("dataService", dataService);
		request.getSession().setAttribute("metadataService", metadataService);
		
		/*Properties props = DBUtil.getInstance().getDataFromPropertiesFile(
		"resources/ServerConfig.properties");
		request.setAttribute("PHOTOS_URL", (String) props
				.getProperty("photos.url"));*/
		return new ModelAndView("printFullProfile");
	}
	
	private IDataService dataService;
	
	private IMetadataService metadataService;
	
	public IDataService getDataService()
	{
		return dataService;
	}
	
	public void setDataService(IDataService dataService)
	{
		this.dataService = dataService;
	}
	
	public IMetadataService getMetadataService()
	{
		return metadataService;
	}
	
	public void setMetadataService(IMetadataService metadataService)
	{
		this.metadataService = metadataService;
	}
	
}
