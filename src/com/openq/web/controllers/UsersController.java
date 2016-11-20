package com.openq.web.controllers;

import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.option.OptionNames;
import com.openq.eav.option.OptionServiceWrapper;
import com.openq.event.EventEntity;
import com.openq.group.IGroupService;
import com.openq.group.IUserGroupMapService;
import com.openq.group.UserGroupMap;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.user.UserAddress;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;
import com.openq.contacts.IContactsService;
import com.openq.contacts.Contacts;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class UsersController extends AbstractController {

    protected ModelAndView handleRequestInternal(HttpServletRequest request,
                                                 HttpServletResponse response) throws Exception {

    	HttpSession session = request.getSession();
        String action = (String) request.getParameter("action");
        session.removeAttribute("fromKOLStrategy");
        String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);

        if (ActionKeys.CREATE_USER.equalsIgnoreCase(action)) {
               
            session.setAttribute("ALL_USER_GROUPS", userGroupsService.getAllGroups());
            session.setAttribute("USER_TYPE_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("USER_TYPES"), userGroupId));
            session.setAttribute("STATE_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("STATE"), userGroupId));
            session.setAttribute("COUNTRY_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("COUNTRY"), userGroupId));
            session.setAttribute("PREFIX_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("PREFIX"), userGroupId));
            session.setAttribute("SUFFIX_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("SUFFIX"), userGroupId));
            System.out.println("in create user action");
            session.setAttribute("MESSAGE1","user added successfully");

            return new ModelAndView("create_user");

        } else if (ActionKeys.UPDATE_USER.equalsIgnoreCase(action)) {

            session.setAttribute("ALL_USER_GROUPS", userGroupsService.getAllGroups());
            session.setAttribute("USER_TYPE_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("USER_TYPES"), userGroupId));
            session.setAttribute("PREFIX_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("PREFIX"), userGroupId));
            session.setAttribute("SUFFIX_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("SUFFIX"), userGroupId));
            session.setAttribute("MESSAGE","user(s) details saved successfully");
            
            return new ModelAndView("update_user");

        } else if (ActionKeys.ADD_USER.equalsIgnoreCase(action)) {
        	 System.out.println("in add user action");
            return new ModelAndView("kol_main_objectives");

        } else if (ActionKeys.SEARCH_USER.equalsIgnoreCase(action)) {

            String partialName = request.getParameter("userName");
            int userTypeSel = 0;
            if (null != request.getParameter("userTypeId") &&
                    !"".equals(request.getParameter("userTypeId"))) {
                userTypeSel = Integer.parseInt(request.getParameter("userTypeId"));
            }
            int groupId = 0;
            if (null != request.getParameter("groupId") &&
                    !"".equals(request.getParameter("groupId"))) {
                groupId = Integer.parseInt(request.getParameter("groupId"));
            }

            request.setAttribute("PARTIAL_USER_NAME", partialName);
            request.setAttribute("USER_TYPE_ID", request.getParameter("userTypeId"));
            request.setAttribute("GROUP_ID", request.getParameter("groupId"));

            String userIds[] = null;
            OptionLookup userTypeOption = new OptionLookup();
            OptionNames optionNames = optionService.getOptionNames(1);
            OptionLookup userTypeOptionArr[] = optionService.getValuesForOption(1, userGroupId);// 1 is for UserTypeId.

            userTypeOption.setOptionId(optionNames);
            userTypeOption.setId(userTypeSel);
            if (null != userTypeOptionArr && userTypeOptionArr.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < userTypeOptionArr.length; i++) {
                    lookup = userTypeOptionArr[i];
                    if (lookup.getId() == userTypeSel) {
                        userTypeOption.setOptValue(lookup.getOptValue());
                    }
                }
            }
            userIds = searchUserService.searchUser(partialName, userTypeOption, groupId);
            if (null != userIds && userIds.length > 0) {
                int userId = 0;
                User user = null;
                User[] userArr = new User[userIds.length];
                for (int i = 0; i < userIds.length; i++) {
                    userId = Integer.parseInt(userIds[i]);
                    user = searchUserService.getUser(userId);
                    userArr[i] = user;
                }
                session.setAttribute("USER_SEARCH_LIST", userArr);
            }
            return new ModelAndView("update_user");

        } else if (ActionKeys.EDIT_USER.equalsIgnoreCase(action)) {
            String userId = null;
            User user = null;
            if (null != request.getParameter("userId")) {
                userId = request.getParameter("userId");
                user = searchUserService.getUser(Long.parseLong(userId));
                session.setAttribute("USER_INFO", user);
                UserGroupMap groups[] = userGroupMapService.getAllGroupsForUser(Long.parseLong(userId));
                session.setAttribute("SELECTED_USER_GROUPS", groups);
                session.setAttribute("KOL_ID", userId);
            }
            session.setAttribute("ALL_USER_GROUPS", userGroupsService.getAllGroups());
            session.setAttribute("STATE_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("STATE"), userGroupId));
            session.setAttribute("COUNTRY_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("COUNTRY"), userGroupId));
            session.setAttribute("PREFIX_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("PREFIX"), userGroupId));
            session.setAttribute("SUFFIX_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("SUFFIX"), userGroupId));
            session.setAttribute("USER_TYPE_LIST", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("USER_TYPES"), userGroupId));
            return new ModelAndView("edit_user");

        } else if (ActionKeys.DELETE_USER.equalsIgnoreCase(action)) {

            String userIds[] = request.getParameterValues("checkedUserList");
            String userAddressIds[] = request.getParameterValues("checkedUserAddressList");

            if (userAddressIds != null && userIds != null) {
                UserAddress address = new UserAddress();
                User user = new User();
                try {
                    // TODO: Investigate this wierd delete bug, the entry should also get deleted from user_group_map
                    for (int j = 0; j < userIds.length; j++) {
                        User existUser = searchUserService.getUser(Long.parseLong(userIds[j]));
                        existUser.setId(Long.parseLong(userIds[j]));
                        existUser.setDeleteFlag("Y");
                        existUser.setUpdateTime(new Date(System.currentTimeMillis()));
                        searchUserService.deleteUser(existUser);
                        //The deleted kol needs to be removed from the contacts of each user.
                        Contacts [] contact = contactsService.getContactsForKol(Long.parseLong(userIds[j]));
                        for(int i=0; i<contact.length; i++){
                            contactsService.delete(contact[i].getContactId());
                        }
                        //The deleted user must be cleaned from all the groups
                        UserGroupMap [] userGrpMap = userGroupMapService.getAllGroupsForUser(Long.parseLong(userIds[j]));
                        for(int i=0;i<userGrpMap.length;i++){
                        	userGroupMapService.deleteUserGroupMap(userGrpMap[i]);
                        }
                        
                    }
                    for (int i = 0; i < userAddressIds.length; i++) {
                        address.setId(Long.parseLong(userAddressIds[i]));
                        searchUserService.deleteUserAddress(address);
                    }
                } catch (Exception bue) {
                    // do nothing, since delete worked!
                }
                session.setAttribute("MESSAGE", "user(s) deleted successfully");
            }
            return new ModelAndView("update_user");
        } else if (ActionKeys.ADV_SEARCH_HOME.equals(action)) {

        	session.removeAttribute("INVITED_USERS");
        	String[] attendeeIds;
    		String attendeeList = request.getParameter("usersFromEvents");
            if(attendeeList!=null&&attendeeList.trim().length()>0){
            	System.out.println("attendee list : " + attendeeList);
            	attendeeIds=attendeeList.split(",");
            	System.out.println("no of attendees "+attendeeIds.length);
            	User user[]=new User[attendeeIds.length];
            	for(int i=0;i<attendeeIds.length;i++){//we are using length -1 because we have one extra coma in attendeelist string
            		System.out.println("attendee id are "+attendeeIds[i]);
            		user[i] = searchUserService.getUser(Long.parseLong(attendeeIds[i]));
            	}
            	session.setAttribute("INVITED_USERS", user);
            }
            if(request.getParameter("fromEvents")!=null){
            long currentUserId = Long.parseLong((String) session
    				.getAttribute(Constants.USER_ID));
            EventEntity event = getEventDTO(request, currentUserId, userGroupId);
			session.setAttribute("EVENT_DETAILS", event);
            }
            session.setAttribute("CURRENT_LINK", "ADVANCED_SEARCH");
            session.removeAttribute("fromKOLStrategy");
            session.removeAttribute("fromOLAlignment");
            session.removeAttribute("fromEvents");
            
            session.setAttribute("THERAPAUTIC_AREA",  optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
            session.setAttribute("TIER", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("TIER"), userGroupId));
            session.setAttribute("TOPIC_EXPERTIS", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("TOPIC_EXPERTISE"), userGroupId));
            session.setAttribute("SPECIALTY", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("SPECIALTY"), userGroupId));
            session.setAttribute("PLATFORM", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("PLATFORM"), userGroupId));
            session.setAttribute("PUBLICATION", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("PUBLICATION"), userGroupId));
            session.setAttribute("RESEARCH", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("RESEARCH"), userGroupId));
            session.setAttribute("POS_AMGEN_SCIENCE", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("THERAPY"), userGroupId));
            session.setAttribute("COUNTRY_LIST",optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("COUNTRY"), userGroupId));
            session.setAttribute("STATE_LIST",optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("STATE"), userGroupId));


            String fromKOLStrategy = null;
            fromKOLStrategy =  request.getParameter("fromKOLStrategy");
            if (null != fromKOLStrategy && "true".equalsIgnoreCase(fromKOLStrategy)) {
                session.setAttribute("fromKOLStrategy",fromKOLStrategy);
                session.setAttribute("CURRENT_LINK", "KOL_STRATEGY");
            }
            
            String fromEvents = null;
            fromEvents = request.getParameter("fromEvents");
            if (null != fromEvents && "true".equalsIgnoreCase(fromEvents)) {
                session.setAttribute("fromEvents",fromEvents);
                session.setAttribute("CURRENT_LINK", "EVENT_ADD");
            }
            String fromOLAlignment = null;
            fromOLAlignment =  request.getParameter("fromOLAlignment");
            if (null != fromOLAlignment && "true".equalsIgnoreCase(fromOLAlignment)) {
                session.setAttribute("fromOLAlignment",fromOLAlignment);
                session.setAttribute("CURRENT_LINK", "OLAlignment");
                 String staffId = null; String userName = null;String email = null;String phone = null;
                if(null != request.getParameter("staffId")){
                    staffId = request.getParameter("staffId");
                    userName = request.getParameter("userName");
                    email = null != request.getParameter("email") ? request.getParameter("email") : null;
                    phone = null != request.getParameter("phone") ? request.getParameter("phone") : null;
                    session.setAttribute("STAFFID",staffId);
                    session.setAttribute("USERNAME",userName);
                    session.setAttribute("EMAIL",email);
                    session.setAttribute("PHONE",phone);
                }
             }

            if(request.getParameter("reset") != null &&
                    "yes".equals(request.getParameter("reset"))) {

                if (null != fromKOLStrategy && "true".equalsIgnoreCase(fromKOLStrategy)) {
                    session.setAttribute("fromKOLStrategy", fromKOLStrategy);
                    session.setAttribute("CURRENT_LINK", "KOL_STRATEGY");
                }else if(null != fromOLAlignment && "true".equalsIgnoreCase(fromOLAlignment)) {

                    session.setAttribute("fromOLAlignment",fromOLAlignment);
                    session.setAttribute("CURRENT_LINK", "OLAlignment");
               }else if(null != fromEvents && "true".equalsIgnoreCase(fromEvents)) {

                   session.setAttribute("fromEvents",fromEvents);
                   session.setAttribute("CURRENT_LINK", "event_add");
              }

                 session.removeAttribute("ADV_SEARCH_RESULT");
                 session.removeAttribute("ADV_SEARCH_FROM");

            }



            return new ModelAndView("advsearch");  
        }

        return new ModelAndView("users");
    }
    /*
     * This mehod get added to make event details object while coming through
     * Events (for GSK demo)
     * TODO - Move this method to helper class
     */
    private EventEntity getEventDTO(HttpServletRequest request,
			long currentUserId,long userGroupId) throws Exception {
		EventEntity event = new EventEntity();
		event.setUserid(currentUserId);
		if (request.getParameter("eventTitle") != null
				&& !"".equals(request.getParameter("eventTitle"))) {
			String title = request.getParameter("eventTitle");
			if (title != null && title.length() > 0) {
				title = title.trim();
				event.setTitle(title);
			}
		}

        if (request.getParameter("eventDate") != null
				&& !"".equals(request.getParameter("eventDate"))) {
			SimpleDateFormat sdf = new SimpleDateFormat(
					ActionKeys.CALENDAR_DATE_FORMAT);
            event.setEventdate(sdf.parse(request.getParameter("eventDate")));
        }
		if (request.getParameter("eventCity") != null
				&& !"".equals(request.getParameter("eventCity"))) {
			event.setCity(request.getParameter("eventCity"));
			
		}
        if (request.getParameter("eventState") != null
                && !"".equals(request.getParameter("eventState"))) {
            
            long lookupId = Long.parseLong(request.getParameter("eventState"));
            OptionLookup stateLookup = optionServiceWrapper.getValuesForId(lookupId, userGroupId);
            event.setState(stateLookup);
       }
        if (request.getParameter("startHrs") != null
				&& !"".equals(request.getParameter("startHrs"))) {
			event.setStartTime(request.getParameter("startHrs"));
		}

        if (request.getParameter("endHrs") != null
				&& !"".equals(request.getParameter("endHrs"))) {
			event.setEndTime(request.getParameter("endHrs"));
		}

        if (request.getParameter("eventType") != null
                && !"".equals(request.getParameter("eventType"))) {

            long lookupId = Long.parseLong(request.getParameter("eventType"));
            OptionLookup typeLookup = optionServiceWrapper.getValuesForId(lookupId, userGroupId);
            event.setEvent_type(typeLookup);

        }
		if (request.getParameter("eventOwner") != null
				&& !"".equals(request.getParameter("eventOwner"))) {
			event.setOwner(request.getParameter("eventOwner"));
		}
        if (request.getParameter("eventTa") != null
                && !"".equals(request.getParameter("eventTa"))) {

            long lookupId = Long.parseLong(request.getParameter("eventTa"));
            OptionLookup TALookup = optionServiceWrapper.getValuesForId(lookupId, userGroupId);
            event.setTa(TALookup);

        }
        if (request.getParameter("eventTherapyId") != null
                && !"".equals(request.getParameter("eventTherapyId"))) {

            long lookupId = Long.parseLong(request.getParameter("eventTherapyId"));
            OptionLookup therapyLookup = optionServiceWrapper.getValuesForId(lookupId, userGroupId);
            event.setTherapy(therapyLookup);
       }
        if(request.getParameter("approvalDate") != null &&
                !"".equals(request.getParameter("approvalDate"))) {
        	SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
            event.setApprovaldate(sdf.parse(request.getParameter("approvalDate")));

        }
        
        if(request.getParameter("endDate") != null &&
                !"".equals(request.getParameter("endDate"))) {
            SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
            event.setEndDate(sdf.parse(request.getParameter("endDate")));

        }
        
        if(request.getParameter("fundingAmount") != null &&
                !"".equals(request.getParameter("fundingAmount"))) {
        	event.setFundingAmount(request.getParameter("fundingAmount"));

        }
        
        if(request.getParameter("status") != null &&
                !"".equals(request.getParameter("status"))) {
            event.setStatus(request.getParameter("status"));

        }
        if(request.getParameter("reviewDate") != null &&
                !"".equals(request.getParameter("reviewDate"))) {
        	SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
            event.setReviewdate(sdf.parse(request.getParameter("reviewDate")));

        }
		if (request.getParameter("eventDescription") != null
				&& !"".equals(request.getParameter("eventDescription"))) {
			event.setDescription((request.getParameter("eventDescription")).trim());
			
		}
		if (request.getParameterValues("invitedOl") != null
				&& !"".equals(request.getParameterValues("invitedOl"))) {
			String invitedOls[] = request.getParameterValues("invitedOl");
			StringBuffer invitedOlBuff = new StringBuffer();
			if (invitedOls != null && invitedOls.length > 0) {
				for (int i = 0; i < invitedOls.length; i++) {
					if (i == 0) {
						invitedOlBuff.append(invitedOls[i]);
					} else {
						invitedOlBuff.append(", ").append(invitedOls[i]);
					}
				}
			}
			event.setInvitedol(invitedOlBuff.toString());
		}
        if(request.getParameterValues("approvers") != null &&
                !"".equals(request.getParameterValues("approvers"))) {
            String approvers[] = request.getParameterValues("approvers");
            StringBuffer approversBuff = new StringBuffer();
            if(approvers != null && approvers.length>0) {
                for(int i=0;i<approvers.length;i++) {
                    if(i==0) {
                        approversBuff.append(approvers[i]);
                    } else {
                        approversBuff.append("@").append(approvers[i]);
                    }
                }
            }
            event.setApprovers(approversBuff.toString());
        }
		if (null != request.getParameter("staffId")
				&& !"".equals(request.getParameter("staffId"))) {
			event.setStaffids(request.getParameter("staffId"));
		}
		event.setCreatetime(new Date(System.currentTimeMillis()));
		event.setUpdatetime(new Date(System.currentTimeMillis()));
		event.setDeleteflag("N");
		return event;
	}
    IUserService searchUserService;
    IGroupService userGroupsService;
    IOptionService optionService;
    IUserGroupMapService userGroupMapService;
    IOptionServiceWrapper optionServiceWrapper;
    IContactsService contactsService;
    

    public IContactsService getContactsService() {
        return contactsService;
    }

    public void setContactsService(IContactsService contactsService) {
        this.contactsService = contactsService;
    }

    public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

    public IUserGroupMapService getUserGroupMapService() {
        return userGroupMapService;
    }

    public void setUserGroupMapService(IUserGroupMapService userGroupMapService) {
        this.userGroupMapService = userGroupMapService;
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

    public IGroupService getUserGroupsService() {
        return userGroupsService;
    }

    public void setUserGroupsService(IGroupService userGroupsService) {
        this.userGroupsService = userGroupsService;
    }

}
