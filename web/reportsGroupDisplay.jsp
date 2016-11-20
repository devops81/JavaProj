<%@ page language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="com.openq.web.ActionKeys" %>
<%@ page import="com.openq.eav.option.OptionNames"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.report.ReportGroups"%>
<%@ include file = "imports.jsp" %>
<script src="<%=COMMONJS%>/validation.js"></script>
<script>
function deleteGroups(parentId){
	
 var thisform =window.frames['groupList'].groupsListForm;
 var flag =false;
 for(var i=0;i<thisform.elements.length;i++){
    if(thisform.elements[i].type =="checkbox" && thisform.elements[i].checked){
   flag =true;
   break;  
  }
 }
 thisform.action = "reportsGroupDisplay.htm?groupId="+parentId;
 if(flag){
  thisform.target="main";
  if(confirm("Do you want to delete the selected group?")){
  thisform.submit();
  }
 }else {
  alert("Please select atleast one group to delete");
 }

}

function addGroup(){
	var thisform = document.groupDisplayForm;
	var doNotRefresh = false;
	
	if (!checkNull(thisform.groupname, "group name") || !checkNull(thisform.groupdesc, "group description") ) {
		doNotRefresh = true;
	}	
	
	if(doNotRefresh == false){
		thisform.submit();
		}
}

function editGroup(){
	var thisform = document.groupDisplayForm;
	var doNotRefresh = false;
	
	if (!checkNull(thisform.editgroupname, "group name") || !checkNull(thisform.editgroupdesc, "group description") ) {
		doNotRefresh = true;
	}		
	
	if(doNotRefresh == false)
		thisform.submit();
}


function refreshTree(refreshpage){
	if(refreshpage){
		var thisform = document.refreshPageForm;
		alert("<%=request.getParameter("groupId")%>");
		thisform.action="reportsGroupDisplay.jsp?action=<%=ActionKeys.REPORT_GROUP%>groupId=<%=request.getParameter("groupId")%>";
		thisform.target="_self";
		thisform.submit();
		return;
	}
}

</script>

<%
	ReportGroups editGrp = (ReportGroups) request.getSession().getAttribute("editGrp");
	String isDeleted = (String) request.getSession().getAttribute("isDeleted");
%>

<html>
<head>
<title>openQ 3.0 - openQ Technologies Inc.</title>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
</head>

<body class="" onLoad="javascript:refreshTree('<c:out escapeXml="false" value="${refresh}"/>')">
<form name="groupDisplayForm" AUTOCOMPLETE="OFF" method="POST">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td>              
		<jsp:include page="report_menu.jsp" flush="true"/>
	  </td>
	</tr>
