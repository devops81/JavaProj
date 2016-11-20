package com.openq.web.controllers;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import com.openq.contacts.Contacts;
import com.openq.authentication.UserDetails;
import com.openq.eav.expert.IExpertListService;
import com.openq.kol.DBUtil;
import com.openq.kol.DataAccessException;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.web.ActionKeys;

/**
 * Created by Raghavan.
 * User: SA.
 * Latest Update made by Raghavan.
 * Date: 7-JUL-2008
 * Time:10.00.00 AM
 */

public class OLAlignmentController extends AbstractController {

    IExpertListService expertListService;
    IUserService userService;
    private static final String ENDDATE = "contact.endDate";
    private static final String PROPERTIES_FILE = "resources/ServerConfig.properties";
    final String DEFAULT_FILTER = "Current Only";
    final String DEFAULT_FILTER_ALL = "All";

    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception 
    {    	
    
    	ModelAndView mav = new ModelAndView("OLAlignment");
        HttpSession session = request.getSession();
        session.setAttribute("CURRENT_LINK","OLAlignment");
        String action = request.getParameter("action");
        String fromOLAlignment = null;
        session.removeAttribute("FILTER_PARAM");
       
        if (null != request.getParameter("fromOLAlignment")){

          fromOLAlignment = request.getParameter("fromOLAlignment");
          session.setAttribute("fromOLAlignment",fromOLAlignment);
        }
        String filterParam = null;
        filterParam = (String) request.getParameter("filterRadio");

        // Current, previous and next date set
        Properties p = DBUtil.getInstance().getDataFromPropertiesFile(PROPERTIES_FILE);
        Date date = new Date(System.currentTimeMillis());
    	SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
    	SimpleDateFormat dateFormatForCalendar = new SimpleDateFormat("MM/dd/yyyy");
    	String presentDate = (dateFormat.format(date)).toString();
    	Date beforeDate = new Date(System.currentTimeMillis() - 24*60*60*1000);
    	String previousDate = dateFormat.format(beforeDate);
    	Date tomorrow = new Date(System.currentTimeMillis() + 24*60*60*1000);
    	String nextDate = dateFormat.format(tomorrow);
        Date endDate = dateFormat.parse(p.getProperty(ENDDATE));
        String endDateString = dateFormat.format(endDate);
    	
    	//Setting session variables for OLAlignment page
    	session.setAttribute("CONTACT_END_DATE",endDateString);
        session.setAttribute("CONTACT_PRESENT_DATE",presentDate);
        session.setAttribute("CONTACT_NEXT_DATE",nextDate);
        session.setAttribute("CONTACT_PREVIOUS_DATE",previousDate);
        session.setAttribute("FILTER_PARAM", filterParam);

        if(ActionKeys.RESET_ALIGN.equalsIgnoreCase(action)){
        	session.removeAttribute("STAFFID");
            session.removeAttribute("USERNAME");
            session.removeAttribute("EMAIL");
            session.removeAttribute("PHONE");
            session.removeAttribute("OLNAME_WITH_ID");
            session.removeAttribute("CONTACTS_OL_MAP");
            session.removeAttribute("FILTER_PARAM");
            return new ModelAndView("OLAlignment");
        }


        if(ActionKeys.RESET_REALIGN.equalsIgnoreCase(action)){
        	long staffId1 = (null != request.getParameter("staffId1") && "" != request.getParameter("staffId1").toString())? Long.parseLong(request.getParameter("staffId1")) : 0;
            long staffId2 = (null != request.getParameter("staffId2") && "" != request.getParameter("staffId2").toString())? Long.parseLong(request.getParameter("staffId2")) : 0;
            session.setAttribute("CONTACTS_OL_MAP_USER1",getAlignedOLMap(staffId1, DEFAULT_FILTER));
            session.setAttribute("CONTACTS_OL_MAP_USER2",getAlignedOLMap(staffId2, DEFAULT_FILTER));
            return new ModelAndView("OLRealignment");
        }
        
        //Get for all the OLs in the contact table for User with this particular StaffId
        if(ActionKeys.GET_OLS.equalsIgnoreCase(action)){
        	
        return getOLs(request,filterParam);
        }
 	   
       if(ActionKeys.KOL_ADD_EXPERTS.equalsIgnoreCase(action)){
           if (null != request.getParameter("fromOLAlignment")){
               fromOLAlignment = request.getParameter("fromOLAlignment");
               session.setAttribute("fromOLAlignment",fromOLAlignment);
             }

              String[] ids = null;
              if (null != request.getParameterValues("ids")){
                  ids = request.getParameterValues("ids");
              }
                ArrayList finalList = new ArrayList();
                ArrayList tempArr = new ArrayList();
                //session.setAttribute("IDS", ids);
                HashSet  tmpSet = new HashSet();
                if (null != session.getAttribute("OLNAME_WITH_ID")){
                 ArrayList olList = (ArrayList)session.getAttribute("OLNAME_WITH_ID");
                  if (null != olList && olList.size() >0){
                         tempArr.addAll(olList);
                  }
                }
                ArrayList OLdata = new ArrayList();
                if (null != ids) {
                    User user[] = new User[ids.length];
                    for (int i = 0; i < ids.length; i++) {
                        if (null != ids[i]) {
                            user[i] = userService.getUser(Long.parseLong(ids[i]));
                            OLdata.add(user[i].getId()+"/"+user[i].getLastName()+", "+ user[i].getFirstName());

                        }
                    }
                }
                if(tempArr.size()>0)  {
                 tmpSet.addAll(tempArr);
                }
                if(OLdata.size() > 0) {
                  tmpSet.addAll(OLdata);
                }
                if(tmpSet.size()>0) {
                    Iterator itr = tmpSet.iterator();
                    String val = null;
                    while(itr.hasNext()) {
                        val = (String)itr.next();
                        if(!finalList.contains(val)) {
                         finalList.add(val);
                        }
                    }
                }

                session.setAttribute("OLNAME_WITH_ID",finalList);
                return new ModelAndView("OLAlignment");
       }else if(ActionKeys.OLREALIGNMENT.equalsIgnoreCase(action)){
    	   
            session.removeAttribute("USER1"); 
            session.removeAttribute("USER2");
             return new ModelAndView("OLRealignment");
       }else if(ActionKeys.SAVE_OLS.equalsIgnoreCase(action)){
    	   
    	   return saveOLs(request,dateFormatForCalendar,dateFormat,filterParam);
       }else if(ActionKeys.SAVE_REALIGNMENT_OLS.equalsIgnoreCase(action)){
    	   
    	   return saveRealignmentOLs(request,dateFormat);
       }else if(ActionKeys.ALIGNMENT_PRINT.equalsIgnoreCase(action)){
    	   
           session.removeAttribute("OL_PRINT_LIST");
           session.removeAttribute("CONTACT_PRINT_LIST");
           String staffId = null != request.getParameter("staffId") ? request.getParameter("staffId"):"";
           String userName = null != request.getParameter("userName") ? request.getParameter("userName"):"";
           session.setAttribute("USERNAME",userName);
           if(null != staffId && !"".equals(staffId)){
                 Contacts[] contacts = expertListService.getOLList(Long.parseLong(staffId)) ;
                 User[] users = new User[contacts.length];
                 for(int i=0;i<contacts.length;i++){
                	 
                	 users[i] = userService.getOLForId(contacts[i].getKolId());
                 }
                 session.setAttribute("OL_PRINT_LIST",users);
                 session.setAttribute("CONTACT_PRINT_LIST",contacts);
           }
          return new ModelAndView("alignment_printlist");
       }else if(ActionKeys.REALIGNMENT_PRINT.equalsIgnoreCase(action) ){
    	   
    	   return printRealignment(request);
       }
       
       removeSessions(request);
        mav = new ModelAndView("OLAlignment");
        return mav;  
    }
    
