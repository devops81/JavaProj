
<jsp:directive.page import="com.openq.report.ReportGroupMap"/><%@ include file = "imports.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="java.util.Properties"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>

<%@page import="com.openq.report.*"%>
<%@page import="java.util.*" %>

<%
	String mode = (String)session.getAttribute("mode");
	String Refresh_parent = (String) session.getAttribute("Refresh_parent");
	ReportGroups group = null;
	String groupIdString="";
	if(session.getAttribute("Group")!=null){
		group = (ReportGroups)session.getAttribute("Group");
		groupIdString = group.getGroupId()+"";
	}
	Collection allReportsList = (Collection) session.getAttribute("reportsList");
	long reportLen=0;
	if(allReportsList!=null){
		reportLen = allReportsList.size();
	}
  	//for(Iterator itr=reportsList.iterator(); itr.hasNext();){
  	//  Report report = (Report)itr.next();
  	  
	List selectedReportGroupMap=null;
	if(session.getAttribute("reportGroupMap")!=null){
		selectedReportGroupMap = (List)session.getAttribute("reportGroupMap");
	}
	TreeMap selectedReportMap = new TreeMap();
    if (selectedReportGroupMap != null && selectedReportGroupMap.size() > 0) {
        ReportGroupMap groups = null;
        for (int i = 0; i < selectedReportGroupMap.size(); i++) {
            groups = (ReportGroupMap)selectedReportGroupMap.get(i);
            selectedReportMap.put(groups.getReport_id()+"",groups.getReport_group_id() + "");
        }
    }
    Map entityGroupMap = (Map) request.getAttribute("REPORT_PERMISSION_MAP");
    request.removeAttribute("REPORT_PERMISSION_MAP");
%>
<script language="javascript" src="js/dojo-release-0.9.0/dojo/dojo.js" djConfig="parseOnLoad: true"></script>
<script language="javascript" src="js/groupLevelSecurity.js"></script>

<script>
var dupReportNameFlag = false;

	
function deleteReportMap()	{
	var thisform1 = document.updateReportForm;
	var j = 0;
    var arrayOfCheckedReports = new Array();
    
        if ('<%=reportLen%>' != 0){
        
	        if (thisform1.deletedReportID.length) {
	
	            for (var i = 0; i < thisform1.deletedReportID.length; i++) {
	        
	        		if (thisform1.deletedReportID[i].checked == true) {
	                    arrayOfCheckedReports[j++] = thisform1.deletedReportID[i].value;
	                    
	                }
	            }
	        }
	        
	        else
	        {
	            arrayOfCheckedReports[0] = thisform1.deletedReportID.value;
	        }
	        thisform1.action = "<%=CONTEXTPATH%>/reportsGroupMap.htm?action=delete&groupId=<%=groupIdString%>&chkGroupIds="+arrayOfCheckedReports;
            thisform1.submit();
      	} 
    }


function addReportMap(){
	var thisform1 = document.updateReportForm;
	var j = 0;
    var arrayOfCheckedReports = new Array();
    
        if ('<%=reportLen%>' != 0){
        
	        if (thisform1.addedReportID.length) {
	
	            for (var i = 0; i < thisform1.addedReportID.length; i++) {
	                if (thisform1.addedReportID[i].checked == true) {
	                    arrayOfCheckedReports[j++] = thisform1.addedReportID[i].value;
	                }
	            }
	        }
	        
	        else
	        {
	            arrayOfCheckedReports[0] = thisform1.addedReportID.value;
	        }
	        thisform1.action = "<%=CONTEXTPATH%>/reportsGroupMap.htm?action=add&groupId=<%=groupIdString%>&chkGroupIds="+arrayOfCheckedReports;
            thisform1.submit();
			} 
}


function Refresh_Page()
	{

		 parent.frames['backgr1'].location.reload();
	}
</script>
<html>
<head>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
</head>
<body>
<% 
    if ("yes".equalsIgnoreCase(Refresh_parent)) 
	   {session.removeAttribute("Refresh_parent"); 
		 %>
		<script>
		  Refresh_Page();
		  </script>
		  <%}%>
	
<form name="updateReportForm" AUTOCOMPLETE="OFF" method="POST">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td>              
		<jsp:include page="report_menu.jsp" flush="true"/>
	  </td>
	</tr>
