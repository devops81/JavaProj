<%@ include file="header.jsp"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.openq.report.Report"%>
<%@page import="com.openq.utils.PropertyReader"%>
<%@page import="com.openq.interactionData.UserRelationship"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>

<%

	Report initialReport = (Report) session
			.getAttribute("initialReport");
	String userId = (String) request.getSession().getAttribute(
			Constants.USER_ID);
	ArrayList reportParametersList = (ArrayList) session
			.getAttribute("REPORT_PARAMETER_LIST");

	
	UserRelationship currentUserRelationship = (UserRelationship) session.getAttribute(Constants.CURRENT_USER_RELATIONSHIP);
	long userReportLevel = -1;
	if(currentUserRelationship != null){
		if(currentUserRelationship.getReportLevel() != null){
			userReportLevel = Long.parseLong(currentUserRelationship.getReportLevel());
		}
	}
	final String DEFAULT_REPORT_DISPLAY_VALUE = "All";
%>

<head>
<link rel="stylesheet" type="text/css" media="all"
	href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />
<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>
<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>
<script type="text/javascript" src="js/newcalendar.js"></script>
<script language="javascript" src="js/populateChildLOV.js"></script>
</head>
<script type="text/javascript">
var reportID=null;
<%if(initialReport!=null){%>
	reportID=<%=initialReport.getReportID()%>;
<%}%>

function toggleCheckboxValue(checkBoxObj, validValue){
	if(checkBoxObj!=null){
		if(checkBoxObj.value == '')
			checkBoxObj.value = validValue;
		else
			checkBoxObj.value = '';
	}
}

function setReportId(reportID){
	document.getElementById("reportId").value = reportID;
	runReport(false);
}

function runReport(hasParametersFlag){

	// Update the product list
	updateProductList();
	
	// Update the UnOffLabelproduct list
	updateUnOffLabelProductList();
	
//Update survey list
if(!updateSurveyList())
	return 0
			if(reportID==null){
				alert("Please Select a report from Choose Reports Section");
				return;
			}
			var elements = document.getElementById('reportForm').elements;
			var parameterList="?reportID="+reportID;
        	if(elements!=null && elements.length>0){
				for(var i = 0; i < elements.length; i++){
					if(elements[i].name!=null && elements[i].name!="" && elements[i].value!=null && elements[i].value!=""){
						if(elements[i].name!='startDate' && elements[i].name!='endDate'
						 && elements[i].name!='reportTerritory' &&  elements[i].name!='reportRegion' && elements[i].name!='reportTherapeuticArea'
						 && elements[i].name!='headQuarters' && elements[i].name!='productList' && elements[i].name!='unOffLabelProductList'
						 && elements[i].name!='surveyList' && elements[i].name!='photourl')
							parameterList=parameterList+"&"+elements[i].name+"='"+elements[i].value+"'"
						else if(elements[i].value!='mm/dd/yyyy')
							parameterList=parameterList+"&"+elements[i].name+"="+elements[i].value
					}

				}
		}
		document.getElementById("rightPane").src="reportsViewer.htm"+parameterList+"&headQuarters=All&URLVer=" + new Date().getTime();
	}


	function show_calendar(sName) {
		gsDateFieldName = sName;
	    // pass in field name dynamically
	    var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";

	    if (document.layers) // NN4 param
	    	winParam = "top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";
	    window.open("Popup/PickerWindow.html", "_new_picker", winParam);
	}

	function updateProductList() {
		var productList = document.getElementById('productList');
		if (productList != null && productList != undefined) {
			var products = document.getElementById('product');
			if (products != null && products != undefined) {
				var nameList = "";
				for (var i=products.length-1; i>0; i--) {
					var product = products.options[i].id;
					nameList =  "'" + product + "'," + nameList;
				}
				productList.value = nameList.substring(0, nameList.length-1);
			}
		}
	}
	
	function updateUnOffLabelProductList() {
		var productList = document.getElementById('unOffLabelProductList');
		if (productList != null && productList != undefined) {
			var products = document.getElementById('unOffLabelProduct');
			if (products != null && products != undefined) {
				var nameList = "";
				for (var i=products.length-1; i>0; i--) {
					var product = products.options[i].id;
					nameList =  "'" + product + "'," + nameList;
				}
				productList.value = nameList.substring(0, nameList.length-1);
			}
		}
	}
	




		function updateSurveyList() {
		var surveyList = document.getElementById('surveyList');
		if (surveyList != null && surveyList != undefined) {
			var surveys = document.getElementById('surveys');
			if (surveys != null && surveys != undefined) {
				var nameList = "";
				if(surveys.options[surveys.options.selectedIndex].id==-1)
					{
					  alert('Please select a survey')
					  return false
					}
				else
				{
					surveyList.value="'"+surveys.options[surveys.options.selectedIndex].id+"'";
				    return true
				}

			}
		}
		return true;
	}