    private ModelAndView getOLs(HttpServletRequest request,String filterParam)
    {
    	logger.info("Getting Ols For StaffId");
    	ModelAndView mav = new ModelAndView("OLAlignment");
    	HttpSession session = request.getSession();
        long staffId = 0;
        Map contactsOLMap = new LinkedHashMap();
        if (null != request.getParameter("staffId")) {
        	logger.info("request.getParameter(staffid)"+request.getParameter("staffId"));
            staffId = Long.parseLong((String) request.getParameter("staffId"));
            System.out.println("staffid in ctrller is="+staffId);
            User[] alignedUser = userService.getUserForStaffIdInOLAlignment(staffId+"");
            System.out.println("alignedUser in ctrller="+alignedUser.length);
            if(alignedUser!=null && alignedUser.length!=0){
            	logger.info("alignedUser.length="+alignedUser.length);
            	session.setAttribute("ALIGNED_USER",alignedUser[0]);
            	session.setAttribute("STAFFID", alignedUser[0].getStaffid());
				session.setAttribute("USERNAME", alignedUser[0].getLastName()+", "+alignedUser[0].getFirstName());
				session.setAttribute("EMAIL", alignedUser[0].getEmail());
				session.setAttribute("PHONE", alignedUser[0].getPhone());
			}
            if(request.getParameter("table")!=null){
                long staffId1 = (null != request.getParameter("staffId1") && !request.getParameter("staffId1").toString().equalsIgnoreCase(""))? Long.parseLong(request.getParameter("staffId1")) : 0;
                long staffId2 = (null != request.getParameter("staffId2") && !request.getParameter("staffId2").toString().equalsIgnoreCase(""))? Long.parseLong(request.getParameter("staffId2")) : 0;
                logger.debug("StaffId1:"+staffId1+" And StaffId2:"+staffId2);
                String user1 = null != request.getParameter("user1") ? request.getParameter("user1") : null;
                String user2 = null != request.getParameter("user2") ? request.getParameter("user2") : null;
                String email1 = null != request.getParameter("email1") ? request.getParameter("email1") : null;
                String phone1 = null != request.getParameter("phone1") ? request.getParameter("phone1") : null;
                String email2 = null != request.getParameter("email2") ? request.getParameter("email2") : null;
                String phone2 = null != request.getParameter("phone2") ? request.getParameter("phone2") : null;

                if(staffId1!=0)
                	session.setAttribute("STAFFID1",staffId1+"");
                if(staffId2!=0)
                	session.setAttribute("STAFFID2",staffId2+"");
                if(user1!=null)
                	session.setAttribute("USER1",user1);
                if(user2!=null)
                	session.setAttribute("USER2",user2);
                if(email1!=null)
                	session.setAttribute("EMAIL1",email1);
                if(email2!=null)
                	session.setAttribute("EMAIL2",email2);
                if(phone1!=null)         
                	session.setAttribute("PHONE1",phone1);
                if(phone2!=null)
                	session.setAttribute("PHONE2",phone2);

                contactsOLMap = getAlignedOLMap(staffId, DEFAULT_FILTER);
                if(request.getParameter("table").equalsIgnoreCase("1")){
            		session.setAttribute("CONTACTS_OL_MAP_USER1",contactsOLMap);
            		session.setAttribute("ALIGNED_USER1",alignedUser[0]);
            	}else if(request.getParameter("table").equalsIgnoreCase("2")){
            		session.setAttribute("CONTACTS_OL_MAP_USER2",contactsOLMap);
            		session.setAttribute("ALIGNED_USER2",alignedUser[0]);
               }
            	return new ModelAndView("OLRealignment");
            }
            contactsOLMap = getAlignedOLMap(staffId, filterParam);
            session.setAttribute("CONTACTS_OL_MAP",contactsOLMap);

        }
        return mav;    
    }
    
    
    private ModelAndView KOLAddExperts(HttpServletRequest request,String fromOLAlignment)
    {

    	HttpSession session = request.getSession();
        if (null != request.getParameter("fromOLAlignment")){
         fromOLAlignment = request.getParameter("fromOLAlignment");
         session.setAttribute("fromOLAlignment",fromOLAlignment);
       }

        String[] ids = null;
        if (null != request.getParameterValues("ids")){
            ids = request.getParameterValues("ids");
        }
          ArrayList finalList = new ArrayList();
          ArrayList tempArr = new ArrayList();
          //session.setAttribute("IDS", ids);
          HashSet  tmpSet = new HashSet();
          if (null != session.getAttribute("OLNAME_WITH_ID")){
           ArrayList olList = (ArrayList)session.getAttribute("OLNAME_WITH_ID");
            if (null != olList && olList.size() >0){
                   tempArr.addAll(olList);
            }
          }
          ArrayList OLdata = new ArrayList();
          if (null != ids) {
              User user[] = new User[ids.length];
              for (int i = 0; i < ids.length; i++) {
                  if (null != ids[i]) {
                      user[i] = userService.getUser(Long.parseLong(ids[i]));
                      OLdata.add(user[i].getId()+"/"+user[i].getLastName()+", "+ user[i].getFirstName());

                  }
              }
          }
          if(tempArr.size()>0)  {
           tmpSet.addAll(tempArr);
          }
          if(OLdata.size() > 0) {
            tmpSet.addAll(OLdata);
          }
          if(tmpSet.size()>0) {
              Iterator itr = tmpSet.iterator();
              String val = null;
              while(itr.hasNext()) {
                  val = (String)itr.next();
                  if(!finalList.contains(val)) {
                   finalList.add(val);
                  }
              }
          }

          session.setAttribute("OLNAME_WITH_ID",finalList);
          logger.debug("returning koladdexperts mav");
          return new ModelAndView("OLAlignment");
    }
    
    
    private ModelAndView saveOLs(HttpServletRequest request,
    		SimpleDateFormat dateFormatForCalendar,SimpleDateFormat dateFormat,String filterParam)throws Exception
    {
    	
    	HttpSession session=request.getSession();
    	session.removeAttribute("OLNAME_WITH_ID");
        User user = new User();
        String ids[] = null;
        String primaryContactsFlags[] = null;
        String contactEndDate[]=null;
        String contactBeginDate[]=null;
        String contactIds[] = null;
        if (null != request.getParameterValues("alignedOLs")){
           ids = request.getParameterValues("alignedOLs");
        }
        if (null != request.getParameterValues("primaryContactFlagValue")){
     	   primaryContactsFlags = request.getParameterValues("primaryContactFlagValue");
         }
        long staffId = 0;
        if (null != request.getParameter("staffId") && !request.getParameter("staffId").trim().equalsIgnoreCase("")) {
            staffId = Long.parseLong((String) request.getParameter("staffId"));
        }
        if (null != request.getParameterValues("contactBeginDate")){
     	   contactBeginDate = request.getParameterValues("contactBeginDate");
     	   System.out.println("contact begin date="+contactBeginDate);
        }
        if (null != request.getParameterValues("contactEndDate")){
     	   contactEndDate = request.getParameterValues("contactEndDate");
     	   System.out.println("contact end date="+contactEndDate);
        }
        if (null != request.getParameterValues("contactIds")){
     	   contactIds = request.getParameterValues("contactIds");
        }
        String userName = null;
        if (null != request.getParameter("userName"))
          userName = request.getParameter("userName");

       String email = null != request.getParameter("email1") ? request.getParameter("email1") : null;
       String phone = null != request.getParameter("phone1") ? request.getParameter("phone1") : null;

        if (null != ids) {
            Contacts[] contactsList = new Contacts[ids.length];
            for (int i = 0; i < ids.length; i++) {
                if (null != ids[i]) {
                    user = userService.getUser(Long.parseLong(ids[i]));

                     Contacts contact = new Contacts();

                        contact.setContactName(userName);
                        contact.setEmail(email);
                        contact.setStaffid(staffId);
                        contact.setPhone(phone);
                        contact.setKolId(Long.parseLong(ids[i]));
                        if(primaryContactsFlags[i].equalsIgnoreCase("Y"))
                     	   contact.setIsPrimaryContact("true");
                        else
                     	   contact.setIsPrimaryContact("false");
                        if(contactBeginDate[i] != null && !contactBeginDate[i].equalsIgnoreCase(""))
                        {
                     	   System.out.println("inside set begin date");
                        try
                        {
                     	   System.out.println("exec begin date try");
                     	   System.out.println("contactBeginDate[i]="+contactBeginDate[i]);
                		       Date dateOfCalendar=dateFormatForCalendar.parse(contactBeginDate[i]);
                		       System.out.println("dateofcalendar="+dateOfCalendar);
                			   contactBeginDate[i]= dateFormat.format(dateOfCalendar).toUpperCase();
                			   System.out.println("contactbegindate[i]="+contactBeginDate[i]);
                	           contact.setBegindate(dateFormatForCalendar.parse(contactBeginDate[i]));
                        }
                        catch(Exception e)
                        {
                     	   System.out.println("exec begin date catch");
                     	   contact.setBegindate(dateFormat.parse(contactBeginDate[i]));   
                        }
                        
                        }
                        if(contactEndDate[i] != null && !contactEndDate[i].equalsIgnoreCase(""))
                        {
                     	   System.out.println("inside set end date");
                     	   try
                     	   {
                     		    Date dateOfCalendar=dateFormatForCalendar.parse(contactEndDate[i]);
                        		   contactEndDate[i]= dateFormat.format(dateOfCalendar).toUpperCase();
                     	        contact.setEnddate(dateFormat.parse(contactEndDate[i]));
                     	   }
                     	   catch(Exception e)
                     	   {
                     		   System.out.println("exec end date catch");
                     		   contact.setEnddate(dateFormat.parse(contactEndDate[i]));
                     	   }
                        }
                        contact.setContactId(Long.parseLong(contactIds[i]));
                        contactsList[i] = contact;
                }

            }
             expertListService.updateContactList(staffId, contactsList);
            session.removeAttribute("USERNAME ");
        }else{
             Contacts[] contacts = expertListService.getOLList(staffId);
            if (null != contacts)
             for(int i=0;i<contacts.length ;i++){
                 expertListService.deleteContact(contacts[i]);
             }
        }
        session.setAttribute("CONTACTS_OL_MAP",getAlignedOLMap(staffId,filterParam));
        return new ModelAndView("OLAlignment");
    
    }
   
    
    private ModelAndView saveRealignmentOLs(HttpServletRequest request,SimpleDateFormat dateFormat)throws Exception
    {	
 	    HttpSession session =request.getSession();
    	String ids1[] = null;
        String list1[] = null;
        String primaryContactsFlags1[] = null;
        String contactEndDate1[]=null;
        String contactBeginDate1[]=null;
        String contactIds1[] = null;
        String ids2[] = null;
        String primaryContactsFlags2[] = null;
        String contactEndDate2[]=null;
        String contactBeginDate2[]=null;
        String contactIds2[] = null;
        if (null != request.getParameterValues("alignedOLsTable1")){
           ids1 = request.getParameterValues("alignedOLsTable1");
        }
        if (null != request.getParameterValues("alignedOLsTable2")){
            ids2 = request.getParameterValues("alignedOLsTable2");
         }
        if (null != request.getParameterValues("hiddenPrimaryContactFlagValueTable1")){
     	   primaryContactsFlags1 = request.getParameterValues("hiddenPrimaryContactFlagValueTable1");
         }
        if (null != request.getParameterValues("hiddenPrimaryContactFlagValueTable2")){
     	   primaryContactsFlags2 = request.getParameterValues("hiddenPrimaryContactFlagValueTable2");
         }
        long staffId = 0;
        if (null != request.getParameterValues("contactBeginDateTable1")){
     	  logger.debug("inside date manipulation");
     	   contactBeginDate1 = request.getParameterValues("contactBeginDateTable1");
     	   logger.debug("contactBeginDateTable1="+contactBeginDate1);
        }
        if (null != request.getParameterValues("contactBeginDateTable2")){
     	   
     	   contactBeginDate2 = request.getParameterValues("contactBeginDateTable2");
     	   logger.debug("contactBeginDateTable2="+contactBeginDate2);
        }
        if (null != request.getParameterValues("contactEndDateTable1")){
     	   contactEndDate1 = request.getParameterValues("contactEndDateTable1");
     	   logger.debug("contactEndDateTable2="+contactBeginDate2);
        }
        if (null != request.getParameterValues("contactEndDateTable2")){
     	   contactEndDate2 = request.getParameterValues("contactEndDateTable2");
     	   logger.debug("contactEndDateTable2="+contactEndDate2);
        }
        if (null != request.getParameterValues("contactIdsTable1")){
     	   contactIds1 = request.getParameterValues("contactIdsTable1");
        }
        if (null != request.getParameterValues("contactIdsTable2")){
     	   contactIds2 = request.getParameterValues("contactIdsTable2");
        }

        long staffId1 = 0;
        if (null != request.getParameter("staffId1")) {
            staffId1 = Long.parseLong(request.getParameter("staffId1"));

        }
        long staffId2 = 0;
        if (null != request.getParameter("staffId2")) {
            staffId2 = Long.parseLong(request.getParameter("staffId2"));
        }
        String user1 = null;
        if (null != request.getParameter("user1")){
             user1 = request.getParameter("user1");
         }

        String user2 = null;
        if (null != request.getParameter("user2")){
             user2 = request.getParameter("user2");
        }
        String moveUser1 = null != request.getParameter("moveUser1") ? request.getParameter("moveUser1") : null;


        String moveUser2 = null != request.getParameter("moveUser2") ? request.getParameter("moveUser2") : null;


        String u1 = null != request.getParameter("r1") ? request.getParameter("r1") : null;
        String u2 = null != request.getParameter("r2") ? request.getParameter("r2") : null;


        moveUser2 = null != u1 ? u1 : null;
        moveUser1 = null != u2 ? u2 : null;
        String email1 = null != request.getParameter("email1") ? request.getParameter("email1") : null;
        String phone1 = null != request.getParameter("phone1") ? request.getParameter("phone1") : null;

        String email2 = null != request.getParameter("email2") ? request.getParameter("email2") : null;
        String phone2 = null != request.getParameter("phone2") ? request.getParameter("phone2") : null;
        User user = new User();
        String query1 ="";
        String query ="";
        // for the first list
        if (null != ids1) {
            logger.debug("No Of Ols in Contact1:"+ids1.length);
            logger.debug("No of pimarycontact flags in table1:"+primaryContactsFlags1.length);
             Contacts[] contactsList1 = new Contacts[ids1.length];
            for (int i = 0; i < ids1.length; i++) {
                if (null !=ids1[i]) {

                    Contacts contact = new Contacts();

                    contact.setContactName(user1);
                    contact.setEmail(email1);
                    contact.setStaffid(staffId1);
                    contact.setPhone(phone1);
                    contact.setKolId(Long.parseLong(ids1[i]));
                    logger.debug("For Id:"+ids1[i]+" Primary Contact Flag is:"+primaryContactsFlags1[i]);
                    if(primaryContactsFlags1[i].equalsIgnoreCase("Y"))
                 	   contact.setIsPrimaryContact("true");
                    else
                 	   contact.setIsPrimaryContact("false");
                    if(contactBeginDate1[i] != null && !contactBeginDate1[i].equalsIgnoreCase("null") )
                    {
                    contact.setBegindate(dateFormat.parse(contactBeginDate1[i]));
                    }
                    if(contactEndDate1[i] != null && !contactEndDate1[i].equalsIgnoreCase("null"))
                    {
                    contact.setEnddate(dateFormat.parse(contactEndDate1[i]));
                    }
                    contact.setContactId(Long.parseLong(contactIds1[i]));
                    contactsList1[i] = contact;
                                       }
            }
            expertListService.updateContactList(staffId1, contactsList1);
        } else {
            Contacts[] contacts = expertListService.getOLList(staffId1);
            if (null != contacts) for (int i = 0; i < contacts.length; i++) {
                expertListService.deleteContact(contacts[i]);
            }
        }
        // for the second list
        if (null != ids2) {
     	   logger.debug("No Of Ols in Contact1:"+ids2.length);
            logger.debug("No of pimarycontact flags in table1:"+primaryContactsFlags2.length);
     	   Contacts[] contactsList2 = new Contacts[ids2.length];
            for (int i = 0; i < ids2.length; i++) {
                if (null != ids2[i]) {
                    user = userService.getUser(Long.parseLong(ids2[i]));
                    Contacts contact = new Contacts();
                    contact.setContactName(user2);
                    contact.setEmail(email2);
                    contact.setStaffid(staffId2);
                    contact.setPhone(phone2);
                    contact.setKolId(Long.parseLong(ids2[i]));
                    logger.debug("For Id:"+ids2[i]+" Primary Contact Flag is:"+primaryContactsFlags2[i]);
                    if(primaryContactsFlags2[i].equalsIgnoreCase("Y"))
                 	   contact.setIsPrimaryContact("true");
                    else
                 	   contact.setIsPrimaryContact("false");
                    if(contactBeginDate2[i] != null && !contactBeginDate2[i].equalsIgnoreCase("null") )
                    {
                    contact.setBegindate(dateFormat.parse(contactBeginDate2[i]));
                    }
                    if(contactEndDate2[i] != null && !contactEndDate2[i].equalsIgnoreCase("null") )
                    {
                    contact.setEnddate(dateFormat.parse(contactEndDate2[i]));
                    }
                    contact.setContactId(Long.parseLong(contactIds2[i]));
                    contactsList2[i] = contact;
                }
            }
            expertListService.updateContactList(staffId2, contactsList2);
        }else{
             Contacts[] contacts = expertListService.getOLList(staffId2);
            if (null != contacts) for (int i = 0; i < contacts.length; i++) {
                expertListService.deleteContact(contacts[i]);
            }
        }
        if (null != moveUser2 && !"".equalsIgnoreCase(moveUser2) ){
           // query = new StringBuffer().append("update contacts set contactname='").append(user2).append("'").append(", staffid = ").append(staffId2).append(",phone=").append(phone2).append(", email='").append(email2).append("' where kolid in ( ").append(list1).append(") and staffid=").append(staffId1).toString();
            query1 = new StringBuffer().append("update kol_development_plan set owner='").append(user1).
            append("', staffid='").append(staffId1).append("' where expert_id in (").append(moveUser2).
            append(") and staffid='").append(staffId2).append("'").toString();

            processMoveData(query1);
        }

        if (null != moveUser1 && !"".equalsIgnoreCase(moveUser1) ){
           query1 = new StringBuffer().append("update kol_development_plan set owner='").append(user2).
           append("', staffid='").append(staffId2).append("' where expert_id in (").append(moveUser1).
           append(") and staffid='").append(staffId1).append("'").toString();

           processMoveData(query1);
        }

        session.setAttribute("CONTACTS_OL_MAP_USER1",getAlignedOLMap(staffId1, DEFAULT_FILTER));
        session.setAttribute("CONTACTS_OL_MAP_USER2",getAlignedOLMap(staffId2, DEFAULT_FILTER));
        return new ModelAndView("OLRealignment");
    
    }
    
