<%@ page language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="com.openq.eav.option.OptionNames"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.group.Groups"%>
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
 thisform.action = "grpDisplay.htm?groupId="+parentId;
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
	
	if(doNotRefresh == false)
		thisform.submit();
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
		thisform.action="grp.jsp";
		thisform.target="_top";
		thisform.submit();
		return;
	}
}

</script>

<%
	OptionLookup [] groupType = (OptionLookup [])request.getSession().getAttribute("groupType");
	OptionLookup [] functionalArea = (OptionLookup []) request.getSession().getAttribute("functionalArea");
	OptionLookup [] TherapeuticArea= (OptionLookup []) request.getSession().getAttribute("TherapeuticArea");
	OptionLookup [] Region  =(OptionLookup [])request.getSession().getAttribute("region");
	Groups editGrp = (Groups) request.getSession().getAttribute("editGrp");
	String isDeleted = (String) request.getSession().getAttribute("isDeleted");
	boolean isAlreadySelected = false;
%>

<html>
<head>
<title>openQ 3.0 - openQ Technologies Inc.</title>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
</head>

<body class="" onLoad="javascript:refreshTree('<c:out escapeXml="false" value="${refresh}"/>')">
<form name="groupDisplayForm" AUTOCOMPLETE="OFF" method="POST">
<div class="producttext" style=height:450>
<table width="100%" height="450" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="20" align="left" valign="top" class="">
	<div class="myexpertlist">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="middle" style="color:#4C7398">
          <td width="2%" height="20">&nbsp;</td>
         
          <td class="myexperttext">Groups</td>
        </tr>
    </table>
	</div>
	</td>
  </tr>

  <tr>
    <td height="1" align="left" valign="top" class="">
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      
    </table></td>
  </tr>
  
  <% if(isDeleted != null && isDeleted.equals("false")){ %>
  <tr>
  <td height="15"> <font face="verdana" size="2" color="red">
            <b>Group delete failed.! There are users associated with group(s)</b></td>
  </tr>
  <% } %>
  <tr>
    <td height="115" align="left" valign="top" class="back-white"><iframe src="grpList.htm?parentID=<%=request.getParameter("groupId")%>" name="groupList" height="100%" width="100%" name="groupList" frameborder="0" scrolling="yes">
    
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
 
 <% if(request.getParameterValues("editgroupId") == null){ %>
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
    <td height="20" align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="25" height="20">&nbsp;</td>
        <td width="150" class="text-blue-01">Group Name* </td>

       <td width="150" class="text-blue-01">Group Description* &nbsp;</td>
        <td width="150" class="text-blue-01">Group Type* </td>
	  </tr>
      <tr>
        <td width="25" height="20">&nbsp;</td>
        <td width="150" class="text-blue-01"><input name="groupname" type="text"  class="field-blue-01-180x20" maxlength="30">&nbsp;&nbsp;</td>

       <td width="150" class="text-blue-01"><input name="groupdesc" type="text"  class="field-blue-01-180x20" maxlength="80">&nbsp;&nbsp;</td>

        <td><select name="grouptype" class="field-blue-06-100x20">
     <% for(int i=0;i<groupType.length;i++) { 
  		String selected = "" ;
  		if(groupType[i].isDefaultSelected())
  			selected = "selected";
     %>     
          <option value="<%=groupType[i].getOptValue()%>" <%=selected %>><%=groupType[i].getOptValue()%></option>
	 <% } %>
     </select></td><td>&nbsp;</td>

        <td width="150" class="text-blue-01">&nbsp;</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
        <td  width="150" class="text-blue-01">&nbsp;</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
     </tr>  
      <tr>
        <td width="25" height="20">&nbsp;</td>
        <td width="150" class="text-blue-01">Therapautic Area</td>

       <td width="150" class="text-blue-01">Functional Area</td>

        <td width="150" class="text-blue-01">Region</td>

        <td width="150" class="text-blue-01">&nbsp;</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
        <td width="150" class="text-blue-01">&nbsp;</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
        </tr>  
      <tr>
		 <td height="20">&nbsp;</td>
         <td><select name="groupTA" class="field-blue-01-180x20">
				<% for(int i=0;i<TherapeuticArea.length;i++){ 
             		String selected = "" ;
              		if(TherapeuticArea[i].isDefaultSelected())
              			selected = "selected";
				%>
		     		<option value="<%=TherapeuticArea[i].getId()%>" class="field-blue-06-100x20" <%=selected%>><%=TherapeuticArea[i].getOptValue()%></option>
		     	<% } %>
		     	<option value="-1" class="field-blue-06-100x20">None</option>
		     	</select>&nbsp;&nbsp;</td>
         <td><select name="groupFA" class="field-blue-01-180x20">
		     	<% for(int i=0;i<functionalArea.length;i++){ 
             		String selected = "" ;
              		if(functionalArea[i].isDefaultSelected())
              			selected = "selected";
		     	%>
		     		<option value="<%=functionalArea[i].getId()%>" class="field-blue-06-100x20" <%=selected%>><%=functionalArea[i].getOptValue()%></option>
		     	<% } %>
		     	<option value="-1" class="field-blue-06-100x20">None</option>
		     	</select></td>
         <td><select name="regions" class="field-blue-01-180x20">
	     	<% for(int i=0;i<Region.length;i++){ 
         		String selected = "" ;
          		if(Region[i].isDefaultSelected())
          			selected = "selected";
	     	%>
	     		<option value="<%=Region[i].getId()%>" class="field-blue-06-100x20" <%=selected %>><%=Region[i].getOptValue()%></option>
	     	<% } %>
	     	<option value="-1" class="field-blue-06-100x20">None</option>
	     	</select></td>
	     <td>&nbsp;</td>
	     <td>&nbsp;</td>
	     <td>&nbsp;</td>
	     <td>&nbsp;</td>
     
      </tr>
    </table></td>
  </tr>
  <tr>
    <td height="10" align="left" valign="top" class="back-white"><table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="25" height="30">&nbsp;</td>
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
        <td width="25" height="20">&nbsp;</td>
        <td width="150" class="text-blue-01">Group Name* </td>

       <td width="150" class="text-blue-01">Group Description* &nbsp;</td>
        <td width="150" class="text-blue-01">Group Type* </td>
	  </tr>
<tr>
        <td width="25" height="20">&nbsp;</td><input type="hidden" name="editgroupid"value="<%=editGrp.getGroupId()%>"/>
        <td width="150" class="text-blue-01"><input name="editgroupname" value="<%=editGrp.getGroupName()%>" type="text"  class="field-blue-01-180x20" maxlength="30">&nbsp;&nbsp;</td>

       <td width="150" class="text-blue-01"><input name="editgroupdesc" value="<%=editGrp.getGroupDescription()%>" type="text"  class="field-blue-01-180x20" maxlength="80">&nbsp;&nbsp;</td>

        <td><select name="editgrouptype" class="field-blue-06-100x20">
     <% isAlreadySelected = false;
     	for(int i=0;i<groupType.length;i++) { 
  		String selected = "" ;
  		if(groupType[i].isDefaultSelected())
  			selected = "selected";
     %>
          <option value="<%=groupType[i].getOptValue()%>" 
          <% if(groupType[i].getOptValue().equals(editGrp.getGroupType())){
        	  isAlreadySelected = true;
          %> selected <%}
          else if(!isAlreadySelected){%><%=selected%> <%} %>><%=groupType[i].getOptValue()%></option>
	 <% } %>
     </select></td><td>&nbsp;</td>

        <td width="150" class="text-blue-01">&nbsp;</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
        <td  width="150" class="text-blue-01">&nbsp;</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
     </tr>
      <tr>
        <td width="25" height="20">&nbsp;</td>
        <td width="150" class="text-blue-01">Therapautic Area</td>

       <td width="150" class="text-blue-01">Functional Area</td>

        <td width="150" class="text-blue-01">Region</td>

        <td width="150" class="text-blue-01">&nbsp;</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
        <td width="150" class="text-blue-01">&nbsp;</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
      </tr>
      <tr>
		 <td height="20">&nbsp;</td>
         <td><select name="editgroupTA" class="field-blue-01-180x20">
         <option value="-1" <%=(-1 == Long.parseLong(editGrp.getTherupticArea())?"selected":"")%> class="field-blue-06-100x20">None</option>
				<% 
					isAlreadySelected = false;
					for(int i=0;i<TherapeuticArea.length;i++){ 
			  		String selected = "" ;
			  		if(TherapeuticArea[i].isDefaultSelected())
			  			selected = "selected";
				%>
		     		<option value="<%=TherapeuticArea[i].getId()%>" 
		     		<% if(TherapeuticArea[i].getId() == Long.parseLong(editGrp.getTherupticArea())){
		     			isAlreadySelected = true;
		     		%>selected<%}
		     		else if(!isAlreadySelected){%><%=selected%> <%} %> class="field-blue-06-100x20"><%=TherapeuticArea[i].getOptValue()%></option>
		     	<% } %>
	 	</select>&nbsp;&nbsp;</td>
         <td>
         <select name="editgroupFA" class="field-blue-01-180x20">
         <option value="-1" <%=(-1 == Long.parseLong(editGrp.getFunctionalArea())?"selected":"")%> class="field-blue-06-100x20">None</option>
		     	<% 
		     		isAlreadySelected = false;
		     		for(int i=0;i<functionalArea.length;i++){ 
		      		String selected = "" ;
		      		if(functionalArea[i].isDefaultSelected())
		      			selected = "selected";
		     	%>
		     		<option value="<%=functionalArea[i].getId()%>" 
		     		<% if (functionalArea[i].getId() == Long.parseLong(editGrp.getFunctionalArea())){
		     			isAlreadySelected = true;
		     		%>selected<%}
		     		else if(!isAlreadySelected){%><%=selected%> <%} %> class="field-blue-06-100x20"><%=functionalArea[i].getOptValue()%></option>
		     	<% } %>
		  </select>
		  </td>
         <td><select name="editregions" class="field-blue-01-180x20">
         <option value="-1" <%=(-1 == Long.parseLong(editGrp.getRegion())?"selected":"")%> class="field-blue-06-100x20">None</option>
	     	<% 	isAlreadySelected = false;
	     		for(int i=0;i<Region.length;i++){ 
	      		String selected = "" ;
	      		if(Region[i].isDefaultSelected())
	      			selected = "selected";
	     	%>
	     		<option value="<%=Region[i].getId()%>" 
	     		<% if (Region[i].getId() == Long.parseLong(editGrp.getRegion())){
	     			isAlreadySelected = true;
	     		%>selected<%}
	     		else if(!isAlreadySelected){%><%=selected%> <%} %> class="field-blue-06-100x20"><%=Region[i].getOptValue()%></option>
	     	<% } %>
     	</select></td>
	     <td>&nbsp;</td>
	     <td>&nbsp;</td>
	     <td>&nbsp;</td>
	     <td>&nbsp;</td>
      </tr>
    </table></td>
  	</tr>
  
    <td height="10" align="left" valign="top" class="back-white"><img src="./images/transparent.gif" width="10" height="10"></td>
  </tr>

  <tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="./images/transparent.gif" width="1" height="1"></td>
  </tr>

  <tr>
    <td height="30" align="left" valign="top" class="back-white"><table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="25" height="30">&nbsp;</td>
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
