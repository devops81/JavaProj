package com.openq.web.controllers;

import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.alerts.IAlertsService;
import com.openq.authentication.UserDetails;
import com.openq.contacts.Contacts;
import com.openq.eav.data.IDataService;
import com.openq.eav.expert.IExpertListService;
import com.openq.eav.expert.MyExpertList;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.org.IOrganizationService;
import com.openq.eav.org.Organization;
import com.openq.kol.DBUtil;
import com.openq.orx.BestORXRecord;
import com.openq.orx.ISearchORX;
import com.openq.orx.SearchORXServiceProvider;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;

public class SearchKolController extends AbstractController {

	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("searchKol");
		HttpSession session = request.getSession();
		String action = (String) request.getParameter("action");
		String userGroupIdString = (String) request.getSession().getAttribute(
				Constants.CURRENT_USER_GROUP);
		String fromAdvanceSearch = null;
		if(request.getParameter("fromAdvanceSearch")!=null) {
		    fromAdvanceSearch = request.getParameter("fromAdvanceSearch");
		}
		String fromExpertFullProfile = request.getParameter("fromExpertFullProfile");
		long userGroupId = -1;
		if (userGroupIdString != null
				&& !"".equalsIgnoreCase(userGroupIdString)) {
			userGroupId = Long.parseLong(userGroupIdString);
		}

		request.getSession().setAttribute(
				"stateAbbriviation",
				optionServiceWrapper.getValuesForOptionName(PropertyReader
						.getLOVConstantValueFor("STATE"), userGroupId));
		request.getSession().removeAttribute("orgResult");
		request.getSession().removeAttribute("OLResult");
		session.setAttribute(Constants.ALERT_QUEUE,
				getAlertsService().getAlertQueue(
						(String) session.getAttribute(Constants.USER_ID)));

		String myexpertIds[] = request.getParameterValues("checkIds");
		boolean saved = true;
		if (myexpertIds != null) {
			UserDetails user = (UserDetails) request.getSession().getAttribute(
					Constants.CURRENT_USER);
			for (int i = 0; i < myexpertIds.length; i++) {
				Contacts contact = new Contacts();

				contact.setContactName(user.getCompleteName());
				contact.setEmail(user.getEmail());
				if (user.getStaffId() != null
						&& user.getStaffId().trim().length() > 0)
					contact.setStaffid(Long
							.parseLong((user.getStaffId().trim())));
				contact.setPhone(user.getTelephoneNumber());
				contact.setKolId(Long.parseLong(myexpertIds[i]));
				boolean isDuplicateContact = expertlistService.addOL(contact);
				saved = saved && isDuplicateContact;
				request.getSession().removeAttribute("myOL");

			}
			String message = "One or more " + DBUtil.getInstance().doctor
					+ "(s) were already in your contact list.";
			if (saved)
				message = DBUtil.getInstance().doctor
						+ "(s) added to contact list.";
			if(fromAdvanceSearch!=null && fromAdvanceSearch.equals("true")) {
			    request.getSession().setAttribute("OLAdded", "true");
			    response.sendRedirect("search.htm");
			}
			
			if(fromExpertFullProfile != null) {
			    response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                if(saved) {
                    message = DBUtil.getInstance().doctor + " added to contact list.";
                }
                else {
                    message = "This " + DBUtil.getInstance().doctor + " is already in your contact list.";
                }
                response.getWriter().write(message);
                response.getWriter().close();
                return null;
			}
			response.sendRedirect("home.htm?message=" + message);
		}

		String name = request.getParameter("searchText");

		String organizationName = request.getParameter("organization");

		String keyword = request.getParameter("searchText");
		keyword = (keyword == null ? keyword : keyword.trim());
		name = (name == null ? name : name.trim());
		String isSAXAJVUserString = (String) session
				.getAttribute(Constants.IS_SAXA_JV_GROUP_USER);
		String jointVenture = null;
		if (isSAXAJVUserString != null && "true".equals(isSAXAJVUserString)) {
			jointVenture = "Saxa_JV";
		}
		
		String isOTSUKAJVUserString = (String) session.getAttribute(Constants.IS_OTSUKA_JV_GROUP_USER);
		if(isOTSUKAJVUserString != null && "true".equals(isOTSUKAJVUserString)){
				jointVenture ="Otsuka_JV";
		}
		
