<html>
<head>
<title>openQ 3.0 - openQ Technologies Inc.</title>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
</head>
<script type="text/javascript" src="./js/sorttable.js"></script>
<%
	String [] GroupName = (String[]) request.getSession().getAttribute("groupname");
	String [] GroupDescription = (String[]) request.getSession().getAttribute("groupdesc");
	String [] GroupType = (String[]) request.getSession().getAttribute("grouptype");
	long [] GroupID = (long []) request.getSession().getAttribute("groupid");
	String parentId = (String) request.getSession().getAttribute("parentId");
	String [] GroupTA=(String[]) request.getSession().getAttribute("groupta");
	String [] GroupFA = (String[]) request.getSession().getAttribute("groupfa");
	String [] Region=(String[]) request.getSession().getAttribute("region");
	
	
%>

<body>
<form name="groupsListForm" method="POST">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="sortable">
<tr align="left" valign="middle" bgcolor="#f5f8f4" height="20%">
      	<td width="3%" align="left">&nbsp;<img src="./images/icon_attendees.gif" width="14" height="14"></td>
        	<td width="14%" class="expertListHeader">Group Name </td>
		<td width="16%" class="expertListHeader">Group Description </td>
        	<td width="13%" class="expertListHeader">Group Type </td>
        	<td width="14%" class="expertListHeader">Therapeutic Area</td>
        	<td width="12%" class="expertListHeader">Functional Area</td>
        	<td width="13%" class="expertListHeader">Region</td>
        </tr>
<% for(int i=0;i < GroupName.length; i++) { %>
  <%if(i%2==0){%>
		
  <tr bgcolor="#fafbf9" >
    <td width="5%" height="20" align="center" valign="middle"><input type="checkbox" name="checkedGroupList" value="<%=GroupID[i]%>"></td>
    <td width="15%" class="text-blue-01-link"><a href="grpDisplay.htm?editgroupId=<%=GroupID[i]%>&groupId=<%=parentId%>" target="main" class="text-blue-01-link"><%=GroupName[i]%></a></td>
    <td width="18%" class="text-blue-01"><%=GroupDescription[i]%></td>
	<td width="16%" class="text-blue-01"><%=GroupType[i]%></td>
	<td width="16%" class="text-blue-01"><%=GroupTA[i]==null?"N.A":GroupTA[i]%></td>
	<td width="12%" class="text-blue-01"><%=GroupFA[i]==null?"N.A":GroupFA[i]%></td>
	<td width="12%" class="text-blue-01">&nbsp;&nbsp;<%=Region[i]==null?"N.A":Region[i]%></td>
	</tr>
	
  <% } else {%>
<tr bgcolor="#f5f8f4" >
    <td width="5%" height="20" align="center" valign="middle"><input type="checkbox" name="checkedGroupList" value="<%=GroupID[i]%>"></td>
   <td width="15%" class="text-blue-01-link"><a href="grpDisplay.htm?editgroupId=<%=GroupID[i]%>&groupId=<%=parentId%>" target="main" class="text-blue-01-link"><%=GroupName[i]%></a></td>
    <td width="18%" class="text-blue-01"><%=GroupDescription[i]%></td>
    <td width="16%" class="text-blue-01"><%=GroupType[i]%></td>
	<td width="16%" class="text-blue-01"><%=GroupTA[i]==null?"N.A":GroupTA[i]%></td>
	<td width="12%" class="text-blue-01"><%=GroupFA[i]==null?"N.A":GroupFA[i]%></td>
	<td width="12%" class="text-blue-01">&nbsp;&nbsp;<%=Region[i]==null?"N.A":Region[i]%></td>
  </tr>
  <% } %>  
  
<% } %>
 </table>
 </form>
</body>
</html>
