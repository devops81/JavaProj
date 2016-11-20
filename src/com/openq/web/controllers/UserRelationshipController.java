/*
 * Author              : Raghavan
 * Created Date        : 2/16/2008
 * Last Change Made by : Raghavan
 * Last Change Made on : 7/16/2008
 *  
 *  This controller is used for the user relationship feature of OpenQ.This controller retrieves the user 
 *  and related user details from the user relationship table and it is used to update or add the details of any user.
 * 
 */


package com.openq.web.controllers;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.eav.option.OptionService;
import com.openq.interactionData.IUserRelationshipService;
import com.openq.interactionData.UserRelationship;
import com.openq.kol.DBUtil;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.PropertyReader;


public class UserRelationshipController extends AbstractController{
	
	IUserRelationshipService  userRelationshipService;
	IOptionServiceWrapper optionServiceWrapper;
	IUserService userService;
	public static Logger logger = Logger.getLogger(UserRelationshipController.class);//to maintain log records
	
	final String DEFAULT_FILTER_CURRENT = "Current Only";
    final String DEFAULT_FILTER_ALL = "All";
    private static final String ENDDATE = "contact.endDate";
	private static final String PROPERTIES_FILE = "resources/ServerConfig.properties";
	SimpleDateFormat sdf=new SimpleDateFormat("dd-MMM-yyyy");//the date format for UI and backend
	SimpleDateFormat sdfForCalendar = new SimpleDateFormat("MM/dd/yyyy");//the date format for calendar widget
	
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
		
		request.getSession().removeAttribute("FILTER_PARAM_USERRELATIONSHIP");
		request.getSession().removeAttribute("MESSAGE");
		request.getSession().setAttribute("CURRENT_LINK","userRelationship");
		request.getSession().setAttribute("REPORT_PRIVILEGE_TYPE",
		optionServiceWrapper.getValuesForOptionName("REPORTPRIVILEGE", userGroupId));//for relationshipType
		String optionList = PropertyReader
		.getLOVConstantValueFor("TERRITORY_LOVS");
		request.getSession().setAttribute("Territories", optionServiceWrapper.getAllOptions(optionList, userGroupId));
		
