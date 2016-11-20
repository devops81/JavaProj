package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.publication.data.IPublicationsService;
import com.openq.publication.data.Publications;

public class PubDetailsController extends AbstractController {
	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("pubdetails");
		HttpSession session = request.getSession();
		
		long publicationId = Long.parseLong((String) request.getParameter("page"));
		Publications publicationDetail;
		
		publicationDetail=publicationsService.getPublicationDetails(publicationId);
		
		session.setAttribute("pubDetail",publicationDetail);
		
		return mav;
	}
	public IPublicationsService publicationsService;
	
	public IPublicationsService getPublicationsService() {
		return publicationsService;
	}
	public void setPublicationsService(IPublicationsService publicationsService) {
		this.publicationsService = publicationsService;
	}
}
