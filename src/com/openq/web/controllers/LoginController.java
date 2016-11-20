package com.openq.web.controllers;

import java.util.Iterator;
import java.util.Properties;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authentication.AuthenticationServiceProvider;
import com.openq.authentication.UserDetails;
import com.openq.authorization.IFeatureAccessService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.option.OptionService;
import com.openq.encription.IEncryptPasswordService;
import com.openq.group.Groups;
import com.openq.group.IGroupService;
import com.openq.group.IUserGroupMapService;
import com.openq.interactionData.IUserRelationshipService;
import com.openq.interactionData.UserRelationship;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.PropertyReader;


public class LoginController extends AbstractController {


    private static Logger logger = Logger.getLogger(LoginController.class);
    private IEncryptPasswordService encryptPasswordService;
    IUserService userService;
    IOptionService optionService;
    IUserRelationshipService userRelationshipService;

    public IEncryptPasswordService getEncryptPwdService() {
		return encryptPasswordService;
	}

	public void setEncryptPwdService(IEncryptPasswordService encryptPwdService) {
		this.encryptPasswordService = encryptPwdService;
	}

	public ModelAndView handleRequestInternal(HttpServletRequest request,
                                              HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("login");
        HttpSession session = request.getSession(true);
        // Get the access permissions for all features and set them in the session
        session.removeAttribute("myOL");
        Properties featureAccessProps = featureAccessService.getFeatureAccessDetails();
        Iterator iter = featureAccessProps.keySet().iterator();
        while(iter.hasNext()) {
            String propKey = (String) iter.next();
            Object propValue = featureAccessProps.getProperty(propKey);
            session.setAttribute(propKey, propValue);
            logger.info("Features related property : " + propKey + " has value = " + propValue);
        }

        /*** Site minder code */
        Cookie[] cookies = request.getCookies();
        boolean siteMinderAuth = false;
        boolean allowAdminLoginOnly = false;
        String siteMinderUserName = "";
        if ( cookies != null && cookies.length > 0) {
            for (int i = 0; i < cookies.length; i++) {
                if (cookies[i].getName().trim().equalsIgnoreCase("sm_user")) {
                    if(!(request.getServletPath().equalsIgnoreCase("/login.htm"))){
                        siteMinderUserName = cookies[i].getValue();
                        siteMinderAuth = true;
                    }else{
                        allowAdminLoginOnly = true;
                    }
                    break;
                }
            }
        }

        /****/
        String action = request.getParameter("action");
        if (action != null && action.equals("logout")) {
            session.invalidate();
            //response.sendRedirect(httpsUrl);
            return mav;
        }

        String name = request.getParameter("userName");
        String userInputPassword = request.getParameter("userPassword");
        if(!siteMinderAuth && name == null && userInputPassword == null) {
        	 mav.addObject("status", "Login unsuccessful");
        	 return mav;
        }
        if (siteMinderAuth||(name != null && !name.equals("") && userInputPassword != null && !userInputPassword.equals(""))) {

            UserDetails user = null;

        	if(siteMinderAuth){
        		user = getUserDetails(siteMinderUserName, "","", mav,siteMinderAuth);
        	    name=siteMinderUserName;
        	    userInputPassword="";
        	}else{
        	    String encryptedPassword = encryptPasswordService.encryptPassword(userInputPassword);
        	 	user = getUserDetails(name, encryptedPassword,userInputPassword, mav,siteMinderAuth);
        	}
            if (user != null) {
            	String staffId = null;
            	if(null != user.getStaffId() && 
            			!"".equals(user.getStaffId())){
            		staffId = user.getStaffId().trim();
            	}
                String userId = user.getId();
                String functionalAreaVal = getGroupFunctionlArea(userId);
                String taFaRegionIds = getTaFaRegion(userId);

                if(taFaRegionIds != null && !"".equals(taFaRegionIds)){
                	String[] taFaRegionArray = taFaRegionIds.split("_");
                	if(taFaRegionArray != null && taFaRegionArray.length > 0 && taFaRegionArray[0] != null)
                		session.setAttribute(Constants.CURRENT_USER_TA, taFaRegionArray[0]);
                }
                long groupId = userGroupMapService.getGroupIdForUser(Long.parseLong(userId));
                session.setAttribute("TA_Fa_Region",taFaRegionIds);
                session.setAttribute(Constants.GROUP_FUNCTIONAL_AREA,functionalAreaVal);
                session.setAttribute(Constants.CURRENT_USER, user);
                session.setAttribute(Constants.COMPLETE_USER_NAME, user.getCompleteName());
                session.setAttribute(Constants.USER_ID ,user.getId());
                session.setAttribute(Constants.USER_TYPE , user.getUserType());
                session.setAttribute(Constants.CURRENT_STAFF_ID, staffId);
                session.setAttribute(Constants.CURRENT_KOL_ID, "-1");
                session.setAttribute(Constants.CURRENT_KOL_ID_SET, "NONE");
                session.setAttribute(Constants.CURRENT_USER_GROUP, groupId+"");
                
                final String currentUserTAs = getCurrentUserTAs(groupId); 

                session.setAttribute(Constants.CURRENT_USER_TAS, currentUserTAs );
                // set the SAXA_JV groupId in session
                Groups SAXAJVGroup = groupService.getGroupByName(Constants.SAXA_JV_GROUP_NAME);
                if(SAXAJVGroup != null){
                	if(groupId == SAXAJVGroup.getGroupId()){
                		session.setAttribute(Constants.IS_SAXA_JV_GROUP_USER, "true");
                	}else{
                		session.setAttribute(Constants.IS_SAXA_JV_GROUP_USER, "false");
                	}
                }
                // set the SAXA_JV groupId in session
                Groups OTSUKAJVGroup = groupService.getGroupByName(Constants.OTSUKA_JV_GROUP_NAME);
                if(OTSUKAJVGroup != null){
                	if(groupId == OTSUKAJVGroup.getGroupId()){
                		session.setAttribute(Constants.IS_OTSUKA_JV_GROUP_USER, "true");
                	}else{
                		session.setAttribute(Constants.IS_OTSUKA_JV_GROUP_USER, "false");
                	}
                }
               
                // information required for tagging interactions and also running reports

                UserRelationship currentUserRelationship = userRelationshipService.getUserRelationShip(Long.parseLong(userId));
                session.setAttribute(Constants.CURRENT_USER_RELATIONSHIP, currentUserRelationship);

                if (user.getUserType().getId() == Constants.ADMIN_USER_TYPE) {
                	session.setAttribute("disclaimer","true");
                	response.sendRedirect("admin.htm");
                    return mav;
                } else if (user.getUserType().getId() == Constants.EXPERT_USER_TYPE ) {
                    session.setAttribute(Constants.CURRENT_USER, user);
                    session.setAttribute(Constants.COMPLETE_USER_NAME, user.getCompleteName());
                    session.setAttribute(Constants.USER_ID ,user.getId());
                    session.setAttribute(Constants.USER_TYPE , user.getUserType());
                    session.setAttribute(Constants.CURRENT_STAFF_ID, staffId);
                    session.setAttribute(Constants.CURRENT_KOL_ID,user.getKolId());
                    session.setAttribute(Constants.CURRENT_KOL_ID_SET, "YES");
                    response.sendRedirect("experthome.htm");
                    return mav;
               } else if( siteMinderAuth || !allowAdminLoginOnly ){
                	session.setAttribute("disclaimer","true");
                    session.setAttribute(Constants.CURRENT_USER, user);
                    session.setAttribute(Constants.COMPLETE_USER_NAME, user.getCompleteName());
                    session.setAttribute(Constants.USER_ID ,user.getId());
                    session.setAttribute(Constants.USER_TYPE , user.getUserType());
                    session.setAttribute(Constants.CURRENT_STAFF_ID, staffId);
                    response.sendRedirect("home.htm");
                    return mav;
               }


            } else {
                if (mav.getModel().get("status") == null)
                    mav.addObject("status", "Login unsuccessful");
            }
        }
        else
        {
            mav.addObject("status", "Login unsuccessful");
        }

        return mav;
    }
    IGroupService groupService;
    IUserGroupMapService userGroupMapService;
    IFeatureAccessService featureAccessService;

