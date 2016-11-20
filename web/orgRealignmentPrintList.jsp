<%@ page language="java" %>
<%@ include file="imports.jsp" %>
<%@ page import="com.openq.authentication.UserDetails" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.contacts.Contacts" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.openq.eav.org.Organization" %>
<%@ page import="com.openq.orgContacts.OrgContacts" %>


<%
    UserDetails [] users = null;//(UserDetails []) request.getSession().getAttribute(Constants.COMPLETE_USER_NAME);
    //String userName = (String) request.getSession().getAttribute(Constants.COMPLETE_USER_NAME);
%>
<script language="javascript">
    function setParentTextBox(empName, empPhone, empEmal, empId) {
        window.opener.addAttendee(empName, empPhone, empEmal, empId);
    }
</script>
<%
    Map contactsOrgMap1=new LinkedHashMap();
    if(session.getAttribute("CONTACTS_ORG_MAP_USER_PRINT1")!=null){
       contactsOrgMap1=(LinkedHashMap)session.getAttribute("CONTACTS_ORG_MAP_USER_PRINT1");
    }
    Map contactsOrgMap2=new LinkedHashMap();
    if(session.getAttribute("CONTACTS_ORG_MAP_USER_PRINT2")!=null){
       contactsOrgMap2=(LinkedHashMap)session.getAttribute("CONTACTS_ORG_MAP_USER_PRINT2");
    }
    String user1= null;
    if (null != session.getAttribute("USER1")){
        user1 = (String)session.getAttribute("USER1");
    }
    String user2= null;
    if (null != session.getAttribute("USER2")){
        user2 = (String)session.getAttribute("USER2");
    }

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>OrgReAlignment Print</title>
    <link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css"/>
    <style type="text/css">
        <!--
        body {
            margin-left: 0px;
            margin-top: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }

        -->
    </style></head>

<body>
<form name="print" method="post">
<table width="100%">
    <tr align="left" valign="middle">
        <td width="80%" height="5">&nbsp;</td>

        <td align="right" valign="middle">
            <a class="text-blue-01-bold" href="#" onClick="window.close();"><img src="<%=COMMONIMAGES%>/close.gif"
                                                                                 width="16" height="16" border="0"
                                                                                 align="middle">&nbsp;Close</a></td>
        <td width="30"></td>

        <td align="right" valign="middle">
            <a class="text-blue-01-bold" href="#" onClick="window.print();"><img src="<%=COMMONIMAGES%>/print_icon.gif"
                                                                                 width="16" height="16" border="0"
                                                                                 align="middle">&nbsp;Print</a></td>
        <td width="10">&nbsp;</td>
    </tr>
</table>
<tr>
    <td colspan="2" height="2" width="100%" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                             width="1"></td>
</tr>

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
<td width="10">&nbsp;</td>
<td><div>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"/></td>
    <td width="10" rowspan="12" align="left" valign="top">&nbsp;</td>
</tr>
<tr>
    <td height="20" align="left" valign="top">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="15" height="20">&nbsp;</td>
                <!--<td width="25">&nbsp;</td>-->
                <%--<td width="40"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14" /></td>--%>
                <td class="text-blue-01-bold-head1">Aligned Orgs of <%=user1%> </td>
            </tr>
        </table>
    </td>
</tr>

<tr>
    <td height="10" align="left" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
            <tr>
              <td width="2%" valign="middle" class="text-blue-01-bold">&nbsp;</td>
              <td valign="middle" class="text-blue-01-bold" width="25%">Name</td>
              <td valign="middle" class="text-blue-01-bold" width="2%">&nbsp;</td>
              <td valign="middle" class="text-blue-01-bold" width="20%">BeginDate</td>
              <td valign="middle" class="text-blue-01-bold" width="2%">&nbsp;</td>
              <td valign="middle" class="text-blue-01-bold" width="20%">EndDate</td>
              <td valign="middle" class="text-blue-01-bold" width="2%">&nbsp;</td>
              <td valign="middle" class="text-blue-01-bold" width="20%">Primary Contact</td>
			  <td valign="middle" class="text-blue-01-bold" width="2%">&nbsp;</td>

            </tr>
            <tr>
              <td colspan="8" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
            </tr>
          </table>
              <div style="height:250px; overflow:auto;">
                     <table id = "orgAlignmentTable" width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <%int count1=0;
						  if(contactsOrgMap1!=null){
		                      Set keySet=contactsOrgMap1.keySet();
						      Iterator i=keySet.iterator();
						      Organization alignedOrg=null;
							  while(i.hasNext()){
							    Object key = i.next();
							    OrgContacts alignedContact = (OrgContacts)(key);
								alignedOrg=(Organization)contactsOrgMap1.get(key);
		                    	if(count1%2==0){
								%>
									<TR align="left" valign="middle" class="back-white-02-light">
								<%
								}else{
								%>
									<TR align="left" valign="middle" class="back-grey-02-light">
								<% } %>
		  						<TD width="2%" height="25" align="center">&nbsp;</TD>
					 	        <td width="25%"  class="text-blue-01"  align="left">
					 	         	<%= alignedOrg.getName()%>
					 	        </td>
							    <td width="2%" class="text-blue-01" align="left">&nbsp;</td>
							    <td width="20%" class="text-blue-01" align= "left">
							    <%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getBegindate())).toString().toUpperCase()%>
							    </td>
							    <td width="2%" class="text-blue-01" align="left">&nbsp;</td>
							    <td width="20%" class="text-blue-01" align= "left">
							    <%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getEnddate())).toString().toUpperCase()%>
							    </td>
								<td width="2%" class="text-blue-01" align="left">&nbsp;</td>
							    <td width="20%" class="text-blue-01" align="left" id="primaryContact<%=count1%>" name="primaryContact">
				                  <% if(alignedContact.getIsPrimaryContact()!=null && alignedContact.getIsPrimaryContact().equalsIgnoreCase("true")){%> Y<%} else{%> N <%}%>
				                </td>



		  					</TR>
		  					<%
		  					count1++;
		  					}
		  				}
	  					%>
                  </table>
              </div>