		if (organizationName != null && !organizationName.equals("")
				&& !organizationName.equals("<Organization>")) {
			Organization[] orgs = orgService
					.searchOrganizations(organizationName);
			request.getSession().setAttribute("orgResult", "1");
			if (orgs != null && orgs.length != 0)
				Arrays.sort(orgs);
			request.getSession().setAttribute("orgsattr", orgs);
			mav.addObject("orgs", orgs);
		}
		if (keyword != null && !"".equals(keyword)
				&& !"<Enter Keyword>".equals(keyword)) {
			List homeSearchResults = dataService.getOLForLastName(keyword,
					jointVenture);
			mav.addObject("homeSearchResults", homeSearchResults);
			request.getSession().setAttribute("OLResult", "1");
		}
		// TODO : Need to cleanup this code. It's making search very slow
		if (ActionKeys.EXPERT_SEARCH_INTERACTION.equalsIgnoreCase(action)) {
			String fromKOLStrategy = null;

			if (request.getParameter("fromKOLStrategy") != null
					&& !"".equals(request.getParameter("fromKOLStrategy"))) {
				fromKOLStrategy = request.getParameter("fromKOLStrategy");
				session.setAttribute("fromKOLStrategy", fromKOLStrategy);
				session.setAttribute("CURRENT_LINK", "KOL_STRATEGY");
			}
			User[] users = null;
			if (null != name && !"".equals(name)) {
				users = searchUserService.searchUser(name);
			}
			// TODO: Get rid of dependency on MyExpertList bean
			MyExpertList[] myExpertLists = null;
			if (users != null && users.length > 0) {
				myExpertLists = getMyExpertListBeans(users);
			}

			if (ActionKeys.EXPERT_SEARCH_INTERACTION.equalsIgnoreCase(action)) {
				request.setAttribute("myexperts_list", myExpertLists);
				String kolIds = null;
				if (null != request.getParameter("kolObject")
						&& !"".equals(request.getParameter("kolObject"))) {
					kolIds = request.getParameter("kolObject");
					request.setAttribute("KOL_OBJECT", kolIds);
				}
			}
			return new ModelAndView("interaction_search_kol");
		}
		return mav;
	}

	private MyExpertList[] getMyExpertListBeans(User[] users) {
		MyExpertList[] myExpertLists;
		User usr;
		myExpertLists = new MyExpertList[users.length];
		MyExpertList list = null;
		for (int i = 0; i < users.length; i++) {
			usr = users[i];

			list = new MyExpertList();

			list.setId(usr.getId());
			list.setKolid(usr.getKolid());
			list.setLocation(usr.getLocation());
			list.setName(usr.getLastName() + ", " + usr.getFirstName());
			list.setPhone(usr.getPhone());
			list.setSpeciality(usr.getSpeciality());
			list.setStaffid(usr.getStaffid());

			myExpertLists[i] = list;
		}
		return myExpertLists;
	}

	IExpertListService expertlistService;
	IUserService searchUserService;
	IOrganizationService orgService;
	IOptionService optionService;
	IOptionServiceWrapper optionServiceWrapper;
	IDataService dataService;

	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

	public IUserService getSearchUserService() {
		return searchUserService;
	}

	public void setSearchUserService(IUserService searchUserService) {
		this.searchUserService = searchUserService;
	}

	public IExpertListService getExpertlistService() {
		return expertlistService;
	}

	public void setExpertlistService(IExpertListService expertlistService) {
		this.expertlistService = expertlistService;
	}

	public IOrganizationService getOrgService() {
		return orgService;
	}

	public void setOrgService(IOrganizationService orgService) {
		this.orgService = orgService;
	}

	public IOptionServiceWrapper getOptionServiceWrapper() {
		return optionServiceWrapper;
	}

	public void setOptionServiceWrapper(
			IOptionServiceWrapper optionServiceWrapper) {
		this.optionServiceWrapper = optionServiceWrapper;
	}

	IAlertsService alertsService;

	public void setAlertsService(IAlertsService service) {
		this.alertsService = service;
	}

	public IAlertsService getAlertsService() {
		return alertsService;
	}
}
