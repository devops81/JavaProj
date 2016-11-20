<!-- saved from url=(0022)http://internet.e-mail -->
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page language="java" %>
<%@ include file="header.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.eav.org.Organization" %>
<%@ page import="com.openq.orgContacts.OrgContacts" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.awt.*" %>
<%@ page import="java.lang.reflect.Array" %>
<%@ page import="com.openq.user.User" %>

<%
    if (request.getSession().getAttribute(Constants.CURRENT_USER) == null)
        response.sendRedirect("login.htm");


    ArrayList OrgData = null;
    if (null != session.getAttribute("ORGNAME_WITH_ID")) {
        OrgData = (ArrayList) session.getAttribute("ORGNAME_WITH_ID");
    }
    String staffIdForOrg ="";
    if (null != session.getAttribute("STAFFID")){
        staffIdForOrg = (String)session.getAttribute("STAFFID");
    }
    String userName ="";
    if (null != session.getAttribute("USERNAME")){
        userName = (String)session.getAttribute("USERNAME");
    }
    User alignedUser=null;
    if (null != session.getAttribute("ALIGNED_USER")){
        alignedUser = (User)session.getAttribute("ALIGNED_USER");
    }

    Map contactsOrgMap=new LinkedHashMap();
    if(session.getAttribute("CONTACTS_ORG_MAP")!=null){
       contactsOrgMap=(LinkedHashMap)session.getAttribute("CONTACTS_ORG_MAP");
    }
    String email = null != session.getAttribute("EMAIL")? (String)session.getAttribute("EMAIL") : null;
    String phone = null != session.getAttribute("PHONE")? (String)session.getAttribute("PHONE") : null;
    String filterParam = null != session.getAttribute("FILTER_PARAM")? (String)session.getAttribute("FILTER_PARAM") : null;
    String beginDate = null != session.getAttribute("CONTACT_PRESENT_DATE")? (String)session.getAttribute("CONTACT_PRESENT_DATE") : null;
    String endDate = null != session.getAttribute("CONTACT_END_DATE")? (String)session.getAttribute("CONTACT_END_DATE") : null;
%>

<HTML>
<HEAD>
    <TITLE>openQ 2.0 - openQ Technologies Inc.</TITLE>
    <LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
    <link rel="stylesheet" type="text/css" media="all" href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />
	<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>
	<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>
    <SCRIPT src="<%=COMMONJS%>/listbox.js" language="Javascript"></SCRIPT>
    <SCRIPT src = "<%=COMMONJS%>/validation.js" language = "Javascript"></SCRIPT>
    <style type="text/css">
        <!--
        style2 {
            color: #0080FF;
            font-weight: normal;
        }

        style7 {
            color: #FF0000
        }

        -->
    </style>
</HEAD>

