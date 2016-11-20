package com.openq.web.controllers;

import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.publication.data.ICmaPubOlService;
import com.openq.publication.data.IPublicationsService;
import com.openq.publication.data.IRequestService;
import com.openq.publication.data.Request;
import com.openq.publication.ovidClient.OvidClient;
import com.openq.user.IUserService;
import com.openq.user.User;

public class PubScheduleController extends AbstractController {
	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("pubschedule");
		
		HttpSession session = request.getSession();
		session.setAttribute("CURRENT_LINK", "PUBCAP");
		session.setAttribute("CURRENT_SUB_LINK", "STATUS");
		
		User[] countExperts = userService.getAllExperts(-1);
		
		session.setAttribute("countExperts", new Integer(countExperts.length));
		
		// Persisting the requests in Request Table
		long currentUserId = 0;
		Request requestCaptureStatus = null;
		
		currentUserId = Long.parseLong((String) session
				.getAttribute(Constants.USER_ID));
		requestCaptureStatus = requestService.getCaptureStatus(currentUserId);
		// fire action
		String action = request.getParameter("submitb");
		Calendar today = Calendar.getInstance();
		Date curTime = today.getTime();
		
		if (requestCaptureStatus == null) {
			requestCaptureStatus = new Request();
			requestCaptureStatus.setUserId(currentUserId);
			requestCaptureStatus.setStatus("idle ");
			requestCaptureStatus.setRequestTimeStamp(curTime);
			requestService.addCaptureStatus(requestCaptureStatus);
			session.setAttribute("message", "idle ");
		} else if(requestCaptureStatus.getRequestCompeleted()==null)
			session.setAttribute("message", requestCaptureStatus.getStatus()
					+ " <br /> Time: "
					+ requestCaptureStatus.getRequestTimeStamp() );
		else
			session.setAttribute("message", requestCaptureStatus.getStatus()
					+ " <br /> Time: "
					+ requestCaptureStatus.getRequestTimeStamp() 
					+ " To "
					+ requestCaptureStatus.getRequestCompeleted());
		
		try{// if triggered fire capture
		if (action != null) {
			try{
			Thread.sleep(500);//disable button
			}catch (Exception e){}
			
			today = Calendar.getInstance();
			curTime = today.getTime();
			boolean statusNullFlag = false;
			
			
		//	int expLen= Integer.parseInt((String)request.getParameter("T1"));
			
			String msg = "Capture started ";
			// CmaPubOl [] experts= cmaPubOlService.getAllOls();
			User[] experts = userService.getAllExperts(-1);
			
			List requestedUsers = Arrays.asList(experts);
//			for (int i = 0; i < experts.length; i++)
//				requestedUsers.add(experts[i]);
			ovidClient.handleRequest(requestedUsers, currentUserId);
			
			if (requestCaptureStatus == null) {
				statusNullFlag = true;
				requestCaptureStatus = new Request();
			}
			requestCaptureStatus.setUserId(currentUserId);
			requestCaptureStatus.setStatus(msg);
			requestCaptureStatus.setRequestTimeStamp(curTime);
			requestCaptureStatus.setRequestCompeleted(null);
			if (statusNullFlag == true)
				requestService.addCaptureStatus(requestCaptureStatus);
			else
				requestService.updateCaptureStatus(requestCaptureStatus);
			session.setAttribute("message", (String) msg + curTime.toString());
		}}catch (Exception e){}
		return mav;
		
	}
	
	ICmaPubOlService cmaPubOlService;
	
	IUserService userService;
	
	OvidClient ovidClient;
	
	IPublicationsService publicationsService;
	
	IRequestService requestService;
	
	public IRequestService getRequestService() {
		return requestService;
	}
	
	public void setRequestService(IRequestService requestService) {
		this.requestService = requestService;
	}
	
	public OvidClient getOvidClient() {
		return ovidClient;
	}
	
	public void setOvidClient(OvidClient ovidClient) {
		this.ovidClient = ovidClient;
	}
	
	public IUserService getUserService() {
		return userService;
	}
	
	public void setUserService(IUserService userService) {
		this.userService = userService;
	}
	
	public IPublicationsService getPublicationsService() {
		return publicationsService;
	}
	
	public void setPublicationsService(IPublicationsService publicationsService) {
		this.publicationsService = publicationsService;
	}
	
	public ICmaPubOlService getCmaPubOlService() {
		return cmaPubOlService;
	}
	
	public void setCmaPubOlService(ICmaPubOlService cmaPubOlService) {
		this.cmaPubOlService = cmaPubOlService;
	}
}