    public IFeatureAccessService getFeatureAccessService() {
        return featureAccessService;
    }

    public void setFeatureAccessService(IFeatureAccessService featureAccessService) {
        this.featureAccessService = featureAccessService;
    }

    public IUserGroupMapService getUserGroupMapService() {
        return userGroupMapService;
    }

    public void setUserGroupMapService(IUserGroupMapService userGroupMapService) {
        this.userGroupMapService = userGroupMapService;
    }

    public IGroupService getGroupService() {
        return groupService;
    }

    public void setGroupService(IGroupService groupService) {
        this.groupService = groupService;
    }

     public String getGroupFunctionlArea(String userId){
            if(userId !=null && userId.length() >0){
                long luserId      = Long.parseLong(userId);
                long groupId      = userGroupMapService.getGroupIdForUser(luserId);

                if(groupId != -1){
                Groups groupDetail = groupService.getGroup(groupId);
                if(groupDetail != null){
                String functionalAreaId = groupDetail.getFunctionalArea();
                if(functionalAreaId != null && functionalAreaId.length() > 0){
                    long faID = Long.parseLong(functionalAreaId);
                    OptionLookup optionLookup = optionService.getOptionLookup(faID,groupId);
                    String functionalAreaValue = optionLookup.getOptValue();
                    return functionalAreaValue;
                  }
                }
              }
            }
        return "";
    }
  public String getTaFaRegion(String userId){
        long groupId      = userGroupMapService.getGroupIdForUser(Long.parseLong(userId));
            String taId = "";
            String faId = "";
            String regionId = "";
            if(groupId != -1){
              Groups groupDetail = groupService.getGroup(groupId);
               if(groupDetail != null){
                  taId = groupDetail.getTherupticArea();
                  faId = groupDetail.getFunctionalArea();
                  regionId = groupDetail.getRegion();
               }
            }
      return taId+"_"+faId+"_"+regionId;
  }
    private UserDetails getUserDetails(String name, String encryptedPassword,String password, ModelAndView mav, boolean siteMinderAuth) {
    	User user = null;
        if(siteMinderAuth)
        {
          System.out.println("SiteMinder auth getdetails");
          user = userService.getUserByUserName(name);
          password="";
          if(user==null)
        	  System.out.println("user is null");
        }
        else
        	user = userService.getUser(name, encryptedPassword);

        if (user != null && !password.equals("dummypassword")) {
            UserDetails uDetails = new UserDetails();
            uDetails.setCompleteName(user.getLastName() + ", "  + user.getFirstName());
            uDetails.setStaffId(user.getStaffid());
            uDetails.setId(user.getId() + "");
            uDetails.setUserType(user.getUserType());
            uDetails.setUserName(name);
            uDetails.setEmail(user.getEmail());
            uDetails.setTelephoneNumber(user.getPhone());
            uDetails.setKolId(user.getKolid()+"");
            return uDetails;
        }
        return null;
        /*else {
            try {
                UserDetails details = authenticationServiceProvider.getIAuthenticationService().authenticate(name, encryptedPassword);
                if (details != null) {
                    // user not in database but exists in LDAP
                    // create a user in our db
                    User u = userService.userExist(name, details.getStaffId());
                    if(u == null){
                        return null;
                    }

                    details.setUserType(u.getUserType());
                    details.setId(u.getId() + "");
                }
                return details;
            } catch (Exception e) {
                e.printStackTrace();
                mav.addObject("status", "LDAP service not available");
                return null;
            }
        }*/

        /*if (name.equals("admin") && password.equals("admin")) {
              UserDetails user = new UserDetails();
              user.setCompleteName("Administrator");
              user.setStaffId("67402");
              return user;
          } else if (name.equals("jmagdlen") && password.equals("jmagdlen")) {
              UserDetails user = new UserDetails();
              user.setCompleteName("Magdlen, James");
              user.setStaffId("67402");
              user.setId("1");
              return user;
          } else {
              return ldapService.authenticate(name, password);
          }*/
    }


    