<script type="text/javascript">
 function printList() {
    var thisform = document.orgAlignment;
    var staffId = document.orgAlignment.staffId.value;
    var userName = document.orgAlignment.userName.value;
    window.open("<%=CONTEXTPATH%>/orgAlignment.htm?action=<%=ActionKeys.ORG_ALIGNMENT_PRINT%>&staffId=" + staffId + "&userName="+userName);
    <%--thisform.action = "<%=CONTEXTPATH%>/OLAlignment.htm?action=<%=ActionKeys.ALIGNMENT_PRINT%>&staffId="+staffId;
    thisform.submit();--%>
 }
 function help() {
    alert("For demonstration purpose only. All links are just placeholders.");
 }


 function removeOrg(formObj, contextURL) {

     var checkedObjArray = new Array();
	 var indexOfObjArray = new Array();
	 var cCount = 0;
	 var chk = false;
	 var orgAlignTable = document.getElementById('orgAlignmentTable');
	 var tablebLen=orgAlignTable.rows.length;
     var editButtonSelect = customGetElementByName('editOrgContact');
	 for(var i=0;i<editButtonSelect.length;i++){
		 if(editButtonSelect[i].checked){
			 chk = true;
			 var rowNum =  findRowNumOfTable(editButtonSelect[i].getAttribute("id"));
			 checkedObjArray[cCount] = orgAlignTable.rows[rowNum];
			 indexOfObjArray[cCount] = rowNum;
			 cCount++;
		}
	}
	if (!chk){
		 alert("Check Row To Delete");
	}
	if (checkedObjArray.length > 0)
	{
		 deleteRows(checkedObjArray);
		 reorder(orgAlignTable, indexOfObjArray[0]);
	}
 }


 function reorder(tableObj, firstIndex){
      for(var i= 0;i< tableObj.rows.length;i++){
           if (i%2>0){
	              tableObj.rows[i].className = "back-grey-02-light";
           }else{
                   tableObj.rows[i].className= "back-white-02-light";
		   }

      }
 }


   function deleteRows(rowObjArray){
    	for (var i=0; i<rowObjArray.length; i++) {
			var rIndex = rowObjArray[i].sectionRowIndex;
			rowObjArray[i].parentNode.deleteRow(rIndex);
		}
  }


 function findRowNumOfTable(editContactIndex){
 	var orgAlignTable = document.getElementById('orgAlignmentTable');
	for(var j=0; j<orgAlignTable.rows.length;j++){
		var rowIndex = (orgAlignTable.rows[j].cells[7].firstChild.id);
		var editIndex = (editContactIndex);
		if(editIndex == rowIndex){
			return j;
		}
	}


 }
 function resetPage() {
    var thisform = document.orgAlignment;
    thisform.action = "<%=CONTEXTPATH%>/orgAlignment.htm?action=<%=ActionKeys.RESET_ORG_ALIGN%>";
    thisform.submit();
 }

 function saveList() {
    var thisform = document.orgAlignment;
    if(document.getElementById('staffId').value!=''){
    	thisform.action = "<%=CONTEXTPATH%>/orgAlignment.htm?action=<%=ActionKeys.SAVE_ORGS%>";
    	setDateValues();
    	thisform.submit();
    } 	else{
    alert('Please Select User');
    }
 }

 function submitAdvOrgSearch(formObj, contextURL){
    if(document.getElementById('staffId').value!=''){
    	formObj.action = "<%=CONTEXTPATH%>/advanced_org_search.htm?action=<%=ActionKeys.ADV_SEARCH_ORG%>&fromOrgAlignment=true";
    	formObj.target = "_top";
    	formObj.submit();
    }else{
    	alert('Please Select User');
    }
 }
 function addAttendee(username, phone, email, staffid) {
    document.orgAlignment.userName.value = username;
    document.orgAlignment.staffId.value = staffid;
    document.orgAlignment.email.value = email;
    document.orgAlignment.phone.value = phone;
    setButtonsOnLoad();
 }


 function show() {
    var formObj = document.orgAlignment;
    formObj.action = "<%=CONTEXTPATH%>/orgAlignment.htm?action=<%=ActionKeys.ORGREALIGNMENT%>";
    formObj.submit();

 }


 function addOrgs() {
    var staffId = document.orgAlignment.staffId.value;
    var thisform = document.orgAlignment;
    var filterButtonRadio = document.orgAlignment.filterRadio;
    var length = filterButtonRadio.length;
   
	for(var i = 0; i < length; i++) {
		if(filterButtonRadio[i].checked) {
			var filterParam = filterButtonRadio[i].value;
		}
    }
    if (staffId != 0) {
		thisform.action = "<%=CONTEXTPATH%>/orgAlignment.htm?action=<%=ActionKeys.GET_ORGS%>&filter="+filterParam;
    	thisform.submit();
    }
 }




 function setButtonsOnLoad(){
	var filterButtonRadio = document.orgAlignment.filterRadio;
    var length = filterButtonRadio.length;
	for(var i = 0; i < length; i++) {
		if('<%=filterParam%>' != null && filterButtonRadio[i].value == '<%=filterParam%>') {
				filterButtonRadio[i].checked='true';
			}
		else if(filterButtonRadio[i].value == 'Current Only') {
			filterButtonRadio[i].checked='true';
		}
	}
 }


 function  getCheckedValue(radioObj) {
		if(!radioObj)
			return "";
		var radioLength = radioObj.length;
		if (radioLength == undefined)
			if(radioObj.checked)
				return radioObj.value;
			else
				return "";
		for(var i = 0; i < radioLength; i++) {
			if(radioObj[i].checked) {
				return radioObj[i].value;
			}
		}
		return "";
 }


  //FOR CALENDAR WIDGET 
 // This function gets called when the end-user clicks on some date.
function selected(cal, date) {
  cal.sel.value = date; // just update the date in the input field.
  if (cal.dateClicked && (cal.sel.id == "sel1" || cal.sel.id == "sel2"||cal.sel.id=="sel3"))
    // if we add this call we close the calendar on single-click.
    // just to exemplify both cases, we are using this only for the 1st
    // and the 3rd field, while 2nd and 4th will still require double-click.
    cal.callCloseHandler();
}