    private ModelAndView printRealignment(HttpServletRequest request)
    {

 	    HttpSession session = request.getSession(); 
 	    session.removeAttribute("OL_PRINT_LIST1");
        session.removeAttribute("CONTACT_PRINT_LIST1");
        session.removeAttribute("OL_PRINT_LIST2");
        session.removeAttribute("CONTACT_PRINT_LIST2");
        String staffId1 = null != request.getParameter("staffId1") ? request.getParameter("staffId1"):"";
        String staffId2 = null != request.getParameter("staffId2") ? request.getParameter("staffId2"):"";
        String user1 =  null != request.getParameter("user1") ? request.getParameter("user1"):"";
        String user2 =  null != request.getParameter("user2") ? request.getParameter("user2"):"";
        session.setAttribute("USER1", user1);
        session.setAttribute("USER2", user2);
        
        if(null != staffId1 && !"".equals(staffId1)){
     	   Contacts[] contacts = expertListService.getOLList(Long.parseLong(staffId1)) ;
            User[] users = new User[contacts.length];
            for(int i=0;i<contacts.length;i++){
           	 users[i] = userService.getOLForId(contacts[i].getKolId());
            }
            session.setAttribute("OL_PRINT_LIST1",users);
            session.setAttribute("CONTACT_PRINT_LIST1",contacts);
        }
        if(null != staffId2 && !"".equals(staffId2)){
     	   Contacts[] contacts = expertListService.getOLList(Long.parseLong(staffId2)) ;
            User[] users = new User[contacts.length];
            for(int i=0;i<contacts.length;i++){
           	 users[i] = userService.getOLForId(contacts[i].getKolId());
            }
            session.setAttribute("OL_PRINT_LIST2",users);
            session.setAttribute("CONTACT_PRINT_LIST2",contacts);
        }
       return new ModelAndView("realignment_printlist");
    
    }

