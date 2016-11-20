<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp"%>
<%@ page language="java" %>
<%@ page import="com.openq.contacts.Contacts"%>
<%@ page import="com.openq.eav.option.OptionNames"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.authentication.UserDetails"%>
<%@ page import="com.openq.web.controllers.Constants"%>

<%  String selectedTab=request.getParameter("selected")==null ?"":request.getParameter("selected");
    String currentKOLName = request.getParameter("currentKOLName") == null ? "" : request.getParameter("currentKOLName");
	String prettyPrint = null != request.getParameter("prettyPrint1") ? (String) request.getParameter("prettyPrint1") : null ;
	if (prettyPrint != null && "true".equalsIgnoreCase(prettyPrint) ) {
%>
 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
       	<td align="right"><span class="text-blue-01-bold" onclick="javascript:window.close()"></span>&nbsp;&nbsp;<span class="text-blue-01-bold" onclick="javascript:window.print()"><img src='images/print.gif' border=0 height="32" title="Printer friendly format"/></span>&nbsp;</td>
	  </tr>
	  </table>
<%}%>




<html>

<head>
<title>openQ 3.0 - openQ Technologies Inc.</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
body {
    margin-left: 0px;
    margin-top: 0px;
    margin-right: 0px;
    margin-bottom: 0px;
}
</style>

<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">

<script  src="<%=COMMONJS%>/validation.js" language="JavaScript"></script>
<script  src="<%=COMMONJS%>/formChangeCheck.js" language="JavaScript"></script>

<%
    OptionLookup userType = (OptionLookup)request.getSession().getAttribute(Constants.USER_TYPE);
%>

<script language="JavaScript">

function toggleAlertMode() {

		var iconName = document.getElementById('_alertIcon').src.toString();
		if (iconName.indexOf('disabled') > 0) {


			if (confirm("Please confirm that you would like to recieve e-mail when '" + "Affiliations" + "' of " + " <%=currentKOLName%> changes. Press OK to confirm.")) {

				document.getElementById('_alertIcon').src = 'images/alert-enabled.gif';
			
				alert("E-mail alerts for '" + "Affiliations" + "' of <%=currentKOLName%> activated.");
				setCookie("Affiliations" + entityId, "enabled", 15);
				//alert(document.getElementById('_alertIcon').src);
			}
		} else {
			if (confirm("Please confirm that you would not like to recieve e-mail when '" + selectedTabName + "' of " + " <%=currentKOLName%> changes. Press OK to confirm.")) {
				document.getElementById('_alertIcon').src = 'images/alert-disabled.gif';
				alert("E-mail alerts for '" + selectedTabName + "' of <%=currentKOLName%> de-activated.");
				eraseCookie(selectedTabName + entityId);
				//alert(document.getElementById('_alertIcon').src);
			}
		}
	}



	/*var attrId = <c:out escapeXml="false" value="${selectedTab}"/>;
	var entityId = <c:out escapeXml="false" value="${entityId}"/>;
	var parentId = <c:out escapeXml="false" value="${parentId}"/>;*/
	var selectedTabName = <%=selectedTab%>

	function toggleAlertMode() {

		var iconName = document.getElementById('_alertIcon').src.toString();
		if (iconName.indexOf('disabled') > 0) {
			if (confirm("Please confirm that you would like to recieve e-mail when '" + selectedTabName + "' of " + " <%=currentKOLName%> changes. Press OK to confirm.")) {
				document.getElementById('_alertIcon').src = 'images/alert-enabled.gif';
				alert("E-mail alerts for '" + selectedTabName + "' of <%=currentKOLName%> activated.");
				//setCookie(selectedTabName + entityId, "enabled", 15);
				//alert(document.getElementById('_alertIcon's).src);
			}
		} else {
			if (confirm("Please confirm that you would not like to recieve e-mail when '" + selectedTabName + "' of " + " <%=currentKOLName%> changes. Press OK to confirm.")) {
				document.getElementById('_alertIcon').src = 'images/alert-disabled.gif';
				alert("E-mail alerts for '" + selectedTabName + "' of <%=currentKOLName%> de-activated.");
				//eraseCookie(selectedTabName + entityId);
				//alert(document.getElementById('_alertIcon').src);
			}
		}
	}


	function addOrg(id, name, type) {
		document.relatedOrg.orgName.value=name;
		document.relatedOrg.orgId.value = id;
		document.relatedOrg.type.value = type;
	}

function deleteOrg(kolId) {

 var thisform =window.frames['orgList'].orgListForm;
 var flag =false;
 for(var i=0;i<thisform.elements.length;i++){
  
  if(thisform.elements[i].type =="checkbox" && thisform.elements[i].checked){
   flag =true;
   break;  
  }
 } 
 thisform.action = "related_org.htm?kolId=" + kolId;
 if(flag){
  thisform.target="inner";
  if(confirm("Do you want to delete the selected Organizations ?")){
  thisform.submit();
  }
 }else {
  alert("Please select atleast one organization to delete");
 }
}

