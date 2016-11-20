package com.openq.web.controllers;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.geocode.GeocodeAddress;
import com.openq.kol.DBUtil;
import com.openq.user.IUserService;
import com.openq.user.User;


/**
 * This class is used to handle all requests for rendering an Expert map
 * 
 * @author Amit Arora 
 */
public class ExpertMapActionController extends AbstractController {
	private static Logger logger = Logger.getLogger(ExpertMapActionController.class);
	
	private IUserService userService;
	
	// Hack for testing
	public ExpertMapActionController(IUserService uService) {
		this.userService = uService;
	}
	
	public ExpertMapActionController() {
		
	}
	
	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	protected ModelAndView handleRequestInternal(HttpServletRequest httpServletRequest, 
			HttpServletResponse httpServletResponse) throws Exception {
		
		HttpSession session = httpServletRequest.getSession();
		
		String expertsToDisplay = null;
		User[] allowedList = null;
		
		String toggleURLDescription = "Show All " + DBUtil.getInstance().doctor + "s";
		
		// Check if the request has any information to display advance search results or OL search results
		// or all experts
		if(httpServletRequest.getParameter("expertsToDisplay") != null) {
			expertsToDisplay = httpServletRequest.getParameter("expertsToDisplay");
			if(expertsToDisplay.equals("AdvSearchResults")) {
				// Get the list of experts returned by the last advanced search
				allowedList = (User[]) session.getAttribute("ADV_SEARCH_RESULT");
				logger.debug("Rendering advanced search results");
				session.setAttribute("expertListDescription", "Search Result Experts");
				session.setAttribute("toggleURL", "expert_map.htm?expertsToDisplay=AllExperts_Adv");
				session.setAttribute("toggleURLDescription", toggleURLDescription);
				session.setAttribute("launchingPage", "users.htm?action=advSearchHome");
			}
			else if(expertsToDisplay.equals("OLSearchResults")) {
				allowedList = (User[]) session.getAttribute("myexperts");
				logger.debug("Rendering OL search results");
				session.setAttribute("expertListDescription", "OL Search Result Experts");
				session.setAttribute("toggleURL", "expert_map.htm?expertsToDisplay=AllExperts_OL");
				session.setAttribute("toggleURLDescription", toggleURLDescription);
				session.setAttribute("launchingPage", "home.htm");
			}
			else if(expertsToDisplay.equals("AllExperts_Adv")) {
				logger.debug("Toggled Advance Search results to show all Experts");
				session.setAttribute("expertListDescription", "All Experts");
				session.setAttribute("toggleURL", "expert_map.htm?expertsToDisplay=AdvSearchResults");
				session.setAttribute("toggleURLDescription", "Show Search Results Only");
				session.setAttribute("launchingPage", "users.htm?action=advSearchHome");
			}
			else if(expertsToDisplay.equals("AllExperts_OL")) {
				logger.debug("Toggled OL Search results to show all Experts");
				session.setAttribute("expertListDescription", "All Experts");
				session.setAttribute("toggleURL", "expert_map.htm?expertsToDisplay=OLSearchResults");
				session.setAttribute("toggleURLDescription", "Show Search Results Only");
				session.setAttribute("launchingPage", "home.htm");
			}
		}
		else {
			session.setAttribute("expertListDescription", "All Experts");
			session.setAttribute("toggleURL", "");
			session.setAttribute("toggleURLDescription", "");
			session.setAttribute("launchingPage", "home.htm");
		}
		
		GeocodeAddress[] expertAddresses = getExpertGeocodeAddresses(allowedList);
		
		// Set all experts that have proper geocoded-addresses on the session so that 
		// they can be rendered on the map
		session.setAttribute("expertAddresses", expertAddresses);
		
		ModelAndView mav = new ModelAndView("expert_map");
		return mav;
	}
	
	/**
	 * Get geocoded addresses corresponding to the list of experts provided. If no list
	 * is provided, then all experts are considered. Geocoded addresses corresponding to
	 * only those experts are returned whose addresses had been successfully geocoded
	 * in the past
	 * 
	 * @param expertList
	 * @return
	 */
	private GeocodeAddress[] getExpertGeocodeAddresses(User[] expertList) {
		ArrayList geocodedAddresses = new ArrayList();
		
		// Get data for all experts from the DB (non-eav tables)
		User[] allExpertsListFromNonEAVTables = userService.getAllExperts();
		
		// check if a specific list of experts should be displayed
		if(expertList == null) {
			// We need to use all experts
			expertList = allExpertsListFromNonEAVTables;
			logger.debug("No expert list was provided");
		}
		else {
			// The list of experts passed from the search pages (OL search/Advance Search) do not
			// have all fields specified. Hence, override the required fields with the data read
			// from the DB
			logger.debug("Overriding lat/long for : " + expertList.length + " experts");
			for(int i=0; i<expertList.length; i++) {
				for(int j=0; j<allExpertsListFromNonEAVTables.length; j++) {
					if(allExpertsListFromNonEAVTables[j].getId() == expertList[i].getId()) {
						expertList[i].setLatitude(allExpertsListFromNonEAVTables[j].getLatitude());
						expertList[i].setLongitude(allExpertsListFromNonEAVTables[j].getLongitude());
						expertList[i].setUserAddress(allExpertsListFromNonEAVTables[j].getUserAddress());
						break;
					}
				}
			}
		}
		
		logger.debug("Overrode lat/long");
		
		
		for(int i=0; i<expertList.length; i++) {
			User expert = expertList[i];
			// Check if the expert's address has been geocoded
			// If so, add him to be shown on the map
			// Otherwise, skip him
			if((expert.getLatitude() != 0) & (expert.getLongitude() != 0)) {
				
				// Display the expert's last name, first name and speciality as the text 
				// for the push-pin on the map
				String expertTextToDisplay = null;
				if(expert.getLastName() != null) {
					expertTextToDisplay = expert.getLastName();
				}
				
				if(expert.getFirstName() != null) {
					if(expertTextToDisplay != null) {
						expertTextToDisplay = expertTextToDisplay + ", " + expert.getFirstName();
					}
					else {
						expertTextToDisplay = expert.getFirstName();
					}
				}
				
				if(expert.getSpeciality() != null) {
					if(expertTextToDisplay != null) {
						expertTextToDisplay = expertTextToDisplay + "(" + expert.getSpeciality() + ")";
					}
				}
				
				// Construct the URL for the OL's profile
				long kolId = expert.getId(); 
				long entityId = expert.getKolid();
				String kolName = expert.getLastName() + ", " + expert.getFirstName();
				String profileURL = "expertfullprofile.htm?kolid=" + kolId + "&entityId=" + entityId + "&currentKOLName=" + kolName;
				
				GeocodeAddress geoAdd = new GeocodeAddress(expert.getLatitude(), expert.getLongitude(), expertTextToDisplay);
				geoAdd.setProfileURL(profileURL);
				
				// Use the expert's displayable address as the description for the push-pin on the map 
				geoAdd.setDescription(expert.getUserAddress().getDisplayableAddress());
				
				geocodedAddresses.add(geoAdd);
			}
		}
		
		logger.debug("Found : " + geocodedAddresses.size() + " experts with geocoded addresses");
		
		return (GeocodeAddress[]) geocodedAddresses.toArray(new GeocodeAddress[geocodedAddresses.size()]);
	}
}