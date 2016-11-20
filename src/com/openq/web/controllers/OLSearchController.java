package com.openq.web.controllers;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.expert.ExpertDetails;
import com.openq.user.IUserService;

public class OLSearchController extends AbstractController{
		
	IUserService searchUserService;
		
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
		ModelAndView mav = new ModelAndView("OL_Search");
		String name = (String)request.getParameter("searchtext");
		String action = request.getParameter("action");

        request.getSession().removeAttribute("users");
        System.out.println("action is " + action);

         if(null != action && !"".equals(action) &&
                "olSearch".equals(action)) {

             String searhText = null != request.getParameter("lastnamesearch") ? request.getParameter("lastnamesearch") : null;
            if (null != searhText)
              request.getSession().setAttribute("myExperts",searchUserService.searchExpert(searhText));
             return new ModelAndView("event_ol_search");
        }
        if(name != null && !name.equals("")){
            List resultList = searchUserService.searchExpert(name);
            ExpertDetails[] myOL = (ExpertDetails[])(resultList.toArray(new ExpertDetails[resultList.size()]));
			request.getSession().setAttribute("users", myOL);
		}
		else
		{
			mav.addObject("message", "Please enter some text");
		}

        return mav;
	}

	public IUserService getSearchUserService() {
		return searchUserService;
	}

	public void setSearchUserService(IUserService searchUserService) {
		this.searchUserService = searchUserService;
	}
	
}
