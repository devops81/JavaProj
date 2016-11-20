<%@ page language="java" %>
<%@ include file="imports.jsp" %>
<%@ page import="com.openq.authentication.UserDetails" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.contacts.Contacts" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.openq.kol.DBUtil"%>


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
    User[] printList1 = null;
    if (session.getAttribute("OL_PRINT_LIST1") != null) {
        printList1 = (User[]) session.getAttribute("OL_PRINT_LIST1");
    }
    User[] printList2 = null;
    if (session.getAttribute("OL_PRINT_LIST1") != null) {
        printList2 = (User[]) session.getAttribute("OL_PRINT_LIST2");
    }

    Contacts[] contactList1 = null;
    if(session.getAttribute("CONTACT_PRINT_LIST1") != null) {
        contactList1 = (Contacts[]) session.getAttribute("CONTACT_PRINT_LIST1");
    }

    Contacts[] contactList2 = null;
    if(session.getAttribute("CONTACT_PRINT_LIST2") != null) {
        contactList2 = (Contacts[]) session.getAttribute("CONTACT_PRINT_LIST2");
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
    <title>OLAlignment Print</title>
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
                <td class="text-blue-01-bold-head1">Aligned <%=DBUtil.getInstance().doctor%>s of <%=user1%> </td>
            </tr>
        </table>
    </td>
</tr>

<tr>
    <td height="10" align="left" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
            <tr>
                <td width="1%" height="20" valign="top">&nbsp;</td>
                <td width="1%" valign="middle" class="text-blue-01-bold">&nbsp;</td>
                <td width="2%" valign="middle" class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif"
                                                                              width="14" height="14"/></td>
                <td valign="middle" class="text-blue-01-bold" width="20%">Name</td>
                <td valign="middle" class="text-blue-01-bold" width="10%">Email</td>
                <td valign="middle" class="text-blue-01-bold" width="10%">Phone</td>
                <td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>
              	<td valign="middle" class="text-blue-01-bold" width="10%">BeginDate</td>
              	<td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>
              	<td valign="middle" class="text-blue-01-bold" width="10%">EndDate</td>
              	<td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>
              	<td valign="middle" class="text-blue-01-bold" width="10%">Primary Contact</td>
                <td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>

            </tr>
            <tr>
                <td colspan="8" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                 height="1"/></td>
            </tr>
        </table>

        <table width="100%" border="0" cellspacing="0" cellpadding="0">

            <%
                if (printList1 != null && printList1.length > 0) {

                    for (int i = 0; i < printList1.length; i++) {

            %>
            <tr>
                <td width="1%" height="20" valign="top">&nbsp;</td>
                <td width="1%" valign="middle"></td>
                <td width="2%" valign="middle" class="text-blue-01"><img
                        src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"/></td>
                <td valign="middle" class="text-blue-01"
                    width="20%"><%= printList1[i].getLastName() + ", " + printList1[i].getFirstName()%></td>
                <td valign="middle" class="text-blue-01"
                    width="10%"><%=null != printList1[i].getEmail() ? printList1[i].getEmail() : ""%></td>
                <td valign="middle" class="text-blue-01"
                    width="10%"><%=null != printList1[i].getPhone() ? printList1[i].getPhone() : ""%></td>
                <td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>
              		<td valign="middle" class="text-blue-01" width="10%">
              	<%=(new SimpleDateFormat("dd-MMM-yyyy").format(contactList1[i].getBegindate())).toString().toUpperCase()%></td>
                <td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>
              	<td valign="middle" class="text-blue-01" width="10%">
              	<%=(new SimpleDateFormat("dd-MMM-yyyy").format(contactList1[i].getEnddate())).toString().toUpperCase()%></td>
                <td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>
                <td valign="middle" class="text-blue-01" width="10%">
                <% if(contactList1[i].getIsPrimaryContact()!=null && contactList1[i].getIsPrimaryContact().equalsIgnoreCase("true")){%> Y<%} else{%> N <%}%>
                </td>
                <td valign="middle" class="text-blue-01" width="1%">&nbsp;</td>
            </tr>

            <%
                    }
                }
            %>
        </table>
    </td>
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
                <td class="text-blue-01-bold-head1">Aligned <%=DBUtil.getInstance().doctor%>s of <%=user2%></td>
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
                <td width="1%" height="20" valign="top">&nbsp;</td>
                <td width="1%" valign="middle" class="text-blue-01-bold">&nbsp;</td>
                <td width="2%" valign="middle" class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif"
                                                                              width="14" height="14"/></td>
                <td valign="middle" class="text-blue-01-bold" width="25%">Name</td>
                <td valign="middle" class="text-blue-01-bold" width="10%">Email</td>
                <td valign="middle" class="text-blue-01-bold" width="10%">Phone</td>
                <td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>
              	<td valign="middle" class="text-blue-01-bold" width="10%">BeginDate</td>
              	<td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>
              	<td valign="middle" class="text-blue-01-bold" width="10%">EndDate</td>
              	<td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>
              	<td valign="middle" class="text-blue-01-bold" width="10%">Primary Contact</td>
                <td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>

            </tr>
            <tr>
                <td colspan="8" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                 height="1"/></td>
            </tr>
        </table>

        <table width="100%" border="0" cellspacing="0" cellpadding="0">

            <%
                if (printList2 != null && printList2.length > 0) {

                    for (int i = 0; i < printList2.length; i++) {

            %>
            <tr>
                <td width="1%" height="20" valign="top">&nbsp;</td>
                <td width="1%" valign="middle"></td>
                <td width="2%" valign="middle" class="text-blue-01"><img
                        src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"/></td>
                <td valign="middle" class="text-blue-01"
                    width="20%"><%=printList2[i].getLastName() + ", " + printList2[i].getFirstName()%></td>
                <td valign="middle" class="text-blue-01"
                    width="10%"><%=null != printList2[i].getEmail() ? printList2[i].getEmail() : ""%></td>
                <td valign="middle" class="text-blue-01"
                    width="10%"><%=null != printList2[i].getPhone() ? printList2[i].getPhone() : ""%></td>
                <td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>
              	<td valign="middle" class="text-blue-01" width="10%">
              	<%=(new SimpleDateFormat("dd-MMM-yyyy").format(contactList2[i].getBegindate())).toString().toUpperCase()%></td>
                <td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>
              	<td valign="middle" class="text-blue-01" width="10%">
              	<%=(new SimpleDateFormat("dd-MMM-yyyy").format(contactList2[i].getEnddate())).toString().toUpperCase()%></td>
                <td valign="middle" class="text-blue-01-bold" width="1%">&nbsp;</td>
                <td valign="middle" class="text-blue-01" width="10%">
                <% if(contactList2[i].getIsPrimaryContact()!=null && contactList2[i].getIsPrimaryContact().equalsIgnoreCase("true")){%> Y<%} else{%> N <%}%>
                </td>
                <td valign="middle" class="text-blue-01" width="1%">&nbsp;</td>
            </tr>

            <%
                    }
                }
            %>
        </table>
    </td>
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
    session.removeAttribute("OL_PRINT_LIST1");
    session.removeAttribute("OL_PRINT_LIST2");
    session.removeAttribute("CONTACT_PRINT_LIST1");
    session.removeAttribute("CONTACT_PRINT_LIST2");
%>