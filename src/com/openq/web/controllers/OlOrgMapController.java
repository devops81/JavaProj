package com.openq.web.controllers;

import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.openq.eav.org.IOrgOlMapService;
import com.openq.eav.org.OrgOlMap;
import com.openq.eav.org.OrgOlMapService;
import com.openq.user.IUserService;
import com.openq.user.User;

public class OlOrgMapController extends AbstractController {

	IOrgOlMapService orgOlMapService;
	IUserService userService;

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		request.getSession().removeAttribute("user");
		String olName = (String) request.getParameter("olName");
		String position = (String) request.getParameter("position");
		String division = (String) request.getParameter("division");
		String year = (String) request.getParameter("year");
		String[] deleteOls = request.getParameterValues("checkedOl");
		long kolId = -1;
		if(request.getParameter("olId") != null && !((String)request.getParameter("olId")).equals(""))
			kolId = Long.parseLong(request.getParameter("olId"));
		
		long orgId = Long.parseLong(request.getParameter("entityId"));
		
		request.getSession().removeAttribute("editOl");
		
		OrgOlMap orgolMap = new OrgOlMap();
		orgolMap.setOlId(kolId);
		orgolMap.setDivision(division);
		orgolMap.setPosition(position);
		orgolMap.setYear(year);
		orgolMap.setOrgId(orgId);
		
		if(olName != null && !olName.equals("")){
			orgOlMapService.saveOrgOlMap(orgolMap);
		}
		
		if (deleteOls != null && deleteOls.length != 0) {
			for (int i = 0; i < deleteOls.length; i++) {
				OrgOlMap orgol = new OrgOlMap();
				try{
					orgol = orgOlMapService.getOrgOlMap(Long.parseLong(deleteOls[i]));
					orgOlMapService.deleteOrgOlMap(orgol);
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}

		OrgOlMap [] orgOlMap = orgOlMapService.getAllOlsForOrgs(orgId);
		User [] user = new User[orgOlMap.length];
		Long [] orgolMapId = new Long[orgOlMap.length];
		
		for(int i=0;i<orgOlMap.length;i++){
			user[i] = userService.getUser(orgOlMap[i].getOlId());
			orgolMapId[i] = new Long(orgOlMap[i].getId());
			user[i].setPosition(orgOlMap[i].getPosition());
			user[i].setDivision(orgOlMap[i].getDivision());
			user[i].setYear(orgOlMap[i].getYear());
			
		}
		
		if(user.length != 0){
			request.getSession().setAttribute("user", user);
			request.getSession().setAttribute("orgolMapId", orgolMapId);
		}

		return new ModelAndView("ol_org_map");
	}
	
	public IOrgOlMapService getOrgOlMapService() {
		return orgOlMapService;
	}

	public void setOrgOlMapService(IOrgOlMapService orgOlMapService) {
		this.orgOlMapService = orgOlMapService;
	}
	
	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}
}
