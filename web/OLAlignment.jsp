<!-- saved from url=(0022)http://internet.e-mail -->
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="header.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.eav.expert.MyExpertList" %>
<%@ page import="com.openq.contacts.Contacts" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.awt.*" %>
<%@ page import="java.lang.reflect.Array" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%
    if (request.getSession().getAttribute(Constants.CURRENT_USER) == null)
        response.sendRedirect("login.htm");


    ArrayList OLData = null;
    if (null != session.getAttribute("OLNAME_WITH_ID")) {
        OLData = (ArrayList) session.getAttribute("OLNAME_WITH_ID");
    }
    String staffIdForOL ="";
    if (null != session.getAttribute("STAFFID")){
        staffIdForOL = (String)session.getAttribute("STAFFID");
        System.out.println("staffidforol"+staffIdForOL);
    }
    String userName ="";
    if (null != session.getAttribute("USERNAME")){
        userName = (String)session.getAttribute("USERNAME");
    }
    User alignedUser=null;
    if (null != session.getAttribute("ALIGNED_USER")){
        alignedUser = (User)session.getAttribute("ALIGNED_USER");
    }

    Map contactsOLMap=new LinkedHashMap();
    if(session.getAttribute("CONTACTS_OL_MAP")!=null){
       contactsOLMap=(LinkedHashMap)session.getAttribute("CONTACTS_OL_MAP");
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
    var thisform = document.olalignment;
    var staffId = document.olalignment.staffId.value;
    var userName = document.olalignment.userName.value;
    window.open("<%=CONTEXTPATH%>/OLAlignment.htm?action=<%=ActionKeys.ALIGNMENT_PRINT%>&staffId=" + staffId + "&userName="+userName);
    <%--thisform.action = "<%=CONTEXTPATH%>/OLAlignment.htm?action=<%=ActionKeys.ALIGNMENT_PRINT%>&staffId="+staffId;
    thisform.submit();--%>
 }
 function help() {
    alert("For demonstration purpose only. All links are just placeholders.");
 }


 function removeOL(formObj, contextURL) {
    //deleted(forms[0].alignedOLs)
     var checkedObjArray = new Array();
	 var indexOfObjArray = new Array();
	 var cCount = 0;
	 var chk = false;
	 var olAlignTable = document.getElementById('olAlignmentTable');
	 var tablebLen=olAlignTable.rows.length;
     var editButtonSelect = customGetElementByName('editOLContact');
	 for(var i=0;i<editButtonSelect.length;i++){
		 if(editButtonSelect[i].checked){
			 chk = true;
			 var rowNum =  findRowNumOfTable(editButtonSelect[i].getAttribute("id"));
			 checkedObjArray[cCount] = olAlignTable.rows[rowNum];
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
		 reorder(olAlignTable, indexOfObjArray[0]);
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
 	var olAlignTable = document.getElementById('olAlignmentTable');
	for(var j=0; j<olAlignTable.rows.length;j++){
		var rowIndex = (olAlignTable.rows[j].cells[7].firstChild.id);
		var editIndex = (editContactIndex);
		if(editIndex == rowIndex){
			return j;
		}
	}


 }
 function resetPage() {
    var thisform = document.olalignment;
    thisform.action = "<%=CONTEXTPATH%>/OLAlignment.htm?action=<%=ActionKeys.RESET_ALIGN%>";
    thisform.submit();
 }

 function saveList() {
    var thisform = document.olalignment;
    if(document.getElementById('staffId').value!=''){
    	thisform.action = "<%=CONTEXTPATH%>/OLAlignment.htm?action=<%=ActionKeys.SAVE_OLS%>";
    	setDateValues();
    	thisform.submit();
    } 	else{
    alert('Please Select User');
    }
 }

 function submitAdvExpertSearch(formObj, contextURL){
    if(document.getElementById('staffId').value!=''){
    	formObj.action = "<%=CONTEXTPATH%>/search.htm?fromEvent=true&default=true&fromOLAlignment=true";
    	formObj.target = "_top";
    	formObj.submit();
    }else{
    	alert('Please Select User');
    }
 }

 function addAttendee(username, phone, email, staffid) {
    document.olalignment.userName.value = username;
    document.olalignment.staffId.value = staffid;
    document.olalignment.email.value = email;
    document.olalignment.phone.value = phone;
    setButtonsOnLoad();
 }


 function show() {
    var formObj = document.olalignment;
    formObj.action = "<%=CONTEXTPATH%>/OLAlignment.htm?action=<%=ActionKeys.OLREALIGNMENT%>";
    formObj.submit();

 }


 function addOLs() {
    var staffId = document.olalignment.staffId.value;
	var thisform = document.olalignment;
    var filterButtonRadio = document.olalignment.filterRadio;
    var length = filterButtonRadio.length;
	for(var i = 0; i < length; i++) {
		if(filterButtonRadio[i].checked) {
			var filterParam = filterButtonRadio[i].value;
		}
    }
    if (staffId != 0) {
		thisform.action = "<%=CONTEXTPATH%>/OLAlignment.htm?action=<%=ActionKeys.GET_OLS%>&filter="+filterParam;
    	thisform.submit();
    }
 }




 function setButtonsOnLoad(){

    var editButtonRadio = document.olalignment.editRadio;
    var radioLength = editButtonRadio.length;
			for(var i = 0; i < radioLength; i++) {
				if(editButtonRadio[i].value == 'endDateRadio') {
					editButtonRadio[i].checked='true';
				}
			}
    var filterButtonRadio = document.olalignment.filterRadio;
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


 function editOLAlignment(){
	var editButtonRadio = document.olalignment.editRadio;
	if(getCheckedValue(editButtonRadio) == 'beginDateRadio'){
		var editButtonSelect = customGetElementByName('editOLContact');
	    for(var i=0;i<editButtonSelect.length;i++){
			if(editButtonSelect[i].checked){
		    	var rowNum =  editButtonSelect[i].getAttribute("id");
				var beginDateTextBoxId = "contactBeginDate"+rowNum;
				var beginDateTextBoxName = document.getElementById(beginDateTextBoxId);
				return showCalendar(beginDateTextBoxId, '%m/%d/%Y', '24', true);
		    }
	    }

	}
	else if(getCheckedValue(editButtonRadio) == 'endDateRadio'){
		var editButtonSelect = customGetElementByName('editOLContact');
	    for(var i=0;i<editButtonSelect.length;i++){
			if(editButtonSelect[i].checked){
		    	var rowNum =  editButtonSelect[i].getAttribute("id");
				var endDateTextBoxId = "contactEndDate"+rowNum;
				var endDateTextBoxName = document.getElementById(endDateTextBoxId);
				return showCalendar(endDateTextBoxId,'%m/%d/%Y', '24', true);

		    }
	    }

	}
	else if(getCheckedValue(editButtonRadio) == 'primaryContactRadio'){
		var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0,dialog=no,minimizable=no";
		var win = window.open("selectPrimaryContact.jsp", "selectPrimaryContactType", winParam);
        if(win != ""){
        	win.focus();
        }
	}
}


 function markPrimaryContactFlag(flag){
	var editButtonSelect = customGetElementByName('editOLContact');
	    for(var i=0;i<editButtonSelect.length;i++){
			if(editButtonSelect[i].checked){
		    	var rowNum =  editButtonSelect[i].getAttribute("id");
		    	var primaryContactId = "primaryContact"+rowNum;
				var primaryContactFlag = document.getElementById(primaryContactId);
				if(flag=='yes'){
					primaryContactFlag.innerHTML='Y';
				}else if(flag=='no'){
					primaryContactFlag.innerHTML='N';
				}
				document.getElementById('hiddenPrimaryContactFlagValue'+rowNum).value=primaryContactFlag.innerHTML;
			}
		}
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
 	var editButtonSelect = customGetElementByName('editOLContact');
	for(var i=0;i<editButtonSelect.length;i++){
		var index = editButtonSelect[i].id;
		var beginDateTextBoxId = "contactBeginDate"+index;
		var beginDateTextBoxName = document.getElementById(beginDateTextBoxId);
		var endDateTextBoxId = "contactEndDate"+index;
		var endDateTextBoxName = document.getElementById(endDateTextBoxId);
		document.getElementById("hiddenContactBeginDate"+index).value=beginDateTextBoxName.value;
		document.getElementById("hiddenContactEndDate"+index).value=endDateTextBoxName.value;
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
<form name="olalignment" method="post" >

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
                <td align="center" valign="top" >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="myexpertlist">
                        <tr align="left" valign="middle">
                            <td width="10" height="20">&nbsp;</td>
                            <td class="colTitle">Thought Leader Alignment </td>
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
                            <input type='hidden' name="staffId" value="<%=null != staffIdForOL ? staffIdForOL :""%>">
                            <input type="hidden" name="email" value="<%=null != email ? email : ""%>"/>
                            <input type="hidden" name="phone" value="<%=null != phone ? phone : ""%>"/>
                            <td width="75" class="text-blue-01"><input name="Select" style="border:0;background : url(images/select.jpg);width:85px; height:22px;" type="button" class="button-01" 
                            onClick="javascript:window.open('employee_search.htm','employeesearch','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes')">
                            </td>
                            <td width="10"></td>
                            <td><input name="save3" type="button"
                                                                        class="button-01"
                                                                        value=" Get <%=DBUtil.getInstance().doctor%>s "
                                                                        onClick="addOLs()"></td>

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
                            <td class="colTitle">Aligned <%=DBUtil.getInstance().doctor%>s </td>
                        </tr>
                    </table>
                </td>
            </tr>

           <tr>
                <td align="left" valign="top" class="colContent">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
           				<td width="1%" height="20">&nbsp;</td>
                        <td width="7%" class="text-blue-01-bold">User Name:</td>
                        <td width="1%">&nbsp;</td>
                        <td width="7%" class="text-blue-01"><%=null != userName ? userName : ""%></td>
                        <td width="1%" >&nbsp;</td>
                        <td width="10%" class="text-blue-01" align="right">Edit Mode </td>
                        <td width="30%" class="text-blue-01" >&nbsp;&nbsp;&nbsp;<input id ="editRadio" name="editRadio" type="radio" value="beginDateRadio"/> Begin Date<br>
                            												 &nbsp;&nbsp;&nbsp;<input id ="editRadio" name="editRadio" type="radio" value="endDateRadio"/> End Date<br>
                            												 &nbsp;&nbsp;&nbsp;<input id ="editRadio" name="editRadio" type="radio" value="primaryContactRadio"/> Primary Contact

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
           				<td width="7%" class="text-blue-01">Filter <%=DBUtil.getInstance().doctor%> Alignment</td>
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
	                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="myexpertlist">
	                    <tr>
	                        <td width="2%" height="25" align="center">&nbsp;</td>
				 	        <td width="4%" valign="middle"  class="colTitle"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
			                <td width="10%" class="colTitle" align="left"> <%=DBUtil.getInstance().doctor%> Name </td>
						    <td width="1%" class="colTitle" align="left">&nbsp;</td>
						    <td width="10%" class="colTitle" align= "left"> Begin Date </td>
						    <td width="10%" class="colTitle" align= "left"> End Date </td>
			                <td width="10%" class="colTitle" align= "left"> Primary Flag </td>
			                <td width="10%" class="colTitle" align= "left"> Edit </td>
			                <td width="1%" class="colTitle" align= "left"></td>
			            </tr>
	                  </table>
	              </td>
            </tr>

            <tr>
	            <td height="100%" align="left" valign="top" class="colContent">
	                <div style="height:150px; overflow:auto;">
                     <table id = "olAlignmentTable" width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <%
	                    int count=0;
						  if(contactsOLMap!=null){

		                      Set keySet=contactsOLMap.keySet();
						      Iterator i=keySet.iterator();
							  while(i.hasNext()){
								Contacts alignedContact = (Contacts)(i.next());
								UserDetails alignedOL=(UserDetails)contactsOLMap.get(alignedContact);
		                    	if(count%2==0){
								%>
									<TR align="left" valign="middle" class="back-white-02-light">
								<%
								}else{
								%>
									<TR align="left" valign="middle" class="back-grey-02-light">
								<% } %>
		  						<TD width="2%" height="25" align="center" >&nbsp;</TD>
					 	        <td width="4%" valign="middle"  class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
				                <td width="10%"  class="text-blue-01"  align="left">
					 	         <%= alignedOL.getLastName()%>, <%= alignedOL.getFirstName()%>
					 	        </td>
							    <td width="1%" class="text-blue-01" align="left">&nbsp;</td>

							    <%String beginDateToDisplay=null;
							    if(alignedContact.getBegindate() != null){ 
							      beginDateToDisplay =(new SimpleDateFormat("MM/dd/yyyy").format(alignedContact.getBegindate()))
							    .toString().toUpperCase();}%>
							  
							    <td width="10%" class="text-blue-01" align= "left">
							    <input id="contactBeginDate<%=count%>" name="contactBeginDate<%=count%>" type="text" class="field-blue-16-150x20" readonly
							    <%if(beginDateToDisplay != null){ %>value="<%=beginDateToDisplay %>" 
							    <%}else{ %>value=""<%}%>>
							    </td>
								
								<%
								String endDateToDisplay = null;
								if(alignedContact.getEnddate() != null)
								{
								endDateToDisplay = (new SimpleDateFormat("MM/dd/yyyy").format(alignedContact.getEnddate()))
								.toString().toUpperCase();
								}
								 %>
								 
							    <td width="10%" class="text-blue-01" align= "left">
							    <input id="contactEndDate<%=count%>" name="contactEndDate<%=count%>" type="text" class="field-blue-16-150x20" readonly
							    <%if(endDateToDisplay != null){ %>value="<%=endDateToDisplay %>" 
							    <%}else{ %>value=""<%}%>/>
							    </td>

				                <td width="10%" class="text-blue-01" align= "left" id="primaryContact<%=count%>" name="primaryContact">&nbsp;&nbsp;&nbsp;&nbsp;
				                  <% if(alignedContact.getIsPrimaryContact()!=null && alignedContact.getIsPrimaryContact().equalsIgnoreCase("true")){%> Y<%} else{%> N <%}%>
				                </td>


				                <td width="10%" class="text-blue-01" align= "left">
				                <INPUT type=checkbox value="<%=alignedOL.getId()%>" name= "editOLContact" id="<%=count%>"> </TD>
							    <td width="1%">
							    <input id="hiddenAlignedOLs<%=count%>" name="alignedOLs" type="hidden" value="<%=alignedOL.getId()%>"/>
							    <input id="hiddenContactBeginDate<%=count%>" name="contactBeginDate" type="hidden" value="<%=beginDateToDisplay%>"/>
							    <input id="hiddenContactEndDate<%=count%>" name="contactEndDate" type="hidden" value="<%=endDateToDisplay%>"/>
							    <input id="hiddenContactIds<%=count%>" name="contactIds" type="hidden" value="<%=alignedContact.getContactId()%>"/>
							    <input id="hiddenPrimaryContactFlagValue<%=count%>" name="primaryContactFlagValue" type="hidden"
							    <% if(alignedContact.getIsPrimaryContact()!=null && alignedContact.getIsPrimaryContact().equalsIgnoreCase("true")){%> value="Y"<%} else{%> value="N" <%}%> >
							    </td>
		  					</TR>
		  					<%
		  					count++;
		  					}
		  				}
	  					%>

	  					<%if(OLData!=null && OLData.size() > 0){
	  						for(int i=0;i<OLData.size();i++){
	  							String[] tempArr = null;
	  						 	String val = null;
	  						 	val = (String)OLData.get(i);
	  						 	tempArr = val.split("/");
	  					%>
	  							<tr>
	                        	<td width="2%" height="25" align="center">&nbsp;</td>
				 	        	<td width="4%" valign="middle"  class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
			                	<td width="10%" class="text-blue-01" align="left"><%=tempArr[1]%></td>
						    	<td width="1%"  class="text-blue-01" align="left">&nbsp;</td>
						    	<td width="10%" class="text-blue-01" align= "left">
						    	<input id="contactBeginDate<%=count%>" name="contactBeginDate<%=count%>" type="text" class="field-blue-16-150x20" readonly
								    	value="<%= beginDate.toUpperCase()%>" >
								</td>
						    	<td width="10%" class="text-blue-01" align= "left">
						    	<input id="contactEndDate<%=count%>" name="contactEndDate<%=count%>" type="text" class="field-blue-16-150x20" readonly
								    	value="<%=endDate.toUpperCase()%>" /></td>
						    	 <td width="10%"  class="text-blue-01" align= "middle" id="primaryContact<%=count%>" name="primaryContact">N</td>
				                <td width="10%" class="text-blue-01" align= "left">
				                	<INPUT type=checkbox value="" name= "editOLContact" id="<%=count%>">
				                </td>
							 	<td width="1%">
							 	<input id="hiddenAlignedOLs<%=count%>" name="alignedOLs" type="hidden" value="<%=tempArr[0]%>">
							    <input id="hiddenContactBeginDate<%=count%>" name="contactBeginDate" type="hidden" value="<%=beginDate%>">
							 	<input id="hiddenContactEndDate<%=count%>" name="contactEndDate" type="hidden" value="<%=endDate%>">
							    <input id="hiddenContactIds<%=count%>" name="contactIds" type="hidden" value="1">
							     <input id="hiddenPrimaryContactFlagValue<%=count%>" name="primaryContactFlagValue" type="hidden" value="N">
							     </td>
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
    <td height="10" align="left" valign="top" class="colcontent">

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="10" height="20">&nbsp;</td>
                <td class="text-blue-01">
                	<input name="Submit3322" type="button" class="button-01" style="border:0;background : url(images/buttons/save.gif);width:73px; height:22px;"onClick="saveList()">
                    &nbsp;&nbsp;
                    <input name="Submit33222" type="button" class="button-01" style="border:0;background : url(images/buttons/add.gif);width:56px; height:22px;" onClick="submitAdvExpertSearch(this.form, '<%=CONTEXTPATH%>');" >
                    &nbsp;&nbsp;
                    <input name="Submit33222" type="button" class="button-01" style="border:0;background : url(images/buttons/delete.gif);width:73px; height:22px;" onClick="removeOL(this.form, '<%=CONTEXTPATH%>');">
                    &nbsp;&nbsp;
                    <input name="Submit33222" type="button" class="button-01" style="border:0;background : url(images/buttons/edit.gif);width:60px; height:22px;" onClick="editOLAlignment()">
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
    <td height="10" align="left" valign="top" class="colContent"></td>
</tr>
</table>
</td>
<td width="10">&nbsp;</td>
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


<% session.removeAttribute("OL_PRINT_LIST");

%>

