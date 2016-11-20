<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page import="com.openq.kol.SearchDTO,java.util.*" %>

<%

	String ovidClientStatus = null;
	Object obj = pageContext.getServletContext().getAttribute("OVID_STATUS");
	if(obj != null)
		ovidClientStatus = obj.toString();

	if(ovidClientStatus != null && "Executing".equals(ovidClientStatus))
		ovidClientStatus = "disabled";

    SearchDTO expertDTO = null;


    ArrayList ad_expert_user_list = (ArrayList) session.getAttribute("EXPERT_ADVANCE_SEARCH");

    String fromDate = (String) session.getAttribute("fromDate");
    if (fromDate == null) fromDate = "";
    String toDate = (String) session.getAttribute("toDate");
    if (toDate == null) toDate = "";
    TreeMap searchAttributes = (TreeMap) session.getAttribute("searchAttributes");
    if (searchAttributes == null) searchAttributes = new TreeMap();
    int userTypeId = 0;/*Integer.parseInt((String) session.getAttribute(SessionKeys.USER_TYPE_ID));*/

    String kolScheduler = "";
    if (session.getAttribute("KOL_SCHEDULER") != null) {
        kolScheduler = (String) session.getAttribute("KOL_SCHEDULER");
    }

    ArrayList ovidSrch = null;
    if (session.getAttribute("OVID_SEARCH_RESULT") != null) {
        ovidSrch = (ArrayList) session.getAttribute("OVID_SEARCH_RESULT");
    }

    TreeMap uniqueIdMap = null;
    if (session.getAttribute("UNIQUE_ID_MAP") != null) {
        uniqueIdMap = (TreeMap) session.getAttribute("UNIQUE_ID_MAP");
    }

    String[] results = new String[3];
    if(request.getAttribute("results") != null){
        results = (String[]) request.getAttribute("results");
    }

    if(results[0] == null || "null".equals(results[0])){
        results[0] = "00:00";
    }
    if(results[1] == null || "null".equals(results[1])){
        results[1] = "";
    }
    if(results[2] == null || "null".equals(results[2])){
        results[2] = "";
    }

%>

<%@ include file="adminHeader.jsp" %>
<html>
<head>
<title>openQ 2.0 - openQ Technologies Inc.</title>
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
<script src="<%=COMMONJS%>/columnSort.js" language="Javascript"></script>

<Script language="Javascript">

function showText(text, id) {
    if (text != null && id != null) {
        text = decodeURIComponent(text);
        if (text != null && text.indexOf("+") != -1) {
            text = text.replace(/\+/g, ' ');
        }
        document.getElementById(id).title = text.substring(0, 500);
    }
}
function commitDB() {
    var flag = false;
    var thisform = document.OvidSearchForm;
    for (var i = 0; i < thisform.elements.length; i++) {

        if (thisform.elements[i].type == "checkbox" && thisform.elements[i].checked) {
            flag = true;
            break;
        }
    }
    if (flag) {
        thisform.action = "<%=CONTEXTPATH%>/search.do?action=<%=ActionKeys.COMMIT_DB%>";
        thisform.submit();
    } else {
        alert("Please select atleast one Author to delete");
    }
}
var ordCol = -1;

function sortExpertData(imageContext, imgName, colNamesList, tableId, col, rev, dataType, orderedCol, dataSize) {


    if (dataSize == null || dataSize == 0)
        return false;

    // toggle the image head icon.
    var imageSrcURL = "";

    var colNames = colNamesList.split(",");
    var element;

    var currentArrow = "";

    for (var index = 0; colNames != null && index < colNames.length; ++index) {

        element = document.getElementById(colNames[index]);

        if (element != null) {

            if (imgName == element.id) {

                imageSrcURL = imageContext + "/transparent.gif";

                currentArrow = element.src.substring(element.src.lastIndexOf('/') + 1);

                if (currentArrow != null && currentArrow == "transparent.gif") {
                    element.src = imageContext + "/arrow_up_dark.gif";
                    rev = false;
                } else {
                    imageSrcURL = imageContext + "/arrow_down_dark.gif";
                    rev = true;
                    if (currentArrow != null && currentArrow == "arrow_down_dark.gif") {
                        element.src = imageContext + "/arrow_up_dark.gif";
                        rev = false;
                    } else {
                        element.src = imageSrcURL;
                    }
                }

            } else {
                imageSrcURL = imageContext + "/transparent.gif";
                element.src = imageSrcURL;
            }
        }
    }

    sortTable(tableId, col, rev, dataType, ordCol);
    ordCol = col;

    //	sortTable(tableId, col, rev, dataType, orderedCol);
}




function searchOvid(){

    var thisform = document.OvidSearchForm;
    thisform.action = "<%=CONTEXTPATH%>/PublicationServlet";
    thisform.submit();
}

function saveschedule(){
    var thisform = document.OvidSearchForm;
    if(thisform.startDate.value == ""){
        alert("Please fill start date");
        return false;
    }
    if(thisform.daysbetween.value == ""){
        alert("Please fill Days Between Execution");
        return false;
    }
    if(isNaN(thisform.daysbetween.value)){
        alert("Days Between Execution should be a number");
        return false;
    }
    if(parseInt(thisform.daysbetween.value) <= 0){
        alert("Days Between Execution should be a non-zero positive number");
        return false;
    }

    thisform.action = "<%=CONTEXTPATH%>/PublicationServlet?source=schedule";
    thisform.submit();
}