/*This is a generic function which deletes all the rows from a given table. Should be ported to a common util.js
*/
function deleteAllTableElements(tableObject)
{
		if(tableObject!=null&&tableObject!=undefined)
		{
			for(var j=tableObject.rows.length-1;j>=0;j--)
			{
				tableObject.deleteRow(j)
			}
	  }

}
/*This javascript fuction removes the static reports parameter content in the page. If for some reports static reports param is not required then it could be removed using this function.
*/
	function removeStaticParameters()
	{
	  var reportsTable = document.getElementById('reportsTableId');
	  //alert(tableObj.rows.length)
	  deleteAllTableElements(reportsTable)
	 }
<%
String reportTherapeuticAreaLOV = PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA");
String reportRegionLOV = PropertyReader.getLOVConstantValueFor("RAD");
String reportTerritoryLOV = PropertyReader.getLOVConstantValueFor("TERRITORY");
String reportProductLOV = PropertyReader.getLOVConstantValueFor("PRODUCT");
String reportOffLabelProductLOV = PropertyReader.getLOVConstantValueFor("OFF_LABEL_PRODUCT");
String reportsAreaOfExpertiseLOV = PropertyReader.getLOVConstantValueFor("AREA_OF_EXPERTISE");
%>
	var userReportLevelJS = <%= userReportLevel %>;
</script>
<body>
<form name="reportForm" method="get">
<input name="reportId" type="hidden" />
<input type="hidden" name="userReportLevel" value="<%=userReportLevel %>"/>
<div class="reportcontentleft" style="height: 300">
<div class="reportleftnav" style="height: 300">
<div class="leftsearchbgpic">
<div class="leftsearchtext" align="left"><span
	class="text-blue-01-bold">Report Universe</span></div>
</div>
<div class="combobox1" name="report">
<table width="100%" height="300">
	<tbody>
		<tr>
			<td><iframe src="reportsTree.htm" name="reportsLeftPane"
				height="1024" id="eportsLeftPane" width="100%" frameborder="0"
				scrolling="auto"></iframe></td>
		</tr>
	</tbody>
</table>
</div>
</div>
</div>