// And this gets called when the end-user clicks on the _selected_ date,
// or clicks on the "Close" button.  It just hides the calendar without
// destroying it.
function closeHandler(cal) {
  cal.hide();                        // hide the calendar
//  cal.destroy();
  _dynarch_popupCalendar = null;
}

// This function shows the calendar under the element having the given id.
// It takes care of catching "mousedown" signals on document and hiding the
// calendar if the click was outside.
function showCalendar(id, format, showsTime, showsOtherMonths) {
   var el = document.getElementById(id);
   if (_dynarch_popupCalendar != null) {
    // we already have some calendar created
    _dynarch_popupCalendar.hide();                 // so we hide it first.
  } else {
    // first-time call, create the calendar.
    var cal = new Calendar(1, null, selected, closeHandler);
    // uncomment the following line to hide the week numbers
    // cal.weekNumbers = false;
    if (typeof showsTime == "string") {
      cal.showsTime = true;
      cal.time24 = (showsTime == "24");
    }
    if (showsOtherMonths) {
      cal.showsOtherMonths = true;
    }
    _dynarch_popupCalendar = cal;                  // remember it in the global var
    cal.setRange(1900, 2070);        // min/max year allowed.
    cal.create();
  }
  _dynarch_popupCalendar.setDateFormat(format);    // set the specified date format
  _dynarch_popupCalendar.parseDate(el.value);      // try to parse the text in field
  _dynarch_popupCalendar.sel = el;                 // inform it what input field we use

  // the reference element that we pass to showAtElement is the button that
  // triggers the calendar.  In this example we align the calendar bottom-right
  // to the button.
  _dynarch_popupCalendar.showAtElement(el, "Br");        // show the calendar
   return false;
}

var MINUTE = 60 * 1000;
var HOUR = 60 * MINUTE;
var DAY = 24 * HOUR;
var WEEK = 7 * DAY;

// If this handler returns true then the "date" given as
// parameter will be disabled.  In this example we enable
// only days within a range of 10 days from the current
// date.
// You can use the functions date.getFullYear() -- returns the year
// as 4 digit number, date.getMonth() -- returns the month as 0..11,
// and date.getDate() -- returns the date of the month as 1..31, to
// make heavy calculations here.  However, beware that this function
// should be very fast, as it is called for each day in a month when
// the calendar is (re)constructed.
function isDisabled(date) {
  var today = new Date();
  return (Math.abs(date.getTime() - today.getTime()) / DAY) > 10;
}

function flatSelected(cal, date) {
  var el = document.getElementById("preview");
  el.innerHTML = date;
}

function showFlatCalendar() {
  var parent = document.getElementById("display");

  // construct a calendar giving only the "selected" handler.
  var cal = new Calendar(0, null, flatSelected);

  // hide week numbers
  cal.weekNumbers = false;

  // We want some dates to be disabled; see function isDisabled above
  cal.setDisabledHandler(isDisabled);
  cal.setDateFormat("%A, %B %e");

  // this call must be the last as it might use data initialized above; if
  // we specify a parent, as opposite to the "showCalendar" function above,
  // then we create a flat calendar -- not popup.  Hidden, though, but...
  cal.create(parent);

  // ... we can show it here.
  cal.show();
}
 

 function setDateValues(){
     var orgAlignTable = document.getElementById('orgAlignmentTable');
      var tablebLen=orgAlignTable.rows.length;
 	  for(var i=0;i<tablebLen;i++){
		var beginDateTextBoxId = "contactBeginDate"+i;		
		var beginDateTextBoxName = document.getElementById(beginDateTextBoxId);	
		var endDateTextBoxId = "contactEndDate"+i;		
		var endDateTextBoxName = document.getElementById(endDateTextBoxId);		
		document.getElementById("hiddenContactBeginDate"+i).value=beginDateTextBoxName.value.toString();	
		document.getElementById("hiddenContactEndDate"+i).value=endDateTextBoxName.value.toString();
		
	}
 }

 //This is  not optimal, but IE doesnt fetch elements which were added throuh DOM by getElementsByName
function customGetElementByName(elementName){
	var allInputs = document.getElementsByTagName("input");
	var elements = new Array();
	var count = 0;
	for(var i=0;i<allInputs.length;i++){
		if(allInputs[i].getAttribute("name") == elementName){
			elements[count]=allInputs[i];
			count++;
		}
	}
	return elements;
}

