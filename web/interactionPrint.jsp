<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="com.openq.attendee.Attendee" %>
<%@ page import="com.openq.interaction.Interaction" %>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="com.openq.user.User, java.text.SimpleDateFormat"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.interaction.InteractionSearchView" %>

<HTML>
<HEAD>
    <TITLE>openQ 2.0 - openQ Technologies Inc.</TITLE>
    <LINK href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">

    <script language="Javascript">

        function showAddInteraction() {
            var thisform = document.interactionForm;
            thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.PROFILE_SHOW_ADD_INTERACTION%>";
            thisform.target = "_self";
            thisform.submit();
        }

        function editInteraction(interactionId, mode) {
            var thisform = document.interactionForm;
            thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.PROFILE_SHOW_EDIT_INTERACTION%>&interactionId=" + interactionId+"&mode="+mode;
            thisform.target = "_self";
            thisform.submit();
        }

		function deleteInteraction(interactionId) {
            var thisform = document.interactionForm;
            thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.DELETE_INTERACTION%>&interactionId="+interactionId+"&from=olProfile";
            thisform.submit();
        }
    </script>

</HEAD>
<%
    List interactionSearchResultsList = (List) request.getAttribute("KOL_INTERACTIONS");
    String currentLink = null;
    if (null != session.getAttribute("ORG_LINK")){
        currentLink = (String) session.getAttribute("ORG_LINK");
    }
    String prettyPrint = null != request.getParameter("prettyPrint") ? (String) request.getParameter("prettyPrint") : null ;

    if (prettyPrint != null && "true".equalsIgnoreCase(prettyPrint) ) { %>
         <table width="100%"  border="0" cellspacing="0" cellpadding="0">
         <tr>
              <td align="right"><span class="text-blue-01-bold" onclick="javascript:window.close()"><IMG
               height=16 src="images/close.gif" width=16 align=middle
               border=0>&nbsp;Close</span>&nbsp;&nbsp;<span class="text-blue-01-bold" onclick="javascript:window.print()"><img src='images/print_icon.gif' align=middle border=0 height="19"/>&nbsp;Print</span>&nbsp;</td>
         </tr>
         </table>
<%}%>


<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" >

<form name="interactionForm" method="POST" AUTOCOMPLETE="OFF">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">

<td>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">

<tr>
<td align="left" valign="top">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
<td width="10" >&nbsp;</td>
<td >
<div>
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
    <td height="10" align="left" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
            <tr>
               <%-- <td width="1%" height="20" valign="top"></td>
                <td width="3%" valign="middle" class="text-blue-01-bold">&nbsp;</td>
                <td width="1%"></td>
				<td width="4%" valign="middle">&nbsp;</td>--%>
                <td width="1%" height="20"></td>
                <td width="25%" valign="middle" class="text-blue-01-bold">User</td>
                <td width="1%"></td>
                <td width="25%" valign="middle" class="text-blue-01-bold"><%=DBUtil.getInstance().doctor%> / Org </td>
                <td width="1%"></td>
                <td width="24%" valign="middle" class="text-blue-01-bold">Topic</td>
                <td width="1%"></td>
                <td width="19%" valign="middle" class="text-blue-01-bold">Date</td>
                <td width="1%"></td>
            </tr>

        </table>



            <table width="100%" border="0" cellspacing="0" cellpadding="0">

                <%
                if (null != interactionSearchResultsList ) {
                    List interactionSearchResults = ( List ) interactionSearchResultsList.get(1);
                        for (int i = 0; i < interactionSearchResults.size(); i++) {
                            InteractionSearchView interactionSearchResult = ( InteractionSearchView ) interactionSearchResults.get(i);
                %>
                <tr <% if (i % 2 > 0) {%> class="back-grey-02-light" <%}%>>

                   <%-- <td width="1%" height="20" valign="top"></td>
                    <td width="3%" valign="middle" class="text-blue-01">

                    </td>
	                <td width="1%"></td>
					<td width="4%"  valign="middle">
                           </td>--%>
	                <td width="1%" height="20"></td>
                    <td width="25%" valign="middle" class="text-blue-01"><%=interactionSearchResult.getUserName()%></td>
	                <td width="1%"></td>
                    <td width="25%" valign="middle" class="text-blue-01"><%=interactionSearchResult.getAttendeeList()%></td>
	                <td width="1%"></td>
                    <td width="24%" valign="middle"
                        class="text-blue-01"><%=interactionSearchResult.getFirstInteractionTopic()%></td>
	                <td width="1%"></td>
                    <td width="19%" valign="middle" class="text-blue-01">
					<%
						SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
					%>
					<%=sdf.format(interactionSearchResult.getInteractionDate())%>
					</td>
	                <td width="1%"></td>
                </tr>
                <%
                        }
                    } else {
                %>
				<tr>
					<td class="text-blue-01-bold" align="center" height="20"><% if (null != currentLink && currentLink.equalsIgnoreCase("YES")) { %>"No interactions have been entered for this Organization" <%}else{%>"No interactions have been entered for this <%=DBUtil.getInstance().doctor%>" <%}%></td>
				</tr>
				<% } %>
            </table>
        </td>
</tr>

<tr>
    <td height="10" align="left" class="back-white"></td>
</tr>

<tr>
    <td height="10" align="left" valign="top" class="back-white"><img
            src="<%=COMMONIMAGES%>/transparent.gif" width="10"
            height="10"></td>
</tr>
<tr>
    <td height="10" align="left" valign="top"></td>
</tr>
</table>
</div>
</td>

</tr>
</table>
</td>
</tr>


</table>
</td>

</tr>
</table>
</form>
</body>
</html>
