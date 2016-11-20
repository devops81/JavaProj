<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file = "imports.jsp" %>
<html>
<head>
<title>openQ 2.0 - openQ Technologies Inc.</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">
<%
String currentLink="";
if(session.getAttribute("CURRENT_LINK")!=null){

	currentLink=(String)session.getAttribute("CURRENT_LINK");
	session.removeAttribute("CURRENT_LINK");
}
%>
</head>
<body>
<!-- Menu starts -->

	<table  width="100%" border="0" cellpadding="0" cellspacing="0" >
	 <tr>

	  

	  
 	<% if(currentLink.equals("reportGroupMap")){%>
	  
	  <td width="25%" class="menu-active" align="center">&nbsp;<a id="sec2" href="<%=CONTEXTPATH%>/reportsGroupMap.htm?action=<%=ActionKeys.REPORT_GROUP_MAP%>&groupId=<%=request.getParameter("groupId")%>" class="text-blue-link" >Manage Reports</a>
	  &nbsp;</td>
	<% }else {%>
	  <td width="25%" class="menu-inactive" align="center">&nbsp;<a id="sec2" href="<%=CONTEXTPATH%>/reportsGroupMap.htm?action=<%=ActionKeys.REPORT_GROUP_MAP%>&groupId=<%=request.getParameter("groupId")%>" class="text-blue-link" >Manage Reports</a>
		  &nbsp;</td>
   <% }%>
    <% if(currentLink.equals("reportGroup")){%>
	 
	  <td width="25%" class="menu-active" align="center">&nbsp;<a id="sec3" href="<%=CONTEXTPATH%>/reportsGroupDisplay.htm?action=<%=ActionKeys.REPORT_GROUP%>&groupId=<%=request.getParameter("groupId")%>" class="text-blue-link">Manage Report Groups</a>
	   &nbsp;</td>
	 <% }else {%>
	  <td width="25%" class="menu-inactive" align="center">&nbsp;<a id="sec3" href="<%=CONTEXTPATH%>/reportsGroupDisplay.htm?action=<%=ActionKeys.REPORT_GROUP%>&groupId=<%=request.getParameter("groupId")%>" class="text-blue-link">Manage Report Groups</a>
	   &nbsp;</td>
     <% }%>
 

	 </tr>
  </table>

</body>
</html>

