<%@ page import="com.openq.group.Groups"%>
<%@ include file = "imports.jsp" %>
<%
Groups[] allUserGroups = (Groups[]) request.getAttribute("ALL_USER_GROUPS");
String alreadySelectedGroups = (String) request.getParameter("alreadySelectedGroups");
String permissionOnFeature = (String) request.getParameter("permissionOnFeature");
String featureId = (String) request.getParameter("featureId");
%>
<html>
<head>
<script language="javascript" src="js/dojo-release-0.9.0/dojo/dojo.js" djConfig="parseOnLoad: true"></script>
<script>
function returnNewGroups(){
var flag = false ;
var newSelectedGroupIds = "";
var newSelectedGroupNames = "";
var thisform = document.groupPermissionForm;
if (null != thisform.groupCheckBox && thisform.groupCheckBox.length != undefined){
	for (var i = 0;  i < thisform.groupCheckBox.length; i++) {
		if (thisform.groupCheckBox[i].checked) {
			newSelectedGroupIds = newSelectedGroupIds + "," + thisform.groupCheckBox[i].id;
			newSelectedGroupNames = newSelectedGroupNames + "," + thisform.groupCheckBox[i].value;
		}
	}
	newSelectedGroupIds = newSelectedGroupIds.substring(1);
	newSelectedGroupNames = newSelectedGroupNames.substring(1);
}else if(null != thisform.groupCheckBox){
	newSelectedGroupIds = thisform.groupCheckBox[0].value;
	newSelectedGroupNames = thisform.groupCheckBox[0].value;
}	
	thisform.action="<%=CONTEXTPATH%>/selectGroupsForPermission.htm?newSelectedGroupIds=,"+newSelectedGroupIds+",&featureId=<%=featureId%>&permissionOnFeature=<%=permissionOnFeature%>";
	window.opener.setNewGroupSecurity(<%=featureId%>, newSelectedGroupNames);
	thisform.submit();
	window.close();
}
function toggleSelectAllCheckbox(currentCheckBox){
	var thisform = document.groupPermissionForm;
	var selectAllCheckbox = thisform.selectAllCheckbox;
	if(currentCheckBox != null){
		if(!currentCheckBox.checked)
			selectAllCheckbox.checked = false;
		else if(currentCheckBox.checked){
			if (null != thisform.groupCheckBox && thisform.groupCheckBox.length != undefined){
				var flag = true;
				for (var i = 0;  i < thisform.groupCheckBox.length; i++) {
					if (!thisform.groupCheckBox[i].checked) {
						flag = false;
						break;
					}
				}
				if(flag)
					selectAllCheckbox.checked = true;
			}else if(null != thisform.groupCheckBox){
				if(thisform.groupCheckBox[0].checked)
					selectAllCheckbox.checked = true;
			}			
		}
	}
}
function checkUncheckAll(selectAllCheckbox){
	var checkboxes = document.groupPermissionForm.groupCheckBox;
	if(selectAllCheckbox != null && selectAllCheckbox.checked)
		checkAll(checkboxes);
	else if (selectAllCheckbox != null && !selectAllCheckbox.checked)
		uncheckAll(checkboxes);
	 
}
function checkAll(field){
for (i = 0; i < field.length; i++)
	field[i].checked = true ;
}

function uncheckAll(field){
for (i = 0; i < field.length; i++)
	field[i].checked = false ;
}
	
</script>
 </head>
 <title>Group Level Security</title>
 <link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css" />
 <body onBlur="self.focus()">   
	<form name="groupPermissionForm" method="post">
	<table width="100%">
	<tr>
		<td width="100%">
			<div>
					<div class="myexpertplan">
						<table>
							<tr>
								<td class="myexperttext">Select Groups</td>
								<td colspan="10">
									<input name="Submit33" type="button" style="border:0;background : url(images/buttons/close_window_cross.gif);width:25px; height:21px;" class="button-01" value="" onClick="javascript:window.close()" />
								</td>
							</tr>
							<tr>
								<td class="myexperttext">All
									<input type="checkbox" name="selectAllCheckbox" onClick="checkUncheckAll(this)"/>
								</td>
								<td></td>
							</tr>
						</table>
					</div>
			</div>
		</td>
	</tr>
	<tr>
		<td width="100%">
		        <table class="myexpertlist" width="100%" cellspacing="0">
			      <%
		                  if(allUserGroups != null){
		                	  if(alreadySelectedGroups == null)
		                		  alreadySelectedGroups = "";
		                	  
		                	  String[] alreadySelectedGroupsArray = alreadySelectedGroups.split(",");
		 	              	for(int i=0; i<allUserGroups.length; i++){
		                  		if(allUserGroups[i] != null && allUserGroups[i].getGroupId() != 0){
		                  			String checked = "";
		                  			if(alreadySelectedGroupsArray != null){
		                  				for(int j=0; j<alreadySelectedGroupsArray.length; j++){
		                   					if(allUserGroups[i].getGroupName().equals(alreadySelectedGroupsArray[j])){
		                  						checked = "checked";
		 	             						break;
		                  					}
		                  				}
		                  					
		                  			}
		          %>
		          <tr>
		          	<td class="text-blue-01">
		          		<input type="checkbox" name="groupCheckBox" id ="<%=allUserGroups[i].getGroupId()%>" value="<%=allUserGroups[i].getGroupName()%>" onClick="toggleSelectAllCheckbox(this)" <%=checked %>/>&nbsp;&nbsp;
		          		<%=allUserGroups[i].getGroupName()%>
		          	</td>
		            <% } } }%>
		            <td align="center"></td>
		        </tr>
		    </table>
	      </td>
	      <td></td>
	 </tr>
	 <tr>
	 	<td width="100%">
	       	<div class="myexpertplan"  align="left">
	       		 &nbsp;&nbsp;<input name="saveChangesButton" type="button" style="border:0;background : url(images/buttons/save.gif);width:73px; height:22px;" class="button-01" value="" onClick="returnNewGroups()" />
		    </div>
		</td>
	</tr>
    </table>	
     </form>      
    </body>
    </html>  
      
      