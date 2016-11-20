package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import com.openq.geocode.ExpertGeocodeData;
import com.openq.geocode.IGeocodeService;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.web.forms.GeocodeExpertsForm;


/**
 * This class is used to handle all requests for geocoding expert addresses
 * 
 * @author Amit Arora 
 */
public class GeocodeExpertsController extends SimpleFormController {
	private static final String GEOCODING_FAILED_STATUS = "Geocoding Failed";
	private static final String GEOCODING_SUCCESSFUL_STATUS = "Geocoding Successful";
	private static final String GEOCODING_PENDING_STATUS = "Geocoding Pending";
	private static final String GEOCODING_NOT_GEOCODED_STATUS = "Not Geocoded";
	
	private static Logger logger = Logger.getLogger(GeocodeExpertsController.class);
	
	private IUserService userService;
	private IGeocodeService geocodeService;
	
	// Hack for testing
	public GeocodeExpertsController(IUserService uService, IGeocodeService gService) {
		this.userService = uService;
		this.geocodeService = gService;
	}
	
	public GeocodeExpertsController() {
		
	}
	
	public IGeocodeService getGeocodeService() {
		return geocodeService;
	}

	public void setGeocodeService(IGeocodeService geocodeService) {
		this.geocodeService = geocodeService;
	}

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	/**
	 * Handle the request for rendering the geocoding experts form
	 */
	protected ModelAndView showForm(HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse,
            BindException bindException) throws Exception {
		logger.debug("Showing geocode experts form");
		
		setExpertGeocodeData(httpServletRequest);
		
		ModelAndView mav = new ModelAndView("geocode_experts");
		return mav;
	}
	
	/**
	 * Handle the request when the user tries to submit some experts for
	 * geocoding, or refreshes the data to see current status of geocoding
	 * requests
	 */
	protected ModelAndView processFormSubmission(HttpServletRequest request,
            HttpServletResponse response,
            Object object, BindException exception) throws Exception {
		String action = (String) request.getParameter("action");
		
		logger.debug("Form submitted with action : " + action);
		
		request.getSession().removeAttribute("confirmationMessage");
		
		if(action.equals("geocode")) {
		
			GeocodeExpertsForm gForm = (GeocodeExpertsForm) object;
			
			// Identify the list of experts (ids) that have been submitted for geocoding
			logger.debug(gForm.getSelectedExperts());
			String[] selectedExpertIds = request.getParameterValues("checkIds");
			
			for(int i=0; i<selectedExpertIds.length; i++) {
				logger.debug(selectedExpertIds[i]);
			}
			
			//Retrieve user objects corresponding to the selected expert IDs
			HttpSession session = request.getSession();
			ExpertGeocodeData[] allExpertGeocodeData = (ExpertGeocodeData[]) session.getAttribute("allExpertGeocodeData");
			User[] selectedExperts = getSelectedExperts(selectedExpertIds, allExpertGeocodeData);
	
			// Geocode the addresses for all experts asynchronously
			geocodeService.geocodeExpertsAsynch(selectedExperts);
			
			session.setAttribute("confirmationMessage", "A background job has been submitted for geocoding the addresses for selected experts");
		}
		else if(action.equals("geocodeAll")) {
			HttpSession session = request.getSession();
			ExpertGeocodeData[] allExpertGeocodeData = (ExpertGeocodeData[]) session.getAttribute("allExpertGeocodeData");
			User[] selectedExperts = new User[allExpertGeocodeData.length];
			for(int i=0; i<allExpertGeocodeData.length; i++) {
				selectedExperts[i] = allExpertGeocodeData[i].getExpert();
			}
			
			// Geocode the addresses for all experts asynchronously
			geocodeService.geocodeExpertsAsynch(selectedExperts);
			
			session.setAttribute("confirmationMessage", "A background job has been submitted for geocoding the addresses for all selected experts");
		}
		else if(action.equals("refresh")) {
			setExpertGeocodeData(request);
		}
		else if(action.equals("filter")) {
			String statusFilter = request.getParameter("statusFilter");
			if(!statusFilter.equals("All")) {
				// set the filter on the session object
				request.getSession().setAttribute("statusFilter", statusFilter);
			}
			else {
				request.getSession().removeAttribute("statusFilter");
			}
			setExpertGeocodeData(request);
		}

		ModelAndView mav = new ModelAndView("geocode_experts");
		return mav; 
	}
	
	/**
	 * This routine is used to read the geocoding status of all experts in the System
	 * and set this data in the session so that it can be rendered appropriately in the UI
	 * 
	 * @param httpServletRequest
	 */
	protected void setExpertGeocodeData(HttpServletRequest httpServletRequest) {
		User[] allExperts = userService.getAllExperts();
		HashMap pendingGeocodeItems = geocodeService.getAsynchGeocodeItemsStatus();
		
		HttpSession session = httpServletRequest.getSession();
		
		String statusFilter = (String) session.getAttribute("statusFilter");
		
		ArrayList expertList = new ArrayList();
		for(int i=0; i<allExperts.length; i++) {
			User expert = allExperts[i];
			Long expertId = new Long(expert.getId());
			String geocodingStatus = null;
			if(pendingGeocodeItems.get(expertId) != null)
				geocodingStatus = (String) pendingGeocodeItems.get(expertId);
			
			if(geocodingStatus == null) {
	        	if((expert.getLatitude() == 0) && (expert.getLongitude() == 0)) 
	        		geocodingStatus = GEOCODING_NOT_GEOCODED_STATUS;
	        	else
	        		geocodingStatus = GEOCODING_SUCCESSFUL_STATUS;
	        }
			
			// check if we need to filter the experts that are displayed
			if((statusFilter != null) && (!statusFilter.equals(""))) {
				if(statusFilter.equals(geocodingStatus))
					expertList.add(new ExpertGeocodeData(expert, geocodingStatus));
			}
			else {
				expertList.add(new ExpertGeocodeData(expert, geocodingStatus));
			}
		}
		
		ExpertGeocodeData[] allExpertGeocodeData = (ExpertGeocodeData[]) expertList.toArray(new ExpertGeocodeData[expertList.size()]);
		session.setAttribute("allExpertGeocodeData", allExpertGeocodeData);
	}
	
	/**
	 * This routine is used to return user objects corresponding to the expert ids that have been
	 * selected and submitted via the UI
	 * 
	 * @param selectedExpertIds list of expert IDs submitted via the UI
	 * @param allExpertsGeocodeData user objects corresponding to all experts in the system
	 * 
	 * @return
	 */
	private User[] getSelectedExperts(String[] selectedExpertIds, ExpertGeocodeData[] allExpertsGeocodeData) {
		User[] selectedExperts = new User[selectedExpertIds.length];

		for(int i=0; i<selectedExpertIds.length; i++) {
			long expertId = Long.parseLong(selectedExpertIds[i]);
			for(int j=0; j<allExpertsGeocodeData.length; j++) {
				if(allExpertsGeocodeData[j].getExpert().getId() == expertId) {
					selectedExperts[i] = allExpertsGeocodeData[j].getExpert();
				}
			}
		}

		return selectedExperts;
	}
}