function validateOrgData(){
  
  var thisform = document.relatedOrg;
  var orgN = thisform.orgName.value;
  var type = thisform.type.value;
  if(orgN == "" || type == ""){
	  alert("Please click on Org Search to add an Oraganization");
	  return false;
  }else{
	  thisform.submit();
  }
}

function pageOnLoad(){
    if(parent.resizeIFramesInnerProfile) parent.resizeIFramesInnerProfile();
}

</script>
</head>
<body onLoad="javascript:pageOnLoad();">
<!--div class="producttext" style=width:100%-->
<form name="relatedOrg" target="inner" action="related_org.htm?kolId=<%=request.getParameter("kolId")%>" method="post" AUTOCOMPLETE="OFF">
 <table width="100%" border="0" cellspacing="0" cellpadding="0" id="responseBlock">
  
  <tr>
    <td height="25" colspan="2" align="left" valign="top" class="">
	<div class="myexpertlist">
     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	 <tr align="left" valign="middle" style="color:#4C7398">
	          <td colspan="5" width=100% valign="middle">
	          	 <div class="myexperttext">Affiliations</div>
	          </td>
			  
	  </tr>
      <tr bgcolor="#faf9f2" >
        <td width="5%" height="25">&nbsp;</td>
        <td width="1%" height="25">&nbsp;</td>
        <td width=20% class="expertListHeader">Name</td>
        <td width=20% class="expertListHeader">Type</td>
        <td width=20% class="expertListHeader">Position</td>
        <td width=20% class="expertListHeader">Division</td>        
        <td width=15% class="expertListHeader">Year</td>
      </tr>
    </table>
	</div>   </td>
  </tr>
  <tr>
    <td height="1" colspan="2" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>
  <tr>
    <td height="100" colspan="2" align="left" valign="top" class="back-white">    
     <iframe name="orgList" src="org_list.htm?kolId=<%=request.getParameter("kolId")%>&action=ORGLIST" height="100%" width="100%" frameborder="0" scrolling="yes"></iframe>    </td>
  </tr>
  <tr>
    <td height="1" colspan="2" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>

  <% if(userType.getOptValue().startsWith("Front")){ %>
  
  <tr>
    <td height="30" colspan="2" align="left" valign="top" class="back-white">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="5" height="30">&nbsp;</td> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td width="10">&nbsp;</td>
        </tr>
    </table></td>
  </tr>
  <tr>
  <% } %>
    <td width="20">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td width="99%" align="left" valign="middle" height="35px">
	<input class=button-01 style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; DISPLAY: block; BACKGROUND: url(images/buttons/delete_orgs.gif); BORDER-LEFT: 0px; WIDTH:100; BORDER-BOTTOM: 0px;width:103px;HEIGHT: 23px" type=button value="" onClick="deleteOrg(<%=request.getParameter("kolId")%>)"></td>
  </tr>
  
  <tr> 
     <td height="20" colspan="2" align="left" valign="top">
	<div class="myexpertplan">
     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr align="left" valign="middle">
        <td width="2%" height="20">&nbsp;</td>
        <td width="2%"><img src="<%=COMMONIMAGES%>/icon_my_events.gif" width="14" height="14"></td>
        
        <td class="myexperttext">Add Organization</td>
      </tr>
    </table>
	</div></td>
  </tr>
  <tr>
    <td height="1" colspan="2" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>
  <tr>  
    <td height="120" colspan="2" align="left" valign="top" class="back-white">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="25" height="20">&nbsp;</td>
          <td width="169" class="text-blue-01">Name *</td>
          <td width="170" class="text-blue-01">&nbsp;</td>
          <td width="183" class="text-blue-01">Type </td>
          <td width="112" class="text-blue-01">Year</td>
          <td width="4" class="text-blue-01">&nbsp;</td>                    
        </tr>
        
        <tr>
          <td width="25" height="20">&nbsp;</td>
          <td width="169" class="text-blue-01">
            <input name="orgName" type="text" class="field-blue-01-180x20" maxlength="25" readonly/></td>          
          <td width="170"  class="text-blue-01-link">
			<a href="#" onClick="javascript:window.open('organization_search.htm','searchopenQ','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');" class="text-blue-01-text">Lookup Organizations</a></td>  
          <td width="183"  class="text-blue-01-link">
			<input name="type" type="text" class="field-blue-01-180x20" readonly /></td>           
          <td width="112"  class="text-blue-01-link">
			<input name="year" type="text" class="field-blue-01-180x20" /></td>          
           <td width="4"  class="text-blue-01-link">
			</td>                            
      </tr>
        
        <tr>
          <td width="25" height="20"></td>
          <td width="169" class="text-blue-01">Position</td>
          <td width="170" class="text-blue-01">Division</td>                    
          <td width="183"  class="text-blue-01-link">
			</td>           
          <td width="112"  class="text-blue-01-link">
			</td>          
           <td width="4"  class="text-blue-01-link">
			</td>                            
      </tr>
        
        <tr>
          <td width="25" height="20">&nbsp;<input type="hidden" name="orgId"/></td>
          <td width="169"  class="text-blue-01-link">
			<input name="position" type="text" class="field-blue-01-180x20" /></td>          
           <td width="170"  class="text-blue-01-link">
			<input name="division" type="text" class="field-blue-01-180x20" /></td>                            
          <td width="183"  class="text-blue-01-link">
			 </td>           
          <td width="112"  class="text-blue-01-link">
			         </td>          
           <td width="4"  class="text-blue-01-link">
			        </td>                            
      </tr>
           
	  <tr>
        <td height="20">&nbsp;</td>  
        <td valign="top"><br>
		<input  class=button-01 style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BACKGROUND: url(images/buttons/add_affiliation.gif); BORDER-LEFT: 0px; WIDTH:116px; BORDER-BOTTOM: 0px; HEIGHT: 23px" type="button" value=""  onClick="javascript:validateOrgData();"></td>
        <td>&nbsp;</td>  
        <td>&nbsp;</td>
        <td>&nbsp;</td>             
        <td valign="top">&nbsp;</td>
         <td valign="top" align="right"  height="30" width="5" style="cursor:hand">&nbsp;</td>