</table>
<div class="producttext" style=height:50>
<table width="100%"  height="70%" border="0" cellspacing="0" cellpadding="0" align="center">

  <tr>
    <td height="20" align="left" valign="top">
     	<div class="myexpertlist">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="middle" style="color:#4C7398">
          <td width="2%" height="20">&nbsp;</td>
          <td width="1%"><img src="images/icon_values.gif" width="14" height="14"></td>
          <td width="97%" class="myexperttext">Reports Added to <%=group.getGroupName()%> Name</td>
          
        </tr>
      </table>
	</div>
    </td>
  </tr>
  
  <tr>
    <td height="25" align="left" valign="top">
	<div class="myexpertplan">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="middle" style="color:#4C7398">
          <td width="5%" height="20">&nbsp;</td>
          <td width="10%"><img src="images/icon_values.gif" width="14" height="14"></td>
          <td width="25%" class="text-blue-01-bold">Report Name</td>
          <td width="25%" class="text-blue-01-bold">Report Description</td>
          <td width="25%" class="text-blue-01-bold">Permitted User Groups</td>
          <td width="10%" class="text-blue-01-bold">Change User Groups</td>
        </tr>
      </table>
	</div>
    </td>
  </tr>

  <%
  	Collection reportsList = (Collection) session.getAttribute("reportsList");
  	%>
  <tr>
      <td height="25" align="left" valign="top">
      <div style=" width:100%; height:100px; overflow:auto;">
        <table width="100%" height="40px" style="max-height:50px,overflow:scroll" border="0" cellspacing="0" cellpadding="0">
    
  <%for(Iterator itr=reportsList.iterator(); itr.hasNext();){
  	  Report report = (Report)itr.next();
  	  if (selectedReportMap != null && selectedReportMap.size()>0){

                if (selectedReportMap.containsKey(report.getReportID()+"")){
                	String permittedGroups = "";
                	Long reportIdLong = new Long(report.getReportID());
                	if(entityGroupMap != null && entityGroupMap.containsKey(reportIdLong) && entityGroupMap.get(reportIdLong) != null)
                		permittedGroups = entityGroupMap.get(reportIdLong)+""; 
  %>
          <tr align="left" valign="middle">
            <td width="5%" height="25" align="center"><input name="deletedReportID" type="checkbox" value='<%=report.getReportID()%>'></td>
            <td width="10%" align="left"><img src="images/icon_values.gif" width="14" height="14"></td>
            <td width="25%" class="text-blue-01-link"><%=report.getName()%></td>
            <td width="25%" class="text-blue-01"><%=report.getDescription()%></td>
            <td width="25%" class="text-blue-01" id="permittedGroupsTd<%=report.getReportID()%>" value = "<%=permittedGroups%>"><%=permittedGroups%></td>
            <td width="10%" class="text-blue-01">
            	<img src="images/configure.gif" onclick="showGroupChangerPopup('<%=report.getReportID()%>','<%=Constants.REPORT_PERMISSION_ID%>')" style="cursor: pointer;">
            </td>
          </tr>
        
  <%
  }}
  	}
  %>
  </table>
  </div>
      </td>
    </tr>
 <tr>
    <td height="30" align="left" valign="top" class="back-white">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="25" height="30">&nbsp;</td>
          <td>
            <input name="deleteReportButton" style="border:0;background : url(images/buttons/delete_reports.gif);width:120px; height:22px;" type="button" value="" class="button-01" onClick="javascript:deleteReportMap()"/>
          </td>
          <td width="10">&nbsp;</td>
        </tr>
      </table>
    </td>
    
  </tr>
<tr>
    <td height="20" align="left" valign="top">
     	<div class="myexpertlist">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="middle" style="color:#4C7398">
          <td width="25" height="20">&nbsp;</td>
          <td width="2%"><img src="images/icon_values.gif" width="14" height="14"></td>
          <td width="2%" class="myexperttext">Available Reports</td>
          <td width="280" class="text-blue-01-bold"></td>
        </tr>
      </table>
	</div>
    </td>
  </tr>
  
  <tr>
    <td height="25" align="left" valign="top">
	<div class="myexpertplan">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="middle" style="color:#4C7398">
          <td width="5%" height="20">&nbsp;</td>
          <td width="10%"><img src="images/icon_values.gif" width="14" height="14"></td>
          <td width="25%" class="text-blue-01-bold"">Report Name</td>
          <td width="25%" class="text-blue-01-bold">Report Description</td>
          <td width="25%" class="text-blue-01-bold">Permitted User Groups</td>
          <td width="10%" class="text-blue-01-bold">Change User Groups</td>
        </tr>
      </table>
	</div>
    </td>
  </tr>

  <tr>
      <td height="25" align="left" valign="top">
      <div style=" width:100%; height:100px; overflow:auto;">
        <table width="100%" height="40px" style="max-height:50px,overflow:scroll" border="0" cellspacing="0" cellpadding="0">
    
  <%for(Iterator itr=reportsList.iterator(); itr.hasNext();){
  	  Report report = (Report)itr.next();
  	  
  	  	
                if (!(selectedReportMap.containsKey(report.getReportID()+""))){
                	String permittedGroups = "";
                	Long reportIdLong = new Long(report.getReportID());
                	if(entityGroupMap != null && entityGroupMap.containsKey(reportIdLong) && entityGroupMap.get(reportIdLong) != null)
                		permittedGroups = entityGroupMap.get(reportIdLong)+""; 
 %>
    
          <tr align="left" valign="middle">
            <td width="5%" height="25" align="center"><input name="addedReportID" type="checkbox" value='<%=report.getReportID()%>'></td>
            <td width="10%" align="left"><img src="images/icon_values.gif" width="14" height="14"></td>
            <td width="25%" class="text-blue-01-link"><%=report.getName()%></td>
            <td width="25%" class="text-blue-01"><%=report.getDescription()%></td>
            <td width="25%" class="text-blue-01" id="permittedGroupsTd<%=report.getReportID()%>"value = <%=permittedGroups%>><%=permittedGroups%></td>
            <td width="10%" class="text-blue-01">
            	<img src="images/configure.gif" onclick="showGroupChangerPopup('<%=report.getReportID()%>','<%=Constants.REPORT_PERMISSION_ID%>')" style="cursor: pointer;">
            </td>
          </tr>
        
  <%
  }
  	}
  %>
  </table>
 </div>
 </td>
 </tr>
<tr>
    <td height="30" align="left" valign="top" class="back-white">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="25" height="30">&nbsp;</td>
          <td>
            <input name="deleteReportButton" style="border:0;background : url(images/buttons/add_report.gif);width:101px; height:22px;" type="button" value="" class="button-01" onClick="javascript:addReportMap()"/>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<td width="280" class="text-blue-01-bold"><a href="reportsDisplay.htm#addReportSection">Upload New Report</a></td>
          </td>
          <td width="10">&nbsp;</td>
        </tr>
      </table>
    </td>
    
  </tr>
   
</table>
</form>
</body>
</html>