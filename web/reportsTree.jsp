<%@ page language="java" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.web.ActionKeys" %>
<%@page import="com.openq.report.*"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ include file="imports.jsp"%>
<%@page import="java.util.*" %>


<%@ include file="treeHeader.jsp"%>

<%

    long []  GroupID = (long []) request.getSession().getAttribute("Groups");
	long []  ParentID =(long []) request.getSession().getAttribute("Parents");
	String [] GroupName = (String []) request.getSession().getAttribute("GroupsName");
	HashMap reportsHashedOnGrp = (HashMap)request.getSession().getAttribute("reportsHashedOnGrp");
	Collection reports = (Collection)request.getSession().getAttribute("reports");
	
	OptionLookup userTypeId = null;
    if (session.getAttribute(Constants.USER_TYPE) != null) {
        userTypeId = (OptionLookup)session.getAttribute(Constants.USER_TYPE);
    }
%>					  

<script>

	// Decide if the names are links or just the icons
	USETEXTLINKS = 1  //replace 0 with 1 for hyperlinks
	
	// Decide if the tree is to start all open or just showing the root folders
	STARTALLOPEN = 1 //replace 0 with 1 to show the whole tree
							
	ICONPATH = 'images/' //change if the gif's folder is a subfolder, for example: 'images/'
	PERSERVESTATE = 0
												  
	//foldersTree = gFld("Reports");

	<% session.setAttribute("CURRENT_LINK", "reportGroupMap");
	if (GroupID!=null && GroupID.length > 0) {  
		if((userTypeId.getOptValue().equalsIgnoreCase("admin"))){
			%>  
		aux<%=GroupID[0]%>=gFld("<%=GroupName[0]%>", "reportsGroupMap.htm?action=<%=ActionKeys.REPORT_GROUP_MAP%>&groupId=<%=GroupID[0]%>");
		foldersTree=gFld("<%=GroupName[0]%>", "reportsGroupMap.htm?action=<%=ActionKeys.REPORT_GROUP_MAP%>&groupId=<%=GroupID[0]%>");
		
		<%
		}else{ %>
		aux<%=GroupID[0]%>=gFld("<%=GroupName[0]%>", "");
		foldersTree=gFld("<%=GroupName[0]%>", "");
		<%}
		 for(int i=1;i<GroupID.length; i++) { 
		 if((userTypeId.getOptValue().equalsIgnoreCase("admin"))){
			if(ParentID[i]==1){%>
				aux<%=GroupID[i]%>=insFld(foldersTree, gFld("<%=GroupName[i]%>", "reportsGroupMap.htm?action=<%=ActionKeys.REPORT_GROUP_MAP%>&groupId=<%=GroupID[i]%>"));
			<%}else{%>
				aux<%=GroupID[i]%>=insFld(aux<%=ParentID[i]%>, gFld("<%=GroupName[i]%>", "reportsGroupMap.htm?action=<%=ActionKeys.REPORT_GROUP_MAP%>&groupId=<%=GroupID[i]%>"));
			<%}
		}else{ %>
			<%if(ParentID[i]==1){%>
				aux<%=GroupID[i]%>=insFld(foldersTree, gFld("<%=GroupName[i]%>", ""));
			<%}else{%>
				aux<%=GroupID[i]%>=insFld(aux<%=ParentID[i]%>, gFld("<%=GroupName[i]%>", ""));
			<%}
		}
		
	 } }
	//Iterator itr = reportsHashedOnGrp;
	Set entries = reportsHashedOnGrp.entrySet();
    Iterator itr = entries.iterator();
	while(itr.hasNext()){
			Map.Entry entry = (Map.Entry)itr.next();
			ReportGroupMap[] rg = (ReportGroupMap [])(entry.getValue());
			for(int j=0;j<rg.length;j++){
				Iterator it = reports.iterator();
				String reportName = "report";
				while(it.hasNext()){
					Report temp = (Report)it.next();
					if(temp.getReportID()==rg[j].getReport_id()){
							reportName = temp.getName();	
							break;
						}
				}%>
				aux<%=50+rg[j].getId()%>=insDoc(aux<%=rg[j].getReport_group_id()%>, gLnk("T", "<%=reportName%>", "<%=CONTEXTPATH%>/reportsUser.htm?reportName=<%=reportName%>"))
			<%}
	}
	%>
	
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
