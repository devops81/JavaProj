<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp"%>
<%@ page language="java" %>
<%@ page import="com.openq.contacts.Contacts"%>
<%@ page import="com.openq.eav.option.OptionNames"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.eav.trials.ClinicalTrials"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="com.openq.eav.trials.TrialsConstants"%>
<%@ page import="com.openq.eav.trials.TrialOlMap"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.user.User"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<html>

<%
  String from = null;
  if (null != session.getAttribute("FromHome")){
    from = (String)session.getAttribute("FromHome");
  }

  long kolId = Long.parseLong(request.getParameter("olId"));
  String currentKOLName = request.getParameter("currentKOLName") == null ? "" : request.getParameter("currentKOLName");
  
  String mode = "ADD";
  if (session.getAttribute("TRIAL_MODE") != null) {
	mode = (String) session.getAttribute("TRIAL_MODE");
  }
  
  OptionLookup statusLookUp[] = null;
  if (session.getAttribute("TRIAL_STATUS") != null) {
    statusLookUp = (OptionLookup[]) session.getAttribute("TRIAL_STATUS");
  }
  
  String title = "";
  String purpose = "";
  String phase = "";
  String molecule = "";
  String status = "";
  
  if(mode.equalsIgnoreCase("EDIT")) {
  	title = (String) session.getAttribute(TrialsConstants.TRIAL_OFFICIAL_TITLE_ATTRIB_ID + "");
  	purpose = (String) session.getAttribute(TrialsConstants.TRIAL_PURPOSE_ATTRIB_ID + "");
  	phase = (String) session.getAttribute(TrialsConstants.TRIAL_PHASE_ATTRIB_ID + "");
  	molecule = (String) session.getAttribute(TrialsConstants.TRIAL_MOLECULE_ATTRIB_ID + "");
  	status = (String) session.getAttribute(TrialsConstants.TRIAL_STATUS_ATTRIB_ID + "");
  }
%>

<head>
<script language="JavaScript">


function chkMandatory(obj)
{

for(var i=0;i<document.forms[0].length;i++)
	{

if(obj.elements[i].type=="text")
		{
if(obj.elements[i].value=="")
{
alert("Enter the value for "+obj.elements[i].id)
obj.elements[i].focus();
exit(-1);
}

		}
	}
	if(document.ol_to_trial_map.status.options[document.ol_to_trial_map.status.selectedIndex].value==-1)
{
alert("Please choose the status");
document.ol_to_trial_map.status.focus();
exit(-1);
}

}
</script>
<title>openQ 3.0 - openQ Technologies Inc.</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">

<script  src="<%=COMMONJS%>/validation.js" language="JavaScript"></script>
<script  src="<%=COMMONJS%>/formChangeCheck.js" language="JavaScript"></script>

