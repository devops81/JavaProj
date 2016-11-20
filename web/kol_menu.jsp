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
//out.print("currentLink " + currentLink);
%>
<script language="JavaScript" type="text/JavaScript">
function brandObjectives() {
 	var thisform = document.KOLStrategy;
	thisform.action = "<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_BRAND_OBJECTIVES%>&link=brandObjectives";
	thisform.target = "_self";
	thisform.submit();	
}
function setSegmentation() {
 	var thisform = document.KOLStrategy;
	thisform.action = "<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_SET_SEGMENT%>&link=setSegmentation";
	thisform.target = "_self";
	thisform.submit();	
}
function keyMessages() {
 	var thisform = document.KOLStrategy;
	thisform.action = "<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_KEY_MESSAGE%>&link=keyMessage";
	thisform.target = "_self";
	thisform.submit();	
}
function tactics() {
 	var thisform = document.KOLStrategy;
	thisform.action = "<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_TACTICS%>&link=tactics";
	thisform.target = "_self";
	thisform.submit();	
}
function createNewNode() {
	var thisform = document.KOLStrategy;
	thisform.action = "<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_NEW_NODE_PAGE%>&link=createNode";
	thisform.target = "_self";
	thisform.submit();	
}
function objectives() {
 	var thisform = document.KOLStrategy;
	thisform.action = "<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_OBJECTIVES%>&link=objectives";
	thisform.target = "_self";
	thisform.submit();	
}
function mainObjectives() {
	var thisform = document.KOLStrategy;
	thisform.action = "<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_MAIN_OBJECTIVES%>&link=MainObjectives";
	thisform.target = "_self";
	thisform.submit();
}

</script>

</head>
<body>
<!-- Menu starts -->

	<table  width="100%" border="0" cellpadding="0" cellspacing="0" >
	 <tr>

	  <% if(currentLink.equals("MainObjectives")){%>
	 
	  <td width="25%" class="menu-active" align="center">&nbsp;<a id="sec3" onClick="javascript:mainObjectives()" href="<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_MAIN_OBJECTIVES%>" class="text-blue-link">Main Objectives</a>
	   &nbsp;</td>
	 <% }else {%>
	  <td width="25%" class="menu-inactive" align="center">&nbsp;<a id="sec3" onClick="javascript:mainObjectives()" href="<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_MAIN_OBJECTIVES%>" class="text-blue-link">Main Objectives</a>
	   &nbsp;</td>
     <% }%>

	  
   <% if ((session.getAttribute("segmentlevel")) != null && 
	   session.getAttribute("segmentlevel").equals("last")) {
	%>
   <% if(currentLink.equals("setSegmentation")){%>
	  <td width="25%" class="menu-active"  align="center">&nbsp;
	   <a id="sec0" onClick="javascript:setSegmentation()" href="<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_SET_SEGMENT%>"
	    class="text-blue-link">Create Segments</a>
	   &nbsp;
	  </td>
   <% }else {%>
	  <td width="25%" class="menu-inactive"  align="center">&nbsp;
	   <a id="sec0" onClick="javascript:setSegmentation()" href="<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_SET_SEGMENT%>"
	    class="text-blue-link">Create Segments</a>
	   &nbsp;
	  </td>
   <% }%>

  
  <% } else { 
		 if(currentLink.equals("createNode")){ %>	 
			<td width="25%" class="menu-active" align="center">
				<a id="sec3" onClick="javascript:createNewNode()" href="<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_NEW_NODE_PAGE%>" class="text-blue-link" >Create Segments</a>
			</td> 
	    <% }else {%>
		 <td width="25%" class="menu-inactive" align="center">
			<a id="sec3" onClick="javascript:createNewNode()" href="<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_NEW_NODE_PAGE%>" class="text-blue-link" >Create Segments</a>
		 </td> 
     <% }%>
   <% } %>

  

  <%-- <% if(currentLink.equals("keyMessage")){%>
	 
	  <td width="25%" class="menu-active" align="center">&nbsp;<a id="sec1" onClick="javascript:keyMessages()" href="<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_KEY_MESSAGE%>" class="text-blue-link">Key Messages</a>
	   &nbsp;</td>
   <% }else {%>
	  <td width="25%" class="menu-inactive" align="center">&nbsp;<a id="sec1" onClick="javascript:keyMessages()" href="<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_KEY_MESSAGE%>" class="text-blue-link">Key Messages</a>
	   &nbsp;</td>
   <% }%>

 --%>

	<% if(currentLink.equals("tactics")){%>
	  
	  <td width="25%" class="menu-active" align="center">&nbsp;<a id="sec2" onClick="javascript:tactics()" href="<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_TACTICS%>" class="text-blue-link" >Tactics</a>
	  &nbsp;</td>
	<% }else {%>
	  <td width="25%" class="menu-inactive" align="center">&nbsp;<a id="sec2" onClick="javascript:tactics()" href="<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_TACTICS%>" class="text-blue-link" >Tactics</a>
		  &nbsp;</td>
   <% }%>
    
   <% if(currentLink.equals("brandObjectives")){%>
	  <td width="25%" class="menu-active"  align="center">&nbsp;
	   <a id="sec0" onClick="javascript:brandObjectives()" href="<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_BRAND_OBJECTIVES%>"
	    class="text-blue-link">Summary</a>
	   &nbsp;
	  </td>
   <% }else {%>
	  <td width="25%" class="menu-inactive"  align="center">&nbsp;
	   <a id="sec0" onClick="javascript:brandObjectives()" href="<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_BRAND_OBJECTIVES%>"
	    class="text-blue-link">Summary</a>
	   &nbsp;
	  </td>
   <% }%>   


	 </tr>
  </table>

</body>
</html>

<%
session.removeAttribute("segmentlevel");
%>