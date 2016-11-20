package com.openq.web.controllers;

import com.mchange.v2.codegen.bean.Property;
import com.openq.attendee.Attendee;
import com.openq.attendee.AttendeeService;
import com.openq.attendee.IAttendeeService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.option.OptionNames;
import com.openq.encription.IEncryptPasswordService;
import com.openq.group.IGroupService;
import com.openq.group.IUserGroupMapService;
import com.openq.group.UserGroupMap;
import com.openq.group.UserGroupMapService;
import com.openq.group.GroupService;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.user.UserAddress;
import com.openq.user.UserService;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;
import com.openq.web.forms.UserForm;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.rpc.ServiceException;
import java.text.SimpleDateFormat;
import java.util.Date;
import com.openq.orx.agmen.ORXServices;
import com.openq.orx.agmen.IORXServices;

import java.util.TreeMap;
import java.rmi.RemoteException;

/**
 * Created by IntelliJ IDEA. User: abhrap Date: Oct 9, 2006 Time: 3:41:48 PM To
 * change this template use File | Settings | File Templates.
 */
public class AddUserController extends SimpleFormController {
	private IEncryptPasswordService encryptPasswordService;

	public IEncryptPasswordService getEncryptPasswordService() {
		return encryptPasswordService;
	}

	public void setEncryptPasswordService(
			IEncryptPasswordService encryptPasswordService) {
		this.encryptPasswordService = encryptPasswordService;
	}

	protected ModelAndView showForm(HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse, BindException bindException)
			throws Exception {
		return null;
	}

