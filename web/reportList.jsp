<html>
<head>
<title>openQ 3.0 - openQ Technologies Inc.</title>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
</head>
<%
	String [] GroupName = (String[]) request.getSession().getAttribute("groupname");
	String [] GroupDescription = (String[]) request.getSession().getAttribute("groupdesc");
	long [] GroupID = (long []) request.getSession().getAttribute("groupid");
	String parentId = (String) request.getSession().getAttribute("parentId");
	
	
%>

<body>
<form name="groupsListForm" method="POST">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<% for(int i=0;i < GroupName.length; i++) { %>
  <%if(i%2==0){%>
		
  <tr bgcolor="#fafbf9" >
    <td width="5%" height="20" align="center" valign="middle"><input type="checkbox" name="checkedGroupList" value="<%=GroupID[i]%>"></td>
    <td width="15%" class="text-blue-01-link"><a href="reportsGroupDisplay.htm?editgroupId=<%=GroupID[i]%>&groupId=<%=parentId%>" target="main" class="text-blue-01-link"><%=GroupName[i]%></a></td>
    <td width="18%" class="text-blue-01"><%=GroupDescription[i]%></td>
	</tr>
	
  <% } else {%>
<tr bgcolor="#f5f8f4" >
    <td width="5%" height="20" align="center" valign="middle"><input type="checkbox" name="checkedGroupList" value="<%=GroupID[i]%>"></td>
   <td width="15%" class="text-blue-01-link"><a href="reportsGroupDisplay.htm?editgroupId=<%=GroupID[i]%>&groupId=<%=parentId%>" target="main" class="text-blue-01-link"><%=GroupName[i]%></a></td>
    <td width="18%" class="text-blue-01"><%=GroupDescription[i]%></td>
    </tr>
  <% } %>  
  
<% } %>
 </table>
 </form>
</body>
</html>