</tr>
</tr>
<tr>
    <td height="20" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                                      height="10"></td>
</tr>
<tr>
    <td height="20" align="left" valign="top">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="15" height="20">&nbsp;</td>
                <td class="text-blue-01-bold-head1">Aligned Orgs of <%=user2%></td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td colspan="8" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"/></td>
</tr>
<tr>
    <td height="10" align="left" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
            <tr>

              <td width="2%" valign="middle" class="text-blue-01-bold">&nbsp;</td>
              <td valign="middle" class="text-blue-01-bold" width="25%">Name</td>
              <td valign="middle" class="text-blue-01-bold" width="2%">&nbsp;</td>
              <td valign="middle" class="text-blue-01-bold" width="20%">BeginDate</td>
              <td valign="middle" class="text-blue-01-bold" width="2%">&nbsp;</td>
              <td valign="middle" class="text-blue-01-bold" width="20%">EndDate</td>
              <td valign="middle" class="text-blue-01-bold" width="2%">&nbsp;</td>
              <td valign="middle" class="text-blue-01-bold" width="20%">Primary Contact</td>
			  <td valign="middle" class="text-blue-01-bold" width="2%">&nbsp;</td>

            </tr>
            <tr>
              <td colspan="8" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
            </tr>
          </table>
              <div style="height:250px; overflow:auto;">
                     <table id = "orgAlignmentTable" width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <%int count2=0;
						  if(contactsOrgMap2!=null){
		                      Set keySet=contactsOrgMap2.keySet();
						      Iterator i=keySet.iterator();
						      Organization alignedOrg=null;
							  while(i.hasNext()){
							    Object key = i.next();
							    OrgContacts alignedContact = (OrgContacts)(key);
								alignedOrg=(Organization)contactsOrgMap2.get(key);
		                    	if(count2%2==0){
								%>
									<TR align="left" valign="middle" class="back-white-02-light">
								<%
								}else{
								%>
									<TR align="left" valign="middle" class="back-grey-02-light">
								<% } %>
		  						<TD width="2%" height="25" align="center">&nbsp;</TD>
					 	        <td width="25%"  class="text-blue-01"  align="left">
					 	         	<%= alignedOrg.getName()%>
					 	        </td>
							    <td width="2%" class="text-blue-01" align="left">&nbsp;</td>
							    <td width="20%" class="text-blue-01" align= "left">
							    <%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getBegindate())).toString().toUpperCase()%>
							    </td>
							    <td width="2%" class="text-blue-01" align="left">&nbsp;</td>
							    <td width="20%" class="text-blue-01" align= "left">
							    <%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getEnddate())).toString().toUpperCase()%>
							    </td>
								<td width="2%" class="text-blue-01" align="left">&nbsp;</td>
							    <td width="20%" class="text-blue-01" align="left" id="primaryContact<%=count2%>" name="primaryContact">
				                  <% if(alignedContact.getIsPrimaryContact()!=null && alignedContact.getIsPrimaryContact().equalsIgnoreCase("true")){%> Y<%} else{%> N <%}%>
				                </td>



		  					</TR>
		  					<%
		  					count2++;
		  					}
		  				}
	  					%>
                  </table>
              </div>
</tr>

<tr>
    <td colspan="2" height="2" width="100%" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                             width="1"></td>
</tr>
</table>
<table width="100%">
    <tr align="left" valign="middle">
        <td width="80%" height="5">&nbsp;</td>

        <td align="right" valign="middle">
            <a class="text-blue-01-bold" href="#" onClick="window.close();"><img src="<%=COMMONIMAGES%>/close.gif"
                                                                                 width="16" height="16" border="0"
                                                                                 align="middle">&nbsp;Close</a></td>
        <td width="30"></td>

        <td align="right" valign="middle">
            <a class="text-blue-01-bold" href="#" onClick="window.print();"><img src="<%=COMMONIMAGES%>/print_icon.gif"
                                                                                 width="16" height="16" border="0"
                                                                                 align="middle">&nbsp;Print</a></td>
        <td width="10">&nbsp;</td>
    </tr>
</table>
</td>
</tr>
</table>
</form>
</body>
</html>
<%
   session.removeAttribute("CONTACTS_ORG_MAP_USER_PRINT1");
   session.removeAttribute("CONTACTS_ORG_MAP_USER_PRINT2");
%>