	protected ModelAndView processFormSubmission(HttpServletRequest request,
			HttpServletResponse response, Object object, BindException exception)
			throws Exception {

		HttpSession session = request.getSession();

		UserForm userForm = (UserForm) object;
		String action = (String) request.getParameter("action");
		String userGroupIdString = (String) request.getSession().getAttribute(
				Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if (userGroupIdString != null
				&& !"".equalsIgnoreCase(userGroupIdString))
			userGroupId = Long.parseLong(userGroupIdString);
		IORXServices orxService = new ORXServices();

		User user = setUserDTO(userForm, userGroupId, request);
		if (ActionKeys.ADD_USER.equalsIgnoreCase(action)) {
			String userName=user.getUserName();
			String staffId=user.getStaffid();
			User verifyExistence = addUserService.checkExistUserNameStaffID(user
					.getUserName(),user.getStaffid());
			if(verifyExistence!=null){
			if(verifyExistence.getUserName().equalsIgnoreCase(userName)&&verifyExistence.getStaffid().equalsIgnoreCase(staffId)&&verifyExistence.getDeleteFlag().equalsIgnoreCase("N")){
				setSessions(session,userGroupId);
				session.setAttribute("MESSAGE1",
						"UserName & StaffId already exist");
				return new ModelAndView("create_user");
			}
			if(verifyExistence.getUserName().equalsIgnoreCase(userName)&&!verifyExistence.getStaffid().equalsIgnoreCase(staffId)&&verifyExistence.getDeleteFlag().equalsIgnoreCase("N")){
    			setSessions(session,userGroupId);
				session.setAttribute("MESSAGE1", "UserName already exist");
				return new ModelAndView("create_user");
    		}
    			
    		if(!verifyExistence.getUserName().equalsIgnoreCase(userName)&&verifyExistence.getStaffid().equalsIgnoreCase(staffId)&&verifyExistence.getDeleteFlag().equalsIgnoreCase("N")){
    			setSessions(session,userGroupId);
				session.setAttribute("MESSAGE1", "Staff ID already exist");
				return new ModelAndView("create_user");	
    		}
			}
			if(verifyExistence!=null&&verifyExistence.getDeleteFlag().equalsIgnoreCase("Y")){
					 user.setId(verifyExistence.getId());
					 user.setUserAddress(verifyExistence.getUserAddress());
					 user.setDeleteFlag("N");
					 addUserService.updateUserAddress(user.getUserAddress());
					 addUserService.updateUser(user);
					}
			else{
					 addUserService.createUserAddress(user.getUserAddress());
					 addUserService.createUser(user);
				 }
				if (user.getUserType().getId() == 4)
					try {
						orxService.registerObject(user.getFirstName(), user
								.getMiddleName(), user.getLastName(), String
								.valueOf(user.getId()), user.getSpeciality(),
								user.getLocation());
					} catch (RemoteException e) {
						e.printStackTrace();
						System.out.println("Orx service not available");
					}

				String checkedUserIds = null;
				if (null != request.getParameter("chkGroupIds")) {
					checkedUserIds = request.getParameter("chkGroupIds");
				}
				if (null != checkedUserIds && !"".equals(checkedUserIds)) {
					String ids[] = null;
					if (checkedUserIds.indexOf(",") != -1) {
						ids = checkedUserIds.split(",");
						if (null != ids && ids.length > 0) {
							for (int i = 0; i < ids.length; i++) {
								userGroupMapService.saveUserGroupMap(user
										.getId(), Long.parseLong(ids[i]));
							}
						}
					} else {
						userGroupMapService.saveUserGroupMap(user.getId(), Long
								.parseLong(checkedUserIds));
					}
				}
				session.setAttribute("MESSAGE1", "user(s) added successfully");
		
		} else if (ActionKeys.SAVE_USER.equalsIgnoreCase(action)) {
			int userId = 0;
			if (session.getAttribute("KOL_ID") != null
					&& !"".equals(session.getAttribute("KOL_ID"))) {
				userId = Integer.parseInt((String) session
						.getAttribute("KOL_ID"));
				user.setId(userId);
				User userDTO = addUserService.getUser(userId);
				user.getUserAddress().setId(userDTO.getUserAddress().getId());
				user.setKolid(userDTO.getKolid());

				// Amit - set the last update time for this OL
				user.setLastUpdateTime(System.currentTimeMillis());
				// Amit - set the last update time for this OL
			}
			session.removeAttribute("KOL_ID");
			if ("ON".equalsIgnoreCase(request.getParameter("deleteFlag"))) {
				user.setDeleteFlag("Y");
			} else
				user.setDeleteFlag("N");
			
			String userName=user.getUserName();
			String staffId=user.getStaffid();
			long kolId=Long.parseLong(request.getParameter("userId"));//user.getId();
			User verifyExistence = addUserService.checkExistUserNameStaffID(user
					.getUserName(),user.getStaffid());
			if(verifyExistence!=null){
			if(verifyExistence.getUserName().equalsIgnoreCase(userName)&&verifyExistence.getStaffid().equalsIgnoreCase(staffId)&&verifyExistence.getId()!=kolId){
				setSessions(session,userGroupId);
				session.setAttribute("MESSAGE",
						"UserName & StaffId already exist cannot be updated");
				return new ModelAndView("edit_user");
			}
			if(verifyExistence.getUserName().equalsIgnoreCase(userName)&&!verifyExistence.getStaffid().equalsIgnoreCase(staffId)&&verifyExistence.getId()!=kolId){
    			setSessions(session,userGroupId);
				session.setAttribute("MESSAGE", "UserName already exist cannot be updated");
				return new ModelAndView("edit_user");
    		}
    			
    		if(!verifyExistence.getUserName().equalsIgnoreCase(userName)&&verifyExistence.getStaffid().equalsIgnoreCase(staffId)&&verifyExistence.getId()!=kolId){
    			setSessions(session,userGroupId);
				session.setAttribute("MESSAGE", "Staff ID already exist cannot be updated");
				return new ModelAndView("edit_user");	
    		}
			}	
			 else {
		
			addUserService.updateUserAddress(user.getUserAddress());
			addUserService.updateUser(user);

			Attendee[] attList = attendeeService.getAttendees(user.getId());
			Attendee att = null;

			for (int i = 0; i < attList.length; i++) {
				att = (Attendee) attList[i];
				att.setName(user.getLastName() + ", " + user.getFirstName());
				attendeeService.updateAttendee(att);
			}

			UserGroupMap groups[] = userGroupMapService
					.getAllGroupsForUser(user.getId());

			if (groups != null && groups.length > 0) {
				UserGroupMap userGroups = null;
				for (int i = 0; i < groups.length; i++) {
					userGroups = groups[i];
					userGroupMapService.deleteUserGroupMap(user.getId(),
							userGroups.getId());
				}
			}

			String checkedUserIds = null;
			if (null != request.getParameter("chkGroupIds")) {
				checkedUserIds = request.getParameter("chkGroupIds");
			}
			if (null != checkedUserIds && !"".equals(checkedUserIds)) {
				String ids[] = null;
				if (checkedUserIds.indexOf(",") != -1) {
					ids = checkedUserIds.split(",");
					if (null != ids && ids.length > 0) {
						for (int i = 0; i < ids.length; i++) {
							userGroupMapService.saveUserGroupMap(user.getId(),
									Long.parseLong(ids[i]));
						}
					}
				} else {
					userGroupMapService.saveUserGroupMap(user.getId(), Long
							.parseLong(checkedUserIds));
				}
			}

			session.setAttribute("ALL_USER_GROUPS", userGroupsService
					.getAllGroups());
			session.setAttribute("SELECTED_USER_GROUPS", userGroupMapService
					.getAllGroupsForUser(user.getId()));
			session
					.setAttribute("USER_TYPE_LIST", optionServiceWrapper
							.getValuesForOptionName(PropertyReader
									.getLOVConstantValueFor("USER_TYPES"),
									userGroupId));
			session.setAttribute("PREFIX_LIST", optionServiceWrapper
					.getValuesForOptionName(PropertyReader
							.getLOVConstantValueFor("PREFIX"), userGroupId));
			session.setAttribute("SUFFIX_LIST", optionServiceWrapper
					.getValuesForOptionName(PropertyReader
							.getLOVConstantValueFor("SUFFIX"), userGroupId));
			session.setAttribute("MESSAGE",
					"user(s) details saved successfully");
			session.setAttribute("MESSAGE1", "user(s) added successfully");
			System.out.print("The value of message1"
					+ session.getAttribute("MESSAGE1"));

		}
		}
		return new ModelAndView("update_user");
	   
	}

	public User setUserDTO(UserForm userForm, long userGroupId,
			HttpServletRequest request) throws Exception {
		User user = null;
		try {
			String userOriginalPassword = (String) request.getSession()
					.getAttribute("USER_ORIGINAL_PASSWORD");
			request.getSession().removeAttribute("USER_ORIGINAL_PASSWORD");
			user = new User();
			user.setUserName(userForm.getUserName());
			if (userForm.getUserPassword().equals(userOriginalPassword)) {
				user.setPassword(userOriginalPassword);
			} else {
				user.setPassword(encryptPasswordService
						.encryptPassword(userForm.getUserPassword())); // encrypt
																		// the
																		// user
																		// password
			}
			// user.setUserName(userForm.getUserName());
			// user.setPassword(userForm.getUserPassword());
			user.setEmail(userForm.getEmailAddress());
			if (userForm.getStaffid() != null && userForm.getStaffid() != "")
				user.setStaffid(userForm.getStaffid());
			else
				user.setStaffid(null);
			user.setDeleteFlag("N");
			user.setTitle(userForm.getTitle());

			/*
			 * OptionLookup userTypeOption = new OptionLookup(); OptionNames
			 * optionNames = optionService.getOptionNames(1); OptionLookup
			 * userTypeOptionArr[] = optionService.getValuesForOption(1);// 1 is
			 * for UserTypeId.
			 * 
			 * userTypeOption.setOptionId(optionNames);
			 * userTypeOption.setId(Long.parseLong(userForm.getUserTypeId()));
			 * if (null != userTypeOptionArr && userTypeOptionArr.length > 0) {
			 * OptionLookup lookup = null; for (int i = 0; i <
			 * userTypeOptionArr.length; i++) { lookup = userTypeOptionArr[i];
			 * if (lookup.getId() == Long.parseLong(userForm.getUserTypeId())) {
			 * userTypeOption.setOptValue(lookup.getOptValue()); } } }
			 */
			user.setUserType(optionService.getOptionLookup(Long
					.parseLong(userForm.getUserTypeId()), userGroupId));
			/*
			 * OptionLookup prefixOption = new OptionLookup(); OptionNames
			 * prefixNames = optionService.getOptionNames(38); OptionLookup
			 * prefixOptionArr[] = optionService.getValuesForOption(38);// 1 is
			 * for UserTypeId.
			 * 
			 * prefixOption.setOptionId(prefixNames);
			 * prefixOption.setId(Long.parseLong(userForm.getPrefix())); if
			 * (null != prefixOptionArr && prefixOptionArr.length > 0) {
			 * OptionLookup lookup = null; for (int i = 0; i <
			 * prefixOptionArr.length; i++) { lookup = prefixOptionArr[i]; if
			 * (lookup.getId() == Long.parseLong(userForm.getPrefix())) {
			 * prefixOption.setOptValue(lookup.getOptValue()); } } }
			 */
			user.setPrefix(optionService.getOptionLookup(Long
					.parseLong(userForm.getPrefix()), userGroupId));

			user.setFirstName(userForm.getFirstName());
			user.setMiddleName(userForm.getMiddleInitial());
			user.setLastName(userForm.getLastName());

			/*
			 * OptionLookup suffixOption = new OptionLookup(); OptionNames
			 * suffixNames = optionService.getOptionNames(39); OptionLookup
			 * suffixOptionArr[] = optionService.getValuesForOption(39);//
			 * 
			 * 
			 * suffixOption.setOptionId(suffixNames);
			 * suffixOption.setId(Long.parseLong(userForm.getSuffix())); if
			 * (null != suffixOptionArr && suffixOptionArr.length > 0) {
			 * OptionLookup lookup = null; for (int i = 0; i <
			 * suffixOptionArr.length; i++) { lookup = suffixOptionArr[i]; if
			 * (lookup.getId() == Long.parseLong(userForm.getSuffix())) {
			 * suffixOption.setOptValue(lookup.getOptValue()); } } }
			 */
			user.setSuffix(optionService.getOptionLookup(Long
					.parseLong(userForm.getSuffix()), userGroupId));

			if (userForm.getBirthDate() != null
					&& !("".equalsIgnoreCase(userForm.getBirthDate()))) {
				// convert String to Date
				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
				Date date = sdf.parse(userForm.getBirthDate());

				user.setBirthDate(date);
			} else {
				user.setBirthDate(null);
			}

			user.setSecurityQuestion(userForm.getSecurityQuestion());
			user.setAnswer(userForm.getAnswer());
			if (userForm.getMSLDate() != null
					&& !("".equalsIgnoreCase(userForm.getMSLDate()))) {
				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
				Date date = sdf.parse(userForm.getMSLDate());
				user.setMslStartDate(date);
			} else
				user.setMslStartDate(null);
			UserAddress address = new UserAddress();
			address.setAddress1(userForm.getAddress1());
			address.setAddress2(userForm.getAddress2());
			address.setCity(userForm.getCity());
			address.setZip(userForm.getZip());

			/*
			 * OptionLookup countryOption = new OptionLookup(); OptionNames
			 * countryName = optionService.getOptionNames(3); OptionLookup
			 * countryOptionArr[] = optionService.getValuesForOption(3);// 3 is
			 * for country.
			 * 
			 * countryOption.setOptionId(countryName);
			 * countryOption.setId(Long.parseLong(userForm.getCountry())); if
			 * (null != countryOptionArr && countryOptionArr.length > 0) {
			 * OptionLookup lookup = null; for (int i = 0; i <
			 * countryOptionArr.length; i++) { lookup = countryOptionArr[i]; if
			 * (lookup.getId() == Long.parseLong(userForm.getCountry())) {
			 * countryOption.setOptValue(lookup.getOptValue()); } } }
			 */
			address.setCountry(optionService.getOptionLookup(Long
					.parseLong(userForm.getCountry()), userGroupId));

			/*
			 * OptionLookup stateOption = new OptionLookup(); OptionNames
			 * stateName = optionService.getOptionNames(2); OptionLookup
			 * stateOptionArr[] = optionService.getValuesForOption(2);// 2 is
			 * for state.
			 * 
			 * stateOption.setOptionId(stateName);
			 * stateOption.setId(Long.parseLong(userForm.getState())); if (null
			 * != stateOptionArr && stateOptionArr.length > 0) { OptionLookup
			 * lookup = null; for (int i = 0; i < stateOptionArr.length; i++) {
			 * lookup = stateOptionArr[i]; if (lookup.getId() ==
			 * Long.parseLong(userForm.getState())) {
			 * stateOption.setOptValue(lookup.getOptValue()); } } }
			 */
			address.setState(optionService.getOptionLookup(Long
					.parseLong(userForm.getState()), userGroupId));
			address.setSuiteRoom(userForm.getSuiteRoom());
			user.setUserAddress(address);
			user.setPhone(userForm.getPhoneNumber());

		} catch (Exception e) {
			logger.error("Error in parsing Date while setting user", e);
		}
		return user;
	}
	public void setSessions(HttpSession session,long userGroupId){
		session.setAttribute("ALL_USER_GROUPS", userGroupsService.getAllGroups());
        session.setAttribute("USER_TYPE_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("USER_TYPES"), userGroupId));
        session.setAttribute("STATE_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("STATE"), userGroupId));
        session.setAttribute("COUNTRY_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("COUNTRY"), userGroupId));
        session.setAttribute("PREFIX_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("PREFIX"), userGroupId));
        session.setAttribute("SUFFIX_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("SUFFIX"), userGroupId));  	
	}

	IUserService addUserService;
	IOptionService optionService;
	IGroupService userGroupsService;
	IUserGroupMapService userGroupMapService;
	IAttendeeService attendeeService;
	IOptionServiceWrapper optionServiceWrapper;

	public IAttendeeService getAttendeeService() {
		return attendeeService;
	}

	public void setAttendeeService(IAttendeeService attendeeService) {
		this.attendeeService = attendeeService;
	}

	public IGroupService getUserGroupsService() {
		return userGroupsService;
	}

	public void setUserGroupsService(IGroupService userGroupsService) {
		this.userGroupsService = userGroupsService;
	}

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

	public IUserGroupMapService getUserGroupMapService() {
		return userGroupMapService;
	}

	public void setUserGroupMapService(IUserGroupMapService userGroupMapService) {
		this.userGroupMapService = userGroupMapService;
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

	public void setOptionServiceWrapper(
			IOptionServiceWrapper optionServiceWrapper) {
		this.optionServiceWrapper = optionServiceWrapper;
	}

}
