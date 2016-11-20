<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="java.util.Properties"%>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="java.awt.*" %>
<%@ page language="java" %>
<%@ page import="com.openq.eav.option.OptionLookup"%>

<%@page import="com.openq.report.Report"%>

<%
int flag = 0;
	String mode = (String)session.getAttribute("mode");
String Refresh_parent = (String) session.getAttribute("Refresh_parent");
Map entityGroupMap = (Map) request.getAttribute("REPORT_PERMISSION_MAP");
request.removeAttribute("REPORT_PERMISSION_MAP");
%>
<script>
	var dupReportNameFlag = false;

function trim(stringToTrim) {
	return stringToTrim.replace(/^\s+|\s+$/g,"");
}

	function addReport() 
	{	
		var formObj = reportForm;
		var frv = formObj.reportName.value;
		var frv1 = trim(frv);
		if (frv1 == "") {
	   		alert("Please provide the name of the report.");
  			return false;
		} 
		
		if (formObj.browse.value == "") {
			alert("Please browse a file for report upload.");		
			return false;
		} 
		
		var fileName = formObj.browse.value;	
		
		var len = fileName.length;
	  	var lastIndex = fileName.lastIndexOf(".");	
		var fileNameSub = fileName.substring(lastIndex+1,len);
		
	
	  if (fileNameSub.substring(0,3) != "jrx") {
		  alert("Please upload only .rpt file"); 
		  return false;
		}
			
		formObj.submit(); 

	}
	
	function updateReport() 
	{  		
		var formObj = reportForm;
		if (checkNull(formObj.browse, 'Report Name') == false) {
  			return false;
		} 
		
		if (!(formObj.reportPath.checked)) {
	
			if (formObj.browse.value == "") {
				alert("Please browse a file for report upload");		
				return false;
			} 
	
	
			var fileName = formObj.browse.value;	
			var len = fileName.length;
		  var lastIndex = fileName.lastIndexOf(".");	
			var fileNameSub = fileName.substring(lastIndex+1,len);
	
	    	if (fileNameSub != "rpt") {
			  alert("Please upload only .rpt file"); 
			  formObj.reportName.value = "";
			  return false;
			}	
		}		
		
		formObj.submit();
	}
	
	function viewReport(reportLoc,winName,features) {
		var url = "CONTEXTPATH/report.do?action=ActionKeys.VIEW_REPORT&reportLoc="+reportLoc;
		window.open(url,winName,features);
	}
	
	function goBack(formObj,contextURL){
		formObj.action = contextURL+"/report.do?action=ActionKeys.REPORT_HOME";
	    formObj.submit();
	}

	function deleteReport()
	{
 		var thisForm = deleteReportForm;
 		var flag = false;
 		var element = thisForm.deletedReportID; 		
 
 		if (element.length == null) {
			if (element.type == "checkbox" && element.checked) {
	   			flag = true;
			}
  		} else {	
    		for (var i=0;i<element.length;i++){
		
     			if (element[i].type == "checkbox" && element[i].checked){
					flag = true;
					break;		
	 			}
    		}
  		}	 
 
	    if (flag) {
     		if(confirm("Do you want to delete the selected report(s)?")){
        		thisForm.submit();
        		
     		}
  		} else {
     		alert("Please select atleast one report to delete");
 		}
 
	}

	function checkDupReportName(contextURL, reportId, reportName, editedReportName) {

		var inputName = document.reportForm.reportName.value;
		if(inputName != undefined && inputName != null && inputName != "") {
			if(Trim(editedReportName.toLowerCase()) != Trim(inputName.toLowerCase()) && Trim(inputName.toLowerCase()) == Trim(reportName.toLowerCase())) {
				alert('Please provide non-duplicate report name');
				document.reportForm.reportName.value = "";
				document.reportForm.reportName.focus();
				return true;	
			}
		}
		
		return false;
	}
	
	function Trim(TRIM_VALUE) {

		if(TRIM_VALUE.length < 1) {
			return"";
		}

		TRIM_VALUE = RTrim(TRIM_VALUE);
		TRIM_VALUE = LTrim(TRIM_VALUE);

		if(TRIM_VALUE == ""){
			return "";
		} else {
			return TRIM_VALUE;
		}
	} //End Function

	function RTrim(VALUE) {
	
		var w_space = String.fromCharCode(32);
		var v_length = VALUE.length;
		var strTemp = "";
		
		if(v_length < 0) {
			return"";
		}
		
		var iTemp = v_length -1;

		while(iTemp > -1) {
		
			if(VALUE.charAt(iTemp) == w_space){
			} else {
				strTemp = VALUE.substring(0,iTemp +1);
				break;
			}
			iTemp = iTemp-1;

		} //End While
		
		return strTemp;

	} //End Function

	function LTrim(VALUE) {

		var w_space = String.fromCharCode(32);
		if(v_length < 1){
			return"";
		}
		var v_length = VALUE.length;
		var strTemp = "";

		var iTemp = 0;

		while(iTemp < v_length) {
			if(VALUE.charAt(iTemp) == w_space){
			} else {
				strTemp = VALUE.substring(iTemp,v_length);
				break;
			}
			iTemp = iTemp + 1;
		} //End While
		
		return strTemp;
	} //End Function	
	
	function Refresh_Page()
	{

		 top.location.href="reportsAdmin.htm";
	}

	
	
	
