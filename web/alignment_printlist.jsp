<%@ page language="java" %>
<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.authentication.UserDetails"%>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="com.openq.contacts.Contacts"%>
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
    User[] printList = null;
    if(session.getAttribute("OL_PRINT_LIST") != null) {
        printList = (User[]) session.getAttribute("OL_PRINT_LIST");
    }
    String userName = null;
    if (null != session.getAttribute("USERNAME")){
        userName = (String)session.getAttribute("USERNAME");
    }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>OLAlignment Print</title>
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css" />
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
			<a class="text-blue-01-bold" href="#" onClick="window.close();"><img src="<%=COMMONIMAGES%>/close.gif" width="16" height="16" border="0" align="middle">&nbsp;Close</a> </td>
			<td width="30"></td>

			<td align="right" valign="middle">
			<a class="text-blue-01-bold" href="#" onClick="window.print();"><img src="<%=COMMONIMAGES%>/print_icon.gif" width="16" height="16" border="0" align="middle">&nbsp;Print</a> </td>
			<td width="10">&nbsp;</td>
		</tr>
	</table>
<tr>
    <td colspan="2" height="2"  width="100%" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"></td>
</tr>

<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="10">&nbsp;</td>
    <td ><div>
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
          <td width="10" rowspan="12" align="left" valign="top">&nbsp;</td>
        </tr>
        <tr>
          <td height="20" align="left" valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
              <td width="15" height="20">&nbsp;</td>
               <td class="text-blue-01-bold-head1">Aligned <%=DBUtil.getInstance().doctor%>s of <%=userName%> </td>
            </tr>
          </table></td>
        </tr>

        <tr>
          <td height="10" align="left" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
        <tr>
              <td width="15" height="20" valign="top">&nbsp;</td>
              <td width="25" valign="middle" class="text-blue-01-bold">&nbsp;</td>
              <td width="40" valign="middle" class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
              <td valign="middle" class="text-blue-01-bold" width="200">Name</td>
              <td valign="middle" class="text-blue-01-bold" width="100">Email</td>
              <td valign="middle" class="text-blue-01-bold" width="100">Phone</td>
              <td valign="middle" class="text-blue-01-bold" width="100">&nbsp;</td>

            </tr>
            <tr>
              <td colspan="8" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
            </tr>
          </table>
              <div style="height:200px; overflow:auto;">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">

                      <%
                          if (printList != null && printList.length > 0) {

                              for (int i = 0; i < printList.length; i++) {

                      %>
                      <tr>
                          <td width="15" height="20" valign="top">&nbsp;</td>
                          <td width="25" valign="middle"></td>
                          <td width="45" valign="middle" class="text-blue-01"><img
                                  src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"/></td>
                          <td valign="middle" class="text-blue-01"
                              width="200"><%=printList[i].getLastName() +", "+ printList[i].getFirstName()%>
                          <td valign="middle" class="text-blue-01"
                              width="100"><%=null != printList[i].getEmail() ? printList[i].getEmail() : ""%>
                          <td valign="middle" class="text-blue-01"
                              width="100"><%=null != printList[i].getPhone() ? printList[i].getPhone() : ""%>
                          <td valign="middle" class="text-blue-01" width="100">&nbsp;</td>
                      </tr>

                      <%
                              }
                          }
                      %>
                  </table>
              </div></td>
        </tr>
   <tr>
    <td colspan="2" height="2"  width="100%" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"></td>
</tr>
   </table>
        <table width="100%">
		<tr align="left" valign="middle">
			<td width="80%" height="5">&nbsp;</td>

			<td align="right" valign="middle">
			<a class="text-blue-01-bold" href="#" onClick="window.close();"><img src="<%=COMMONIMAGES%>/close.gif" width="16" height="16" border="0" align="middle">&nbsp;Close</a> </td>
			<td width="30"></td>

			<td align="right" valign="middle">
			<a class="text-blue-01-bold" href="#" onClick="window.print();"><img src="<%=COMMONIMAGES%>/print_icon.gif" width="16" height="16" border="0" align="middle">&nbsp;Print</a> </td>
			<td width="10">&nbsp;</td>
		</tr>
	</table>
    </td>
  </tr>
</table>
</form>
</body>
</html>
<% session.removeAttribute("OL_PRINT_LIST");%>