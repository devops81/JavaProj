<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file = "imports.jsp" %>
<%@page import = "java.util.*"%>

<%
String currentLink = "";
String searchKeyword = "";
String searchInFlag = "";
String searchAction = "";
String advanceSearchFlag = "";
String adChkId = "";

if (request.getAttribute("keyword") != null) {
	searchKeyword = (String) request.getAttribute("keyword");
}

if (request.getAttribute("chkId") != null) {
	searchInFlag = (String) request.getAttribute("chkId");
}

if (request.getAttribute("AdvanceSearch") != null) {
	advanceSearchFlag = (String) request.getAttribute("AdvanceSearch");
}

/*if (advanceSearchFlag != null && "YES".equalsIgnoreCase(advanceSearchFlag)) {
	searchAction=ActionKeys.ADVANCED_EXPERT_SEARCH;
} else {
	searchAction=ActionKeys.EXPERT_SEARCH_HOME;
}*/

if (request.getAttribute("adChkId") != null) {
	adChkId = (String) request.getAttribute("adChkId");
} else {
	adChkId = "false";
}

if (session.getAttribute("CURRENT_LINK_OVID")!=null) {
	currentLink = (String)session.getAttribute("CURRENT_LINK_OVID");

}





%>
   <table width="100%"  border="0" cellspacing="0" cellpadding="0">

    <tr>
     <td height="20" align="left" valign="top" class="back_horz_head"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr align="left" valign="middle">
        <td width="10" height="20">&nbsp;</td>
        <td width="25"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14"></td>
        <td class="text-white-bold">Profile Capture - Ovid Search</td>
      </tr>
     </table></td>
    </tr>

	<tr>
	  <td height="20" align="left" valign="top" class="back-menu">
	   <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	    <tr align="left" valign="middle">

	      <% if(currentLink.equals("Results")){

		  %>
		  	    <td width="7" align="center" class="menu-active"><img src="<%=COMMONIMAGES%>/transparent.gif" width="7" height="7"></td>
		  	    <td width="27" align="left" class="menu-active"><img src="<%=COMMONIMAGES%>/icon_menu_expert_search.gif" width="22" height="20"></td>
		  		<td width="95" class="menu-active"><a href="<%=CONTEXTPATH%>/profileCapture.htm?action=<%=ActionKeys.OVID_RESULTS%>&link=Results" class="text-white-link">Results</a></td>
		  <% } else {%>
			    <td width="7" align="center"><img src="<%=COMMONIMAGES%>/transparent.gif" width="7" height="7"></td>
			    <td width="27" align="left"><img src="<%=COMMONIMAGES%>/icon_menu_expert_search.gif" width="22" height="20"></td>
		  	    <td width="95" class="text-blue-01">
				<a href="<%=CONTEXTPATH%>/profileCapture.htm?action=<%=ActionKeys.OVID_RESULTS%>&link=Results" class="text-black-link">
				  Results</a>
  	      		</td>
	      <% } %>

	      <td width="1" class="back-blue-01-dark"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>

	      <% if(currentLink.equals("Data Sources")){

	      %>

				<td width="7" class="menu-active"><img src="<%=COMMONIMAGES%>/transparent.gif" width="7" height="7"></td>
		      	<td width="30" class="menu-active"><img src="<%=COMMONIMAGES%>/icon_menu_event_search.gif" width="25" height="20"></td>
			  	<td width="95"class="menu-active"><a href="<%=CONTEXTPATH%>/profileCapture.htm?action=<%=ActionKeys.OVID_DATA_SOURCES%>&link=Data Sources" class="text-white-link">Data Sources</a></td>
		  <% } else {%>
	      		<td width="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="7" height="7"></td>
	      		<td width="30" class="text-black-link"><img src="<%=COMMONIMAGES%>/icon_menu_event_search.gif" width="25" height="20"></td>
		  		<td width="95" class="text-blue-01">

				<a href="<%=CONTEXTPATH%>/profileCapture.htm?action=<%=ActionKeys.OVID_DATA_SOURCES%>&link=Data Sources" class="text-black-link">
                  Data Sources</a>
				</td>
  		  <% } %>

   		  <td width="1" class="back-blue-01-dark"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>

	      <% if(currentLink.equals("Ovid Schedule")){

		  %>

		  	    <td width="7" align="center" class="menu-active"><img src="<%=COMMONIMAGES%>/transparent.gif" width="7" height="7"></td>
		  	    <td width="27" align="left" class="menu-active"><img src="<%=COMMONIMAGES%>/icon_menu_expert_search.gif" width="22" height="20"></td>
		  		<td width="95" class="menu-active">
				<a href ="<%=CONTEXTPATH%>/profileCapture.htm?action=<%=ActionKeys.OVID_SCHEDULE%>&link=Ovid Schedule"  class="text-white-link" >
				<!--
				<a href="<%=CONTEXTPATH%>/search.do?action=<%=searchAction%>&link=Expert Search&keyword=<%=searchKeyword%>&chkId=<%=searchInFlag%>&AdvanceSearch=<%=advanceSearchFlag%>" class="text-white-link">-->Schedule</a></td>
		  <% } else {%>
			    <td width="7" align="center"><img src="<%=COMMONIMAGES%>/transparent.gif" width="7" height="7"></td>
			    <td width="27" align="left"><img src="<%=COMMONIMAGES%>/icon_menu_expert_search.gif" width="22" height="20"></td>
		  	    <td width="95" class="text-blue-01">
				<a href ="<%=CONTEXTPATH%>/profileCapture.htm?action=<%=ActionKeys.OVID_SCHEDULE%>&link=Ovid Schedule"  class="text-black-link">
				  <!--
		          <a href="<%=CONTEXTPATH%>/search.do?action=<%=searchAction%>&link=Expert Search&keyword=<%=searchKeyword%>&chkId=<%=searchInFlag%>&AdvanceSearch=<%=advanceSearchFlag%>" class="text-black-link">-->Schedule</a>
  	      		</td>
	      <% } %>

          <td width="1" class="back-blue-01-dark"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
	      <td>&nbsp;</td>
        </tr>
       </table>
      </td>
     </tr>
	 <!--
     <tr>
       <td height="20" align="left" valign="top" class="back-blue-02-light"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
     </tr>
     -->
    </table>
<%
    session.removeAttribute("CURRENT_LINK");
%>