    /**
	 * @return the userRelationshipService
	 */
	public IUserRelationshipService getUserRelationshipService() {
		return userRelationshipService;
	}

	/**
	 * @param userRelationshipService the userRelationshipService to set
	 */
	public void setUserRelationshipService(
			IUserRelationshipService userRelationshipService) {
		this.userRelationshipService = userRelationshipService;
	}

	public IOptionService getOptionService() {
        return optionService;
    }

    public void setOptionService(IOptionService optionService) {
        this.optionService = optionService;
    }

    AuthenticationServiceProvider authenticationServiceProvider;
    public AuthenticationServiceProvider getLdapAuthenticationService() {
        return authenticationServiceProvider;
    }

    public void setAuthenticationServiceProvider(AuthenticationServiceProvider authenticationServiceProvider) {
        this.authenticationServiceProvider = authenticationServiceProvider;
    }

    public IUserService getUserService() {
        return userService;
    }

    public void setUserService(IUserService userService) {
        this.userService = userService;
    }

	public IEncryptPasswordService getEncryptPasswordService() {
		return encryptPasswordService;
	}

	public void setEncryptPasswordService(
			IEncryptPasswordService encryptPasswordService) {
		this.encryptPasswordService = encryptPasswordService;
	}
	
	private String getCurrentUserTAs(final long userGroupId){
		
		StringBuffer userTAsBuffer = new StringBuffer("-1");
		
		final OptionLookup [] userTAsList = optionService.getValuesForOption(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId);
		
		for(int i=0; i < userTAsList.length; i++){			
			userTAsBuffer.append(",").append(userTAsList[i].getId());					
		}		
		return userTAsBuffer.toString();
	}
}