<div class="contentmiddle" height="1024">
<%
	if (reportParametersList != null && reportParametersList.size() > 0) {
%>
<div class="producttext" height="20">
		<div class="myexpertlist">
            <table width="100%">
              <tr style="color:#4C7398">
                <td width="50%" align="center">
                  <div class="myexperttext"><%=(initialReport != null)? initialReport.getName():""%></div>
                </td>
              </tr>
            </table>
          </div>
<table name="reportsTable" id="reportsTableId" width="100%" border="0">
 <tr>
 <td width="28%">
 &nbsp;</td>
 <td width="28%">
 &nbsp;</td>
 <td width="28%">
 &nbsp;</td>
 <td>
 <!--a class="text-blue-link" href="http://localhost:8082/jasperserver-pro/flow.html?_flowId=adhocFlow&curlnk=2">Ad-hoc Reports
  </a-->
 </td>
</tr>
<%String disabled = "";
//if(userReportLevel == Constants.HQ_REPORT_LEVEL){
   disabled = "disabled";
//}else{
	//disabled = "";
//}
%>
<!--tr>
	<td width="20%"><span class="text-blue-01-bold">Head Quarters : </span></td>
	<td>
		<select id="headQuarters"
				name="headQuarters" class="field-blue-01-180x20" <%=disabled%>
				onChange="populateChildLOV(this, 'reportTherapeuticArea', true, '<%=reportTherapeuticAreaLOV%>')">
			<option id="<%= Constants.GET_ALL_CHILD_LOVS%>" value="All" selected><%=DEFAULT_REPORT_DISPLAY_VALUE %></option>
			<c:forEach items="${reportsHeadQuarters}" varStatus="i">
				<option id="<c:out value="${reportsHeadQuarters[i.index].id}"></c:out>"
						value="<c:out value="${reportsHeadQuarters[i.index].optValue}"></c:out>"
						class="field-blue-06-180x20"
						<c:if test="${userTerritory == reportsHeadQuarters[i.index].id}">selected</c:if>>
						<c:out value="${reportsHeadQuarters[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select>
	</td>
</tr-->
<%
	if(userReportLevel != Constants.HQ_REPORT_LEVEL){
		disabled = "disabled";
	}else{
		disabled = "";
	}

%>
 <%System.out.println("RealPath: "+request.getRealPath("")+System.getProperty("file.separator")+"photos"+System.getProperty("file.separator"));
 if(reportParametersList.contains("photourl")) {%>
 
 <tr><td width="20">&nbsp;<input type="hidden" name="photourl" 
value='<%=request.getRealPath("")+System.getProperty("file.separator")+"photos"+System.getProperty("file.separator")%>' /></td><tr>
<%} %>

<%if(reportParametersList.contains("reportTherapeuticArea")){ %>
<tr>
	<td width="20%"><span class="text-blue-01-bold">Therapeutic Area : </span></td>
	<td>
		<select id="reportTherapeuticArea"
				name="reportTherapeuticArea" class="field-blue-01-180x20" <%=disabled %>
				onChange="populateChildLOV(this, 'reportRegion', true, '<%=reportRegionLOV%>'),
				 populateChildLOVByDeleteStatus(this, 'product', true, '<%=reportProductLOV%>', true)
				 populateChildLOVByDeleteStatus(this, 'unOffLabelProduct', true, '<%=reportOffLabelProductLOV%>', true)">
			<option id="<%= Constants.GET_ALL_CHILD_LOVS%>" value="All" selected><%=DEFAULT_REPORT_DISPLAY_VALUE %></option>
			<c:forEach items="${reportsTA}" varStatus="i">
				<option id="<c:out value="${reportsTA[i.index].id}"></c:out>"
						value="<c:out value="${reportsTA[i.index].optValue}"></c:out>"
						class="field-blue-06-180x20"
						<%if(userReportLevel!=Constants.HQ_REPORT_LEVEL&&
	                     userReportLevel != Constants.TA_REPORT_LEVEL){%>
						<c:if test="${userParentTA == reportsTA[i.index].id}">selected</c:if>>
						<%} else{%>
						<c:if test="${userTerritory == reportsTA[i.index].id}">selected</c:if>>
						<%}%>
						<c:out value="${reportsTA[i.index].optValue}"></c:out>
				   </option>
			</c:forEach>
		</select>
	</td>
</tr>
<%} %>
<%		if(userReportLevel != Constants.HQ_REPORT_LEVEL &&
			userReportLevel != Constants.TA_REPORT_LEVEL){
			disabled = "disabled";
		}else{
			disabled = "";
		}

%>
<%if(reportParametersList.contains("reportRegion")){ %>
<tr>
	<td width="20%"><span class="text-blue-01-bold">Region : </span></td>
	<td>
		<select id="reportRegion"
				name="reportRegion" class="field-blue-01-180x20" <%=disabled %>
				onChange="populateChildLOV(this, 'reportTerritory', true, '<%=reportTerritoryLOV%>')">
			<option id="<%= Constants.GET_ALL_CHILD_LOVS%>" value="All" selected><%=DEFAULT_REPORT_DISPLAY_VALUE %></option>
			<c:forEach items="${reportsRAD}" varStatus="i">
				<option id="<c:out value="${reportsRAD[i.index].id}"></c:out>"
						value="<c:out value="${reportsRAD[i.index].optValue}"></c:out>"
						class="field-blue-06-180x20"
						<%if(userReportLevel!= Constants.HQ_REPORT_LEVEL &&
			userReportLevel != Constants.TA_REPORT_LEVEL &&
					userReportLevel != Constants.RAD_REPORT_LEVEL){%>
						<c:if test="${userParentRAD == reportsRAD[i.index].id}">selected</c:if>>
						<%} else{%>
					    <c:if test="${userTerritory == reportsRAD[i.index].id}">selected</c:if>>
						<%}%>
						<c:out value="${reportsRAD[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select>
	</td>
</tr>
<%} %>
<%
 	if(userReportLevel == Constants.MSL_REPORT_LEVEL || userReportLevel == -1){
		disabled = "disabled";
	}else{
		disabled = "";
	}
%>
<%if(reportParametersList.contains("reportTerritory")){ %>
<tr>
	<td width="20%"><span class="text-blue-01-bold">Territory : </span></td>
	<td>
		<select id="reportTerritory"
				name="reportTerritory" class="field-blue-01-180x20" <%=disabled %>>
			<option id="<%= Constants.GET_ALL_CHILD_LOVS%>" value="All" selected><%=DEFAULT_REPORT_DISPLAY_VALUE %></option>
			<c:forEach items="${reportsTerritory}" varStatus="i">
				<option id="<c:out value="${reportsTerritory[i.index].id}"></c:out>"
						value="<c:out value="${reportsTerritory[i.index].optValue}"></c:out>"
						class="field-blue-06-180x20"
						<c:if test="${userTerritory == reportsTerritory[i.index].id}">selected</c:if>>
						<c:out value="${reportsTerritory[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select>
	</td>
</tr>
<%} %>
<%if (reportParametersList.contains("surveys")){%>
	   <script type="text/javascript">
		removeStaticParameters()
		</script>
		<tr>
		<td width="20%"><input type="hidden" id="surveyList" name="surveyList" value=""><span class="text-blue-01-bold">Survey : </span></input></td>
		<td>
			<select	id="surveys" name="surveys" class="field-blue-01-180x20">
				<option id="-1" value="" selected>Select a Survey</option>
				<c:forEach items="${surveyName}" var="mapEntry">
					<option id="<c:out value="${mapEntry.value}"></c:out>"
					value="<c:out value="${mapEntry.value}"></c:out>" class="field-blue-06-100x20">
				  <c:out value="${mapEntry.key}"></c:out>
					</option>
				</c:forEach>
			</select>
		</td>
	</tr>
<%}%>
<%
		if (reportParametersList.contains("therapeuticArea") || reportParametersList.contains("region")) {
	%>
<tr>
	<%
		if (reportParametersList.contains("therapeuticArea")) {
	%>

		<td width="28%" ><span class="text-blue-01-bold">Therapeutic Area:</span></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("region")) {
		%>
		<td width="28%"><span class="text-blue-01-bold">Region:</span></td>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
	<%
		}
	%>
	</tr>
	<%}%>
	<%
		if (reportParametersList.contains("therapeuticArea") || reportParametersList.contains("region")) {
	%>
	<tr>
		<%
			if (reportParametersList.contains("therapeuticArea")) {
		%>
		<td width="28%" ><select name="therapeuticArea"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${reportsTA}" varStatus="i">
				<option value="<c:out value="${reportsTA[i.index].id}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${reportsTA[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("region")) {
		%>
		<td width="28%"><select name="region"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${reportsEventRegion}" varStatus="i">
				<option value="<c:out value="${reportsEventRegion[i.index].id}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${reportsEventRegion[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<%}%>
	<%
		if (reportParametersList.contains("productInteraction")) {
	%>
	<tr>
		<td width="20%"><span class="text-blue-01-bold">Product Interactions : </span></td>
		<td>
			<select	name="productInteraction" class="field-blue-01-180x20">
				<option value="" selected>All</option>
				<option value="1">1st</option>
			</select>
		</td>
	</tr>
	<%
		}
	%>
	<%
		if (reportParametersList.contains("product")) {
	%>
	<tr>
		<td width="20%"><input type="hidden" id="productList" name="productList" value="">
		<span class="text-blue-01-bold">Product : </span></input></td>
		<td>
			<select	id="product" name="product" class="field-blue-01-180x20">
				<option value="" selected>All</option>
				<c:forEach items="${reportsProducts}" varStatus="i">
					<option id="<c:out value="${reportsProducts[i.index].id}"></c:out>" value="<c:out value="${reportsProducts[i.index].optValue}"></c:out>" class="field-blue-06-100x20">
						<c:out value="${reportsProducts[i.index].optValue}"></c:out>
					</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<%
		}
	%>
	
	<%
		if (reportParametersList.contains("unOffLabelProduct")) {
	%>
	<tr>
		<td width="20%"><input type="hidden" id="unOffLabelProductList" name="unOffLabelProductList" value=""><span class="text-blue-01-bold">Unsolicited Off-Label Product : </span></input></td>
		<td>
			<select	id="unOffLabelProduct" name="unOffLabelProduct" class="field-blue-01-180x20">
				<option value="" selected>All</option>
				<c:forEach items="${reportsUnOffLabelProducts}" varStatus="i">
					<option id="<c:out value="${reportsUnOffLabelProducts[i.index].id}"></c:out>" value="<c:out value="${reportsUnOffLabelProducts[i.index].optValue}"></c:out>" class="field-blue-06-100x20">
						<c:out value="${reportsUnOffLabelProducts[i.index].optValue}"></c:out>
					</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<%
		}
	%>
	   <%
        if (reportParametersList.contains("allProduct")) {
    %>
    <tr>
        <td width="20%"><span class="text-blue-01-bold">Product : </span></td>
        <td>
            <select id="allProduct" name="allProduct" class="field-blue-01-180x20">
                <option value="" selected>All</option>
                <c:forEach items="${reportsProducts}" varStatus="i">
                    <option id="<c:out value="${reportsProducts[i.index].id}"></c:out>" value="<c:out value="${reportsProducts[i.index].optValue}"></c:out>" class="field-blue-06-100x20">
                        <c:out value="${reportsProducts[i.index].optValue}"></c:out>
                    </option>
                </c:forEach>
            </select>
        </td>
    </tr>
    <%
        }
    %>
	<%
		if (reportParametersList.contains("startDate") || reportParametersList.contains("endDate")) {
	%>
	<tr>
		<%
			if (reportParametersList.contains("startDate")) {
		%>
		<td width="28%"><span class="text-blue-01-bold" onclick="DeleteRow(this)">Choose Start Date:</span></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("endDate")) {
		%>
		<td width="28%"><span class="text-blue-01-bold">Choose End Date:</span></td>
		<%
			}
		%>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<%}%>
	<%
		if (reportParametersList.contains("startDate") || reportParametersList.contains("endDate")) {
	%>

	<tr>
		<%
			if (reportParametersList.contains("startDate")) {
		%>
		<td width="11%"><input type="text" size="15"
			class="field-blue-01-180x20" name="startDate" id="sel1"
			value="mm/dd/yyyy" onclick="if(value=='mm/dd/yyyy')value=''"><a href="#"
			onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"></a>
		<a href="#"
			onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"><img
			src="images/buttons/calendar_24.png" width="22" height="22"
			border="0" align="top"></a></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("endDate")) {
		%>
		<td width="11%"><input type="text" size="15"
			class="field-blue-01-180x20" name="endDate" id="sel2"
			value="mm/dd/yyyy" onclick="if(value=='mm/dd/yyyy')value=''"><a href="#"
			onclick="return showCalendar('sel2', '%m/%d/%Y', '24', true);"></a>
		<a href="#"
			onclick="return showCalendar('sel2', '%m/%d/%Y', '24', true);"><img
			src="images/buttons/calendar_24.png" width="22" height="22"
			border="0" align="top"></a></td>
		<%
			}
		%>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<%}%>
	<%
		if (reportParametersList.contains("therapy") || reportParametersList.contains("description") || reportParametersList.contains("division")) {
	%>

	<tr>
		<%
			if (reportParametersList.contains("therapy")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Therapy:</span></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("description")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Medical Meeting
		Description:</span></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("division")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Medical Meeting
		Division:</span></td>
		<%
			}
		%>

	</tr>
	<%}%>
	<%
		if (reportParametersList.contains("therapy") || reportParametersList.contains("description") || reportParametersList.contains("division")) {
	%>
	<tr>
		<%
			if (reportParametersList.contains("therapy")) {
		%>
		<td width="28%" ><select name="therapy"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${reportsTherapy}" varStatus="i">
				<option value="<c:out value="${reportsTherapy[i.index].id}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${reportsTherapy[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("description")) {
		%>
		<td width="28%" ><select name="description"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${reportsEventSubType}" varStatus="i">
				<option value="<c:out value="${reportsEventSubType[i.index].id}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${reportsEventSubType[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("division")) {
		%>
		<td width="28%" ><select name="division"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${reportsEventDivision}" varStatus="i">
				<option value="<c:out value="${reportsEventDivision[i.index].id}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${reportsEventDivision[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
	</tr>
	<%}%>
    <%
       if (reportParametersList.contains("diseaseArea")) {
    %>
    <tr>
        <td width="28%" ><span class="text-blue-01-bold">Disease Area:</span></td>
        <td width="28%" >
            <select id="diseaseArea" name="diseaseArea" class="field-blue-01-180x20" onChange="populateChildLOV(this, 'areaOfExpertise', true, '<%=reportsAreaOfExpertiseLOV%>')">
                <option id="<%= Constants.GET_ALL_CHILD_LOVS%>" value="All" selected><%=DEFAULT_REPORT_DISPLAY_VALUE %></option>
                <c:forEach items="${reportsDiseaseArea}" varStatus="i">
                    <option id="<c:out value="${reportsDiseaseArea[i.index].id}"></c:out>" value="<c:out value="${reportsDiseaseArea[i.index].optValue}"></c:out>" class="field-blue-06-100x20">
                        <c:out value="${reportsDiseaseArea[i.index].optValue}"></c:out>
                    </option>
                </c:forEach>
            </select>
        </td>
    </tr>
    <%}%>
    <%
       if (reportParametersList.contains("areaOfExpertise")) {
    %>
    <tr>
        <td width="28%" ><span class="text-blue-01-bold">Area of Expertise:</span></td>
        <td width="28%" >
            <select id="areaOfExpertise" name="areaOfExpertise" class="field-blue-01-180x20">
                <option value="" selected>All</option>
                <c:forEach items="${reportsAreaOfExpertise}" varStatus="i">
                    <option id="<c:out value="${reportsAreaOfExpertise[i.index].id}"></c:out>" value="<c:out value="${reportsAreaOfExpertise[i.index].optValue}"></c:out>" class="field-blue-06-100x20">
                        <c:out value="${reportsAreaOfExpertise[i.index].optValue}"></c:out>
                    </option>
                </c:forEach>
            </select>
        </td>
    </tr>
    <%}%>
	<%
		if (reportParametersList.contains("MSLOLType") ||
				reportParametersList.contains("saxaOLCharacteristics") ||
				reportParametersList.contains("CVMETSphereOfInfluence")) {
	%>

	<tr>
		<%
			if (reportParametersList.contains("MSLOLType")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">MSL <%=DBUtil.getInstance().doctor%> Type :</span></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("saxaOLCharacteristics")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Saxa <%=DBUtil.getInstance().doctor%> Characteristics :</span></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("CVMETSphereOfInfluence")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Sphere Of Influence :</span></td>
		<%
			}
		%>

	</tr>
	<%}%>
	<%
		if (reportParametersList.contains("MSLOLType") ||
				reportParametersList.contains("saxaOLCharacteristics") ||
				reportParametersList.contains("CVMETSphereOfInfluence")) {
	%>
	<tr>
		<%
			if (reportParametersList.contains("MSLOLType")) {
		%>
		<td width="28%" ><select name="MSLOLType"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${MSLOLType}" varStatus="i">
				<option value="<c:out value="${MSLOLType[i.index].optValue}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${MSLOLType[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("saxaOLCharacteristics")) {
		%>
		<td width="28%" ><select name="saxaOLCharacteristics"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${saxaOLCharacteristics}" varStatus="i">
				<option value="<c:out value="${saxaOLCharacteristics[i.index].optValue}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${saxaOLCharacteristics[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("CVMETSphereOfInfluence")) {
		%>
		<td width="28%" ><select name="CVMETSphereOfInfluence"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${CVMETSphereOfInfluence}" varStatus="i">
				<option value="<c:out value="${CVMETSphereOfInfluence[i.index].optValue}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${CVMETSphereOfInfluence[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
	</tr>
	<%}%>
	<%
		if (reportParametersList.contains("status") || reportParametersList.contains("speakerTrainerBureau")) {
	%>
	<tr>
		<%
			if (reportParametersList.contains("status")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Medical Meeting
		Status:</span></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("speakerTrainerBureau")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Speaker/Trainer
		Bureau :</span></td>
		<%
			}
		%>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<%}%>
	<%
		if (reportParametersList.contains("status") || reportParametersList.contains("speakerTrainerBureau")) {
	%>

	<tr>
		<%
			if (reportParametersList.contains("status")) {
		%>
		<td width="28%" ><select name="status"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${reportsEventStatus}" varStatus="i">
				<option value="<c:out value="${reportsEventStatus[i.index].id}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${reportsEventStatus[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("speakerTrainerBureau")) {
		%>
		<td width="28%" ><select name="speakerTrainerBureau"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${reportsEventType}" varStatus="i">
				<option value="<c:out value="${reportsEventType[i.index].id}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${reportsEventType[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>

	</tr>
	<%}%>

		<%
			if (reportParametersList.contains("contactType")) {
		%>
		<tr>
			<td width="28%" ><span class="text-blue-01-bold">Contact
			Type:</span></td>
		</tr>
		<tr>
		<td width="28%" ><select name="contactType"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${reportsContactMechanismType}" varStatus="i">
				<option value="<c:out value="${reportsContactMechanismType[i.index].id}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${reportsContactMechanismType[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>

		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
		</tr>
		<%
			}
		%>

	<%
		if (reportParametersList.contains("contractActiveFlag") || reportParametersList.contains("agreementTerm")) {
	%>
	<tr>
		<%
			if (reportParametersList.contains("contractActiveFlag")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Active:</span></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("agreementTerm")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Term:</span></td>
		<%
			}
		%>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<%}%>
	<%
		if (reportParametersList.contains("contractActiveFlag") || reportParametersList.contains("agreementTerm")) {
	%>
	<tr>
		<%
			if (reportParametersList.contains("contractActiveFlag")) {
		%>
		<td width="28%" ><select name="contractActiveFlag"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<option value="Yes">Active</option>
			<option value="No">Inactive</option>
		</select></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("agreementTerm")) {
		%>
		<td width="28%" ><select name="agreementTerm"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${reportsAgreementTerms}" varStatus="i">
				<option value="<c:out value="${reportsAgreementTerms[i.index].id}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${reportsAgreementTerms[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>

	</tr>
<%}%>
	<%
		if (reportParametersList.contains("eventOwner") || reportParametersList.contains("eventRequestor")) {
	%>
	<tr>
		<%
			if (reportParametersList.contains("eventOwner")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Owner:</span></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("eventRequestor")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Requestor:</span></td>
		<%
			}
		%>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<%}%>
	<%
		if (reportParametersList.contains("eventOwner") || reportParametersList.contains("eventRequestor")) {
	%>
	<tr>
		<%
			if (reportParametersList.contains("eventOwner")) {
		%>
		<td class="text-blue-01" valign="top"><input type="text" id=""
			name="eventOwner" class="field-blue-01-180x20" value=""> <!--A href="#" onClick="employeeSearch()" class="text-blue-01-link">  Lookup Employee</A-->
		</td>

		<%
			}
		%>
		<%
			if (reportParametersList.contains("eventRequestor")) {
		%>
		<td class="text-blue-01" valign="top"><input type="text"
			name="eventRequestor" class="field-blue-01-180x20" value="">
		</td>
		<%
			}
		%>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>

	</tr>
<%}%>

		<%
			if (reportParametersList.contains("proceduralVolumeFlag")) {
		%>
		<tr>
			<td class="text-blue-01" valign="top">&nbsp;&nbsp;&nbsp;&nbsp; <input
				type="checkbox" name="carotid" class="field-blue-01-180x20" value="Carotid"
				onClick="toggleCheckboxValue(this,'Carotid')" checked>Carotid
			&nbsp;&nbsp;&nbsp;&nbsp; <input type="checkbox" name="ivus"
				class="field-blue-01-180x20" value="IVUS"
				onClick="toggleCheckboxValue(this,'IVUS')" checked>IVUS
			&nbsp;&nbsp;&nbsp;&nbsp; <input type="checkbox" name="des"
				class="field-blue-01-180x20" value="DES"
				onClick="toggleCheckboxValue(this,'DES')" checked>DES
			&nbsp;&nbsp;&nbsp;&nbsp; <input type="checkbox" name="leod"
				class="field-blue-01-180x20" value="LEOD"
				onClick="toggleCheckboxValue(this,'LEOD')" checked>LEOD</td>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
		<%
			}
		%>

		<%
			if (reportParametersList.contains("speakerBureauFlag") || reportParametersList.contains("trainerBureauFlag")) {
		%>
		<tr>
			<td class="text-blue-01" valign="top">&nbsp;&nbsp;&nbsp;&nbsp;
		<% if(!reportParametersList.contains("trainerBureauFlag")){%>
			 	<input
				type="checkbox" name="des" class="field-blue-01-180x20" value="Drug-Eluting Stent (DES)"
				onClick="toggleCheckboxValue(this,'Drug-Eluting Stent (DES)')" checked>DES
			&nbsp;&nbsp;&nbsp;&nbsp;
		<%} %>
			<input type="checkbox" name="ivus"
				class="field-blue-01-180x20" value="Intra Vascular Ultra Sound"
				onClick="toggleCheckboxValue(this,'Intra Vascular Ultra Sound')" checked>IVUS
			&nbsp;&nbsp;&nbsp;&nbsp; <input type="checkbox" name="rota"
				class="field-blue-01-180x20" value="Rotablator"
				onClick="toggleCheckboxValue(this,'Rotablator')" checked>ROTA
			&nbsp;&nbsp;&nbsp;&nbsp; <input type="checkbox" name="carotid"
				class="field-blue-01-180x20" value="Carotid "
				onClick="toggleCheckboxValue(this,'Carotid ')" checked>CAROTID
			&nbsp;&nbsp;&nbsp;&nbsp; <input type="checkbox" name="cryo"
				class="field-blue-01-180x20" value="CryoPlasty Therapy"
				onClick="toggleCheckboxValue(this,'CryoPlasty Therapy')" checked>CRYOPLASTY</td>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
		<%
			}
		%>

	<%
		if (reportParametersList.contains("activeFlag") || reportParametersList.contains("qualifiedFor") || reportParametersList.contains("state")) {
	%>
	<tr>
		<%
			if (reportParametersList.contains("activeFlag")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Active:</span></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("qualifiedFor")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">Level:</span></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("state")) {
		%>
		<td width="28%" ><span class="text-blue-01-bold">State/Prov.:</span></td>
		<%
			}
		%>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<%}%>
	<%
		if (reportParametersList.contains("activeFlag") || reportParametersList.contains("qualifiedFor") || reportParametersList.contains("state")) {
	%>
	<tr>
		<%
			if (reportParametersList.contains("activeFlag")) {
		%>
		<td width="28%" ><select name="activeFlag"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<option value="1">Active</option>
			<option value="0">Inactive</option>
		</select></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("qualifiedFor")) {
		%>
		<td width="28%" ><select name="qualifiedFor"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${reportsQualifiedFor}" varStatus="i">
				<option value="<c:out value="${reportsQualifiedFor[i.index].id}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${reportsQualifiedFor[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
		<%
			if (reportParametersList.contains("state")) {
		%>
		<td width="28%" ><select name="state"
			class="field-blue-01-180x20">
			<option value="" selected>All</option>
			<c:forEach items="${reportsState}" varStatus="i">
				<option value="<c:out value="${reportsState[i.index].id}"></c:out>"
						class="field-blue-06-100x20">
						<c:out value="${reportsState[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%
			}
		%>
	</tr>
<%}%>


		<%
			if (reportParametersList.contains("expertName")) {
		%>
		<tr>
			<td width="28%" ><span class="text-blue-01-bold"><%=DBUtil.getInstance().doctor%>
			Name:</span> <input type="text" name="expertName"
				class="field-blue-01-180x20" value=""></td>
		</tr>
		<%
			}
		%>

		<%
			if (reportParametersList.contains("accountNumber")) {
		%>
		<tr>
			<td width="28%" colspan="2"><span class="text-blue-01-bold">Account Number:</span>
			<input type="text" name="accountNumber"	class="field-blue-01-180x20" value=""></td>
		</tr>
		<%
			}
		%>

		<%
			if (reportParametersList.contains("venueName")) {
		%>
		<tr>
			<td width="28%" colspan="2"><span class="text-blue-01-bold">Venue Name:</span>
			&nbsp;&nbsp;&nbsp;
			<input type="text" name="venueName" class="field-blue-01-180x20" value=""></td>
		</tr>
		<%
			}
		%>

	<%
		if (reportParametersList.contains("Te_Re") || reportParametersList.contains("interactionType")) {
	%>
	<tr>
	 <% if (reportParametersList.contains("Te_Re")){%>
		<td width="28%" ><span class="text-blue-01-bold">Report Level:</span></td>

		<%} %>
	<% if (reportParametersList.contains("interactionType")){%>
		<td width="28%" ><span class="text-blue-01-bold">Interaction Type:</span></td>

		<%} %>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>

	</tr>
	<%} %>
	<%

 	if(userReportLevel == Constants.MSL_REPORT_LEVEL || userReportLevel == -1){
		disabled = "disabled";
	}else{
		disabled = "";
	}

		if (reportParametersList.contains("Te_Re") || reportParametersList.contains("interactionType")) {
	%>
	<tr>
	  <% if (reportParametersList.contains("Te_Re")){%>
		<td width="28%" ><select name="Te_Re"
			class="field-blue-01-180x20" <%=disabled %> >
			<c:forEach items="${reportResultsLevel}" varStatus="i">
				<option value=<c:out value="${reportResultsLevel[i.index].optValue}"></c:out>
						class="field-blue-06-100x20">
						<c:out value="${reportResultsLevel[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%} %>
		<% if (reportParametersList.contains("interactionType")){%>
		<td width="28%" ><select name="interactionType"
			class="field-blue-01-180x20">
			<c:forEach items="${reportInteractionType}" varStatus="i">
				<option value=<c:out value="${reportInteractionType[i.index].optValue}"></c:out>
						class="field-blue-06-100x20">
						<c:out value="${reportInteractionType[i.index].optValue}"></c:out>
				</option>
			</c:forEach>
		</select></td>
		<%} %>
	</tr>
<%}%>

	<tr></tr>
	<td width="28%" class="text-blue-01"><input type="button"
		name="Search1" align="center"
		style="border: 0; background: url(images/buttons/generate.gif); width: 91px; height: 22px;"
		class="button-01" value="" onClick="runReport()" /></td>
	<td>&nbsp;</td>
	<td width="20">&nbsp;<input type="hidden" name="userId"	value=<%=userId%> /></td>
	</tr>
</table>
</div>
<%
	} else {
%> "Please choose a report from the Report Menu" <%
	}
%>
<div class="producttext" height="1024">
<td valign=top><iframe src="blank.html" name="rightPane"
	height="1024" id="rightPane" width="100%" frameborder="0"
	scrolling="auto"></iframe></td>
</div>
</div>
</form>
</body>
<%@ include file="footer.jsp"%>


