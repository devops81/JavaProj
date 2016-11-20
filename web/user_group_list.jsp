<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp" %>
<%@ page import="com.openq.group.Groups" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%

    Groups[] groupInfo = null;
    if (session.getAttribute("ALL_USER_GROUPS") != null) {
        groupInfo = (Groups[]) session.getAttribute("ALL_USER_GROUPS");
    }

%>
<html>
<head>
    <title><%=DBUtil.getInstance().doctor%> DNA 2.0 - openQ Technologies</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">
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

</head>

<body>
<form name="groupsListForm" method="Post">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <%
            if (groupInfo != null && groupInfo.length > 0) {
                Groups groups = null;
                for (int i = 0; i < groupInfo.length; i++) {
                    groups = groupInfo[i];

        %>
		<tr bgcolor='<%=(i%2==0?"#fafbf9":"#f5f8f4")%>'>
            <td width="25" height="20" align="center" valign="middle"><input type="checkbox" name="checkedGroups"
                                                                             value="<%=groups.getGroupId()%>"></td>
            <td width="25"><img src="<%=COMMONIMAGES%>/icon_attendees.gif" width="14" height="14"></td>
            <td class="text-blue-01"><%=groups.getGroupName()%></td>
        </tr>
        <% }
        }
        %>
    </table>
</form>
<%
    session.removeAttribute("ALL_USER_GROUPS");
%>
</body>
</html>
