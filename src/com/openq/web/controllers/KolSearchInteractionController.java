package com.openq.web.controllers;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.attendee.IAttendeeService;
import com.openq.audit.IDataAuditService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.scripts.organization.IOrgService;
import com.openq.interaction.IInteractionService;
import com.openq.interactionData.IInteractionDataService;
import com.openq.kol.InteractionsDTO;
import com.openq.kol.InteractionsManager;
import com.openq.kol.KOLManager;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.EventNotificationMailSender;
import com.openq.utils.PlanNotificationEmail;
import com.openq.web.ActionKeys;

/**
 *
 * User: abhrap
 * Date: Oct 17, 2006
 * Time: 10:36:00 AM
 */
public class KolSearchInteractionController extends AbstractController {
     IOptionService options;

    IDataAuditService dataAuditService;
   
    protected ModelAndView handleRequestInternal(HttpServletRequest request,
                                                 HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
    	long userGroupId = -1;
    	if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString)){
    	 userGroupId = Long.parseLong(userGroupIdString);
    	}
        String action = (String) request.getParameter("action");
        request.setAttribute("go",request.getParameter("go"));
        request.setAttribute("kol_name", request.getParameter("kol_name"));
        request.setAttribute("kol_id", request.getParameter("kolId"));
    	String isSAXAJVUserString = (String) session.getAttribute(Constants.IS_SAXA_JV_GROUP_USER);
    	boolean isSAXAJVUser = false;
    	if(isSAXAJVUserString != null && "true".equals(isSAXAJVUserString)){
    			isSAXAJVUser = true;
    	}
    	
    	String isOTSUKAJVUserString = (String) session.getAttribute(Constants.IS_OTSUKA_JV_GROUP_USER);
    	boolean isOTSUKAJVUser = false;
    	if(isOTSUKAJVUserString != null && "true".equals(isOTSUKAJVUserString)){
    			isOTSUKAJVUser = true;
    	}
    	
        if(request.getParameter("kolId")!=null){
         session.setAttribute(Constants.CURRENT_KOL_ID, request.getParameter("kolId"));
        } 
        String userid = "";
        HashMap activityHash = new HashMap();
        if (request.getSession().getAttribute(Constants.CURRENT_USER) != null){
            userid =  (String)session.getAttribute(Constants.USER_ID);
            session.setAttribute("USER_ID",userid);
            KOLManager kolManager = new KOLManager();
            activityHash = kolManager.getMatchedTaFaRegion(Long.parseLong(userid));

        }
        String orgId = null ;
        if (null != session.getAttribute("ORGID")){
            orgId = (String)session.getAttribute("ORGID");
        }
        if (ActionKeys.PROFILE_INTERACTION.equalsIgnoreCase(action)) {
              String kolId = (String) session.getAttribute(Constants.INTERACTION_PROFILE_KOLID);
              if (orgId != null ){
                kolId = orgId;
              }
            if (null != kolId && !"".equals(kolId)) {
                List interactionSearchResults = interactionService.
                											getAllInteractionsByExpertId(Long.parseLong(kolId));
                  request.setAttribute("KOL_INTERACTIONS", interactionSearchResults);
            }
            String print = null != request.getParameter("prettyPrint") ? request.getParameter("prettyPrint") : null ;
            if ( (null != print && "true".equalsIgnoreCase(print)) || (null != print  &&  "false".equalsIgnoreCase(print)))
               return new ModelAndView("interactionPrint");
            else
            return new ModelAndView("kol_interactions");

        } else if (ActionKeys.SEARCH_INTERACTION.equalsIgnoreCase(action)) {
        	ModelAndView mav = new ModelAndView("search_interaction_main");
        	SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);

            session.setAttribute("CURRENT_LINK","INTERACTIONS");
            Date fromDate = null;
            if (null != request.getParameter("fromDate") &&
                    !"".equals(request.getParameter("fromDate"))) {
                fromDate = sdf.parse(request.getParameter("fromDate"));
            }
            Date toDate = null;
            if (null != request.getParameter("toDate") &&
                    !"".equals(request.getParameter("toDate"))) {
                toDate = sdf.parse(request.getParameter("toDate"));
            }
            String kolName = (String) request.getParameter("kolName");
            String productSelectedId = (String) request.getParameter("productLOV");
			String userName = (String) request.getParameter("userName");
            String searchStaffId = (String) request.getParameter("staffId");
            String searchUserId = (String) request.getParameter("userId");
           	boolean isJVUser =false ;
            if(isSAXAJVUser || isOTSUKAJVUser){
            	isJVUser=true;
            }
            
           	Map interactionSearchParameters = new HashMap();
            interactionSearchParameters.put("fromDate", request.getParameter("fromDate"));
           	interactionSearchParameters.put("toDate", request.getParameter("toDate"));
            interactionSearchParameters.put("kolName", kolName);
            interactionSearchParameters.put("productSelectedId", productSelectedId);
            interactionSearchParameters.put("userName", userName);
            interactionSearchParameters.put("searchStaffId", searchStaffId);
            interactionSearchParameters.put("searchUserId", searchUserId);
            interactionSearchParameters.put("isSAXAJVUser", new Boolean ( isSAXAJVUser ));
            interactionSearchParameters.put("isOTSUKAJVUser",new Boolean(isOTSUKAJVUser));
           	
           	long selectedUserID = searchUserId != null ? Long.parseLong(searchUserId) : 0;
           	long selectedProductId = productSelectedId != null ? Long.parseLong(productSelectedId) : 0;
           	
            List interactionSearchResults = interactionService
					.getInteractionResultsList(fromDate, toDate,
							selectedUserID, kolName, selectedProductId, isJVUser, 0);
            
           session.setAttribute("INTERACTION_SEARCH_RESULT", interactionSearchResults);
           session.setAttribute("INTERACTION_SEARCH_PARAMETER_MAP", interactionSearchParameters);
           
	       return mav;
        } else if (ActionKeys.ADD_DEV_PLAN.equalsIgnoreCase(action)) {

            InteractionsManager interactionsManager = new InteractionsManager();
            InteractionsDTO interactionDTO = new InteractionsDTO();

            interactionDTO.setActivity(request.getParameter("activity"));
            interactionDTO.setRole(request.getParameter("role"));
            interactionDTO.setStatus(request.getParameter("status"));
            interactionDTO.setTherapy(request.getParameter("therapy"));
            interactionDTO.setDueDate(request.getParameter("dueDate"));
            interactionDTO.setOwner(request.getParameter("owner"));
            interactionDTO.setStaffId(request.getParameter("staffId"));
            interactionDTO.setStaffId(request.getParameter("staffId"));
            interactionDTO.setComment(request.getParameter("comment"));




            int expertId = Integer.parseInt((String) session.getAttribute(Constants.CURRENT_KOL_ID));

            interactionDTO.setExpertId(expertId);
            interactionDTO.setUserId(Integer.parseInt(userid));

            User u = searchUserService.getUser(expertId);

            PlanNotificationEmail email = new PlanNotificationEmail();
            email.interactionsDTO = interactionDTO;
            email.activityHash = activityHash;
            email.u = u;
            sendMailToAttendee(email);

            boolean flag = new KOLManager().isExists(request.getParameter("activity"),expertId);
            if (!flag){
            interactionsManager.addDevPlan(interactionDTO);
            session.setAttribute("MESSAGE","Plan added successfully");
            }else{
                session.setAttribute("MESSAGE","Plan already exists");
            }
            session.setAttribute("DEV_PLANS_LIST", interactionsManager.getAllDevPlans(expertId));

            return new ModelAndView("development_plan");

        } else if (ActionKeys.DELETE_DEV_PLAN.equalsIgnoreCase(action)) {
            InteractionsManager interactionsManager = new InteractionsManager();
            String[] devPlanIds = null;
            if (request.getParameter("checkedDevPlanList") != null) {
                devPlanIds = request.getParameterValues("checkedDevPlanList");
            }
            if (null != devPlanIds && !"".equals(devPlanIds)) {
                interactionsManager.deleteDevPlan(devPlanIds);
            }
            int expertId = Integer.parseInt((String) session.getAttribute(Constants.CURRENT_KOL_ID));
            session.setAttribute("DEV_PLANS_LIST", interactionsManager.getAllDevPlans(expertId));
            session.setAttribute("MESSAGE","Plan(s) deleted successfully");
            return new ModelAndView("development_plan");

        } else if (ActionKeys.EDIT_DEV_PLAN.equalsIgnoreCase(action)) {
            if (request.getParameter("devPlanId") != null) {
                int expertId = Integer.parseInt((String) session.getAttribute(Constants.CURRENT_KOL_ID));
                String activity = request.getParameter("activity");
                String role = request.getParameter("role");
                String comments = request.getParameter("comments");
                session.setAttribute("MODE", "EDIT");
                
                int devPlanId = Integer.parseInt(request.getParameter("devPlanId"));
                InteractionsManager interactionsManager = new InteractionsManager();

                session.setAttribute("SEL_DEV_PLAN", interactionsManager.getDevPlanDetails(devPlanId));
                session.setAttribute("SEL_COMMENTS", comments);
                session.setAttribute("SEL_DEV_PLAN_ID", devPlanId + "");
                session.setAttribute("SEL_ACTIVITY_ID", activity + "");
                session.setAttribute("SEL_TITLE_ID",role+"");
                session.setAttribute("DEV_PLANS_LIST", interactionsManager.getAllDevPlans(expertId));
                session.setAttribute("DEV_PLANS_HISTORY_LIST", interactionsManager.getDevPlanHistory(devPlanId));

                return new ModelAndView("development_plan");
            }

        } else if (ActionKeys.UPDATE_DEV_PLAN.equalsIgnoreCase(action)) {
            if (request.getParameter("devPlanId") != null) {

                int devPlanId = Integer.parseInt((String) request.getParameter("devPlanId"));
                String activity = request.getParameter("activity");
                InteractionsManager interactionsManager = new InteractionsManager();
                  String role = null != request.getParameter("role") ? request.getParameter("role") : (String)session.getAttribute("SEL_TITLE_ID");

                InteractionsDTO interactionDTO = new InteractionsDTO();
                    interactionDTO.setActivity(request.getParameter("tactic"));
                    interactionDTO.setRole(role);
                    interactionDTO.setStatus(request.getParameter("status"));
                    interactionDTO.setTherapy(request.getParameter("therapy"));
                    interactionDTO.setDueDate(request.getParameter("dueDate"));
                    interactionDTO.setOwner(request.getParameter("owner"));
                    interactionDTO.setStaffId(request.getParameter("staffId"));
                    interactionDTO.setComment(request.getParameter("comment"));

                int expertId = Integer.parseInt((String) session.getAttribute(Constants.CURRENT_KOL_ID));
                interactionDTO.setExpertId(expertId);
                interactionDTO.setUserId(Integer.parseInt(userid));
                interactionsManager.updateDevPlan(devPlanId, interactionDTO);
                session.setAttribute("MESSAGE","Plan saved successfully");
                session.setAttribute("DEV_PLANS_LIST", interactionsManager.getAllDevPlans(expertId));
                return new ModelAndView("development_plan");

            }

        } else if (ActionKeys.DEV_PLAN_HOME.equalsIgnoreCase(action)) {

            session.setAttribute("PLAN_ROLE", optionServiceWrapper.getValuesForOptionName("Role", userGroupId));
            session.setAttribute("PLAN_STATUS", optionServiceWrapper.getValuesForOptionName("Status", userGroupId));
            session.setAttribute("PLAN_THERAPY", optionServiceWrapper.getValuesForOptionName("Therapy", userGroupId));

            KOLManager kolManager = new KOLManager();
            session.setAttribute("ACTIVITY",kolManager.getMatchedTaFaRegion(Long.parseLong(userid)));

            InteractionsManager interactionsManager = new InteractionsManager();
            String print = null != request.getParameter("prettyPrint") ? request.getParameter("prettyPrint") : null ;
            int expertId = Integer.parseInt((String) request.getSession().getAttribute(Constants.CURRENT_KOL_ID));
            session.setAttribute("EXPERT_ID", expertId + "");
            request.getSession().setAttribute("MODE", "ADD");
            request.getSession().setAttribute("DEV_PLANS_LIST", interactionsManager.getAllDevPlans(expertId));
            session.setAttribute("SUBLINK", "25");
           if ( (null != print && "true".equalsIgnoreCase(print)) || (null != print  &&  "false".equalsIgnoreCase(print)))
               return new ModelAndView("development_plan_list");
            else
             return new ModelAndView("development_plan");
        }
        return null;
    }

    IInteractionService interactionService;
    IAttendeeService attendeeService;
    IUserService searchUserService;
    IInteractionDataService interactionDataService;
    IOptionServiceWrapper optionServiceWrapper;
    IOrgService orgService;

    public IOrgService getOrgService() {
        return orgService;
    }

    public void setOrgService(IOrgService orgService) {
        this.orgService = orgService;
    }


    public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

    public IUserService getSearchUserService() {
        return searchUserService;
    }

    public void setSearchUserService(IUserService searchUserService) {
        this.searchUserService = searchUserService;
    }

    public IAttendeeService getAttendeeService() {
        return attendeeService;
    }

    public void setAttendeeService(IAttendeeService attendeeService) {
        this.attendeeService = attendeeService;
    }

    public IInteractionService getInteractionService() {
        return interactionService;
    }

    public void setInteractionService(IInteractionService interactionService) {
        this.interactionService = interactionService;
    }

    public IOptionService getOptions() {
        return options;
    }

    public void setOptions(IOptionService options) {
        this.options = options;
    }


    public void sendMailToAttendee(PlanNotificationEmail email ) {
            String htmlString = email.returnCompleteHTMLString();
            EventNotificationMailSender.getInstance().send(htmlString);
    }

	public IInteractionDataService getInteractionDataService() {
		return interactionDataService;
	}

	public void setInteractionDataService(
			IInteractionDataService interactionDataService) {
		this.interactionDataService = interactionDataService;
	}

    public IDataAuditService getDataAuditService() {
        return dataAuditService;
    }

    public void setDataAuditService(IDataAuditService dataAuditService) {
        this.dataAuditService = dataAuditService;
    }
}
