package com.openq.web.controllers;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.contacts.Contacts;
import com.openq.eav.expert.IExpertListService;
import com.openq.eav.org.IOrganizationService;
import com.openq.eav.org.Organization;
import com.openq.kol.DBUtil;
import com.openq.kol.DataAccessException;
import com.openq.orgContacts.IOrgContactsService;
import com.openq.orgContacts.OrgContacts;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.web.ActionKeys;

/**
 * Created by IntelliJ IDEA.
 * User: radhikav
 * Date: Dec 11, 2006
 * Time: 5:18:35 PM
 * To change this template use File | Settings | File Templates.
 */
public class OrgAlignmentController extends AbstractController {

    IOrgContactsService orgContactsService;
    IExpertListService expertListService;
    IOrganizationService orgService;

    IUserService userService;
    private static final String ENDDATE = "contact.endDate";
    private static final String PROPERTIES_FILE = "resources/ServerConfig.properties";
    final String DEFAULT_FILTER = "Current Only";
    final String DEFAULT_FILTER_ALL = "All";
    


    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
        logger.debug("inside org alignment controller");
        HttpSession session = request.getSession();
        session.setAttribute("CURRENT_LINK","OrgAlignment");
        String action = request.getParameter("action");
        String fromOrgAlignment = null;
        if (null != request.getParameter("fromOrgAlignment")){
          fromOrgAlignment = request.getParameter("fromOrgAlignment");
          session.setAttribute("fromOrgAlignment",fromOrgAlignment);
        }
        String filterParam = null;
        filterParam = (String) request.getParameter("filterRadio");


        Properties p = DBUtil.getInstance().getDataFromPropertiesFile(
				PROPERTIES_FILE);
        Date date = new Date(System.currentTimeMillis());
    	SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
    	SimpleDateFormat dateFormatForCalendar = new SimpleDateFormat("MM/dd/yyyy");
    	String presentDate = (dateFormatForCalendar.format(date)).toString();
    	Date beforeDate = new Date(System.currentTimeMillis() - 24*60*60*1000);
    	String previousDate = dateFormat.format(beforeDate);
    	Date tomorrow = new Date(System.currentTimeMillis() + 24*60*60*1000);
    	String nextDate = dateFormat.format(tomorrow);
    	session.setAttribute("CONTACT_END_DATE",p.getProperty(ENDDATE));
        session.setAttribute("CONTACT_PRESENT_DATE",presentDate);
        session.setAttribute("CONTACT_NEXT_DATE",nextDate);
        session.setAttribute("CONTACT_PREVIOUS_DATE",previousDate);
        session.setAttribute("FILTER_PARAM", filterParam);

        if(ActionKeys.RESET_ORG_ALIGN.equalsIgnoreCase(action)){
        	session.removeAttribute("STAFFID");
            session.removeAttribute("USERNAME");
            session.removeAttribute("EMAIL");
            session.removeAttribute("PHONE");
            session.removeAttribute("ORGNAME_WITH_ID");
            session.removeAttribute("CONTACTS_ORG_MAP");
            session.removeAttribute("FILTER_PARAM");
            return new ModelAndView("orgAlignment");
        }