<script language="javascript">
    function toggleAlertMode() {

		var iconName = document.getElementById('_alertIcon').src.toString();
		if (iconName.indexOf('disabled') > 0) {


			if (confirm("Please confirm that you would like to recieve e-mail when '" + "Clinical trials" + "' of " + " <%=currentKOLName%> changes. Press OK to confirm.")) {

				document.getElementById('_alertIcon').src = 'images/alert-enabled.gif';
			
				alert("E-mail alerts for '" + "Clinical trials" + "' of <%=currentKOLName%> activated.");
				setCookie("Clinical trials" + entityId, "enabled", 15);
				//alert(document.getElementById('_alertIcon').src);
			}
		} else {
			if (confirm("Please confirm that you would not like to recieve e-mail when '" + "Clinical trials" + "' of " + " <%=currentKOLName%> changes. Press OK to confirm.")) {
				document.getElementById('_alertIcon').src = 'images/alert-disabled.gif';
				alert("E-mail alerts for '" + selectedTabName + "' of <%=currentKOLName%> de-activated.");
				eraseCookie(selectedTabName + entityId);
				//alert(document.getElementById('_alertIcon').src);
			}
		}
	}
	
	function launchAddTrialForm() {
		document.addTrial.target = "_top";
		document.addTrial.submit();
	}
	
	function deleteSelectedTrials() {
		var thisForm = document.ol_to_trial_map;
		var flag = false;
		var element = thisForm.checkedTrialIds;
		
		if (element.length == null) {
			if (element.type == "checkbox" && element.checked){
			   flag = true;
			}
	  	} 
	  	else {
		  for (var i=0;i<element.length;i++){
		    if (element[i].type == "checkbox" && element[i].checked){
			  flag = true;
			  break;
			}
		  }
	   }
	   
	   if(flag) {
	   	 if (confirm("Do you want to delete the selected trial(s)?")) {
		   thisForm.action = "ol_to_trial_map.htm?action=<%=ActionKeys.DELETE_CLINICAL_TRIALS%>&olId=<%=kolId%>";
		   thisForm.submit();
		 }
	   } 
	   else {
	     alert("Please select atleast one trial to delete");
	   }
	}
	
	function editSelectedTrial() {
		var thisForm = document.ol_to_trial_map;
		var count = 0;
		var element = thisForm.checkedTrialIds;
		
		if (element.length == null) {
		  if (element.type == "checkbox" && element.checked){
		    count = 1;
		  }
	  	} 
	  	else {
		  for (var i=0;i<element.length;i++){
		    if (element[i].type == "checkbox" && element[i].checked){
			  count++;
			}
		  }
	   }
	   
	   if(count == 1) {
	      thisForm.action = "ol_to_trial_map.htm?action=<%=ActionKeys.EDIT_CLINICAL_TRIAL%>&olId=<%=kolId%>";
		  thisForm.submit();
	   } 
	   else {
	     alert("Please select one trial to edit");
	   }
	}
	
	function cancelEditing()
	{
	  var thisForm = document.ol_to_trial_map;
	  thisForm.action =  "ol_to_trial_map.htm?action=<%=ActionKeys.CLINICAL_TRIAL_HOME%>&olId=<%=kolId%>";
	  thisForm.submit();
	}
	
	function saveUpdatedTrial() {
		var thisForm = document.ol_to_trial_map;
		
		if(checkRequiredFields) {		
			thisForm.action = "ol_to_trial_map.htm?action=<%=ActionKeys.SAVE_UPDATED_CLINICAL_TRIAL%>&olId=<%=kolId%>";
			thisForm.submit();
		}
		else {
			return false;
		}
	}
	
	function checkRequiredFields() {
		var thisForm = document.ol_to_trial_map;
		if (thisForm.title.value == "") {
		  alert ("Please specify a title");
          thisForm.title.focus();
          return false;
		}

		if (thisForm.status.value == "-1") {
		  alert ("Please specify a status");
          thisForm.status.focus();
          return false;
		}
	}

	function addNewTrial() {
	    checkRequiredFields();
		var thisForm = document.ol_to_trial_map;

		// Check all fields are populated properly
		if(checkRequiredFields) {
			thisForm.action = "ol_to_trial_map.htm?action=<%=ActionKeys.ADD_CLINICAL_TRIAL%>&olId=<%=kolId%>";
			thisForm.submit();
		}
		else {
			return false;
		}
	}
</script>

</head>

<body >

<%
   boolean prettyPrint = false;
   String prettyPrintString = request.getParameter("prettyPrint");
   if((prettyPrintString != null) && prettyPrintString.equalsIgnoreCase("true"))
   	  prettyPrint = true;

   if(prettyPrint) {
 %>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td align="right">
	      <span class="text-blue-01-bold" onclick="javascript:window.print()">
	        <img src='images/print.gif' align=middle border=0 height="32"/>
	      </span>
	    </td>
	  </tr>
	</table>
<%
   }
%>

