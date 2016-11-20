<%@ page language="java" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@page import="com.openq.group.Groups"%>

<%@page import="java.util.*" %>


<%@ include file="treeHeader.jsp"%>

<%

    long []  GroupID = (long []) request.getSession().getAttribute("Groups");
	long []  ParentID =(long []) request.getSession().getAttribute("Parents");
	String [] GroupName = (String []) request.getSession().getAttribute("GroupsName");

%>					  

<script>

	// Decide if the names are links or just the icons
	USETEXTLINKS = 1  //replace 0 with 1 for hyperlinks
	
	// Decide if the tree is to start all open or just showing the root folders
	STARTALLOPEN = 0 //replace 0 with 1 to show the whole tree
							
	ICONPATH = 'images/' //change if the gif's folder is a subfolder, for example: 'images/'
	PERSERVESTATE = 0
												  
	foldersTree = gFld("Users");

	<%if (GroupID.length > 0) {  %>  
		aux<%=GroupID[0]%>=insFld(foldersTree, gFld("<%=GroupName[0]%>", "grpDisplay.htm?groupId=<%=GroupID[0]%>"));
		
		<% for(int i=1;i<GroupID.length; i++) { %>
		
		aux<%=GroupID[i]%>=insFld(aux<%=ParentID[i]%>, gFld("<%=GroupName[i]%>", "grpDisplay.htm?groupId=<%=GroupID[i]%>"));
	
	<% } }%>
</script>
			
<table border=0>
   <tr> 
	<td align="left" valign="middle"><a href="http://www.treemenu.net/" target="_blank" ></a></td>
   </tr>
   <tr> 
</table>

</div>
<span class=TreeviewSpanArea> 
<script>initializeDocument()</script>

<%@ include file="treeFooter.jsp"%>