<%
    completeName = (String) request.getSession().getAttribute(Constants.COMPLETE_USER_NAME);
%>


</script>
<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" onLoad="setButtonsOnLoad()" onSubmit="javascript:setDateValues()">
<form name="orgAlignment" method="post" >

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="producttext">
<tr align="left" valign="top">

<td>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="colContent">
<tr>
    <td width="10" class="colContent">&nbsp;</td>
</tr>

<tr>
<td align="left" valign="top">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
    <%-- <td width="5" class="back_vert_sprtr">&nbsp;</td>--%>
    <td width="10" class="colContent">&nbsp;</td>
    <td class="colContent">

    <div style="height:415px;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="colContent">

            <tr>
                <td height="20" align="left" valign="top" >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="myexpertlist">
                        <tr align="left" valign="middle">
                            <td width="10" height="20">&nbsp;</td>
                            <td class="colTitle">Organization Alignment </td>
                            <td class="text-white-bold" align="right" valign="middle"><a href="javascript:printList()"
                                                                                         class="text-white-bold"
                                                                                         target="_self"
                                                                                         title="Printer-friendly version of this section"><img
                                    src="<%=COMMONIMAGES%>/print_icon.gif" width="16" height="16" border="0"></a>
                            </td>
                            <td width="30" height="20">&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="1" align="left" valign="top" class="colContent"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                                 width="1" height="1"></td>
            </tr>
            <tr>
                <td height="10" align="left" valign="top" class="colContent"></td>
            </tr>
            <tr>
                <td align="left" valign="top" class="colContent">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="10" height="20">&nbsp;</td>
                            <td width="150" class="text-blue-01"><span class="style2">User Name</span></td>
                            <td width="190"><input name="userName" class="field-blue-01-180x20" readonly value="<%=null != userName ? userName : ""%>"
                                                   /></td>
                            <input type='hidden' name="staffId" value="<%=null != staffIdForOrg ? staffIdForOrg :""%>">
                            <input type="hidden" name="email" value="<%=null != email ? email : ""%>"/>
                            <input type="hidden" name="phone" value="<%=null != phone ? phone : ""%>"/>
                            <td width="75" class="text-blue-01"><input name="Select" type="button" class="button-01" style="border:0;background : url(images/select.jpg);width:85px; height:22px;"
                                                            onClick="javascript:window.open('employee_search.htm','employeesearch','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes')">
                            </td>
                            <td width="10">&nbsp;</td>
                            <td><input name="save3" type="button"
                                                                        class="button-01"
                                                                        value=" Get Orgs "
                                                                        onClick="addOrgs()"></td>

                        </tr>

                    </table>
                </td>
            </tr>
            <tr>
                <td height="10" align="left" valign="top" class="colContent"><img
                        src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
            </tr>
            <tr>
                <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                               height="10"></td>
                <td width="10" rowspan="11" align="left" valign="top">&nbsp;</td>
            </tr>

            <tr>
                <td height="20" align="left" valign="top" >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="myexpertlist">
                        <tr align="left" valign="middle">
                            <td width="10" height="20">&nbsp;</td>
                            <td class="colTitle">Aligned Orgs </td>
                        </tr>
                    </table>
                </td>
            </tr>

           <tr>
                <td align="left" valign="top" class="colContent">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
           				<td width="1%" height="20">&nbsp;</td>
           				<td width="1%" height="20">&nbsp;</td>
                        <td width="10%" class="text-blue-01-bold">User Name:</td>
                        <td width="1%">&nbsp;</td>
                        <td class="text-blue-01" align="left"><%=null != userName ? userName : ""%></td>
                        </td>
           			</tr>

           			</table>
           		</td>
           	</tr>

           <tr>
              <td align="left" valign="top" class="colContent">
                 <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
           				<td width="1%" height="20">&nbsp;</td>
           				<td width="7%" class="text-blue-01-bold">Filter Org Alignment</td>
           				<td width="1%">&nbsp;</td>
                        <td width="7%" class="text-blue-01"><input id ="filterRadio" name ="filterRadio" type="radio" value="Current Only" />Current Only</td>
           				<td width="7%" class="text-blue-01"><input id ="filterRadio" name ="filterRadio" type="radio" value="All"/>All</td>
                        <td width="10%">&nbsp;</td>
                        <td width="30%" >&nbsp;</td>
                    </tr>
                 </table>
               <td>
           	</tr>

            <tr>
                <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                               height="10"></td>
                <td width="10" rowspan="11" align="left" valign="top">&nbsp;</td>
            </tr>



            <tr>
	            <td height="100%" align="left" valign="top" class="colContent">
	                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="colTitle">
	                    <tr>
	                        <td width="2%" height="25" align="center" class="colTitle">&nbsp;</td>
				 	        <td width="4%" valign="middle"  class="colTitle"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
			                <td width="10%" class="colTitle" align="left"> Org Name </td>
						    <td width="1%" class="colTitle" align="left">&nbsp;</td>
						    <td width="10%" class="colTitle" align= "left"> Begin Date </td>
						    <td width="10%" class="colTitle" align= "left"> End Date </td>
			                <td width="1%" class="colTitle" align= "left"></td>
			            </tr>
	                  </table>
	              </td>
            </tr>

            <tr>
	            <td height="100%" align="left" valign="top" class="colContent">
	                <div style="height:150px; overflow:auto;">
                     <table id = "orgAlignmentTable" width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <%int count=0;
						  if(contactsOrgMap!=null){
		                      Set keySet=contactsOrgMap.keySet();
						      Iterator i=keySet.iterator();
						      Organization alignedOrg=null;
							  while(i.hasNext()){
							    Object key = i.next();
							    OrgContacts alignedContact = (OrgContacts)(key);
								alignedOrg=(Organization)contactsOrgMap.get(key);
		                    	if(count%2==0){
								%>
									<TR align="left" valign="middle" class="back-white-02-light">
								<%
								}else{
								%>
									<TR align="left" valign="middle" class="back-grey-02-light">
								<% } %>
		  						<TD width="2%" height="25" align="center">&nbsp;</TD>
					 	        <td width="4%" valign="middle"  class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
				                <td width="10%"  class="text-blue-01"  align="left">
					 	         	<%= alignedOrg.getName()%>
					 	        </td>
							    <td width="1%" class="text-blue-01" align="left">&nbsp;</td>
							    <td width="10%" class="text-blue-01" align= "left">

							    <input style="float:left;" id="contactBeginDate<%=count%>" name="contactBeginDate<%=count%>" type="text" class="field-blue-16-150x20" readonly
							    	value="<%=(new SimpleDateFormat("MM/dd/yyyy").format(alignedContact.getBegindate())).toString().toUpperCase()%>" >
							         <a style="float:left;margin-top:2px;margin-left:5px" href="#" onclick="return showCalendar('contactBeginDate<%=count%>', '%m/%d/%Y', '24', true);">
                                    <img src="images/buttons/calendar_24.png" width="15" height="15" border="0" align="left" >
                                
							    </td>
							    <td width="10%" class="text-blue-01" align= "left">
							    <input style="float:left;" id="contactEndDate<%=count%>" name="contactEndDate<%=count%>" type="text" class="field-blue-16-150x20" readonly
							    	value="<%=(new SimpleDateFormat("MM/dd/yyyy").format(alignedContact.getEnddate())).toString().toUpperCase()%>" />
							      	<a style="float:left;margin-top:2px;margin-left:5px" href="#" onclick="return showCalendar('contactEndDate<%=count%>', '%m/%d/%Y', '24', true);">
							     	<img src="images/buttons/calendar_24.png" width="15" height="15" border="0" align="left" >
							    </td>
                                 <td width="1%">
							    <input id="hiddenAlignedOrgs<%=count%>" name="alignedOrgs" type="hidden" value="<%=alignedOrg.getEntityId()%>">
							    <input id="hiddenContactBeginDate<%=count%>" name="contactBeginDate" type="hidden" value="<%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getBegindate())).toString()%>">
							    <input id="hiddenContactEndDate<%=count%>" name="contactEndDate" type="hidden" value="<%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getEnddate())).toString()%>" >
							    <input id="hiddenContactIds<%=count%>" name="contactIds" type="hidden" value="<%=alignedContact.getOrgContactsId()%>">
							    </td>
		  					</TR>
		  					<%
		  					count++;
		  					}
		  				}
	  					%>

	  					<%if(OrgData!=null && OrgData.size() > 0){
	  						for(int i=0;i<OrgData.size();i++){
	  							String[] tempArr = null;
	  						 	String val = null;
	  						 	val = (String)OrgData.get(i);
	  						 	tempArr = val.split("/");
	  					%>
	  							<tr>
	                        	<td width="2%" height="25" align="center">&nbsp;</td>
				 	        	<td width="4%" valign="middle"  class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
			                	<td width="10%" class="text-blue-01" align="left"><%=tempArr[1]%></td>
						    	<td width="1%"  class="text-blue-01" align="left">&nbsp;</td>
						    	<td width="15%" class="text-blue-01" align= "left">
						    	<input  style="float:left;" id="contactBeginDate<%=count%>" name="contactBeginDate<%=count%>" type="text" class="field-blue-16-150x20" readonly
								    	value="<%= beginDate%>" />
								  <a style="float:left;margin-top:2px;margin-left:5px" href="#" onclick="return showCalendar('contactBeginDate<%=count%>', '%m/%d/%Y', '24', true);">
                                    <img src="images/buttons/calendar_24.png" width="15" height="15" border="0" align="left" >
                                
								 </td>
						    	<td width="15%" class="text-blue-01" align= "left">
						    	<input  style="float:left;" id="contactEndDate<%=count%>" id="contactEndDate<%=count%>" name="contactEndDate<%=count%>" type="text" class="field-blue-16-150x20" readonly
								    	value="<%=endDate%>" />	
								  <a style="float:left;margin-top:2px;margin-left:5px" href="#" onclick="return showCalendar('contactEndDate<%=count%>', '%m/%d/%Y', '24', true);">
                                  <img src="images/buttons/calendar_24.png" width="15" height="15" border="0" align="left" >
                                </td>                                 					
				             		                    
							 	<td width="1%">
							 	<input id="hiddenAlignedOrgs<%=count%>" name="alignedOrgs" type="hidden" value="<%=tempArr[0]%>"></td>
			                	<input id="hiddenContactBeginDate<%=count%>" name="contactBeginDate" type="hidden" value="<%=beginDate%>" />
							    <input id="hiddenContactEndDate<%=count%>" name="contactEndDate" type="hidden" value="<%=endDate%>" />
							    <input id="hiddenContactIds<%=count%>" name="contactIds" type="hidden" value="1"/>
							    <input id="hiddenPrimaryContactFlagValue<%=count%>" name="primaryContactFlagValue" type="hidden" value="N"/>

			                	</tr>
	  					<%
	  					count++;
	  					} }%>
	                  </table>
	                  </div>
	              </td>
            </tr>