<form name="ol_to_trial_map" method="post" AUTOCOMPLETE="OFF">

  <div class="producttext">
    <div class="myexpertlist">
      <table width="100%">
        <tr style="color:#4C7398">
        <td width=1%>
         <div style="float:right"><img src="images/addpic.jpg"></div>
        </td>
        <td width="50%" align="left">
          <div class="myexperttext">Clinical Trials</div>
        </td>

        </tr>
      </table>
    </div>

    <table height="150" width="100%">
	  <tr>
	   <td valign="top" width="100%">
	    <table width="100%" valign="top" cellspacing="0">
	      <tr bgcolor="#faf9f2">
		      <td width="2%">&nbsp;</td>
		      <td width="28%" class="expertListHeader">Official Title</td>
		      <td width="2%">&nbsp;</td>
		      <td width="18%" class="expertListHeader">Objective</td>
		      <td width="2%">&nbsp;</td>
		      <td width="13%" class="expertListHeader">Phase</td>
		      <td width="2%">&nbsp;</td>
		      <td width="18%" class="expertListHeader">Intervention</td>
		      <td width="2%">&nbsp;</td>
		      <td width="13%" class="expertListHeader">Status</td>
	      </tr>
	      <%

			ClinicalTrials [] trials = (ClinicalTrials [])request.getSession().getAttribute("trials");
			TrialOlMap [] trialOlMapArray = (TrialOlMap []) request.getSession().getAttribute("trialOlMapArray");

	        if(trials != null && trials.length != 0) {
	          for(int i=0;i<trials.length;i++){
	     %>

		       <tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'>

		         <%
                   if(!prettyPrint) {
                 %>

		         <td width="2%" height="25" align="center">
		           <input type="checkbox" name="checkedTrialIds" value="<%=trialOlMapArray[i].getTrialId()%>"/>&nbsp;
		         </td>

		         <%
		           }
		           else {
		         %>

		         <td width="2%">&nbsp;</td>

		         <%
		           }
		         %>

	        <td width="28%" class="expertListRow" align="left" ><a target="_top" class='text-blue-01-link' href="trials.htm?entityId=<%=trialOlMapArray[i].getTrialId()%>"><%=trials[i].getOfficialTitle()%></a></td>
				 <td width="2%">&nbsp;</td>
				 <td width="18%" class="text-blue-01" align="left" ><%=trials[i].getPurpose()!= null?trials[i].getPurpose():"" %></td>
				 <td width="2%">&nbsp;</td>
				 <td width="13%" class="text-blue-01" align="left" ><%=trials[i].getPhase()!=null?trials[i].getPhase():"" %></td>
				 <td width="2%">&nbsp;</td>
				 <td width="18%" class="text-blue-01" align="left" ><%=trials[i].getMolecules() !=null ?trials[i].getMolecules():""%></td>
				 <td width="2%">&nbsp;</td>
				 <td width="13%" class="text-blue-01" align="left" ><%=trials[i].getStatus()%></td>
	        </tr>

		  <% } } %>
        </table>
       </td>
      </tr>

      <!-- Delete trial button -->
      <%
	    if(!prettyPrint) {
	  %>
      <tr>
        <td height="20" valign="top" class="back-white">
	     <table width="100%" border="0" cellspacing="0" cellpadding="0">
	       <tr>
	         <td width="5" height="20">&nbsp;</td>
	         <td width="125">&nbsp;&nbsp;<input name="DeleteTrialButton" type="button" class=button-01 style="border:0px none; DISPLAY: block; BACKGROUND: url('images/buttons/delete_trials.gif'); WIDTH:10; width:103px;HEIGHT: 22px" value="" onClick="deleteSelectedTrials();" <c:out escapeXml="false" value="${disableTrialDeleteButton}"/></td>
	         <td width="4">&nbsp;</td>
	         <td>&nbsp;<input name="EditTrialButton" type="button" style="border:0px none; DISPLAY: block; BACKGROUND: url('images/buttons/edit_trial.gif'); WIDTH:100; width:82px;HEIGHT: 22px"  class="button-01" value="" onClick="editSelectedTrial();" <c:out escapeXml="false" value="${disableTrialEditButton}"/></td>
	         <td width="10">&nbsp;</td>
			 <td width="50" height="20">&nbsp;</td>
	       </tr>
	     </table>
	    </td>
	  </tr>
	  <%
	    }
	  %>

    </table>
   </div>

