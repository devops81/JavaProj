<%@ include file="treeHeader.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.eav.metadata.EntityType" %>

<div style="position:relative; top:50px; left:37px" > 
					  
<script>
			  
	// Decide if the names are links or just the icons
	USETEXTLINKS = 1  //replace 0 with 1 for hyperlinks

	// Decide if the tree is to start all open or just showing the root folders
	STARTALLOPEN = 0 //replace 0 with 1 to show the whole tree

	ICONPATH = 'images/' //change if the gif's folder is a subfolder, for example: 'images/'
	PERSERVESTATE = 0
	
	// add tree root
	<%=request.getSession().getAttribute(Constants.TREE_ROOT)%>

	// add kol profile
	<%=request.getSession().getAttribute(Constants.KOL_PROFILE_TREE)%>
	
	// Institution and Trials are commented for AGO - Rohit
	// add institution tree
	//<%=request.getSession().getAttribute(Constants.INSTITUTIONS_TREE)%>
	//
	// add trials tree
	//<%=request.getSession().getAttribute(Constants.TRIALS_TREE)%>
	
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
