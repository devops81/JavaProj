package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authentication.UserDetails;
import com.openq.contacts.Contacts;
import com.openq.eav.expert.ExpertDetails;
import com.openq.eav.expert.IExpertDetailsService;
import com.openq.eav.expert.IExpertListService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.user.UserAddress;
import com.openq.utils.PropertyReader;

public class AddGuestController extends AbstractController{

	IUserService addUserService;
	IOptionService optionService;
	IOptionServiceWrapper optionServiceWrapper;
	IExpertListService expertlistService;
	IExpertDetailsService expertDetailsService;



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

public IExpertListService getExpertlistService() {
    return expertlistService;
  }

  public void setExpertlistService(IExpertListService expertlistService) {
    this.expertlistService = expertlistService;
  }

  protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
	  String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
		
		long sphOfInfluenceId = optionService.getIdForOptionValueAndParentName("N/A","Sphere of Influence");

		request.getSession().removeAttribute("userSaved");

		String fullName = request.getParameter("hcpFirstName");
		String lastName = request.getParameter("hcpLastName");
		String speciality = request.getParameter("hcpSpeciality");
		String address1 = request.getParameter("hcpAddress1");
		String address2 = request.getParameter("hcpAddress2");
		String country = request.getParameter("hcpCountry");
		String state = request.getParameter("hcpState");
		String zipCode = request.getParameter("hcpZipCode");
		String city = request.getParameter("hcpCity");
		String ssoid = request.getParameter("hcpSsoid");
		String ssname = request.getParameter("hcpSsname");
		String primaryPhone = request.getParameter("primaryPhone");
		String primaryFax = request.getParameter("primaryFax");
		String primaryEmail = request.getParameter("primaryEmail");
		String primaryMobile = request.getParameter("primaryMobile");
		String expertListCheckBox = request.getParameter("guestCheckBox");
		String fromAddGuest = null;
		if (request.getParameter("fromAddGuest") != null) {
		    fromAddGuest = (String)request.getParameter("fromAddGuest");
		}

		OptionLookup [] countryList = optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("COUNTRY"), userGroupId);
		OptionLookup [] stateList = optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("STATE"), userGroupId);
		OptionLookup [] ta = optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId);		

		request.getSession().setAttribute("countryList", countryList);
		request.getSession().setAttribute("stateList", stateList);
		request.getSession().setAttribute("ta", ta);

		if(fullName != null && !fullName.equals("")){
			long countryId = Long.parseLong(country);
			long stateId = Long.parseLong(state);

			UserAddress userAddress = new UserAddress();
			userAddress.setAddress1(address1);
			userAddress.setAddress2(address2);
			userAddress.setCity(city);
			userAddress.setCountry(optionService.getOptionLookup(countryId, userGroupId));
			userAddress.setZip(zipCode);
			userAddress.setState(optionService.getOptionLookup(stateId, userGroupId));

			User user = new User();
			user.setFirstName(fullName);
			user.setLastName(lastName);
			user.setUserAddress(userAddress);
			user.setSpeciality(Long.parseLong(speciality) == -1 ?"": optionService.getOptionLookup(Long.parseLong(speciality), userGroupId).getOptValue());
			user.setUserName("");
			user.setPassword("");
			user.setEmail(primaryEmail);
			user.setPhone(primaryPhone);
			user.setFax(primaryFax);
			user.setMobile(primaryMobile);
			user.setMslOlType(Constants.DEFAULT_MSL_OL_TYPE);
			user.setStaffid("");
			user.setSsname(ssname);
			user.setSsoid(ssoid);
			user.setDeleteFlag("N");
			user.setSphereOfInf(optionService.getOptionLookup(sphOfInfluenceId, userGroupId));
			user.setUserType(optionService.getOptionLookup(4l, userGroupId));
			addUserService.createUserAddress(userAddress);
			long kolid = addUserService.createUser(user);

			if (expertListCheckBox.equals("true")) {
	  			/*Add the guest to the MyExpertList*/
			    UserDetails userDetails = (UserDetails) request.getSession().getAttribute(Constants.CURRENT_USER);
			    Contacts contact = new Contacts();
			    contact.setContactName(userDetails.getCompleteName());
			    contact.setEmail(userDetails.getEmail());
			    contact.setStaffid(Long.parseLong(userDetails.getStaffId()));
			    contact.setPhone(userDetails.getTelephoneNumber());
			    contact.setKolId(user.getId());
			    request.getSession().removeAttribute("myOL");
			    expertlistService.addOL(contact);
			}

		request.getSession().setAttribute("userSaved", user);

/* Now we need to add an entry corresponding to this user in the Experts_Details_Mview (Materialized view.)
	This entry will be temporary and will be gone once the materialized view is refreshed.
	*/

		ExpertDetails expDetails = new ExpertDetails();
		expDetails.setId(user.getId());
		expDetails.setKolid(kolid);
		expDetails.setFirstName(fullName);
		expDetails.setLastName(lastName);
		expDetails.setAddressLine1(address1);
		expDetails.setAddressLine2(address2);
		expDetails.setAddressCity(city);
		expDetails.setAddressState(optionService.getOptionLookup(stateId, userGroupId).getOptValue());
		expDetails.setAddressPostalCode(zipCode);
		expDetails.setAddressCountry(optionService.getOptionLookup(countryId, userGroupId).getOptValue());
		expDetails.setPrimaryPhone(primaryPhone);
		expDetails.setPrimaryEmail(primaryEmail);
		expDetails.setPrimaryFax(primaryFax);
		expDetails.setPrimaryMobile(primaryMobile);
		expDetails.setDeleteFlag("N");
		expDetails.setMslOlType(Constants.DEFAULT_MSL_OL_TYPE);
		expertDetailsService.saveExpertDetails(expDetails);


		if (fromAddGuest != null && fromAddGuest.equals("true")) {
		    String kolName = lastName+", "+fullName;
		    String kolId = Long.toString(user.getId());

		    response.sendRedirect("expertfullprofile.htm?kolid="+kolId+"&entityId="+kolid+"&"+Constants.CURRENT_KOL_NAME+"="+kolName);

		}
	}

	    return new ModelAndView("add_guest_hcp");
}

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

	public IUserService getAddUserService() {
		return addUserService;
	}

	public void setAddUserService(IUserService addUserService) {
		this.addUserService = addUserService;
	}
	public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

}
