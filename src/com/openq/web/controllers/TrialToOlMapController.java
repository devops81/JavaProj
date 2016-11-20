package com.openq.web.controllers;

import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.openq.eav.trials.ITrialOlMapService;
import com.openq.eav.trials.TrialOlMap;
import com.openq.user.IUserService;
import com.openq.user.User;

public class TrialToOlMapController extends AbstractController {

	ITrialOlMapService trialOlMapService;
	IUserService userService;

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		request.getSession().removeAttribute("user");
		String role = (String) request.getParameter("role");
		String institution = (String) request.getParameter("institution");
		String[] deleteOls = request.getParameterValues("checkedOl");
		long kolId = -1;
		if(request.getParameter("olId") != null) {
			System.out.println("Ol id is : " + request.getParameter("olId"));
			kolId = Long.parseLong(request.getParameter("olId"));
		}
		
		long trialId = Long.parseLong(request.getParameter("entityId"));
		
		request.getSession().removeAttribute("editOl");
		
		if(kolId != -1) {
			TrialOlMap trialOlMap = new TrialOlMap();
			trialOlMap.setTrialId(trialId);
			trialOlMap.setOlId(kolId);
			trialOlMap.setRole(role);
			trialOlMap.setInstitution(institution);
			
			trialOlMapService.saveTrialOlMap(trialOlMap);
		}
		
		if (deleteOls != null && deleteOls.length != 0) {
			for (int i = 0; i < deleteOls.length; i++) {
				TrialOlMap trialOl = new TrialOlMap();
				try{
					trialOl = trialOlMapService.getTrialOlMap(Long.parseLong(deleteOls[i]));
					trialOlMapService.deleteTrialOlMap(trialOl);
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}

		TrialOlMap [] trialOlMapArray = trialOlMapService.getAllOlsForTrial(trialId);
		User [] user = new User[trialOlMapArray.length];
		
		for(int i=0;i<trialOlMapArray.length;i++){
			user[i] = userService.getUser(trialOlMapArray[i].getOlId());
		}
		
		if(user.length != 0){
			request.getSession().setAttribute("user", user);
			request.getSession().setAttribute("trialOlMapArray", trialOlMapArray);
		}

		return new ModelAndView("trial_to_ol_map");
	}
	
	public ITrialOlMapService getTrialOlMapService() {
		return trialOlMapService;
	}
	
	public void setTrialOlMapService(ITrialOlMapService trialOlMapService) {
		this.trialOlMapService = trialOlMapService;
	}

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}
}