function show_calendar(sName) {
    gsDateFieldName = sName;
    // pass in field name dynamically
    var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";
    if (document.layers)    // NN4 param
        winParam = "top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";
    window.open("Popup/PickerWindow.html", "_new_picker", winParam);
}

function MM_openBrWindow(theURL, winName, features)
{
    window.open(theURL, winName, features);
}
function checkTime() {
    var time = window.document.forms[0].startTime.value;
	time = time.replace('.',':');
    var index = time.indexOf(':');
    var index1 = 3;
    if(index == -1){
    	index = 2;
    	index1 = index;
    }
    var hr = parseInt(time.substr(0,index));
    var min = 0;
    if(time.length - index1 > 0) {
        min = parseInt(time.substr(index1,time.length));
    }


    if(isNaN(hr) || isNaN(min)){
        alert("Only numbers allowed");
        window.document.forms[0].startTime.focus();
        return false;
    }
	if(hr < 0){
		alert("Only positive numbers allowed");
        window.document.forms[0].startTime.focus();
        return false;
	}
    if(hr < 10)
    	hr = "0"+hr;
    if(min < 10 && min >0)
    	min = "0"+min;
    window.document.forms[0].startTime.value = hr+":"+min;
    if(hr < 0 || min < 0){
        alert("Only positive numbers allowed");
        window.document.forms[0].startTime.focus();
        return false;
    }
    if(hr > 23){
        alert("Hours can not be more than 23");
        window.document.forms[0].startTime.focus();
        return false;
    }
    if(min > 60){
        alert("Minutes can not be more than 60");
        window.document.forms[0].startTime.focus();
        return false;
    }

}
</Script>


<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">
</head>

<body>
<form name="OvidSearchForm" method="Post" AUTOCOMPLETE="OFF">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
    <td>
        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">


<tr>
<td height="100%" align="left" valign="top">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
<!--		<td width="200" class="back-blue-02-light">
		<iframe name="adcalender" src="<%=COMMONJSP%>/blank.jsp" height="100%" width="120%"  frameborder="0" scrolling="auto"></iframe>
		</td>
        <td width="5" class="back_vert_sprtr">&nbsp;</td>
-->
<td width="10" class="back-blue-02-light">&nbsp;</td>
<td class="back-blue-02-light">
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>

<tr valign="top">
    <td>
        <jsp:include page="ovid_search_menu.jsp"/>
    </td>
</tr>

<tr>
    <td height="30" align="left" valign="top">&nbsp;</td>
</tr>
<tr>
    <td height="20" align="left" valign="top" class="back_horz_head">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="10" height="20">&nbsp;</td>
                <td width="25"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td class="text-white-bold">Schedule</td>
                <td class="text-white-bold" align="right"></td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>
<tr>
    <td height="30" align="left" valign="bottom" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="8">&nbsp;</td>
			</tr>
            <tr>
                <td width="1%">&nbsp;</td>
                <td width="10%" class="text-blue-01">Start Time (Hr:Min)*<br>(eg 00:00 - 23:59)</td>
                <td width="1%">&nbsp;</td>
                <td width="10%" class="text-blue-01">Start Date* (MM/DD/YYYY)</td>
                <td width="1%">&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="10%" class="text-blue-01">Days Between Execution*</td>
                <td width="30%">&nbsp;</td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td align="left" valign="top" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="1%" height="30">&nbsp;</td>
                <td width="10%" valign="top"><input name="startTime" type="text" class="text-blue-01" value="<%=results[0]%>" maxlength="5" onblur="checkTime()"></td>
                <td width="1%">&nbsp;</td>
                <td width="10%" class="text-blue-01" valign="top"><input name="startDate" type="text" value="<%=results[1]%>" class="text-blue-01" readonly></td>
                <td width="1%" align="right">
                <a href="javascript:void(0)" onclick="show_calendar('forms[0].startDate');return false;">
                  <img src="<%=COMMONIMAGES%>/icon_calendar.gif" width="14" height="17" border="0">
                </a>
              </td>
                <td width="1%">&nbsp;</td>
                <td width="10%" class="text-blue-01" valign="top"><input name="daysbetween" type="text" value="<%=results[2]%>" class="field-blue-16-150x20" maxlength="3"></td>

                <td width="30%">&nbsp;</td>
            </tr>
        </table>
    </td>
</tr>

<tr>
    <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>

<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>

<tr>
    <td height="50" align="left" valign="middle" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="1%" height="30">&nbsp;</td>
                <td width="15%"><input type="button" name="saveSchedule" class="button-01" value="Save Schedule" onclick="saveschedule();"/></td>
                <td width="1%" height="30">&nbsp;</td>
                <td width="15%"><%--<input type="button" name="executeCapture" class="button-01" value="Execute Capture" onclick="searchOvid();" >--%></td>
                <td width="60%" height="30">&nbsp;</td>
            </tr>
        </table>
    </td>
</tr>

</table>
</td>
</tr>
</table>
</td>
</tr>
</table>

</form>

</body>
<%@ include file="footer.jsp" %>
</html>
