<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file = "header.jsp" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="com.openq.attendee.Attendee" %>
<%@ page import="com.openq.interaction.Interaction" %>
<%@ page import="com.openq.interaction.InteractionSearchView" %>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="com.openq.user.User, java.text.SimpleDateFormat"%>
<%@ page import="com.openq.kol.DBUtil"%>


<HTML>
<HEAD>
    <TITLE>openQ 2.0 - openQ Technologies Inc.</TITLE>
    <LINK href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="./js/sorttable.js"></script>
    <script language="Javascript">

        function showAddInteraction() {
            var thisform = document.kolinteractionForm;
            thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.PROFILE_SHOW_ADD_INTERACTION%>";
            thisform.target = "_self";
            thisform.submit();
        }

        function editInteraction(interactionId, mode) {
            var thisform = document.kolinteractionForm;
            thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.PROFILE_SHOW_EDIT_INTERACTION%>&fromInteractionForThisOL=true&interactionId=" + interactionId+"&mode="+mode;
            thisform.target = "_self";
	        thisform.submit();
        }

		function deleteInteraction(interactionId) {
            var thisform = document.kolinteractionForm;
            thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.DELETE_INTERACTION%>&interactionId="+interactionId+"&from=olProfile";
            thisform.submit();
        } 
    </script>

</HEAD>
<%
    List interactionSearchResultsList = (List) request.getAttribute("KOL_INTERACTIONS");
    String presentLink = null;
    if (null != session.getAttribute("ORG_LINK")){
        presentLink = (String) session.getAttribute("ORG_LINK");
    }
%>
<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" >

<form name="kolinteractionForm" method="POST" AUTOCOMPLETE="OFF">

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
<table width="100%" border="0" cellspacing="0" cellpadding="0" >


<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                   height="10"></td>
    <td width="10" rowspan="16" align="left" valign="top">&nbsp;</td>
</tr>

<tr>
    <td height="20" align="left" valign="top">
    <div class="myexpertlist">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr style="color: rgb(76, 115, 152);">
                <td width="10" height="20">&nbsp;</td>
                <td>
                	<div class="myexperttext"><% if (null != presentLink && presentLink.equalsIgnoreCase("YES")) { %>Org Interactions <%}else{%><%=DBUtil.getInstance().doctor%> Interactions<%}%></div>
                </td>
                <td class="text-white-bold" align="right" width="150" valign="middle">
                   <a class=text-blue-01-link target='_top' href="expertfullprofile.htm?kolid=<%=(String)session.getAttribute(Constants.INTERACTION_PROFILE_KOLID) %>&entityId=<%=session.getAttribute(Constants.INTERACTION_PROFILE_EXPERTID)%>&<%=Constants.CURRENT_KOL_NAME%>=<%=request.getAttribute("kol_name")%>">Back To Profile</a>
                   &nbsp;&nbsp;&nbsp;&nbsp;
                   <a href="<%=CONTEXTPATH%>/searchInteraction.htm?action=<%=ActionKeys.PROFILE_INTERACTION %>&kolid=<%=(String)session.getAttribute(Constants.CURRENT_KOL_ID) %>&expertId=<%=(String) request.getAttribute("EXPERT_ID")%>&prettyPrint=true"
		 			 class="text-white-bold" target="_blank" title="Printer-friendly version of this section"><img src="<%=COMMONIMAGES%>/print_icon.gif" width="16" height="16" border="0"></a>
		  		</td>
            	<td>&nbsp;</td>
            </tr>
        </table>
        </div>
    </td>
</tr>

