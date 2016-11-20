package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.publication.data.IOvidDbService;
import com.openq.publication.data.OvidDb;

public class PubDataSourceController  extends AbstractController  {
	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("pubdatasource");	
		HttpSession session = request.getSession();
		session.setAttribute("CURRENT_LINK","PUBCAP");
		session.setAttribute("CURRENT_SUB_LINK","DATASOURCES");
		 
		OvidDb [] ovidDbs;
		ovidDbs= ovidDbService.getAllOvidDataSource();
		session.setAttribute("DATASOURCE",ovidDbs);
		 
		return mav;
	}
	
	public IOvidDbService ovidDbService;
	public IOvidDbService getOvidDbService() {
		return ovidDbService;
	}

	public void setOvidDbService(IOvidDbService ovidDbService) {
		this.ovidDbService = ovidDbService;
	}

}