<%
    if(!prettyPrint) {
%>
    <div class="producttext">
   	  <table width="100%">
   	    <tr>
		  <td height="20" align="left" valign="top">
		    <div class="myexpertlist">
		      <table width="98%"  border="0" cellspacing="0" cellpadding="0">
			    <tr style="color:#4C7398">
			      <td>
			           <div class="myexperttext"><%=((mode.equalsIgnoreCase("EDIT")) ?  "Edit Trial" :  "Add New Trial") %></div>
			      </td>
			    </tr>
			  </table>
		    </div>
		  </td>
		</tr>

		<tr>
		  <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
		</tr>
		<tr>
		  <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
		</tr>

		<tr>
		    <td height="40" align="left" valign="top" class="back-white">
		      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
		          <td width="3%" height="20">&nbsp;</td>
		          <td width="25%" class="text-blue-01-bold"> Official Title *</td>
		          <td width="3%" class="text-blue-01">&nbsp;</td>
		          <td width="15%" class="text-blue-01-bold"> Objective  </td>
		          <td width="3%" class="text-blue-01">&nbsp;</td>
		          <td width="15%" class="text-blue-01-bold"> Phase </td>
		          <td width="3%" class="text-blue-01">&nbsp;</td>
		          <td width="15%" class="text-blue-01-bold"> Intervention </td>
		          <td width="3%" class="text-blue-01">&nbsp;</td>
		          <td width="15%" class="text-blue-01-bold"> Status *</td>
		        </tr>
		        <tr>
		          <td width="3%" height="20">&nbsp;</td>
		          <td width="25%" class="text-blue-01-bold"><input name="title" id="title" type="text" value="<%=title%>"/></td>
		          <td width="3%" class="text-blue-01">&nbsp;</td>
		          <td width="15%" class="text-blue-01-bold"><input id="Objective"  name="purpose" type="text" value="<%=purpose%>"/></td>
		          <td width="3%" class="text-blue-01">&nbsp;</td>
		          <td width="15%" class="text-blue-01-bold"><input name="phase" id="Phase" type="text" value="<%=phase%>"/></td>
		          <td width="3%" class="text-blue-01">&nbsp;</td>
		          <td width="15%" class="text-blue-01-bold"><input name="molecule" id="Intervention" type="text" value="<%=molecule%>"/></td>
		          <td width="3%" class="text-blue-01">&nbsp;</td>
		          <td width="15%" class="text-blue-01-bold">
		          	<select name="status" id="status"  class="field-blue-01-180x20">
					   <option value="-1">Please Select</option>
					   <%if (statusLookUp != null && statusLookUp.length > 0) {
			                OptionLookup lookup = null;
			                String val = "";
			                for (int i = 0; i < statusLookUp.length; i++) {
			                    lookup = statusLookUp[i];
			                    val =  String.valueOf(lookup.getId());
			           %>
			           <option value="<%=lookup.getOptValue()%>" <%=lookup.getOptValue().equals(status)?"SELECTED":""%>><%=lookup.getOptValue()%></option>
			           <%
			                }
			             }
			           %>
					</select>
		          </td>
		        </tr>
		      </table>
		    </td>
		</tr>
				
		<tr>
	      <td valign="top" class="back-white">
		     <table width="100%" border="0" cellspacing="0" cellpadding="0">
		       <tr>
		         <td width="5" height="20">&nbsp;</td>
		<%
				 if(mode.equalsIgnoreCase("EDIT")) {
		%>
		         <td width="127">&nbsp;&nbsp;<input name="SaveTrial" type="button" style="border:0px none; DISPLAY: block; BACKGROUND: url('images/buttons/save_trial.gif'); WIDTH:10; width:94px;HEIGHT: 23px" class="button-01" value="" onClick="saveUpdatedTrial();" <c:out escapeXml="false" value="${disableTrialEditButton}"/></td>
		         <td width="132">&nbsp;&nbsp;&nbsp;&nbsp;<input name="CancelEditTrial" type="button"  class="button-01" style="border:0px none; DISPLAY: block; BACKGROUND: url('images/buttons/cancel_edit.gif'); WIDTH:10; width:101px;HEIGHT: 22px" value="" onClick="cancelEditing();" <c:out escapeXml="false" value="${disableTrialEditButton}"/></td>
		<%
				 }
				 else {
		%>
				<td width="528">&nbsp;&nbsp;<input name="AddTrial" type="button" style="border:0px none; DISPLAY: block; BACKGROUND: url('images/buttons/add_trial.gif'); WIDTH:10; width:84px;HEIGHT: 22px" class="button-01" value="" onClick="addNewTrial();" <c:out escapeXml="false" value="${disableTrialAddButton}"/></td>
		<%
				 }
		%>
		         <td width="10">&nbsp;</td>
		         <td>&nbsp;</td>
		         <td width="10">&nbsp;</td>
				 <td width="50" height="20">&nbsp;</td>
		       </tr>
		     </table>
		  </td>
	    </tr>
		<tr>
	      <td valign="top" class="back-white">
		     <table width="100%" border="0" cellspacing="0" cellpadding="0">
		       <tr>
		         <td width="5" height="20">&nbsp;</td>
		<%
				 if(mode.equalsIgnoreCase("EDIT")) {
		%>
		         <td width="127">&nbsp;&nbsp;</td>
		         <td width="132">&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<%
				 }
				 else {
		%>
				<td align="right"><table>
<td valign="top" align="right"  height="30" width="0" style="cursor:hand"></a></td>
      <!--<% if ( request.getParameter("currentKOLName") != null && !request.getParameter("currentKOLName").equals("") )
                 { %>
                 <td valign="top" align="right" width="48" style="cursor:hand"
                     ><a class="text-blue-link" href='<%=request.getContextPath()%>/<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>.vcf'>
<img src='images/vCard.jpg' border=0 height="32"></a><br>
					<a class="text-blue-link" href='<%=request.getContextPath()%>/<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>.vcf'>
					Vcard</a></td><%}%>
    <td width="11">&nbsp;</td>
    
                 <td valign="top" align="right" width="37" style="cursor:hand"
                     onClick="javascript:window.open('printFullProfile.htm?entityId=<%=request.getParameter("parentId")%>&currentKOLName=<%=request.getParameter("currentKOLName")%>')">
                     <img src='images/print_profile.gif' border=0 height="32" title="Printer friendly format"/><br><a class="text-blue-link" href="#" >Profile</a>

                 </td>
                -->

     <td width="11">&nbsp;</td>
                

     <td width="15" height="30" onclick="window.open('ol_to_trial_map.htm?olId=' + <%=request.getSession().getAttribute("KOLID")%> + '&prettyPrint=true' + '&action=<%=ActionKeys.CLINICAL_TRIAL_HOME%>')"><img src='images/print.gif' border=0 height="32" title="Printer friendly format"/><br><a class="text-blue-link" href="#">
		Print</a></td>
        <td width="11">&nbsp;</td>

        </td>  
        <td valign="top" align="top" width="5" onclick='javascript:toggleAlertMode()' style="cursor:hand">
					<img id='_alertIcon' border=0 src='images/alert-disabled.gif' height=32 alt='Alert me when data changes.' /><br><a class="text-blue-link" href="#">
		Notify</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></table></td>
		<%
				 }
		%>
		         </tr>
		     </table>
		  </td>
	    </tr>

	  </table>
	</div>
<%
	}
%>

</form>
<%   	  
   if(!prettyPrint) {
%>
      <table width=100% border="0" cellspacing="0" cellpadding="0">
			  </table>
	  
	  <form name="addTrial" action="add_trial.jsp">
	  </form>
<%
   }
%>
</body>
</html>