<tr>
    <td height="10" align="left" class="back-white">
     <div style="height:200px; overflow:auto;">
        <table width="100%"  border="0" cellspacing="0" cellpadding="0" style="background-color:#faf9f2" class="sortable">
            <tr bgcolor="#f5f8f4">
                <td width="1%" height="20" valign="top"></td>
                <td width="3%" valign="middle" class="expertListHeader">&nbsp;</td>
                <td width="1%"></td>                                    
                <td width="4%" valign="middle">&nbsp;</td>
                <td width="1%"></td>                              
                <td width="10%" valign="middle" class="expertListHeader">User</td>
                <td width="1%"></td>
                <td width="11%" valign="middle" class="expertListHeader">Attendee Count</td>
                <td width="2%"></td>
                <td width="20%" valign="middle" class="expertListHeader"><%=DBUtil.getInstance().doctor%> / Org</td>
                <td width="1%"></td>
                <td width="15%" valign="middle" class="expertListHeader">Topic</td>
                <td width="1%"></td>
                <td width="20%" valign="middle" class="expertListHeader sortfirstdesc">Product(s)</td>
                <td width="1%"></td>
                <td width="10%" valign="middle" class="expertListHeader sortfirstdesc">Date</td>
                <td width="1%"></td>
            </tr>
            <%if (null != interactionSearchResultsList ) {
                List interactionSearchResults = ( List ) interactionSearchResultsList.get(1);
                    for (int i = 0; i < interactionSearchResults.size(); i++) {
                        InteractionSearchView interactionSearchResult = ( InteractionSearchView ) interactionSearchResults.get(i);
            %>
                <tr <% if (i % 2 > 0) {%> class="back-grey-02-light" <%}%>>

                    <td width="1%" height="20" valign="top"></td>
                    <td width="3%" valign="middle" class="text-blue-01">
                        <%
                            if (Long.parseLong((String) request.getSession().getAttribute(Constants.USER_ID)) == interactionSearchResult.getUserId()) {
                        %>
                        <a href="javascript:editInteraction(<%=interactionSearchResult.getInteractionId()%>, 'edit')"
                           class="text-blue-01-link">Edit</a>

                        <%
                        } else {
                        %>
						<a href="javascript:editInteraction(<%=interactionSearchResult.getInteractionId()%>, 'view')"
                           class="text-blue-01-link">View</a>
                        <%
                            }
                        %>
                    </td>
	                <td width="1%" height="20" valign="top"></td>
					<td width="4%" valign="middle" class="text-blue-01">
                    <%
                        if (Long.parseLong((String)request.getSession().getAttribute(Constants.USER_ID)) == interactionSearchResult.getUserId()) {
                    %>
                        <a href="javascript:deleteInteraction(<%=interactionSearchResult.getInteractionId()%>)" class="text-blue-01-link">Delete</a>
		            <% } %>
                    </td>
	                <td width="1%"></td>
                    <td width="10%" valign="middle" class="text-blue-01" ><%= interactionSearchResult.getUserName() %></td>
	                <td width="1%"></td>
                    <td width="11%" valign="middle" class="text-blue-01">
                    	<%
                    		long totalAttendeeCount = interactionSearchResult
                    								.getAttendeeCount()
                    								+ interactionSearchResult
                    										.getOtherAttendeeCount();
                    	%>
                    	<%=totalAttendeeCount%>
                    </td>
                    <td width="2%"></td>
                    <td width="20%" valign="middle" class="text-blue-01" ><%=interactionSearchResult
													.getAttendeeList() != null ? interactionSearchResult
											.getAttendeeList()
											: ""%></td>
                    <td width="1%"></td>
                    <td width="15%" valign="middle"
                        class="text-blue-01" ><%=interactionSearchResult
													.getFirstInteractionTopic() != null ? interactionSearchResult
											.getFirstInteractionTopic()
											: ""%></td>
                    <td width="1%"></td>
                    <td width="20%" valign="middle" class="text-blue-01">
                    	<%=interactionSearchResult
											.getProductList()%>
                    </td>
                    <td width="1%"></td>
                    <td width="19%" valign="middle" class="text-blue-01" >
                    <%
                    	SimpleDateFormat sdf = new SimpleDateFormat(
                    							"MM/dd/yyyy");
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
					<td class="text-blue-01-bold" align="center" height="20"><% if (null != presentLink && presentLink.equalsIgnoreCase("YES")) { %>"No interactions have been entered for this Organization" <%}else{%>"No interactions have been entered for this <%=DBUtil.getInstance().doctor%>" <%}%></td>
				</tr>
				<% } %>
            </table>
        </div></td>
</tr>

<tr>
    <td height="10" align="left" class="back-white"></td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                   height="1"></td>
</tr>

<tr>
    <td height="10" align="left" valign="top" class="back-white"><img
            src="<%=COMMONIMAGES%>/transparent.gif" width="10"
            height="10"></td>
</tr>
<tr>
    <td height="10" align="left" valign="top" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">

            <tr>
                <td width="10" height="20">&nbsp;</td>
                <td class="text-blue-01">
         <input name="Submit33" class="button-01"  style="border:0;background : url(images/buttons/add_interaction.gif); width=120; height=22;" value="" type="button" onClick="showAddInteraction()" target="self"></td>
            </tr>

        </table>
    </td>
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
<td width="10" >&nbsp;</td>
</tr>
</table>
</td>
</tr>


</table>
</td>

</tr>
</table>
</form>
<%@ include file="footer.jsp" %>
</body>
</html>