</script>
<html>
<head>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
</head>
<script type="text/javascript" src="./js/sorttable.js"></script>
<script language="javascript" src="js/groupLevelSecurity.js"></script>
<body>
	<% 
    if ("yes".equalsIgnoreCase(Refresh_parent)) 
	   {session.removeAttribute("Refresh_parent"); 
		 %>
		<script>
		  Refresh_Page();
		  </script>
		  <%}%>
	
<form name="deleteReportForm" AUTOCOMPLETE="OFF" method="POST" enctype="multipart/form-data">
<div class="producttext" style=width:98%>
<input type="hidden" name="action" value="delete"/>
<table width="100%"  height="100px" border="0" cellspacing="0" cellpadding="0" align="center">

  <tr>
    <td height="20" align="left" valign="top">
     	<div class="myexpertlist">
	      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	        <tr align="left" valign="middle" style="color:#4C7398">
	          <td width="5%" height="20">&nbsp;</td>
	          <td width="2%"><img src="images/icon_values.gif" width="14" height="14"></td>
	          <td width="28%" class="availablereportstext">Available Report </td>
	          <td width="25%" class="text-blue-01-bold">&nbsp;</td>
	          <td width="20%" class="text-blue-01-bold">&nbsp;</td>
	          <td width="20%" class="text-blue-01-bold">&nbsp;</td>
	        </tr>
	        <tr align="left" valign="middle" style="color:#4C7398" class="myexpertplan">
	          <td width="5%" height="20">&nbsp;</td>
	          <td width="2%"><img src="images/icon_values.gif" width="14" height="14"></td>
	          <td width="28%" class="text-blue-01-bold">Report Name</td>
	          <td width="25%" class="text-blue-01-bold">Report Description</td>
	          <td width="20%" class="text-blue-01-bold">Permitted User Groups</td>
	          <td width="20%" class="text-blue-01-bold">Change User Groups</td>
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
	        <table width="100%" height="40px" style="max-height:50px,overflow:scroll" border="0" cellspacing="0" cellpadding="0" class="sortable">
			      <%
				  	for(Iterator itr=reportsList.iterator(); itr.hasNext();){
				  	  Report report = (Report)itr.next();
					  	String permittedGroups = "";
						Long reportIdLong = new Long(report.getReportID());
						if(entityGroupMap != null && entityGroupMap.containsKey(reportIdLong) && entityGroupMap.get(reportIdLong) != null)
							permittedGroups = entityGroupMap.get(reportIdLong)+"";
			  	  %>
		          <tr align="left" valign="middle">
		            <td width="5%" height="25" align="center"><input name="deletedReportID" type="checkbox" value='<%=report.getReportID()%>'></td>
		            <td width="2%" align="left"><img src="images/icon_values.gif" width="14" height="14"></td>
		            <td width="25%" class="text-blue-01-link"><%=report.getName()%></td>
		            <td width="25%" class="text-blue-01"><%=report.getDescription()%></td>
		            <td width="25%" class="text-blue-01" id="permittedGroupsTd<%=report.getReportID()%>"value="<%=permittedGroups%>"><%=permittedGroups%></td>
		            <td width="10%" class="text-blue-01">
		            	<img src="images/configure.gif" onclick="showGroupChangerPopup('<%=report.getReportID()%>','<%=Constants.REPORT_PERMISSION_ID%>')" style="cursor: pointer;">
		            </td>
		          </tr>
			  <%
			  	}
			  %>
	      </table>
	    </div>
      </td>
    </tr>
  <br>  
  <tr>
    <td height="10" align="left" valign="top" class="back-white">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="25" height="10">&nbsp;</td>
          <td>
            <input name="deleteReportButton" style="border:0;background : url(images/buttons/delete_reports.gif);width:120px; height:22px;" type="button" class="button-01" onClick="javascript:deleteReport()"/>
          </td>
          <td width="10">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>

