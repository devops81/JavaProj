package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.publication.data.IOlPubSummaryService;
import com.openq.publication.data.IOlTotalPubsService;
import com.openq.publication.data.IPublicationsService;
import com.openq.publication.data.IRequestService;
import com.openq.publication.data.OlPublicationSummaryDTO;
import com.openq.publication.data.OlTotalPubs;
import com.openq.publication.data.Publications;
import com.openq.user.IUserService;
import com.openq.user.User;

public class PubResultController extends AbstractController  {
	
	
	
	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("pubresults");	
		HttpSession session = request.getSession();
		session.setAttribute("CURRENT_LINK","PUBCAP");
		session.setAttribute("CURRENT_SUB_LINK","RESULTS");
	
		
	    OlPublicationSummaryDTO [] olPublicationArray = olPubSummaryService.getAllOlPubSummary();	    
	    
	    
	    session.setAttribute("olPublicationSummaryDTOArray",olPublicationArray);
		
		return mav;
	}
	
	public IOlPubSummaryService olPubSummaryService;
	
	public IOlPubSummaryService getOlPubSummaryService() {
		return olPubSummaryService;
	}
	public void setOlPubSummaryService(IOlPubSummaryService olPubSummaryService) {
		this.olPubSummaryService = olPubSummaryService;
	}
	
}
