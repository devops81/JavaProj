package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.data.DataService;
import com.openq.eav.data.IDataService;
import com.openq.interaction.Interaction;
import com.openq.user.User;

public class OlSearchDataController extends AbstractController {

	protected ModelAndView handleRequestInternal(HttpServletRequest req, HttpServletResponse res) throws Exception {
	    User searchResult[] = (User[]) req.getSession().getAttribute("ADV_SEARCH_RESULT");
		System.out.print("Enter OlSearchDataController");
	    getCustomDataForOl(searchResult, dataService);
		System.out.print("Exit OlSearchDataController");
		return new ModelAndView("olsearchdata");
	}

	public static void getCustomDataForOl(User[] searchResult, IDataService dataService) {
		if (searchResult != null && searchResult.length > 0) {
			for (int i=0; i<searchResult.length; i++)
			{
				User u = searchResult[i]; 
				u.setLastInteraction(dataService.getLastInteractionForUser(u));
				u.setPubCount(dataService.getPublicationCountForUser(u));
				u.setBioData(dataService.getBio(u));
			}
		}
	}

	private IDataService dataService;

	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}
}