<td valign="middle" align="right" width="5" style="cursor:hand" onclick="javascript:window.open('searchInteraction.htm?action=<%=ActionKeys.DEV_PLAN_HOME%>')">&nbsp;</td>
     <td width="15" height="30">&nbsp;</td>
     <td valign="middle" align="right" width="5" onclick='javascript:toggleAlertMode()' style="cursor:hand">&nbsp;</td>
     <td width="5" height="30">&nbsp;</td>
        <td width="10">&nbsp;</td>

        <td>&nbsp;</td>
      
      </tr>
           
	  <tr>
        <td height="20">&nbsp;</td>  
        <td valign="top">&nbsp;</td>
        <td>&nbsp;</td>  
        <td colspan="10" align="right">
        <table>

	<%if (!"true".equalsIgnoreCase(prettyPrint) ) {%>

      <% if ( request.getParameter("currentKOLName") != null && !request.getParameter("currentKOLName").equals("") )
                 { %><!--
                 <td valign="top" align="right" width="67" style="cursor:hand"
                     >
					<a class="text-blue-link" href='<%=request.getContextPath()%>/<%=request.getParameter("parentId")%>.vcf'>
<img src='images/vCard.jpg' border=0 height="32"></a><br>
					<a class="text-blue-link" href='<%=request.getContextPath()%>/<%=request.getParameter("parentId")%>.vcf'>
					Vcard</a></td><%}%>
      <% if ( request.getParameter("currentKOLName") != null && !request.getParameter("currentKOLName").equals("") )
                 { %><td width="8">&nbsp;</td>
                 <td valign="top" align="right" width="37" style="cursor:hand" class="text-blue-link"
                     onClick="javascript:window.open('printFullProfile.htm?entityId=<%=request.getParameter("parentId")%>&currentKOLName=<%=request.getParameter("currentKOLName")%>')">
                    						<a class="text-blue-link" href="#" > <img src='images/print_profile.gif' border=0 height="32" title="Printer friendly format"/><br>
Profile</a>

                 </td>-->
                 <% } %>  <td width="8">&nbsp;</td>   
	<td width="39" height="30" onclick="window.open('related_org.htm?kolId=' + <%=request.getSession().getAttribute("KOLID")%> + '&prettyPrint1=true')" align=center><a class="text-blue-link" href="#"><img src='images/print.gif' border=0 height="32" title="Printer friendly format"/><br>
		Print</a></td>
        <td width="4"></td>

        </td>  
        <td valign="top" align="top" width="45" onclick='toggleAlertMode()' style="cursor:hand">
					<img id='_alertIcon' border=0 src='images/alert-disabled.gif' height=32 alt='Alert me when data changes.' /><br><a class="text-blue-link" href="#">
		Notify</a></td>
<tr>
<td valign="top" align="right"  height="30" width="67" style="cursor:hand">&nbsp;</td>
                 <td valign="top" align="right" width="8" style="cursor:hand"
                     >
					&nbsp;</td>
     <td valign="middle" align="right" width="5">&nbsp;</td>
     <td width="8" height="30" onclick="window.open('related_org.htm?kolId=' + <%=request.getSession().getAttribute("KOLID")%> + '&prettyPrint1=true')">&nbsp;</td>
        <td width="39">&nbsp;</td>

        <td valign="top" align="top" width="4" onclick='toggleAlertMode()' style="cursor:hand">
					&nbsp;</td>
</tr>
		</table><%}%></td>
      
      </tr>
    </table></td>
  </tr>
</table>
</form>
<!--/div-->
</body>
</html>