</table>
<div class="producttext" style=height:390>
<table width="100%" height="390" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="20" align="left" valign="top" class="">
	<div class="myexpertlist">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="middle" style="color:#4C7398">
          <td width="2%" height="20"><input type="hidden" name="groupId" value=<%=request.getParameter("groupId")%>></td>
         
          <td class="myexperttext">Groups</td>
        </tr>
    </table>
	</div>
	</td>
  </tr>

  <tr>
    <td height="25" align="left" valign="top" class="">
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr align="left" valign="middle" bgcolor="#f5f8f4">
      	<td width="5%" align="center">&nbsp;<img src="./images/icon_attendees.gif" width="14" height="14"></td>
        	<td width="15%" class="expertListHeader">Group Name </td>
		<td width="18%" class="expertListHeader">Group Description </td>
        	</tr>
    </table></td>
  </tr>
  
  <% if(isDeleted != null && isDeleted.equals("false")){ %>
  <tr>
  <td height="15" align="center"> <font face="verdana" size="2" color="red">
            <b>Group delete failed.! There are Reports associated with group(s)</b></td>
  </tr>
  <% } %>
  <tr>
    <td height="115" align="left" valign="top" class="back-white"><iframe src="reportList.htm?parentID=<%=request.getParameter("groupId")%>" name="groupList" height="100%" width="100%" name="groupList" frameborder="0" scrolling="yes">
    
    </iframe></td>
  </tr>
  <tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="./images/transparent.gif" width="1" height="1"></td>
  </tr>
 
  <tr>

    <td height="30" align="left" valign="top" class="back-white"><table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="25" height="30">&nbsp;</td>
            <td>
            &nbsp;</td>
          <td width="10">
            <input name="delete" type="button" style="border:0;background : url(images/buttons/delete_group.gif);width:111px; height:22px;" onClick="javascript:deleteGroups(<%=request.getParameter("groupId")%>)" class="button-01" value=""></td>

        </tr>

    </table></td>
  </tr>
 
 <% 
 if(request.getParameterValues("editgroupId")== null || request.getParameter("isEdited")!=null){ %>
  <tr>
    <td height="20" align="left" valign="top" class="">
	<div class="myexpertplan">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr align="left" valign="middle" style="color:#4C7398">
        <td width="2%" height="20">&nbsp;</td>
        <td width="2%"><img src="./images/icon_attendees.gif" width="14" height="14"></td>
        <td class="myexperttext">Add New Group </td>
      </tr>
    </table>
	</div>
	</td>
  </tr>
  <tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="./images/transparent.gif" width="10" height="10"></td>
  </tr>
  <tr>
    <td height="20" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="35" height="20">&nbsp;</td>
        <td width="150" class="text-blue-01">Group Name* </td>
		<td width="35" height="20">&nbsp;</td>
        <td width="150" class="text-blue-01">Group Description* &nbsp;</td>
        </tr>
      <tr>
        <td width="35" height="20">&nbsp;</td>
        <td width="150" class="text-blue-01"><input name="groupname" type="text"  class="field-blue-01-180x20" maxlength="30">&nbsp;&nbsp;</td>
		<td width="35" height="20">&nbsp;</td>
        <td width="150" class="text-blue-01"><input name="groupdesc" type="text"  class="field-blue-01-180x20" maxlength="80">&nbsp;&nbsp;</td>

        <td></td><td>&nbsp;</td>

        <td width="150" class="text-blue-01">&nbsp;</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
        <td  width="150" class="text-blue-01">&nbsp;</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
     </tr>  
     
    </table></td>
  </tr>
  <tr>
    <td height="20" align="left" valign="top" class="back-white"><table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="35" height="20">&nbsp;</td>
          <td><input name="addgroup" type="button" style="border:0;background : url(images/buttons/add_group.gif);width:98px; height:23px;" onClick="javascript:addGroup()" class="button-01" value=""/></td>

        <td width="10">&nbsp;</td>
      </tr>
    </table></td>
  </tr>


<% }else { %>
  <tr>
    <td height="20" align="left" valign="top" class="">
	<div class="myexpertplan">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr align="left" valign="middle" style="color:#4C7398">
        <td width="2%" height="20">&nbsp;</td>
        <td width="2%"><img src="./images/icon_attendees.gif" width="14" height="14"></td>
        <td class="myexperttext">Edit Group </td>
      </tr>
    </table>
	</div>
	</td>
  </tr>
  
  <tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="./images/transparent.gif" width="10" height="10"></td>
  </tr>
  <tr>
    <td height="20" align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="35" height="20">&nbsp;</td>
        <td width="150" class="text-blue-01">Group Name* </td>
		<td width="35" height="20">&nbsp;</td>
        <td width="150" class="text-blue-01">Group Description* &nbsp;</td>
        </tr>
		<tr>
        <td width="35" height="20">&nbsp;</td><input type="hidden" name="editgroupid"value="<%=editGrp.getGroupId()%>"/>
        <td width="150" class="text-blue-01"><input name="editgroupname" value="<%=editGrp.getGroupName()%>" type="text"  class="field-blue-01-180x20" maxlength="30">&nbsp;&nbsp;</td>
		<td width="35" height="20">&nbsp;</td>
        <td width="150" class="text-blue-01"><input name="editgroupdesc" value="<%=editGrp.getGroupDescription()%>" type="text"  class="field-blue-01-180x20" maxlength="80">&nbsp;&nbsp;</td>

        <td></td><td>&nbsp;</td>

        <td width="150" class="text-blue-01">&nbsp;</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
        <td  width="150" class="text-blue-01">&nbsp;</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
     </tr>
          </table></td>
  	</tr>
  
    <td height="10" align="left" valign="top" class="back-white"><img src="./images/transparent.gif" width="10" height="10"></td>
  </tr>

  <tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="./images/transparent.gif" width="1" height="1"></td>
  </tr>

  <tr>
    <td height="30" align="left" valign="middle" class="back-white"><table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="35" height="30">&nbsp;</td>
          <td><input name="editgroup" type="button" style="border:0;background : url(images/buttons/update_group.gif);width:117px; height:23px;" onClick="javascript:editGroup()" class="button-01" value=""/></td>

        <td width="10">&nbsp;</td>
      </tr>
    </table></td>
  </tr>

<% } %>

</table>
</div>
</form>
<form name="refreshPageForm"></form>
</body>

</html>
