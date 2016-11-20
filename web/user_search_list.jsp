<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%
	 User[] userList = null;
	 ArrayList engagedUserIds = null;
	 
	 if (session.getAttribute("USER_SEARCH_LIST") != null)
	 {
	 	userList = (User[])session.getAttribute("USER_SEARCH_LIST");
	 }	
	 
	 if (session.getAttribute("USER_ENAGAGED_LIST") != null)
	 {
	 	engagedUserIds = (ArrayList)session.getAttribute("USER_ENAGAGED_LIST");
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
<script type="text/javascript" src="./js/sorttable.js"></script>
</head>

<body>
<form name="listUsersForm" method="post">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="sortable">
<tr align="left" valign="middle">
                <td width="25" height="25" align="center">
                    <!--<input type="checkbox" name="checkUser" value="checked" title="Select or deselect all users" onClick="javascript:checkUncheck(this.form)">--></td>
                <td width="25" align="left"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td class="text-blue-01-bold">User Name </td>
            </tr>
  <%
    if (userList != null && userList.length > 0)
    {
        User user = null;
        for (int i=0;i<userList.length;i++)
    	{
        	user = userList[i];
  %>      	
  <tr bgcolor='<%=(i%2==0?"#fafbf9":"#f5f8f4")%>'>
   <td width="25" height="20" align="center" valign="middle">
    <input type="checkbox" name="checkedUserList" value="<%=user.getId()%>" />
    <input type="hidden" name="checkedUserAddressList" value='<%=(user.getUserAddress() != null ? user.getUserAddress().getId() + "": "")%>' />
    <%
    	if (engagedUserIds != null && engagedUserIds.size() > 0)
    	{
    		for (int j=0;j<engagedUserIds.size();j++)
    		{
    			if (user.getKolid() == ((Integer)engagedUserIds.get(j)).intValue())
    			{
    %>
    disabled
    <%
    			}
    		}
    	}		
    %>

    </td>
    <td width="25"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
    <td class="text-blue-01-link"><a href="<%=CONTEXTPATH%>/users.htm?action=<%=ActionKeys.EDIT_USER%>&userId=<%=user.getId()%>" target="main" class="text-blue-01-link"><%=user.getLastName()+", "+user.getFirstName()%></a></td>
  </tr>
  <% }
     session.removeAttribute("USER_SEARCH_LIST");
   }%>
</table>
</form>
</body>
</html>