		ModelAndView mav = new ModelAndView("userRelationship");
		String action=(String)request.getParameter("action");
		String name=(String)request.getParameter("name");	
		String filterParam = null;			//UserRelationship Form input parameter for effective date filtering
        filterParam = (String) request.getParameter("filterRadio");
        request.getSession().setAttribute("FILTER_PARAM_USERRELATIONSHIP", filterParam);
        Properties properties = DBUtil.getInstance().getDataFromPropertiesFile(PROPERTIES_FILE);
        request.getSession().setAttribute("firstTime", "yes");

    
        if(action !=null && action.equals("relateduser")){
		
        	/*
        	 * To get the related users details for the given user.	
        	 * 
        	 */
        	logger.info("inside related user action");
			request.getSession().removeAttribute("USERS");		
			request.getSession().removeAttribute("MESSAGE");
			request.getSession().removeAttribute("USER_RELATION");
			String staffId =(String) request.getParameter("staffid");
			request.getSession().removeAttribute("user");
			request.getSession().removeAttribute("Supervisor");
			request.getSession().removeAttribute("userRelationship");
			request.getSession().removeAttribute("Territory");
			request.getSession().setAttribute("REDISPLAY_STAFFID", staffId);
			request.getSession().setAttribute("MESSAGE", "No result found");
	        request.getSession().setAttribute("USERNAME", name);
	        if(staffId !=null && !staffId.equals(""))
				
				logger.info("Staff id  Not Null");	
	        	User userForStaffId = userService.getUserByStaffId(staffId);
	        	UserRelationship userRelationship = null;
	        	  
	        		if(userForStaffId !=null)
	        			//logger.info("test user name"+userForStaffId[0].getFirstName());
	        			 userRelationship= userRelationshipService.getUserRelationShip(userForStaffId.getId());
	        		User supervisor = null;
	        		if(userRelationship!=null)
	        		{
	        			if(userRelationship.getSupervisorId()!= null &&  !"-1".equalsIgnoreCase(userRelationship.getSupervisorId()) && !"".equalsIgnoreCase(userRelationship.getSupervisorId()))
	        		 supervisor = userService.getUser(Long.parseLong(userRelationship.getSupervisorId()));
	        			request.getSession().setAttribute("User", userForStaffId);
	        		request.getSession().setAttribute("Supervisor", supervisor);
	        		if(userRelationship.getTerritory() != null && !"".equalsIgnoreCase(userRelationship.getTerritory()))
	        			request.getSession().setAttribute("Territory", optionServiceWrapper.getOptionLookup(Long.parseLong(userRelationship.getTerritory())));
	        		request.getSession().setAttribute("userRelationship",userRelationship);
	        		}
	        			
			//return getRelatedUser(request,filterParam,staffId,mav);//fetches the related_user details from the database. 
	        		request.getSession().removeAttribute("firstTime");
   		    
		}

		
        if(action !=null && action.equals("resetPage")){
        	
        	/*
        	 * To reset the page contents
        	 * 
        	 */
			logger.info("page reset");
			request.getSession().removeAttribute("USERS");
			request.getSession().removeAttribute("STAFFID");		
			request.getSession().removeAttribute("MESSAGE");
			request.getSession().removeAttribute("USER_RELATION");
			request.getSession().removeAttribute("name");	
			request.getSession().removeAttribute("FILTER_PARAM_USERRELATIONSHIP");
			request.getSession().removeAttribute("user");
			request.getSession().removeAttribute("Supervisor");
			request.getSession().removeAttribute("userRelationship");
			request.getSession().removeAttribute("Territory");
			request.getSession().removeAttribute("REDISPLAY_STAFFID");
			request.getSession().removeAttribute("firstTime");
			request.getSession().removeAttribute("USERNAME");
			
		}
		
		
		if(action !=null && (action.equals("saveuser") || action.equals("addUser")))
		{
		 	
			/*
			 * To compare the old and new values passed from the form and make a decision,
			 * 			whether to save or update the records.
			 * 
			 */
			
			
			ArrayList newValues = new ArrayList();//to pass the new values obtained from the userRelationship form
			String userIdPassed=request.getParameter("hiddenUserId");
			long privilegeType=Long.parseLong(request.getParameter("hiddenReportPrivilegeId"));
			String supervisorUserIdPassed=request.getParameter("hiddenSupervisorId");
			String territoryIdPassed=request.getParameter("hiddenTerritoryId");
			Date endDate=parseDate((String)request.getParameter("end"));
			Date beginDate = parseDate((String)request.getParameter("begin"));
			String userId="-1",relatedUserId="-1",territoryId="-1";
			User user = userService.getUserByStaffId(userIdPassed);
			User relatedUser = null;
			if(supervisorUserIdPassed != null && !"-1".equalsIgnoreCase(supervisorUserIdPassed) )
		     relatedUser = userService.getUserByStaffId(supervisorUserIdPassed);	
		    
		    //User[] territory =  userService.getUserByStaffId(territoryIdPassed);	
		    logger.debug("useridpassed="+userIdPassed);
		    if(user!=null)
		    userId=user.getId()+"";
		    if(relatedUser!=null)
		    relatedUserId=relatedUser.getId()+"";
		    //territoryId = "-1";
		    /*OptionLookup optionLookup = null; 
		     if(territoryIdPassed != null)
		    	optionLookup = optionServiceWrapper.getOptionForOptionValue(territoryIdPassed);
		   */
		    //optionLookup = optionServiceWrapper.getOptionLookup(Long.parseLong(territoryIdPassed));
		    OptionLookup optionId=optionServiceWrapper.getValuesForId(privilegeType, userGroupId);
		    long reportLevel = Long.parseLong(optionId.getOptValue());
		    if(territoryIdPassed != null && !"".equalsIgnoreCase(territoryIdPassed)){
		       if(reportLevel == 2)
		    	territoryId = optionServiceWrapper.getIdForOptionValueAndParentName(territoryIdPassed, "RAD")+"";
		       if(reportLevel == 1)
		    	   territoryId = optionServiceWrapper.getIdForOptionValueAndParentName(territoryIdPassed, "Territory")+"";
		       if(reportLevel == 3)
		    	   territoryId = optionServiceWrapper.getIdForOptionValueAndParentName(territoryIdPassed, "Therapeutic Area")+"";
		       if(reportLevel == 4)
		    		territoryId = optionServiceWrapper.getIdForOptionValueAndParentName(territoryIdPassed, "HeadQuarters")+"";
		    }
		    OptionLookup optionLookup=null;
		    if(null!=territoryId && !"".equalsIgnoreCase(territoryId)){
		    	optionLookup = optionServiceWrapper.getOptionLookup(Long.parseLong(territoryId));
		    }
		    logger.info("userId="+userId);
		    logger.info("related user id="+relatedUserId);
		    logger.info("territoryId="+territoryId);
	        
	        //privilegeType = Long.parseLong(optionId.getOptValue());
	        if(user!=null && relatedUser!=null){
	        UserRelationship userRelationship = userRelationshipService.getUserRelationShip(user.getId());
	        if(userRelationship == null){
	        	userRelationship = new UserRelationship();
	        	userRelationship.setUserId(userId);
	        	userRelationship.setSupervisorId(relatedUserId);
	        	userRelationship.setReportLevel(reportLevel+"");
	        	userRelationship.setTerritory(territoryId);
	        	userRelationship.setBeginDate(beginDate);
	        	userRelationship.setEndDate(endDate);
	        	userRelationshipService.saveUserrelation(userRelationship);
	        }
	        else
	        {
	        	userRelationship.setUserId(userId);
	        	userRelationship.setSupervisorId(relatedUserId);
	        	userRelationship.setReportLevel(reportLevel+"");
	        	userRelationship.setTerritory(territoryId);
	        	userRelationship.setBeginDate(beginDate);
	        	userRelationship.setEndDate(endDate);
	        	userRelationshipService.updateUserrelation(userRelationship); 
	        	
	        }

	        request.getSession().removeAttribute("user");
			request.getSession().removeAttribute("Supervisor");
			request.getSession().removeAttribute("userRelationship");
			request.getSession().removeAttribute("Territory");
		    request.getSession().setAttribute("userRelationship", userRelationship);
		    request.getSession().setAttribute("User", user);
       		request.getSession().setAttribute("Supervisor", relatedUser);
       		request.getSession().setAttribute("Territory", optionLookup);
       		
       		request.getSession().removeAttribute("firstTime");
		       
	        }
	       
	        
            /*logger.info("inside save user action");

            ArrayList oldNewValues = null;
            oldNewValues = getValues(request, userGroupId);//to get the old and existing values from the userRelationship form
            
            if(saveUserRelation !=null&& oldNewValues.get(10) !=null && oldNewValues.get(11) !=null)
		    {
		    	if(!(request.getParameter("userIdValue").equalsIgnoreCase("0")))//to confirm userid is present
		    	{
		    		 long staffId = (request.getParameter("userIdValue")!= null) 
		    		 				?Long.parseLong(request.getParameter("userIdValue")) 
		    		 				: 0;
			          
			           //To compare the old with existing values and make a decision whether to save or update
			           compareValues(oldNewValues,staffId,saveUserRelation,request,properties);			           
			                
		    	}
		    }
		    
		    //Redisplay the details
		    String persistStaffId =(String) request.getSession()
		    				.getAttribute("REDISPLAY_STAFFID");//to take staffid back to the userRelationship form
		    request.getSession().setAttribute("USERNAME", name);

		    mav=getRelatedUser(request,filterParam,persistStaffId,mav);*/
		    
		}
		return mav;
	}
		 
		 /* if(action !=null && action.equals("addUser")){
			 /*
			  *To add new related user details directly from the UI. 
			  * 
			  */
			/*  
			logger.info("inside add_user");
		 	UserRelationship saveUserRelation=new UserRelationship();
			String userIdPassed=request.getParameter("hiddenUserId");
			long privilegeType=Long.parseLong(request.getParameter("hiddenReportPrivilegeId"));
			String relatedUserIdPassed=request.getParameter("hiddenSupervisorId");
			String territoryIdPassed = ((String)request.getParameter("hiddenTerritoryId") != null) 
									   ?  request.getParameter("hiddenTerritoryId") 
									   : null;
			Date beginDate=parseDate(request.getParameter("begin"));
			Date endDate=parseDate(request.getParameter("end"));
			String userId="",relatedUserId="",territoryId="";
			User[] user = (User[])userService.getUserForStaffId(userIdPassed);
		    User[] relatedUser = (User[])userService.getUserForStaffId(relatedUserIdPassed);
		    User[] territory = (territoryIdPassed != null) ? 
		    		(User[])userService.getUserForStaffId(territoryIdPassed) : null ;
		    
		    userId=assignId(user, userIdPassed);		    	    
		    relatedUserId=assignId(relatedUser, relatedUserIdPassed);
	        if(territoryIdPassed != null){
	        	 territoryId=assignId(territory, territoryIdPassed);
	         }
            OptionLookup optionId=optionServiceWrapper.getValuesForId(privilegeType, userGroupId);	    
		    if(saveUserRelation !=null&& userIdPassed !=null && relatedUserIdPassed !=null){
		    	if(territoryIdPassed == null){
				    	territoryId = null;
				    }				    	
 		    setUserRelationship(saveUserRelation,territoryId,userId,relatedUserId,
		    			optionId,beginDate,endDate);
		    
			   
 		   saveOrUpdateUserRelationship(saveUserRelation,request,"save");//Save in the database
 		   }
		   request.getSession().removeAttribute("USERNAME");
		    return mav;
		}
		 request.getSession().removeAttribute("USERNAME");
		   return mav;
	}

	
	/*
	 * For a given a userid gets the user and related user details.
	 * 
	 * Created By          : Raghavan
	 * Created Date        : 7/16/2008
	 * Last Change Made by : Raghavan
	 * Last Change Made on : 7/16/2008
	 * 
	 * @request
	 * @filterParam - the current/all records filter
	 * @staffId
	 */
	private ModelAndView getRelatedUser(HttpServletRequest request,String filterParam,
			String staffId,ModelAndView mav)throws Exception{
		/*
		 * The staffid passed as parameter is used to get the user details through 
		 *					 the UserRelationshipService and the details are set out in session attributes.
		 * 
		 */
		
		if(staffId !=null && !staffId.equals("")){
			
			logger.info("Staff id  Not Null");	
        	User userForStaffId = userService.getUserByStaffId(staffId);
        	
        	  
        		if(userForStaffId !=null){
        			//logger.info("test user name"+userForStaffId[0].getFirstName());
        			UserRelationship userRelationship= userRelationshipService.getUserRelationShip(userForStaffId.getId());
			    										
        	/*		User[] userDetails = new User[userRelation.length];
        			User[] relatedUserDetails = new User[userRelation.length];
        			User[] territoryDetails = new User[userRelation.length];
        			User user=null;
        			User relatedUser=null;
        			User territory=null;
        			ArrayList rowWiseUserRelationships = new ArrayList();	
        			Map userRelationshipDetails = new HashMap();
					if(userRelation !=null && userRelation.length>0){
        					logger.info("getting userRelation id="+userRelation.length);
        						for(int i=0;i<userRelation.length;i++) {
        							rowWiseUserRelationships = new ArrayList();	
        							user=userService.getLightWeightOLForId(userRelation[i].getUserId());
        								relatedUser=userService.getLightWeightOLForId(userRelation[i].getSupervisorId());
        								String checkTerritory=userRelation[i].getTerritory();
        								territory=(checkTerritory !=null) 
        										? userService.getLightWeightOLForId(checkTerritory) : null; 
        										if(user !=null && relatedUser!=null){
        											userDetails[i]=user;
        											rowWiseUserRelationships.add(user);
        											relatedUserDetails[i]=relatedUser; 
        											rowWiseUserRelationships.add(relatedUser);
        											territoryDetails[i]=territory;
        											rowWiseUserRelationships.add(territory);
        											
        											System.out.println("date b4 parsing="+userRelation[i].getBeginDate());
        											rowWiseUserRelationships.add(userRelation[i]);
        										}
        						userRelationshipDetails.put(i+"",rowWiseUserRelationships);
        						}           		      
        					mav.addObject("USER_RELATIONSHIP_DETAILS",userRelationshipDetails );//to test jstl
        					request.getSession().setAttribute("USER_RELATION", userRelation);
			            }
					logger.info("Users retrieved");					
        		}
        		else
				{
					logger.info("Search Results: Users Returned Null");
					request.getSession().setAttribute("MESSAGE", "No result found");
				}*/
		}	
		}
		return mav;
	}

	
	
	/*
	 * Parses the date,in which a string is passed as parameter and returns a date.
	 * 
	 * Created By          : Raghavan
	 * Created Date        : 7/16/2008
	 * Last Change Made by : Raghavan
	 * Last Change Made on : 7/16/2008
	 * 
	 * 
	 * @dateToParse - a String which is to be converted into Date
	 * 
	 */
	private Date parseDate(String dateToParse)throws Exception{		
		/*
		 *  parseException may be thrown 
		 * 				as the calendar date format and display date format are different.
		 */
		System.out.println("inside parsing="+dateToParse);
		Date parsedDate=null;
		try
		{
			parsedDate=sdf.parse(dateToParse);//@sdf - (dd-MMM-yyyy)format
		}
		catch(Exception e)//parse exception 
		{
			parsedDate=sdfForCalendar.parse(dateToParse);//@sdfForCalendar - (MM/dd/yyyy)format	
		}
		System.out.println("outside parsing="+parsedDate);
		return parsedDate;
	}
	
	
	
	/*
	 * Sets all the details needed for the user relationship.
	 * 
	 * Created By          : Raghavan
	 * Created Date        : 7/16/2008
	 * Last Change Made by : Raghavan
	 * Last Change Made on : 7/16/2008
	 * 
	 */
	private void setUserRelationship(UserRelationship saveUserRelation,String territoryId,
			String userId,String relatedUserId,OptionLookup relationshipType,Date beginDate,Date endDate){
			/*
			 * All the values to be set in the user relationship are sent as parameters and 
			 * 					those values are set using the  appropriate setter methods.
			 *
			 * Since  the territory is an optional value an null check is made for it.
			 * 
			 */
		
			if(territoryId != null){
				saveUserRelation.setTerritory(territoryId);
			}
		   saveUserRelation.setUserId(userId);
		   saveUserRelation.setSupervisorId(relatedUserId);
		   saveUserRelation.setReportLevel(relationshipType.getOptValue());
		   saveUserRelation.setBeginDate(beginDate);
	       saveUserRelation.setEndDate(endDate);
	}
	
	
	/*
	 * To obtain the user id .
	 * 
	 * Created By          : Raghavan
	 * Created Date        : 7/19/2008
	 * Last Change Made by : Raghavan
	 * Last Change Made on : 7/19/2008
	 *  
	 *  
	 */
	private String assignId(User[] userToAssign,String userId){
		/*
		 * User array length is checked,if its not zero the corresponding userid for it is obtained
		 * 					 else the userid passed is being assigned.
		 * 
		 */
		
		return((userToAssign.length==0) ? userId :   ""+userToAssign[0].getId());	
	}
	
		
	/*
	 * To compare the territory,user and related users and make the decision whether 
	 * 				to save & also update the details or just to update the details.
	 * 
	 * Created By          : Raghavan
	 * Created Date        : 7/20/2008
	 * Last Change Made by : Raghavan
	 * Last Change Made on : 7/20/2008
	 *  
	 *  @OldNewValues - an arraylist which holds all the needed values
	 *  @staffId
	 *  @saveUserRelation - an userRelationship object which is to be saved or updated
	 *  @request
	 *  @properties - to access the server config properties(to take date)
	 *  
	 */
	private void compareValues(ArrayList oldNewValues,long staffId,UserRelationship saveUserRelation,
					HttpServletRequest request,Properties properties)throws Exception{
			/*
			 *
			 * If territory,user (or) related user is changed, old record is updated with endDate as previous date
			 * 			and a new record is saved with new begin date of today and if the supervisor is changed the 
			 * 					endDate is made as 01-JAN-2014 and if rest of the fields are only changed,
			 * 								only an update is made.
			 * 
			 */
			
	     //Compare with old values
	           if(oldNewValues.get(2) != null && oldNewValues.get(1) != null && oldNewValues.get(0) != null && 
	        		   (oldNewValues.get(2).equals(oldNewValues.get(6))) && (oldNewValues.get(1).equals(oldNewValues.get(5)))&& 
	        		   								(oldNewValues.get(0).equals(oldNewValues.get(4)))){
	        	   saveUserRelation.setId(staffId);		
	        	   
	        	   setUserRelationship(saveUserRelation,(String) oldNewValues.get(4),(String) oldNewValues.get(5),
	        			   (String) oldNewValues.get(6),(OptionLookup) oldNewValues.get(7),
	        			   				(Date)oldNewValues.get(8),(Date)oldNewValues.get(9));
	        	  
	        	   saveOrUpdateUserRelationship(saveUserRelation,request,"update");
	           	
	           }
	           else
	           {
	        	   //Update old data with past date
	        	   saveUserRelation.setId(staffId);
	        	   Date prevDate= new Date(System.currentTimeMillis()- 24*60*60*1000);
	        	   OptionLookup optionIdParameter= (oldNewValues.get(3) != null)? (OptionLookup)oldNewValues.get(3) 
  		    		   : (OptionLookup)oldNewValues.get(7);
	        	   setUserRelationship(saveUserRelation,(String) oldNewValues.get(0),(String)oldNewValues.get(1),
	        		  (String)oldNewValues.get(2),optionIdParameter,(Date)oldNewValues.get(8), prevDate);
  		       
	        	   saveOrUpdateUserRelationship(saveUserRelation,request,"update");//Update in the database
	           
	        	   //Save new data
	        	   Date newBeginDate = new Date(System.currentTimeMillis());
	        	   Date endDateParameter = !(((String)oldNewValues.get(2)).equals((String)oldNewValues.get(6))) 
	        	   					?(new SimpleDateFormat("dd-MMM-yyyy").parse(properties.getProperty(ENDDATE)))
	        	   					:(Date)oldNewValues.get(9);
   					
	        	   setUserRelationship(saveUserRelation, (String)oldNewValues.get(4), (String)oldNewValues.get(5),
	        			   (String)oldNewValues.get(6),(OptionLookup)oldNewValues.get(7), newBeginDate, endDateParameter);
   			   
	        	   // Save in the database
	        	   saveOrUpdateUserRelationship(saveUserRelation,request,"save");//Save in the database
   			   
	           }
	}

	
	/*
	 * 
	 * To get all the values from the userRelationship form and add everything 
	 * 				in a arraylist for further manipulations. 
	 * 
	 * Created By          : Raghavan
	 * Created Date        : 7/21/2008
	 * Last Change Made by : Raghavan
	 * Last Change Made on : 7/21/2008
	 *  
	 *  @request
	 *  
	 */
	private ArrayList getValues(HttpServletRequest request, long userGroupId)throws Exception {	
		/*
		 * It returns a arraylist which holds all the values passed from the userRelationship form
		 * 			and their index values are added with it for reference. 
		 * 				
		 * 
		 */
		
		ArrayList oldNewValues=new ArrayList();//to pass the values
		
		ArrayList oldValues = getOldValues(request, userGroupId);//to get the old values 
		
        ArrayList newValues = getNewValues(request, userGroupId);//to get the existing values
       
        //adding the old and existing values to the arraylist with the index starting from zero.
	    oldNewValues.add(0,oldValues.get(0));
	    oldNewValues.add(1,oldValues.get(1));
	    oldNewValues.add(2,oldValues.get(2));
	    oldNewValues.add(3,oldValues.get(3));
	    oldNewValues.add(4,newValues.get(0));
	    oldNewValues.add(5,newValues.get(1));
	    oldNewValues.add(6,newValues.get(2));
	    oldNewValues.add(7,newValues.get(3));
	    oldNewValues.add(8,oldValues.get(4));
	    oldNewValues.add(9,newValues.get(4));
	    oldNewValues.add(10,newValues.get(5));
	    oldNewValues.add(11,newValues.get(6));
		return oldNewValues;
	}
	
	
	/*
	 * 
	 * To get all old values from the userRelationship form and add everything 
	 * 				in a arraylist for further manipulations. 
	 * 
	 * Created By          : Raghavan
	 * Created Date        : 7/22/2008
	 * Last Change Made by : Raghavan
	 * Last Change Made on : 7/22/2008
	 *  
	 *  @request
	 *  
	 */
	private ArrayList getOldValues(HttpServletRequest request, long userGroupId)throws Exception{
		/*
		 * It returns a arraylist which holds all the old  values passed from the userRelationship form
		 * 			and their index values are added with it for reference. 
		 * 				
		 * 
		 */
		
		ArrayList oldValues = new ArrayList();//to pass the old values obtained from the userRelationship form
		String oldUserIdPassed=request.getParameter("oldhiddenUserId");
		logger.info("hidden user id="+oldUserIdPassed);
		long oldPrivilegeType=0;
		OptionLookup oldOptionId = new OptionLookup();
		if(!request.getParameter("oldhiddenReportPrivilegeId").equalsIgnoreCase("0")){
			oldPrivilegeType=Long.parseLong(request.getParameter("oldhiddenReportPrivilegeId"));
			oldOptionId=optionServiceWrapper.getValuesForId(oldPrivilegeType, userGroupId);
		}
		String oldRelatedUserIdPassed=request.getParameter("oldhiddenSupervisorId");
		String oldTerritoryIdPassed=request.getParameter("oldhiddenTerritoryId");
		Date beginDate=parseDate((String)request.getParameter("oldbegin"));
		String oldUserId="",oldRelatedUserId="",oldTerritoryId="";
		User[] oldUser = (User[])userService.getUserForStaffId(oldUserIdPassed);
	    User[] oldRelatedUser = (User[])userService.getUserForStaffId(oldRelatedUserIdPassed);	
	    User[] oldTerritory = (User[])userService.getUserForStaffId(oldTerritoryIdPassed);	
	    oldUserId=assignId(oldUser,oldUserIdPassed); 		    	    
	    oldRelatedUserId=assignId(oldRelatedUser, oldRelatedUserIdPassed);
	    oldTerritoryId=assignId(oldTerritory,oldTerritoryIdPassed);

	    //Adding the values to the arrayList	    
	    oldValues.add(0,oldTerritoryId);
	    oldValues.add(1,oldUserId);
	    oldValues.add(2,oldRelatedUserId);
	    oldValues.add(3,oldOptionId);
	    oldValues.add(4,beginDate);
	    return oldValues;
	}
	
	
	/*
	 * 
	 * To get the new  values from the userRelationship form and add everything 
	 * 				in an arraylist for further manipulations. 
	 * 
	 * Created By          : Raghavan
	 * Created Date        : 7/22/2008
	 * Last Change Made by : Raghavan
	 * Last Change Made on : 7/22/2008
	 *  
	 *  @request
	 *  
	 */
	private ArrayList getNewValues(HttpServletRequest request, long userGroupId)throws Exception{
		/*
		 * It returns a arraylist which holds all the new/existing values passed from the userRelationship form
		 * 			and their index values are added with it for reference. 
		 * 				
		 * 
		 */
		
		ArrayList newValues = new ArrayList();//to pass the new values obtained from the userRelationship form
		String userIdPassed=request.getParameter("hiddenUserId");
		long privilegeType=Long.parseLong(request.getParameter("hiddenReportPrivilegeId"));
		String relatedUserIdPassed=request.getParameter("hiddenSupervisorId");
		String territoryIdPassed=request.getParameter("hiddenTerritoryId");
		Date endDate=parseDate((String)request.getParameter("end"));
		String userId="",relatedUserId="",territoryId="";
		User[] user = (User[])userService.getUserForStaffId(userIdPassed);
	    User[] relatedUser = (User[])userService.getUserForStaffId(relatedUserIdPassed);	
	    User[] territory = (User[])userService.getUserForStaffId(territoryIdPassed);	
	    logger.debug("useridpassed="+userIdPassed);
	    userId=assignId(user, userIdPassed);		    	    
	    relatedUserId=assignId(relatedUser,relatedUserIdPassed);
	    territoryId=assignId(territory, territoryIdPassed);
	    logger.info("userId="+userId);
	    logger.info("related user id="+relatedUserId);
	    logger.info("territoryId="+territoryId);
        OptionLookup optionId=optionServiceWrapper.getValuesForId(privilegeType, userGroupId);

        //Adding the values to the arrayList
        newValues.add(0,territoryId);
        newValues.add(1,userId);
        newValues.add(2,relatedUserId);
        newValues.add(3,optionId);
        newValues.add(4,endDate);
        newValues.add(5,userIdPassed);
        newValues.add(6,relatedUserIdPassed);
		return newValues;
	}
	
	
	/*
	 * 
	 *To save or update the userrelationship object based on the saveOrUpdate string passed.
	 * 
	 * Created By          : Raghavan
	 * Created Date        : 7/22/2008
	 * Last Change Made by : Raghavan
	 * Last Change Made on : 7/22/2008
	 *  
	 *  
	 *  @saveUserRelation - the userRelationship object which is to be saved
	 *  @request
	 *  @saveOrUpdate - it decides whether save or update action to be made
	 *  
	 */
	private void  saveOrUpdateUserRelationship(UserRelationship saveUserRelation,HttpServletRequest request,
			String saveOrUpdate){
			/*
			 * To save/update the userRelationship details,based on the saveOrUpdate String passed,
			 * 				the corresponding action will be executed.
			 * 			
			 * 
			 */
		
		if(saveOrUpdate.equalsIgnoreCase("update")){
		
			String updateResult=userRelationshipService.updateUserrelation(saveUserRelation);
   			logger.info("updated result"+updateResult);
   			if(updateResult.equals("true"))
   				request.getSession().setAttribute("MESSAGE", "Updated Successfully");
 		}
		
		if(saveOrUpdate.equalsIgnoreCase("save")){
			
			String saveResult=userRelationshipService.saveUserrelation(saveUserRelation);
			logger.info("saveResult"+saveResult);
			if(saveResult.equals("true"))
				request.getSession().setAttribute("MESSAGE", "Saved Successfully");
		}
	}
	
	
	public IUserRelationshipService getUserRelationshipService() {
		return userRelationshipService;
	}

	
	public void setUserRelationshipService(
			IUserRelationshipService userRelationshipService) {
		this.userRelationshipService = userRelationshipService;
	}

	
	public IOptionServiceWrapper getOptionServiceWrapper() {
		return optionServiceWrapper;
	}

	
	public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
		this.optionServiceWrapper = optionServiceWrapper;
	}


	public IUserService getUserService() {
		return userService;
	}


	public void setUserService(IUserService userService) {
		this.userService = userService;
	}
	
	
}


