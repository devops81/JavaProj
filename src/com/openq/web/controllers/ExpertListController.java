package com.openq.web.controllers;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.expert.ExpertDetails;
import com.openq.eav.expert.IExpertDetailsService;
import com.openq.eav.expert.IExpertListService;

public class ExpertListController extends AbstractController {

	IExpertListService expertlistService;
	IExpertDetailsService expertDetailsService;

	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("expertlist");
		HttpSession session = request.getSession();
		String action = request.getParameter("action");
    if(action!=null&&action.equals("delete"))
    {
      String[] kolIdsToBeDeleted = (String[]) request.getParameterValues("expertCheckBox");
      if(kolIdsToBeDeleted!=null&&kolIdsToBeDeleted.length>0)
      {
    	  session.removeAttribute("myOL");
        expertlistService.deleteMyExperts(kolIdsToBeDeleted, (String) session.getAttribute(Constants.CURRENT_STAFF_ID));
      }
     }

    if(session.getAttribute("myOL") == null){
        String staffId = (String) session.getAttribute(Constants.CURRENT_STAFF_ID);
        if(staffId != null){
            List resultList = expertDetailsService.getExpertDetails(staffId);
            ExpertDetails[] myOL = null;
            if (resultList != null && resultList.size() > 0){
                myOL = (ExpertDetails[])(resultList.toArray(new ExpertDetails[resultList.size()]));
            }
            session.setAttribute("myOL", myOL);
        }
	 }

	return mav;
	}

	public IExpertListService getExpertlistService() {
		return expertlistService;
	}

	public void setExpertlistService(IExpertListService expertlistService) {
		this.expertlistService = expertlistService;
	}

	/**
	 * @return the expertDetailsService
	 */
	public IExpertDetailsService getExpertDetailsService() {
		return expertDetailsService;
	}

	/**
	 * @param expertDetailsService the expertDetailsService to set
	 */
	public void setExpertDetailsService(IExpertDetailsService expertDetailsService) {
		this.expertDetailsService = expertDetailsService;
	}



}