        if(ActionKeys.RESET_ORG_REALIGN.equalsIgnoreCase(action)){
        	long staffId1 = (null != request.getParameter("staffId1") && "" != request.getParameter("staffId1").toString())? Long.parseLong(request.getParameter("staffId1")) : 0;
            long staffId2 = (null != request.getParameter("staffId2") && "" != request.getParameter("staffId2").toString())? Long.parseLong(request.getParameter("staffId2")) : 0;
            session.setAttribute("CONTACTS_ORG_MAP_USER1",orgContactsService.getOrgContactsMapForStaffId(staffId1, DEFAULT_FILTER));
            session.setAttribute("CONTACTS_ORG_MAP_USER2",orgContactsService.getOrgContactsMapForStaffId(staffId2, DEFAULT_FILTER));
            return new ModelAndView("orgRealignment");
        }
        //Get for all the ORGs in the contact table for User with this particular StaffId
        if(ActionKeys.GET_ORGS.equalsIgnoreCase(action)){
        	logger.info("Getting Orgs For StaffId");
        	ModelAndView mav = new ModelAndView("orgAlignment");
            long staffId = 0;
            Map contactsOrgMap = new LinkedHashMap();
            if (null != request.getParameter("staffId")) {
                staffId = Long.parseLong((String) request.getParameter("staffId"));
                User[] alignedUser = userService.getUserForStaffId(staffId+"");
                logger.debug("aligneduser="+alignedUser);
                if(alignedUser!=null && alignedUser.length!=0){
                	logger.debug("aligneduser.length="+alignedUser.length);
                	logger.debug("aligneduser.getstaffid="+alignedUser[0].getStaffid());
                	logger.debug("aligneduser.name="+alignedUser[0].getLastName()+", "+alignedUser[0].getFirstName());
                	session.setAttribute("ALIGNED_USER",alignedUser[0]);
                	session.setAttribute("STAFFID", alignedUser[0].getStaffid());
					session.setAttribute("USERNAME", alignedUser[0].getLastName()+", "+alignedUser[0].getFirstName());
					session.setAttribute("EMAIL", alignedUser[0].getEmail());
					session.setAttribute("PHONE", alignedUser[0].getPhone());
                }
                if(request.getParameter("table")!=null){
                	String list1[] = null;
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

                    contactsOrgMap = orgContactsService.getOrgContactsMapForStaffId(staffId, DEFAULT_FILTER);
                    if(request.getParameter("table").equalsIgnoreCase("1")){
                		session.setAttribute("CONTACTS_ORG_MAP_USER1",contactsOrgMap);
                		session.setAttribute("ALIGNED_USER1",alignedUser[0]);

                	}else if(request.getParameter("table").equalsIgnoreCase("2")){
                		session.setAttribute("CONTACTS_ORG_MAP_USER2",contactsOrgMap);
                		session.setAttribute("ALIGNED_USER2",alignedUser[0]);

                	}
                	return new ModelAndView("orgRealignment");
                }
                contactsOrgMap = orgContactsService.getOrgContactsMapForStaffId(staffId, filterParam);
                session.setAttribute("CONTACTS_ORG_MAP",contactsOrgMap);

            }
            return mav;
        }
       if(ActionKeys.ADD_ORG_TO_ALIGNMENT.equalsIgnoreCase(action)){

         if (null != request.getParameter("fromOrgAlignment")){
          fromOrgAlignment = request.getParameter("fromOrgAlignment");
          session.setAttribute("fromOrgAlignment",fromOrgAlignment);
        }

         String[] strOrgIds = null;
         if (request.getParameterValues("orgSegmentId") != null) {
         	strOrgIds= request.getParameterValues("orgSegmentId");
         }
           ArrayList finalList = new ArrayList();
           ArrayList tempArr = new ArrayList();
           //session.setAttribute("IDS", ids);
           HashSet  tmpSet = new HashSet();
           if (null != session.getAttribute("ORGNAME_WITH_ID")){
            ArrayList orgList = (ArrayList)session.getAttribute("ORGNAME_WITH_ID");
             if (null != orgList && orgList.size() >0){
                    tempArr.addAll(orgList);
             }
           }
           ArrayList Orgdata = new ArrayList();
           if (null != strOrgIds) {
               Organization org[] = new Organization[strOrgIds.length];
               for (int i = 0; i < strOrgIds.length; i++) {
                   if (null != strOrgIds[i]) {
                       org[i] = orgService.getOrganizationByid(Long.parseLong(strOrgIds[i]));
                       Orgdata.add(org[i].getEntityId()+"/"+org[i].getName());

                   }
               }
           }
           if(tempArr.size()>0)  {
            tmpSet.addAll(tempArr);
           }
           if(Orgdata.size() > 0) {
             tmpSet.addAll(Orgdata);
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

           session.setAttribute("ORGNAME_WITH_ID",finalList);
           return new ModelAndView("orgAlignment");

       }else if(ActionKeys.ORGREALIGNMENT.equalsIgnoreCase(action)){
            session.removeAttribute("USER1");
            session.removeAttribute("USER2");

             return new ModelAndView("orgRealignment");
       }else if(ActionKeys.SAVE_ORGS.equalsIgnoreCase(action)){
           session.removeAttribute("ORGNAME_WITH_ID");

           User user = new User();

           String ids[] = null;
           String primaryContactsFlags[] = null;
           String contactEndDate[]=null;
           String contactBeginDate[]=null;
           String contactIds[] = null;
           if (null != request.getParameterValues("alignedOrgs")){
              ids = request.getParameterValues("alignedOrgs");
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
           }
           if (null != request.getParameterValues("contactEndDate")){
        	   contactEndDate = request.getParameterValues("contactEndDate");
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
               OrgContacts[] contactsList = new OrgContacts[ids.length];
               for (int i = 0; i < ids.length; i++) {
                   if (null != ids[i]) {
                        OrgContacts contact = new OrgContacts();

                           contact.setContactName(userName);
                           contact.setEmail(email);
                           contact.setStaffid(staffId);
                           contact.setPhone(phone);
                           contact.setOrgId(Long.parseLong(ids[i]));
                           try
                           {
                           contact.setBegindate(dateFormat.parse(contactBeginDate[i]));
                           }
                           catch(Exception e)
                           {
                           contact.setBegindate(dateFormatForCalendar.parse(contactBeginDate[i]));	   
                           }
                           try
                           {
                           contact.setEnddate(dateFormat.parse(contactEndDate[i]));
                           }
                           catch(Exception e)
                           {
                           contact.setEnddate(dateFormatForCalendar.parse(contactEndDate[i]));	   
                           }
                           contact.setOrgContactsId(Long.parseLong(contactIds[i]));
                           contactsList[i] = contact;

                   }

               }
                orgContactsService.updateOrgContactList(staffId, contactsList);

           }else{
                OrgContacts[] contacts = orgContactsService.getOrgContactsList(staffId);
               if (null != contacts)
                for(int i=0;i<contacts.length ;i++){
                    orgContactsService.deleteOrgContact(contacts[i]);
                }
           }
           session.setAttribute("CONTACTS_ORG_MAP",orgContactsService.getOrgContactsMapForStaffId(staffId,filterParam));
           return new ModelAndView("orgAlignment");
       }else if(ActionKeys.SAVE_REALIGNMENT_ORGS.equalsIgnoreCase(action)){

    	   String ids1[] = null;
           String primaryContactsFlags1[] = null;
           String contactEndDate1[]=null;
           String contactBeginDate1[]=null;
           String contactIds1[] = null;
           String ids2[] = null;
           String primaryContactsFlags2[] = null;
           String contactEndDate2[]=null;
           String contactBeginDate2[]=null;
           String contactIds2[] = null;
           if (null != request.getParameterValues("alignedOrgsTable1")){
              ids1 = request.getParameterValues("alignedOrgsTable1");
           }
           if (null != request.getParameterValues("alignedOrgsTable2")){
               ids2 = request.getParameterValues("alignedOrgsTable2");
            }
           if (null != request.getParameterValues("hiddenPrimaryContactFlagValueTable1")){
        	   primaryContactsFlags1 = request.getParameterValues("hiddenPrimaryContactFlagValueTable1");
            }
           if (null != request.getParameterValues("hiddenPrimaryContactFlagValueTable2")){
        	   primaryContactsFlags2 = request.getParameterValues("hiddenPrimaryContactFlagValueTable2");
            }
           long staffId = 0;
           if (null != request.getParameterValues("contactBeginDateTable1")){
        	   contactBeginDate1 = request.getParameterValues("contactBeginDateTable1");
           }
           if (null != request.getParameterValues("contactBeginDateTable2")){
        	   contactBeginDate2 = request.getParameterValues("contactBeginDateTable2");
           }
           if (null != request.getParameterValues("contactEndDateTable1")){
        	   contactEndDate1 = request.getParameterValues("contactEndDateTable1");
           }
           if (null != request.getParameterValues("contactEndDateTable2")){
        	   contactEndDate2 = request.getParameterValues("contactEndDateTable2");
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
               logger.debug("No Of Orgs in Contact1:"+ids1.length);
               logger.debug("No of pimarycontact flags in table1:"+primaryContactsFlags1.length);
        	   OrgContacts[] contactsList1 = new OrgContacts[ids1.length];
               for (int i = 0; i < ids1.length; i++) {
                   if (null !=ids1[i]) {
                       OrgContacts contact = new OrgContacts();
                       contact.setContactName(user1);
                       contact.setEmail(email1);
                       contact.setStaffid(staffId1);
                       contact.setPhone(phone1);
                       contact.setOrgId(Long.parseLong(ids1[i]));
                       logger.debug("For Id:"+ids1[i]+" Primary Contact Flag is:"+primaryContactsFlags1[i]);
                       if(primaryContactsFlags1[i].equalsIgnoreCase("Y"))
                    	   contact.setIsPrimaryContact("true");
                       else
                    	   contact.setIsPrimaryContact("false");
                       try
                       {
                       contact.setBegindate(dateFormat.parse(contactBeginDate1[i]));
                       }
                       catch(Exception e)
                       {
                       contact.setBegindate(dateFormatForCalendar.parse(contactBeginDate1[i]));	   
                       }
                       try
                       {
                       contact.setEnddate(dateFormat.parse(contactEndDate1[i]));
                       }
                       catch(Exception e)
                       {
                        contact.setEnddate(dateFormatForCalendar.parse(contactEndDate1[i]));
                       }
                       contact.setOrgContactsId(Long.parseLong(contactIds1[i]));

                       contactsList1[i] = contact;

                   }
               }
               orgContactsService.updateOrgContactList(staffId1, contactsList1);
           } else {
               OrgContacts[] contacts = orgContactsService.getOrgContactsList(staffId1);
               if (null != contacts) for (int i = 0; i < contacts.length; i++) {
        	   orgContactsService.deleteOrgContact(contacts[i]);
               }
           }
           // for the second list
           if (null != ids2) {
        	   logger.debug("No Of Orgs in Contact2:"+ids2.length);
               logger.debug("No of pimarycontact flags in table1:"+primaryContactsFlags2.length);

        	   OrgContacts[] contactsList2 = new OrgContacts[ids2.length];
               for (int i = 0; i < ids2.length; i++) {
                   if (null != ids2[i]) {
                      OrgContacts contact = new OrgContacts();
                       contact.setContactName(user2);
                       contact.setEmail(email2);
                       contact.setStaffid(staffId2);
                       contact.setPhone(phone2);
                       contact.setOrgId(Long.parseLong(ids2[i]));
                       logger.debug("For Id:"+ids2[i]+" Primary Contact Flag is:"+primaryContactsFlags2[i]);
                       if(primaryContactsFlags2[i].equalsIgnoreCase("Y"))
                    	   contact.setIsPrimaryContact("true");
                       else
                    	   contact.setIsPrimaryContact("false");
                       try
                       {
                       contact.setBegindate(dateFormat.parse(contactBeginDate2[i]));
                       }
                       catch(Exception e)
                       {
                    	   contact.setBegindate(dateFormatForCalendar.parse(contactBeginDate2[i]));	   
                       }
                       
                       try
                       {
                    	   contact.setEnddate(dateFormat.parse(contactEndDate2[i]));   
                       }
                       catch(Exception e)
                       {
                    	   contact.setEnddate(dateFormatForCalendar.parse(contactEndDate2[i]));
                       }
                       contact.setOrgContactsId(Long.parseLong(contactIds2[i]));
                       contactsList2[i] = contact;

                   }
               }
               orgContactsService.updateOrgContactList(staffId2, contactsList2);
           }else{
                OrgContacts[] contacts = orgContactsService.getOrgContactsList(staffId2);
               if (null != contacts) for (int i = 0; i < contacts.length; i++) {
                   orgContactsService.deleteOrgContact(contacts[i]);
               }
           }
           session.setAttribute("CONTACTS_ORG_MAP_USER1",orgContactsService.getOrgContactsMapForStaffId(staffId1, DEFAULT_FILTER));
           session.setAttribute("CONTACTS_ORG_MAP_USER2",orgContactsService.getOrgContactsMapForStaffId(staffId2, DEFAULT_FILTER));

           return new ModelAndView("orgRealignment");

       }else if(ActionKeys.ORG_ALIGNMENT_PRINT.equalsIgnoreCase(action)){
           String staffId = null != request.getParameter("staffId") ? request.getParameter("staffId"):"";
           String userName = null != request.getParameter("userName") ? request.getParameter("userName"):"";
           session.setAttribute("USERNAME",userName);
           if(null != staffId && !"".equals(staffId)){
        	   session.setAttribute("CONTACTS_ORG_MAP_USER_PRINT",orgContactsService.getOrgContactsMapForStaffId(Long.parseLong(staffId), DEFAULT_FILTER));
       }
          return new ModelAndView("orgAlignmentPrint");
       }else if(ActionKeys.ORG_REALIGNMENT_PRINT.equalsIgnoreCase(action) ){
           String staffId1 = null != request.getParameter("staffId1") ? request.getParameter("staffId1"):"";
           String staffId2 = null != request.getParameter("staffId2") ? request.getParameter("staffId2"):"";
           String user1 =  null != request.getParameter("user1") ? request.getParameter("user1"):"";
           String user2 =  null != request.getParameter("user2") ? request.getParameter("user2"):"";
           session.setAttribute("USER1", user1);
           session.setAttribute("USER2", user2);

           if(null != staffId1 && !"".equals(staffId1)){
        	   session.setAttribute("CONTACTS_ORG_MAP_USER_PRINT1",orgContactsService.getOrgContactsMapForStaffId(Long.parseLong(staffId1), DEFAULT_FILTER));

           }
           if(null != staffId2 && !"".equals(staffId2)){
        	   session.setAttribute("CONTACTS_ORG_MAP_USER_PRINT2",orgContactsService.getOrgContactsMapForStaffId(Long.parseLong(staffId2), DEFAULT_FILTER));
                          }
          return new ModelAndView("orgRealignmentPrintList");
       }
       /* if (null != session.getAttribute("STAFFID")){
            String staffId = (String)session.getAttribute("STAFFID");
            return new ModelAndView("forward:OLAlignment.htm?action="+ActionKeys.KOL_ADD_EXPERTS);
        }
*/
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
       session.removeAttribute("ORGNAME_WITH_ID");
       session.removeAttribute("CONTACTS_ORG_MAP");
       session.removeAttribute("CONTACTS_ORG_MAP_USER1");
       session.removeAttribute("CONTACTS_ORG_MAP_USER2");
       ModelAndView mav = new ModelAndView("orgAlignment");
       return mav;
    }


    public IUserService getUserService() {
        return userService;
    }

    public void setUserService(IUserService userService) {
        this.userService = userService;
    }



    public void processMoveData(String query1){
      Connection con = null;
      PreparedStatement psmt = null;
      ResultSet rs = null;
      try {
          con = DBUtil.getInstance().createConnection();

      /*    psmt = con.prepareStatement(query);
          int i = psmt.executeUpdate();
          psmt.close();*/

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


	public IOrgContactsService getOrgContactsService() {
		return orgContactsService;
	}


	public void setOrgContactsService(IOrgContactsService orgContactsService) {
		this.orgContactsService = orgContactsService;
	}


	public IOrganizationService getOrgService() {
	    return orgService;
	}


	public void setOrgService(IOrganizationService orgService) {
	    this.orgService = orgService;
	}
}