<tr>
    <td height="10" align="left" valign="top">&nbsp;</td>
</tr>

<tr>
    <td height="10" align="left" valign="top" class="colContent"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                                      height="10"></td>
</tr>
<tr>
    <td height="10" align="left" valign="top" class="colContent">

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="10" height="20">&nbsp;</td>
                <td class="text-blue-01">
                	<input name="Submit3322" type="button" class="button-01" style="border:0;background : url(images/buttons/save.gif);width:73px; height:22px;" onClick="saveList()">
                    &nbsp;&nbsp;
                    <input name="Submit33222" type="button" class="button-01" style="border:0;background : url(images/buttons/add.gif);width:56px; height:22px;"  onClick="submitAdvOrgSearch(this.form, '<%=CONTEXTPATH%>');">
                    &nbsp;&nbsp;
                    <input name="Submit33222" type="button" class="button-01" style="border:0;background : url(images/buttons/delete.gif);width:73px; height:22px;"  onClick="removeOrg(this.form, '<%=CONTEXTPATH%>');">
                    &nbsp;&nbsp;                   
                    <input name="Submit33223" type="button" class="button-01" value="Realign"  onClick="javascript:show()">
                    &nbsp;&nbsp;
                    <input name="Submit33223" type="button" class="button-01" style="border:0;background : url(images/buttons/reset.gif);width:65px; height:22px;" onClick="resetPage()"> &nbsp;

                </td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="10" align="left" valign="top" class="colContent"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                                      height="10"></td>
</tr>
<tr>
    <td height="10" align="left" valign="top"></td>
</tr>
</table>
</td>
<td width="10" class="colContent">&nbsp;</td>
</tr>
</table>
</td>
</tr>
<%-- <tr>
  <td height="1" align="left" valign="top" class="back-blue-01-dark"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>--%>

</table>
</td>
<%-- <td width="5" class="back-blue-01-dark"><img src="<%=COMMONIMAGES%>/transparent.gif" width="5" height="5"></td>--%>
</tr>
</table>
</form>
</body>
<script type="text/javascript">

</script>
</html>
<%@ include file="footer.jsp" %>


<% session.removeAttribute("ORG_PRINT_LIST");%>