    private void removeSessions(HttpServletRequest request)
    {
    	HttpSession session= request.getSession();
    	session.removeAttribute("STAFFID");
        session.removeAttribute("STAFFID1");
        session.removeAttribute("STAFFID2");
        session.removeAttribute("USERNAME");
        session.removeAttribute("USERNAME1");
        session.removeAttribute("USERNAME2");
        session.removeAttribute("EMAIL");
        session.removeAttribute("EMAIL1");
        session.removeAttribute("EMAIL2");
        session.removeAttribute("PHONE");
        session.removeAttribute("PHONE1");
        session.removeAttribute("PHONE2");
        session.removeAttribute("OLNAME_WITH_ID");
        session.removeAttribute("CONTACTS_OL_MAP");
        session.removeAttribute("CONTACTS_OL_MAP_USER1");
        session.removeAttribute("CONTACTS_OL_MAP_USER2");
        session.removeAttribute("FILTER_PARAM");
        
    }
    
    public Map getAlignedOLMap(long staffId, String filterParam){
    	Map contactsOLMap = new LinkedHashMap();
    	Contacts[] contactsForStaffId =null;
        if(filterParam.equalsIgnoreCase("All"))
        	contactsForStaffId = expertListService.getAllOLList(staffId);
        else
        	contactsForStaffId = expertListService.getOLList(staffId);
        if(contactsForStaffId!=null && contactsForStaffId.length!=0){
	        UserDetails[] olDetails = null;;
	        List olList = new ArrayList();
	        for(int i=0;i<contactsForStaffId.length;i++){
	        	UserDetails ol =getUserDetails(contactsForStaffId[i].getKolId());
	        	if(ol!= null)
	        		olList.add(ol);

	        }
	        olDetails = (UserDetails[]) olList.toArray(new UserDetails[olList.size()]);
	        Arrays.sort(olDetails);
	        for(int i=0;i<olDetails.length;i++){
	        	for(int j=0;j<contactsForStaffId.length;j++){

	        		if(Long.parseLong(olDetails[i].getId())==contactsForStaffId[j].getKolId()){
	        			contactsOLMap.put(contactsForStaffId[j],olDetails[i]);
	        		}

	        	}
	        }
        }

        return contactsOLMap;
    }
    
