<%@ page import="com.openq.web.ActionKeys"%>
<%@ include file="treeHeader.jsp" %>
<%@ page import="com.openq.kol.DBUtil"%>

<div style="position:relative; top:50px; left:37px" > 
					  
<script>
			  
	// Decide if the names are links or just the icons
	USETEXTLINKS = 1  //replace 0 with 1 for hyperlinks
				
	// Decide if the tree is to start all open or just showing the root folders
	STARTALLOPEN = 0 //replace 0 with 1 to show the whole tree
							
	ICONPATH = 'images/' //change if the gif's folder is a subfolder, for example: 'images/'
	PERSERVESTATE = 0
												  
							
	foldersTree = gFld("Users");
							
	insFld(foldersTree, gFld("Create New User", "users.htm?action=<%=ActionKeys.CREATE_USER%>"))
	
	insFld(foldersTree, gFld("View User Profile", "users.htm?action=<%=ActionKeys.UPDATE_USER%>"))
		
	insFld(foldersTree, gFld("Geocode <%=DBUtil.getInstance().doctor%>s", "geocode_experts.htm"))
	
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

<%@ include file="treeFooter.jsp" %>