<form name="reportForm" AUTOCOMPLETE="OFF" method="POST" enctype="multipart/form-data">
<%           	
  if ("EDIT".equalsIgnoreCase(mode)) {
%>
<input type="hidden" name="action" value="update"/>
<input type="hidden" name="reportID" value="1"/>
<%
  } else {
%>
<input type="hidden" name="action" value="add"/>
<%
  }
%>
<a name="addReportSection"></a>
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="20" align="left" valign="top" class="myexpertplan">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr align="left" valign="middle" style="color:#4C7398">
	<td width="2%" height="20"></td>

        <td width="2%" align="left">&nbsp;<img src="images/icon_values.gif" width="14" height="14"></td>
        <td  class="myexperttext"><%= ("EDIT".equalsIgnoreCase(mode) ?"Edit Report":"Upload New Report")%></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
  </tr>
  <tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="images/transparent.gif" width="10" height="10"></td>
  </tr>
  <tr>
    <td height="50" align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="25" height="20">&nbsp;</td>
        <td width="180" class="text-blue-01">Report Name *</td>
        <td width="20" class="text-blue-01">&nbsp;</td>
        <td width="220" class="text-blue-01">Report File Path *</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td height="20">&nbsp;</td>
        <td><input name="reportName" type="text" class=".field-new1-01-180x20"></td>
        <td>&nbsp;</td>
        <td colspan="3" class="text-blue-01">
        	<!--input name="browse" type="file" class=""/-->
        	
		<!--div class="fileinputs">
			<input name="reportFile" type="file" class="file" />
				<div class="fakefile">
				<input />
					<img src="images/addactivity.jpg" />
				</div>
		</div>
		<div class="fileinputs">
			<input name="reportFile" type="file" class="file">
		</div>
		<input type="file" name="browse" style="display: none;">
	   	<input type="text" name="file">
	   	<input type="button" style="border:0;background : url(images/buttons/browse.gif);width:78px; height:22px;" onClick="browse.click();file.value=browse.value;"-->
			<input name="browse" type="file" class=""/>
        </td>
		
	        </td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td height="10" colspan="8"><img src="images/transparent.gif" width="10" height="10"></td>
      </tr>
      <tr>
        <td height="20">&nbsp;</td>
        <td  width="180" class="text-blue-01">Report Description </td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td height="20">&nbsp;</td>
        <td><textarea name="reportDesc" wrap="VIRTUAL" class="field-blue-07-180x50"></textarea></td>
        <td>&nbsp;</td>
        <td valign="top" class="text-black-link">&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="images/transparent.gif" width="10" height="10"></td>
  </tr>
  <tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
  </tr>
  <tr>
    <td height="30" align="left" valign="middle" class="back-white">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="25" height="30">&nbsp;</td>        
          <%           	
       	    if ("EDIT".equalsIgnoreCase(mode)) {
          %>
	        <td>
	          <input name="updateReportButton" type="button" class="button-01" value="Update Report" onClick="updateReport()"> 
			    </td>
	        <td width="10">&nbsp;</td>
    	    <td width="10"><input name="cancelReportButton" type="button" class="button-01" value="Cancel Edit" onClick="javascript:goBack(this.form, '<%=CONTEXTPATH%>')"> </td>
          <%
            } else { 
          %>
	        <td>
	          <input name="addReportButton" type="button" style="border:0;background : url(images/buttons/add_report.gif);width:101px; height:23px;" class="button-01" value="" onClick="addReport()">
	        </td>
          <%
            } 
          %>
      </tr>
    </table></td>
  </tr>
  

</table>
</div>
</form>
</body>
</html>