       /**
     * Get values a light weight user object. Incremently increase object values if needed. In Contacts table Id is wrongly labeled as KOLID
     * @param kolId
     * @return UserDetails
     */
    private UserDetails getUserDetails(long kolId){
    	User user = userService.getOLForId(kolId);
    	if(user!=null){
	    	logger.debug("Got User for Kolid:"+kolId+ "User Name:"+user.getFirstName()+","+user.getLastName()+"ID:"+user.getId());

	    	UserDetails uDetails = new UserDetails();
	        uDetails.setFirstName(user.getFirstName());
	        uDetails.setLastName(user.getLastName());
	        uDetails.setCompleteName(user.getLastName() + ", "  + user.getFirstName());
	        uDetails.setId(user.getId() + "");
	        logger.debug("User Details are set");
	        return uDetails;
    	}
    	logger.debug("No User For KolId:"+kolId+" Returning Null");
    	return null;
    }

    public void processMoveData(String query1){
      Connection con = null;
      PreparedStatement psmt = null;
      ResultSet rs = null;
      try {
          con = DBUtil.getInstance().createConnection();
          psmt = con.prepareStatement(query1);
          int j = psmt.executeUpdate();
          psmt.close();
          con.commit();

      } catch (SQLException e) {
          try {
              con.rollback();
          } catch (SQLException e1) {
              e1.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
          }
      } catch (Exception e) {
          try {
              con.rollback();
          } catch (SQLException e1) {
              e1.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
          }
      } finally {
          try {
              DBUtil.getInstance().closeDBResources(con, psmt, rs);
          } catch (DataAccessException e) {
              e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
          }
      }

  }
    public IUserService getUserService() {
        return userService;
    }

    public void setUserService(IUserService userService) {
        this.userService = userService;
    }


    public IExpertListService getExpertListService() {
           return expertListService;
       }

       public void setExpertListService(IExpertListService expertListService) {
           this.expertListService = expertListService;
       }


    
}
